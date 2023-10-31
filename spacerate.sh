#!/bin/bash

#Eduardo Lopes     103070
#Tomás Brás        112665

#declaração de variaveis
declare reverse=0               #ordenação normal
declare sort_name=0             #ordenação default dos ficheiros
declare -A value1
declare -A value2
declare -A value3
declare found=0                 #caminho encontrado no A
declare expressao="*"
declare space_dif=0
declare arrayA_filled=0
declare arrayB_filled=0

#declaração de arrays
declare -A space_arrayA
declare -A space_arrayB 
declare -A space_arrayfinal

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
                if [ -n "$OPTARG" ]; then
                    expressao=$OPTARG
                fi
                ;;
        esac
    done
    shift $((OPTIND - 1))
}

function space() {
    local file="$1"
    local temp_file=$(mktemp)  # Cria um arquivo temporário

    tail -n +2 "$file" > "$temp_file"

    if [ $arrayA_filled -eq 0 ]; then
        while IFS=' ' read -r size locat; do
            space_arrayA["$locat"]=$size
        done < "$temp_file"
        arrayA_filled=1
    else
        while IFS=' ' read -r size locat; do
            space_arrayB["$locat"]=$size
        done < "$temp_file"
        arrayB_filled=1
    fi
    
    found=0
    rm "$temp_file"  # Remove o arquivo temporário

    if [ $arrayB_filled -eq 1 ]; then
    found=0 

        for first1 in "${!space_arrayA[@]}"; do
            tamanho="${space_arrayA[$first1]}"

            if [[ -n ${space_arrayB[$first1]} ]]; then
                spacedif=$((space_arrayB[$first1] - tamanho))
                space_arrayfinal[$first1]=$spacedif
            else
                modify_first="$first1-NEW"
                space_arrayfinal[$modify_first]=$tamanho
            fi
        done

        for first2 in "${!space_arrayB[@]}"; do
            if [[ -z ${space_arrayA[$first2]} ]]; then
                spacedif=${space_arrayB[$first2]}
                modify_first="$first2-REMOVED"
                space_arrayfinal[$modify_first]=$spacedif
            fi
        done
    fi
}

function print() {
    if [[ "${#space_arrayfinal[@]}" -eq 0 ]]; then
        echo "Precisa de passar dois ficheiros como argumento"
        exit 1
    fi
    printf "%-5s %s\n" "SIZE" "NAME"
    if [[ $reverse -eq 1 ]]; then
        if [[ $sort_name -eq 1 ]]; then
            for val in "${!space_arrayfinal[@]}"; do
                printf "%-5s %s\n" "${space_arrayfinal[$val]}" "$val"
            done | sort -k2,2r
        else
            for val in "${!space_arrayfinal[@]}"; do
                printf "%-5s %s\n" "${space_arrayfinal[$val]}" "$val"
            done | sort -k1,1n
        fi
    else
        if [[ $sort_name -eq 1 ]]; then
            for val in "${!space_arrayfinal[@]}"; do
                printf "%-5s %s\n" "${space_arrayfinal[$val]}" "$val"
            done | sort -k2,2
        else
            for val in "${!space_arrayfinal[@]}"; do
                printf "%-5s %s\n" "${space_arrayfinal[$val]}" "$val"
            done | sort -k1,1nr
        fi
    fi
}


function main() {
    input "$@"
    files "$@"
    print "$@"
}

main "$@"
unset IFS