module Main where

import System.Environment
import Lib

main :: IO ()
main = do
  [file] <- getArgs
  lookupWords file
