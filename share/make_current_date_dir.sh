#!/bin/bash
#
# 创建当前日期目录
# 版权 2024 J1nH4ng<j1nh4ng@icloud.com>

# Globals:
# Arguments:
#  None

#######################################
# banner 引用函数
# Globals:
#   BASH_SOURCE
# Arguments:
#  None
#######################################
function import_banner() {
  local script_dir
  script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  source "${script_dir}/../core/banner.sh"
  banner_main
}

#######################################
# Function: Get Input
# Globals:
#   dir_path
# Arguments:
#   1
#######################################
function get_input() {
  dir_path=$1
}

#######################################
# Function: Get Current Date
# Globals:
#   current_date
# Arguments:
#  None
#######################################
function get_current_date() {
  current_date=$(date +"%Y%m%d%H%M%S")
}

#######################################
# Function: Make Date Directory
# Globals:
#   current_date
#   dir_path
# Arguments:
#  None
#######################################
function make_date_dir() {
  mkdir "${dir_path}"/"${current_date}"
}

#######################################
# main Function，用于函数调用
# Arguments:
#   1
#######################################
function make_current_date_dir_main() {
  get_input "$1"
  get_current_date
  make_date_dir
}

#######################################
# Main Function
# Arguments:
#   1
#######################################
function main() {
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # banner 输出
    import_banner

    get_input "$1"
    get_current_date
    make_date_dir
  fi
}

main "$@"
