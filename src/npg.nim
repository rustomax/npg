# Password generation utility in Nim
# Based on `passgen` library (https://github.com/rustomax/nim-passgen)
# Installation instructions:
# `nimble install npg`

import strutils, parseopt
import passgen

const
    softwareVersion = "0.2.0"
    minPassLen = 4
    maxPassLen = 1024
    defaultPassLen = 16
    defaultPassNum = 1

proc printSoftwareVersion() =
    echo "npg - Nim random password generator"
    echo "version: ", softwareVersion

proc printHelp() =
    printSoftwareVersion()
    echo ""
    echo "Usage: npg [options]"
    echo "  -h, --help    : print this message"
    echo "  -v, --version : print version"
    echo ""
    echo "Password options:"
    echo "  -N=<x> : generate <x> passwords (default = 1)"
    echo "  -L=<y> : generate <y> character-long passwords"
    echo "           (default password length = 16, min = 4, max = 1024)"
    echo ""
    echo "Character sets (default = include all):"
    echo "  -l     : include lower case letters"
    echo "  -u     : include upper case letters"
    echo "  -d     : include digits"
    echo "  -s     : include special characters"
    echo ""
    echo "Example  : npg"
    echo "           generate 1 password, 16 characters-long,"
    echo "           using all character sets (lower and uppercase letters,"
    echo "           digits and special characters)"
    echo ""
    echo "Example  : npg -L=20 -N=10 -lud"
    echo "           generate 10 passwords, 20 characters-long,"
    echo "           using alpha-numerical characters only (no special characters)"
    echo ""
    echo "Example  : npg -N=5 -L=4 -d"
    echo "           generate 10 4-digit numerical PINs"

proc main() =
    # Parse CLI arguments
    var p = initOptParser()
    var flags: set[CFlag] = {}
    var passLen = defaultPassLen
    var passNum = defaultPassNum

    while true:
        p.next()
        case p.kind
        of cmdEnd: break
        of cmdShortOption, cmdLongOption:
            case p.key
            of "N":
                passNum = parseInt(p.val)
                if passNum < 1:
                    raise(newException(ArgumentException, "invalid value " & p.key & ": " & p.val))
            of "L":
                passLen = parseInt(p.val)
                if passLen < minPassLen or passLen > maxPassLen:
                    raise(newException(ArgumentException, "invalid value " & p.key & ": " & p.val))
            of "l":
                flags = flags + {fLower}
            of "u":
                flags = flags + {fUpper}
            of "d":
                flags = flags + {fDigits}
            of "s":
                flags = flags + {fSpecial}
            of "v", "version":
                printSoftwareVersion()
                quit(0)
            of "h", "help":
                printHelp()
                quit(0)
            else:
                raise(newException(ArgumentException, "invalid argument " & p.key & ": " & p.val))
        else:
            raise(newException(ArgumentException, "invalid argument " & p.key & ": " & p.val))

    # If no flags were specified, using default of all characters
    if flags == {}:
        flags = {fLower, fUpper, fDigits, fSpecial}

    # Initialize new password generator
    let pg = newPassGen(passlen = passLen, flags = flags)

    # Generate and print out passwords
    for i in 1..passNum:
        echo pg.getPassword()

main()