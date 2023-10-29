#!/bin/bash

#Eduardo Lopes     103070
#Tomás Brás        112665

#declaração de variaveis
declare reverse=0               #ordenação normal
declare sort_name=0             #ordenação default dos ficheiros

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
                echo "Opção inválida! A sair..."
                exit 1
                ;;
        esac
    done
    shift $((OPTIND - 1))
}

function space() {
    #nothing yet
    return 0
}

function print() {
    :'
    echo "SIZE NAME $(date +%Y%m%d) $@"
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