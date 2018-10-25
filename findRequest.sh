#!/usr/bin/env bash
#--------------------------------------------------------------------------------------------------
# find request script
#--------------------------------------------------------------------------------------------------
FINDREQUEST_APPNAME="findRequest"
FINDREQUEST_VERSION="0.1.0"

# IFS stands for "internal field separator". It is used by the shell to determine how to do word splitting, i. e. how to recognize word boundaries.
SAVEIFS=$IFS
IFS=$(echo -en "\n\b") # <-- change this as it depends on your app

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

function _usage() {
    echo -e "$(basename $0) v$FINDREQUEST_VERSION"
    echo -e "Usage: $(basename $0) [OPTIONS] [WORD SEARCH]"
    echo -e " -h , --help                    : Print this help"
	echo -e " -f , --file                    : File to perform the search"
	echo -e " -a , --append                  : Append the search output to the file output"
    echo -e "      --version                 : Print version"
	echo -e ""
    echo -e "Exit status:"
    echo -e " 0  if OK,"
    echo -e " 1  if some problems (e.g., cannot access subdirectory)."
	exit 0
}

function _version() {
    echo -e "$(basename $0) v$FINDREQUEST_VERSION"
	exit 0
}

function log() {
	echo -e $1
}

# option
OPTS=$(getopt -o hf:a --long "help,version,file:,append" -n $(basename $0) -- "$@")
#Bad arguments, something has gone wrong with the getopt command.
if [ $? -ne 0 ]; then
    #Option not allowed
    echo -e "Error: '$0' invalid option '$1'."
    echo -e "Try '$0 -h' for more information."
    exit 1
fi

# A little magic, necessary when using getopt.
eval set -- "$OPTS"

while true; do
    case "$1" in
        -h|--help)
            _usage
            exit 0
			;;
        --version)
            _version
            exit 0
			;;
        -f|--file) #Print to file
            FILE=$2
            shift 2
			;;
		-a|--append) #Print to file
            APPEND=true
            shift 1
			;;
        --)
            shift
            break
			;;
    esac
done

# init variables
APPEND=false
LOG_TIME=$(date +%Y%m%d)
FILE_LOG=${FILE}.${LOG_TIME}

if [ "$APPEND" = false ] ; then
    cat /dev/null > $FILE_LOG
fi

grepLines=$(grep ">$1<" "${FILE}" --line-number | cut -d ':' -f1)

time_init=$(date +%s%N | cut -b1-13)
for linea in $grepLines;
do
	startL=0
	endL=0
	
    inizioLinea=$(head -$linea "${FILE}" | tac | grep '<!--type=' -m 1 --line-number | cut -d ':' -f1)
	startL=$(($linea-$inizioLinea))
	
    endS="/soapenv:Envelope"
	endL=$(tail -n +$linea "${FILE}" | grep $endS -m 1 --line-number | cut -d ':' -f1)
	endL=$(($linea+$endL-1))
	
	endPrint=$(($endL-$startL+1))
	tail -n +$startL ${FILE} | head -n$endPrint >> $FILE_LOG
	
    echo "-----" >> $FILE_LOG
done
time_end=$(date +%s%N | cut -b1-13)

echo "done in "$(($time_end-$time_init))"ms"

# Restore IFS
IFS=$SAVEIFS
exit 0
