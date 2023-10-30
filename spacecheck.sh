#!/bin/bash

#Eduardo Lopes     103070
#Tomás Brás        112665

#declaração de variaveis
declare total_space
declare minimo
declare limite
declare expressao
declare reverse=0               #ordenação normal
declare sort_name=0             #ordenação default dos ficheiros
declare validation='^[0-9]+$'
declare date

#declaração de arrays
declare -A space_array

function directories() {          #verifica quais dos argumentos são diretotias
    for i in "$@"; do
        if [[ -d "$i" ]]; then
            space "$i"  
        fi
    done   
}

function input() {                                                                                            
    while getopts ":n:r:a:d:s:l" flag; do
        case $flag in
            n)  
                if [ -n "$OPTARG" ]; then
                    expressao=$OPTARG
                fi
                ;;
            r)  
                reverse=1
                ;;
            a)  
                sort_name=1
                ;;
            d)  
                #verifica se a data é válida
                if date -d "$OPTARG" >/dev/null 2>&1; then
                    date=$OPTARG
                else
                    echo "Data inválida"
                    exit 1
                fi
                ;;
            s)  
                #verificação se o número é inteiro positivo
                if [[ $OPTARG =~ $validation ]] && [[ $OPTARG -gt 0 ]]; then
                    minimo=$OPTARG
                else
                    echo "Número inserido inválido"
                    exit 1
                fi
                ;;
            l)  
                #verificação se o número é positivo
                if [[ $OPTARG -gt 0 ]]; then
                    limite=$OPTARG
                else
                    echo "Número inserido inválido"
                    exit 1
                fi
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
    dires=($(find "$1" -type d))

    for i in "${dires[@]}"; do
        total_space=0
        files=($(find "$i" -type f -size +$minimo -name "$expressao"))

        for k in "${files[@]}"; do
            if [[ ! -d "$k" ]]; then
                space=$(du "$k" | awk '{print $1}' | grep -oE '[0-9.]+')
                total_space=$(echo "$total_space + $space" | bc)
            fi
        done

        # Save the value in an array
        space_array[$i]="$total_space"
    done 
}

function print() {
    # Use head -n to limit the number of lines in the table
    echo "SIZE NAME $(date +%Y%m%d) $@"
    if [[ $reverse -eq 1 ]]; then
        if [[ $sort_name -eq 1 ]]; then
            for val in "${!space_array[@]}"; do
                echo "${space_array[$val]} $val"
            done | sort -rn -k1,1 -k2,2
        else
            for val in "${!space_array[@]}"; do
                echo "${space_array[$val]} $val"
            done | sort -rn
        fi
    else
        if [[ $sort_name -eq 1 ]]; then
            for val in "${!space_array[@]}"; do
                echo "${space_array[$val]} $val"
            done | sort -k2,2r -k1,1n
        else
            for val in "${!space_array[@]}"; do
                echo "${space_array[$val]} $val"
            done
        fi
    fi
}

function main() {
    input "$@"
    directories "$@"
    print
}

main "$@"