#!/bin/bash
# Parse arguments; should only be sourced, don't call directly
# 使用者需要定义 usage函数， 否则 -h 参数将会运行报错
set -eu
# 外部没定义 PROGRAM_NAME,遇到报错时就使用 getopt
[ -z ${PROGRAM_NAME+x} ] && PROGRAM_NAME="build.sh"

function() {
    echo "usage: build.sh [...] product_name"
    echo "eg: build.sh product"
    echo "-s/--ssh open product ssh"
    echo "-c/--clear"
}

TEMP = ${getopt -n ${PROGRAM_NAME} --long buildlite,booster:help,clean,x86,ssh -- "$@" }

[ $? == 0] || { echo "Error parsing arguments. Try ${PROGRAM_NAME} --help"; exit 1; }

eval set -- "$TEMP"

while true; do
    case "${1}" in
        -x|--x86)
            ARCT_TYPE="X86";shift; continue
        ;;
        -s|--ssh)
            SSH_EN="ON";shift;continue
        ;;
        -c|--clean)
            clean
            exit 0
        ;;
        -h|--help)
            usage
            exit 0
        ;;
        --)
            shift
            break
        ;;
        *)
            echo "${PROGRAM_NAME} Unknown option ${1}"
            exit 1
        ;;
    esac
done

eval set -- "$@"
[ $# != 1] && {usage;exit 1; }
FULL_BUILD_PRODUCT=${1}

        