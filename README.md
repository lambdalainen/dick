# dick
`dick` is a simple program to batch lookup words. It reads a text file and outputs a
Markdown file. Kudos goes to [Free Dictionary API](https://github.com/meetDeveloper/freeDictionaryAPI).

## Build

Refer to [The Haskell Tool Stack](https://docs.haskellstack.org/en/stable/README/) to set up Stack.

```
stack install
```

## Usage

Put the words or phrases in a text file `FILE.txt`, one per line, then run

```
dick words.txt
```

The output file is written to `FILE-result.md`.

## Example

```
$ cat words.txt
ad nauseam
frivolous
capricious

$ dick words.txt

$ cat words-result.md
## ad nauseam
_/ad ˈnɔːzɪam/_
*adverb*
- Used to refer to the fact that something has been done or repeated so often that it has become annoying or tiresome.
[repeatedly, again and again, over and over, over and over again, time and again, time and time again, frequently, often, many times, many a time, time after time, on many occasions, many times over]
## frivolous
_/ˈfrɪvələs/_
*adjective*
- Not having any serious purpose or value.
[flippant, glib, waggish, joking, jokey, light-hearted, facetious, fatuous, inane, shallow, superficial, senseless, thoughtless, ill-considered, non-serious]
> rules to stop frivolous lawsuits
## capricious
_/kəˈprɪʃəs/_, _/kəˈpriʃəs/_
*adjective*
- Given to sudden and unaccountable changes of mood or behavior.
[fickle, inconstant, changeable, variable, unstable, mercurial, volatile, erratic, vacillating, irregular, inconsistent, fitful, arbitrary]
> a capricious and often brutal administration
```

## When rendered:

<img src="https://raw.githubusercontent.com/lambdalainen/dick/master/png/markdown.png" alt="Screenshot" width="600">
