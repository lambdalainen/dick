{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib (
    lookupWords
  ) where

import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as B
import GHC.Generics
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Status (statusCode)
import qualified Network.URI.Encode as URI
import Prelude hiding (Word)
import System.FilePath.Posix
import Text.PrettyPrint hiding ((<>))

data Phonetic = Phonetic {
    text  :: String,
    audio :: String
  } deriving (Generic, Show)

data Definition = Definition {
    definition :: String,
    synonyms   :: Maybe [String],
    example    :: Maybe String
  } deriving (Generic, Show)

data Meaning = Meaning {
    partOfSpeech :: String,
    definitions  :: [Definition]
  } deriving (Generic, Show)

data Word = Word {
    word      :: String,
    origin    :: Maybe String,
    phonetics :: [Phonetic],
    meanings  :: [Meaning]
  } deriving (Generic, Show)

instance FromJSON Phonetic
instance FromJSON Definition
instance FromJSON Meaning
instance FromJSON Word

lookupWords :: FilePath -> IO ()
lookupWords inputFile = do
  manager <- newTlsManager
  words   <- lines <$> readFile inputFile
  let outputFile = dropExtension inputFile ++ "-result.md"
  mapM_ (lookupWord manager outputFile) words

lookupWord :: Manager -> FilePath -> String -> IO ()
lookupWord manager outputFile word = do
  request  <- parseRequest $ "https://api.dictionaryapi.dev/api/v2/entries/en_US/" ++ URI.encode word
  response <- httpLbs request manager
  case statusCode $ responseStatus response of
    200   -> do
      let body = responseBody response
      -- print body
      case decode body :: Maybe [Word] of
        Nothing -> B.putStrLn $ "Couldn't decode body: " <> body
        Just ws -> mapM_ write_output ws
    other -> putStrLn $ "Unexpected statusCode: " ++ show other
  where
  write_output = appendFile outputFile . render . mdWord

mdPhonetic :: Phonetic -> Doc
mdPhonetic (Phonetic t _) =
  char '_' <> txt t <> char '_'

mdDefinition :: Definition -> Doc
mdDefinition (Definition def syns eg) =
  txt "- " <> txt def <> newline <>
  md_synonyms syns <>
  md_example eg
  where
  md_synonyms Nothing   = empty
  md_synonyms (Just xs) = lbrack <> sepBy (comma <> space) (map txt xs) <> rbrack <> newline

  md_example Nothing   = empty
  md_example (Just eg) = txt "> " <> txt eg <> newline

mdMeaning :: Meaning -> Doc
mdMeaning (Meaning pos defs) =
  char '*' <> txt pos <> char '*' <> newline <> hcat (map mdDefinition defs)

mdWord :: Word -> Doc
mdWord (Word w orig ps ms) =
  txt "## " <> txt w <> newline <>
  sepBy (comma <> space) (map mdPhonetic ps) <> newline <>
  mk_origin orig <>
  hcat (map mdMeaning ms)
  where
  mk_origin Nothing  = empty
  mk_origin (Just m) = lparen <> txt m <> rparen <> newline

sepBy :: Doc -> [Doc] -> Doc
sepBy _ []      = empty
sepBy _ [x]     = x
sepBy by (x:xs) = x  <> by <> sepBy by xs

txt :: String -> Doc
txt = Text.PrettyPrint.text

newline :: Doc
newline = char '\n'
