#!/bin/bash

#Eduardo Lopes     103070
#Tomás Brás        112665

#declaração de variaveis
declare reverse=0               #ordenação normal
declare sort_name=0             #ordenação default dos ficheiros
declare -A value1
declare -A value2
declare -A value3


#verifica quais dos argumentos são ficheiros
function files() {    
    for i in "$@"; do
        if [[ -f "$i" ]]; then
            space "$i" 
        fi  
    done   
}

function input() {                                                                          
    while getopts ":n:r:a:d:s:l" flag; do
        case $flag in

            r)  
                reverse=1
                ;;
            a)  
                sort_name=1
                ;;
            *)
                #eu interpretei assim porque ha um caso em que nao ha nhum flag so eu usei este para o caso sem nada
                #entendeste aquilo que quis dizer? ve o primeiro exeplo nao tem flag
                
                ;;
        esac
    done
    shift $((OPTIND - 1))
}

function space() {
    if [ -e "$arquivo" ]; then
        primeiro=true
        while IFS= read -r linha; do
            if [ "$primeiro" = true ]; then
                # Ignorar a primeira linha (cabeçalho)
                primeiro=false
                continue
            fi
                size=$(echo "$linha" | cut -d' ' -f1)
                name=$(echo "$linha" | cut -d' ' -f2-)
                values["$nome"]=$size
        done < "$arquivo"
    else
        echo "O arquivo não existe."
    fi
}

function print() {
    printf "%-10s %-10s\n" "SIZE" "NAME" 
    if [[ $reverse -eq 1 ]]; then
        if [[ $sort_name -eq 1 ]]; then
            
        else

        fi
    else
        if [[ $sort_name -eq 1 ]]; then

        else

        fi
    fi
    '
    return 0
}

function main() {
    files "$@"
    input "$@"
}

main "$@"