#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -t|--type)
    TYPE="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--session)
    SESSION="$2"
    shift # past argument
    shift # past value
    ;;
    -m|--messaggeId)
    MESSEGEID="$2"
    shift # past argument
    shift # past value
    ;;
    -ts|--targetService)
    TARGETSERVICE="$2"
    shift # past argument
    shift # past value
    ;;
    -f|--file)
    FILE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo type  = "${TYPE}"
echo session  = "${SESSION}"
echo messaggeId  = "${MESSEGEID}"
echo targetService  = "${TARGETSERVICE}"
echo file  = "${FILE}"

grepLines=$(grep ">$1<" "${FILE}" --line-number | cut -d ':' -f1)

echo $grepLines
for linea in $grepLines;
do
	startL=0
	endL=0
	inizioLinea=$(head -$linea "${FILE}" | tac | grep '<!--type=' -m 1 --line-number | cut -d ':' -f1)
	startL=$(($linea-$inizioLinea+1))
	#echo start $startL
	endS="/soapenv:Envelope"
	endL=$(tail -n +$linea "${FILE}" | grep $endS -m 1 --line-number | cut -d ':' -f1)
	#echo end $endL
	endL=$(($linea+$endL-1))
	#echo end $endL
	endPrint=$(($endL-$startL+1))
	echo PRINT FILE FROM $startL to $endPrint
	#log="awk 'NR >= $startL && NR <= $endL' '${FILE}'" #-> altro metodo per estrapolare le righe dal file, forse meno veloce
	tail -n +$startL ${FILE} | head -n$endPrint >> prova.txt
	echo "-------------------------------------" >> prova.txt
	echo "$log"
done
