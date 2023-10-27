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
declare -a space_array

function directories() {          #verifica quais dos argumentos são diretotias
    for i in "$@"; do
        if [[ -d "$i" ]]; then
            space "$i"  
        fi
    done   
}

function input() {

    #zona de teste
    echo "$@"                                                                       #vai exibir todos os argumentos passados
    echo "${@: -1}"     
    dir=${@: -1}                                                                    #atribui o último argumento á variável file
    du --time $dir                                                                  #printa em bytes e não em kilobytes
    size_in_bytes=$(du $dir | grep -oE '[0-9.]+')                                #size_in_kilobytes=$(du -b "$file" | awk '{print $1}') #alternativa que usa awk(temos de ver qual funciona)
                                                                                    #size_in_bytes=$((size_in_kilobytes * 1024))
     
    #fim de zona                           
                                                                                    
    while getopts ":n:r:a:d:s:l" flag; do
        case $flag in
            n)  
                expressao=$OPTARG
                #isto é para o print
                dat=$(stat -c "%y" "$dir" | cut -d ' ' -f1)
                size=$(du -sh "$dir" | awk '{print $1}')            # Use o comando stat para obter informações detalhadas sobre o arquivo
                printf "%-10s %-10s %-10s %-10s\n" "SIZE" "NAME" "$dat" "$oper"
                find "$dir" -type d -exec du -k {} \; | awk '{file=$2; sub(/\.[^.]+$/, "", file); printf "%-10s %-10s\n", $1, file}'
                find "$dir" -type f -exec du -k {} \; | awk '{file=$2; sub(/\.[^.]+$/, "", file); printf "%-10s %-10s\n", $1, file}'
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
    dires=$(find "$1" -type d )
    index=0

    for i in "${dires[@]}"; do
        total_space="0"
        files=$(find "$dires" -type f -size "$minimo" -name "$expressao")

        for k in "${files[@]}"; do
            if [[ ! -d "$k" ]]; then
                space=$(du "$k" | grep -oE '[0-9.]+')
            fi
            total_space=$(echo "$total_space + $space" | bc)
        done

        #guardar o valor num array
        space_array[$index]="$total_space"
        ((index++))
    done 
}

function print() {
    #utilizar o head -n para delimitar o numero de linhas da tabela
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
    directories "$@"
    input "$@"
}

main "$@"