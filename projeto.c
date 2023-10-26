#!/bin/bash

#Eduardo Lopes       103070
#Tomás Brás        112665

#declaração de variaveis

input() {

    #zona de teste
    echo "$@"
    echo "${@: -1}"
    file=${@: -1}
    du --time $file
    du --time $file | cut -d " " -f 1 
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
                space=$OPTARG
                echo "$space"
                #if du $file | cut -b 1 > $space ; then
                    
                #else
                    #echo "Tamanho minimo inválido"
                    #exit 1;
                #fi
                ;;
            l)
                printf "%4s %4s" "SIZE" "NAME" 
                echo " $@"
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
