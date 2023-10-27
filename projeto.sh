#!/bin/bash

#Eduardo Lopes     103070
#Tomás Brás        112665

#declaração de variaveis

input() {

    #zona de teste
    echo "$@"
    echo "${@: -1}"
    file=${@: -1}
    du --time $file
    du $file | grep -oE '[0-9.]+'
    #fim de zona

    while getopts ":n:r:a:d:s:l" flag; do
        case $flag in
            n)
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