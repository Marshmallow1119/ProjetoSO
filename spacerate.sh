#!/bin/bash

#Eduardo Lopes     103070
#Tomás Brás        112665

#declaração de variaveis
declare reverse=0               #ordenação normal
declare sort_name=0             #ordenação default dos ficheiros
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
    while getopts "ra" flag; do
        case $flag in
            r)  
                reverse=1
                ;;
            a)  
                sort_name=1
                ;;
            *)
                #caso seja passado um argumento não válido
                echo "Opção inválida! A sair..."
                exit 1
                ;;
        esac
    done
    shift $((OPTIND - 1))
}

function space() {
    local file="$1"
    local temp_file=$(mktemp)  # Cria um arquivo temporário

    if [[ $(head -n 1 "$file") == "SIZE"* ]]; then
        tail -n +2 "$file" > "$temp_file"
    else
        # Caso a primeira linha não comece com "SIZE", apenas copie o arquivo original
        cp "$file" "$temp_file"
    fi

    if [ $arrayA_filled -eq 0 ]; then
        while IFS=' ' read -r size locat || [ -n "$size" ]; do
            space_arrayA["$locat"]=$size
        done < "$temp_file"
        arrayA_filled=1
    else
        while IFS=' ' read -r size locat || [ -n "$size" ]; do
            space_arrayB["$locat"]=$size
        done < "$temp_file"
        arrayB_filled=1
    fi

    rm "$temp_file"  # Remove o arquivo temporário

    if [ "$arrayA_filled" -eq 1 ] && [ "$arrayB_filled" -eq 1 ]; then

        for first1 in "${!space_arrayA[@]}"; do
            tamanho="${space_arrayA[$first1]}"
            if [[ -n ${space_arrayB[$first1]} ]]; then
                tama="${space_arrayB[$first1]}"
                spacedif=$((tama - tamanho))
                space_arrayfinal[$first1]=$spacedif
            else
                modify_first="$first1-NEW"
                space_arrayfinal["$modify_first"]=$tamanho
            fi
        done

        for first2 in "${!space_arrayB[@]}"; do
            if [[ -z ${space_arrayA[$first2]} ]]; then
                spacedif=${space_arrayB[$first2]}
                modify_first="$first2-REMOVED"
                space_arrayfinal["$modify_first"]=$(( -1 * ${space_arrayB[$first2]} ))
            fi
        done
    fi
}

function print() {
    if [[ "${#space_arrayfinal[@]}" -eq 0 || "$#" -ne 2]]; then
        echo "Precisa de passar dois ficheiros como argumento"
        exit 1
    fi

    echo -e "SIZE NAME"
    if [[ $reverse -eq 1 ]]; then
        if [[ $sort_name -eq 1 ]]; then
            for val in "${!space_arrayfinal[@]}"; do
                echo -e "${space_arrayfinal[$val]} $val"
            done | sort -k2,100r
        else
            for val in "${!space_arrayfinal[@]}"; do
                echo -e "${space_arrayfinal[$val]} $val"
            done | sort -k1,1n
        fi
    else
        if [[ $sort_name -eq 1 ]]; then
            for val in "${!space_arrayfinal[@]}"; do
                echo -e "${space_arrayfinal[$val]} $val"
            done | sort -k2,100
        else
            for val in "${!space_arrayfinal[@]}"; do
                echo -e "${space_arrayfinal[$val]} $val"
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