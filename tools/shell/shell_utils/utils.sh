#!/bin/bash
# 通用函数
set -euo pipefail
function get_script_directory() {
    echo $(cd "$(dirname "$0")";pwd)
}

function log_error() {
    echo "error:[oct cut] ${1}"
    exit 1
}

function log_info() {
    echo "info:[oct cut] ${1}"
    exit 1
}

function check_path_exit() {
    path_to_check=${1}
    [ -d "${path_to_check}" ] && return 0
    [ -f "${path_to_check}" ] && return 0
    log_error "${log_error} not exist"
}

# copy result to OUTPUT_DIR
function check_and_install() {
    [ $# != 2 ] && log_error "check_and_install: args should be 2!"
    path_to_isntall=${1}
    OUTPUT_DIR=${2}
    log_info "installing "${path_to_isntall}" to ${OUTPUT_DIR}"
    [ -f "${path_to_isntall}" ] && { cp -f "${path_to_isntall}" ${OUTPUT_DIR}/ ; return 0; }
    [ -d "${path_to_isntall}" ] && { cp -rf "${path_to_isntall}" ${OUTPUT_DIR}/ ; return 0; }
    log_error "failed to install, "${path_to_isntall}" not exist !"
}

function recreate_dir() {
    path=${1}
    [ -f "${path}" ] && log_error ""${path}" is a file, should be a dir, please check why"
    [ -d "${path}" ] && { rm -rf "${path}"; log_info "remove and recreate "${path}""; }
    mkdir -p "${path}"
}