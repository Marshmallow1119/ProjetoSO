#!/bin/bash

#Eduardo Lopes     103070
#Tomás Brás        112665

#declaração de variaveis
declare total_space=0
declare minimo=0
declare limite=10000
declare expressao="*"
declare reverse=0               #ordenação normal
declare sort_name=0             #ordenação default dos ficheiros
declare validation='^[0-9]+$'
declare input_date=$(date +%s)

#variavel para ficheiros com espaço no nome
IFS=$'\n'

#declaração de arrays
declare -A space_array

#verifica quais dos argumentos são diretotias
function directories() {          
    for i in "$@"; do
        if [[ -d "$i" ]]; then
            space "$i"  
        fi
    done   
}

#verificação e leitura das flags passadas como argumentos
function input() {                                                                                            
    while getopts "n:rad:s:l:" flag; do
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
                input_date=$(date -d "$OPTARG" +%s 2>/dev/null)
                if [[ -z $input_date ]]; then
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

#calculo do espaço ocupado pelos ficheiros de um diretório
function space() {
    dires=($(find "$1" -type d))

    while IFS= read -r -d '' dir; do
        total_space=0
        while IFS= read -r -d '' file; do

            if [[ ! -d "$file" ]]; then
                space=$(du "$file" | awk '{print $1}' | grep -oE '[0-9.]+')
                if [[ $space -ge $minimo ]]; then
                    total_space=$(echo "$total_space + $space" | bc)
                fi
            fi
        done < <(find "$dir" -type f -name "$expressao" ! -newermt "@$input_date" -print0)
        
        # Guardar os valores num array
        space_array["$dir"]=$total_space
    done < <(find "$1" -type d -print0)
}

function print() {
    #verificação se passou algum diretório como argumento
    if [[ "${#space_array[@]}" -eq 0 ]]; then 
        echo "Precisa de passar um diretório como argumento"
        exit 1
    fi

    #print final
    echo "SIZE NAME $(date +%Y%m%d) $@"
    if [[ $reverse -eq 1 ]]; then
        if [[ $sort_name -eq 1 ]]; then
            for val in "${!space_array[@]}"; do
                echo "${space_array[$val]} $val"
            done | sort -k2,100r | head -n "$limite"
        else
            for val in "${!space_array[@]}"; do
                echo "${space_array[$val]} $val"
            done | sort -k1,1n | head -n "$limite"
        fi
    else
        if [[ $sort_name -eq 1 ]]; then
            for val in "${!space_array[@]}"; do
                echo "${space_array[$val]} $val"
            done | sort -k2,100 | head -n "$limite"
        else
            for val in "${!space_array[@]}"; do
                echo "${space_array[$val]} $val"
            done | sort -k1,1nr | head -n "$limite"
        fi
    fi
}

function main() {
    input "$@"
    directories "$@"
    print "$@"
}

main "$@"
unset IFS