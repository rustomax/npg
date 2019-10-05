# npg
Password generation utility in Nim, based on [passgen library](https://github.com/rustomax/nim-passgen)

## Installation
```sh
nimble install npg
```

## Usage

```sh
Usage: npg [options]
  -h, --help    : print this message
  -v, --version : print version

Password options:
  -N=<x> : generate <x> passwords (default = 1)
  -L=<y> : generate <y> character-long passwords, (default = 16)

Character sets (default = include all):
  -l     : include lower case letters
  -u     : include upper case letters
  -d     : include digits
  -s     : include special characters

Example  : npg
           generate 1 password, 16 characters-long,
           using all character sets (lower and uppercase letters,
           digits and special characters)

Example  : npg -L=20 -N=10 -lud
           generate 10 passwords, 20 characters-long,
           using alpha-numerical characters only (no special characters)

Example  : npg -N=5 -L=4 -d
           generate 10 4-digit numerical PINs

```