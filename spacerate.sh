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
    space_dif=0

    if [ ${#space_arrayA[*]} -eq 0 ]; then
        tail -n +2 "$1" | while IFS=' ' read -r -d '' size locat ; do
            space_arrayA["$size"]=$locat
        done 
    else
        tail -n +2 "$1" | while IFS=' ' read -r -d '' size locat ; do
            space_arrayB["$size"]=$locat
        done 
        echo "adoro tudo"
    fi


    found=0
    if [ ${#space_arrayB[*]} -ne 0 ]; then
        for first1 in "${!space_arrayA[@]}"; do
            echo "$first1"
            for first2 in "${!space_arrayB[@]}"; do
                echo "$first2"
                if [ "$first1" == "$first2" ]; then
                    spacedif=$((space_arrayB[$first2] - space_arrayA[$first1]))
                    space_arrayfinal[$first1]=$spacedif
                    echo "$spacedif"
                    break
                else 
                    found=1;
                fi
            done

            if [[ $found -eq 1 ]]; then
                spacedif=$(space_arrayA[$first1])
                modify_first="$caminhoB-NEW"
                space_arrayfinal[$modify_first]=$spacedif
            fi
        done
    fi

    found=0

    for first2 in "${!space_arrayA[@]}"; do
        for first1 in "${!space_arrayB[@]}"; do
            if [ "$first2" == "$first1" ]; then
                spacedif=$((space_arrayB[$first1] - space_arrayA[$first2]))
                space_arrayfinal[$first2]=$spacedif
                break
            else 
                found=1;
            fi
        done
        if [[ $found -eq 1 ]]; then
            spacedif=$(space_arrayB[$first2])
            modify_first="$caminhoB-REMOVED"
            space_arrayfinal[$modify_first]=$spacedif
        fi
    done
    echo "${space_Arrayfinal[@]}"
}
    

function print() {
    if [[ "${#space_arrayfinal[@]}" -eq 0 ]]; then 
        echo "Precisa de passar dois ficheiros como argumento"
        exit 1
    fi
    #print final
    printf "%-10s %-10s\n" "SIZE" "NAME" 
    if [[ $reverse -eq 1 ]]; then
        if [[ $sort_name -eq 1 ]]; then
            for val in "${!space_arrayfinal[@]}"; do
                echo "${space_arrayfinal[$val]} $val"
            done | sort -k2,100r
        else
            for val in "${!space_arrayfinal[@]}"; do
                echo "${space_arrayfinal[$val]} $val"
            done | sort -k1,1n
        fi
    else
        if [[ $sort_name -eq 1 ]]; then
            for val in "${!space_arrayfinal[@]}"; do
                echo "${space_arrayfinal[$val]} $val"
            done | sort -k2,100 
        else
            for val in "${!space_arrayfinal[@]}"; do
                echo "${space_arrayfinal[$val]} $val"
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