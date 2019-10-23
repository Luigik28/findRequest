# findRequest

Script per la ricerca di Request &amp; Response SOAP di un WS

## Help
```
findRequest.sh v0.1.0
Usage: findRequest.sh [OPTIONS] [WORD SEARCH]
 -h , --help                    : Print this help
 -f , --file                    : File to perform the search
 -a , --append                  : Append the search output to the file output
      --version                 : Print version

Exit status:
 0  if OK,
 1  if some problems (e.g., cannot access subdirectory).
```
## Example
```
./findRequest.sh -f file.log WORD-TO-SEARCH
```
