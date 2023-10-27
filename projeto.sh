#!/bin/bash

#Eduardo Lopes     103070
#Tomás Brás        112665

#declaração de variaveis
 
function input() {

    #zona de teste
    echo "$@"    
    echo -e                                                                 #vai exibir todos os argumentos passados  
    dir=${@: -1}                                                            #atribui o último argumento á variável file
    du --time $dir                                                                #printa em bytes e não em kilobytes
    size_in_bytes=$(du -b $dir | grep -oE '[0-9.]+')                                #size_in_kilobytes=$(du -b "$file" | awk '{print $1}') #alternativa que usa awk(temos de ver qual funciona)
                                                                                    #size_in_bytes=$((size_in_kilobytes * 1024))
    oper=""
    oper="${oper}$1 ${@: -2}"
    
    #fim de zona                                
                                                                                
    while getopts ":n:r:a:d:s:l" flag; do
        case $flag in
            n)
            
                dat=$(stat -c "%y" "$dir" | cut -d ' ' -f1)
                size=$(du -sh "$dir" | awk '{print $1}')            # Use o comando stat para obter informações detalhadas sobre o arquivo
                printf "%-10s %-10s %-10s %-10s\n" "SIZE (KB)" "NAME" "$dat" "$oper"
                find "$dir" -type d -exec du -k {} \; | awk '{file=$2; sub(/\.[^.]+$/, "", file); printf "%-10s %-10s\n", $1, file}'
                find "$dir" -type f -exec du -k {} \; | awk '{file=$2; sub(/\.[^.]+$/, "", file); printf "%-10s %-10s\n", $1, file}'
                ;;  
            r)
                ;;
            a)
                ;;
            d)

                ;;
            s)
                minimo=$OPTARG
                echo "$minimo"
                #if du $file | grep -oE '[0-9.]+' > $minimo ; then
                    
                #else
                    #echo "Tamanho minimo inválido"
                    #exit 1;
                #fi
                ;;
            l)
                #utilizar o head -n para delimitar o numero de linhas da tabela
                echo "SIZE NAME $@"
                ;;
    
            *)
                echo "Opção inválida! A sair..."
                exit 1;;
        esac
    done
    shift $((OPTIND - 1))
}


main(){
    input "$@"
}
main "$@" 