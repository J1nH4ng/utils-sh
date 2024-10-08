#!/bin/bash
#
# 环境变量检查脚本
# 版权 2024 J1nH4ng<j1nh4ng@icloud.com>

# Globals:
# Arguments:
#  None

#######################################
# 日志输出脚本引入
# Arguments:
#  None
#######################################
function import_output_logs() {
  local script_dir
  script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  source "${script_dir}/../core/output_logs.sh"
}

#######################################
# Git 环境检查
# Arguments:
#  None
#######################################
function git_env_check() {
  echo_info "检查 Git 是否安装"
  if command -v git >/dev/null 2>&1; then
    echo_info "Git 已成功安装"
  else
    echo_error_basic "Git 不存在于系统路径中，请安装 Git"
    exit 1
  fi
}

#######################################
# MVN 环境检查
# Arguments:
#  None
#######################################
function mvn_env_check() {
#  local mvn_path
#
#  echo_info "检查 MVN 是否安装"
#  if command -v mvn >/dev/null 2>&1; then
#    echo_info "MVN 已成功安装"
#    mvn --version
#    mvn_bin="mvn"
#  else
#    echo_error_basic "MVN 不存在于系统路径中，请输入 MVN 路径或安装 MVN"
#    while true; do
#      read -erp "请输入 MVN 路径：" mvn_path
#      if [ -x "${mvn_path}" ] && command -v mvn >/dev/null 2>&1; then
#        echo_info "在 ${mvn_path} 中查找到了 MVN"
#        ${mvn_path} --version
#        mvn_bin="${mvn_path}"
#        break
#      else
#        echo_error_basic "MVN 路径无效，脚本将退出"
#        exit 1
#      fi
#    done
#  fi

  echo_info "检查 mvn 是否安装"
  if command -v mvn >/dev/null 2>&1; then
    echo_info "mvn 已成功安装"
  else
    echo_error_basic "mvn 不存在于系统路径中，请安装 mvn"
    exit 1
  fi
}

#######################################
# Pnpm 环境检查
# Arguments:
#  None
#######################################
function pnpm_env_check() {
  echo_info "检查 pnpm 是否安装"
  if command -v pnpm >/dev/null 2>&1; then
    echo_info "pnpm 已成功安装"
  else
    echo_error_basic "pnpm 不存在于系统路径中，请安装 pnpm"
    exit 1
  fi
}


#######################################
# Nvm 环境检查
# Arguments:
#  None
#######################################
function nvm_env_check() {
  echo_info "检查 nvm 是否安装"
  if command -v pnpm >/dev/null 2>&1; then
    echo_info "nvm 已成功安装"
  else
    echo_error_basic "nvm 不存在于系统路径中，请安装 nvm"
    exit 1
  fi
}

#######################################
# lrzsz 环境检查
# Arguments:
#  None
#######################################
function lrzsz_env_check() {
  echo_info "检查 lrzsz 是否安装"
  if command -v sz >/dev/null 2>&1; then
    echo_info "lrzsz 已成功安装"
  else
    echo_error_basic "lrzsz 不存在于系统路径中，请安装 lrzsz"
    exit 1
  fi
}

#######################################
# zip 环境检查
# Arguments:
#  None
#######################################
function zip_env_check() {
  echo_info "检查 zip 是否安装"
  if command -v zip >/dev/null 2>&1; then
    echo_info "zip 已成功安装"
  else
    echo_error_basic "zip 不存在于系统路径中，请安装 zip"
    exit 1
  fi
}

#######################################
# env_bin 函数
# Arguments:
#  None
#######################################
function env_bin() {
  declare -rx mvn_bin="mvn"
  declare -rx git_bin="git"
  declare -rx pnpm_bin="pnpm"
  declare -rx nvm_bin="nvm"
  declare -rx sz_bin="sz"
  declare -rx zip_bin="zip"
}

#######################################
# main 函数 用于其他脚本调用
# Arguments:
#  None
#######################################
function env_check_main() {
  echo_info "开始环境检查"
  mvn_env_check
  git_env_check
  pnpm_env_check
  zip_env_check
  nvm_env_check
  lrzsz_env_check
  echo_info "环境检查完成"
}

#######################################
# main 函数
# Arguments:
#  None
#######################################
function main() {
  import_output_logs
  mvn_env_check
  git_env_check
  pnpm_env_check
  zip_env_check
  nvm_env_check
  lrzsz_env_check
  echo_info "环境检查完成"
}

main "$@"
