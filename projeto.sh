#!/bin/bash

#Eduardo Lopes     103070
#Tomás Brás        112665

#declaração de variaveis

input() {

    #zona de teste
    echo "$@"                                                                       #vai exibir todos os argumentos passados
    echo "${@: -1}"     
    dir=${@: -1}                                                                    #atribui o último argumento á variável file
    du --time $dir                                                                  #printa em bytes e não em kilobytes
    size_in_bytes=$(du -b $dir | grep -oE '[0-9.]+')                                #size_in_kilobytes=$(du -b "$file" | awk '{print $1}') #alternativa que usa awk(temos de ver qual funciona)
                                                                                    #size_in_bytes=$((size_in_kilobytes * 1024))
    oper=""
    oper="${oper}${${@: -3} ${@: -2} ${@: -1}"
    ext=${@: -2} 
     
                                                                                    #fim de zona                                
                                                                                    
    while getopts ":n:r:a:d:s:l" flag; do
        case $flag in
            n)
            
            info_file=$(stat "$dir")                                                 # Use o comando stat para obter informações detalhadas sobre o arquivo
            date=$(echo "$informacoes" | grep "Modify:" | awk '{print $2, $3}')      #data de modificação do resultado
            printf "%-10s %-50s %-25s %-10s\n" "SIZE" "NAME" "Modify" "$oper"
            find "$dir" -type f -name "$ext" -exec du -h {} \; | awk '{print $1, $2}'
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

main() {
    input "$@"
}

main "$@"