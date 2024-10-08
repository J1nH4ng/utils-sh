#!/bin/bash
#
# 下载 git 仓库
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
# 从列表文件中选择或输入并写入
# Arguments:
#  1. 提示信息
#  2. 列表文件路径
#  3. 记录索引
# Returns:
#  选择的值或输入的值
#######################################
function select_or_input() {
  local prompt=$1
  local list_file=$2
  local index=$3

  local value

  local options=()
  local option
  local line

  if [ -f "${list_file}" ]; then
    while IFS= read -r line; do
      if [[ "${line}" =~ ^\【([^\】]+)\】\【([^\】]+)\】\【([^\】]+)\】$ ]]; then
        local project_name="${BASH_REMATCH[1]}"
        local package_name="${BASH_REMATCH[2]}"
        local git_url="${BASH_REMATCH[3]}"
        if [[ -n "${project_name}" && -n "${package_name}" && -n "${git_url}" ]]; then
          options+=("【${project_name}】【${package_name}】【${git_url}】")
        fi
      fi
    done < "${list_file}"
  fi

  if [ ${#options[@]} -eq 0 ]; then
    read -erp "${prompt}" value
  else
    select option in "${options[@]}" "手动输入"; do
      if [ -n "${option}" ] && [ "${option}" != "手动输入" ]; then
        if [[ "${option}" =~ ^\【([^\】]+)\】\【([^\】]+)\】\【([^\】]+)\】$ ]]; then
          local project_name="${BASH_REMATCH[1]}"
          local package_name="${BASH_REMATCH[2]}"
          local git_url="${BASH_REMATCH[3]}"
          case "${index}" in
            1) value="${project_name}" ;;
            2) value="${package_name}" ;;
            3) value="${git_url}" ;;
          esac
          break
        else
          echo_warn "无效选择，请重新选择"
        fi
      elif [ "${option}" == "手动输入" ]; then
        read -erp "${prompt}" value
        break
      else
        echo_warn "无效选择，请重新选择"
      fi
    done
  fi

  echo "${value}"
}

#######################################
# 写入记录到列表文件
# Arguments:
#  1. 项目包名
#  2. 包名
#  3. Git 地址
#  4. 列表文件路径
#######################################
function write_record() {
  local project_name=$1
  local package_name=$2
  local git_url=$3
  local list_file=$4

  if ! grep -q "【${project_name}】【${package_name}】【${git_url}】" "${list_file}"; then
    echo "【${project_name}】【${package_name}】【${git_url}】" >> "${list_file}"
  fi
}

#######################################
# 下载源代码
# Arguments:
#  None
#######################################
function git_clone() {
  local branch_name
  local data_path
  data_path="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  local list_file="${data_path}/../data/speed-cicd/project_list.txt"

  local git_url

  echo_info "请选择或输入输入项目名：\n"
  project_name=$(select_or_input "请输入项目名：" "${list_file}" 1)

  echo "========================================================================"
  echo_info "您选择或输入的项目名为：\033[44m${project_name}\033[0m"
  echo -e "========================================================================\n"


  if [ -z "${project_name}" ]; then
    echo_error_basic "项目包名不能为空"
    exit 1
  fi

  echo_info "请选择或输入项目包名：\n"
  package_name=$(select_or_input "请输入项目包名：" "${list_file}" 2)

  echo "========================================================================"
  echo_info "您选择或输入的项目包名为：\033[44m${package_name}\033[0m"
  echo -e "========================================================================\n"

  if [ -z "${package_name}" ]; then
    echo_error_basic "项目包名不能为空"
    exit 1
  fi

  echo_info "请选择或输入项目 Git 地址：\n"
  git_url=$(select_or_input "请输入项目 Git 地址：" "${list_file}" 3)

  echo "========================================================================"
  echo_info "您选择或输入的 Git 地址为：\033[44m${git_url}\033[0m"
  echo -e "========================================================================\n"

  if [ -z "${git_url}" ]; then
    echo_error_basic "Git 地址不能为空"
    exit 1
  fi

  write_record "${project_name}" "${package_name}" "${git_url}" "${list_file}"

  echo_info "请选择要克隆的分支：\n"
  select branch_name in main test "手动输入"; do
    case "${branch_name}" in
      main|test)
        break
        ;;
      "手动输入")
        read -erp "请输入分支名称：" branch_name
        if [ -n "${branch_name}" ]; then
          echo_info "您输入的分支名称为：${branch_name}"
          break
        else
          echo_warn "分支名称不能为空，请重新输入"
        fi
        ;;
      *)
        echo_warn "无效选择，请重新选择"
        ;;
    esac
  done

  echo "========================================================================"
  echo_info "您选择或输入的 Git 分支为：\033[44m${branch_name}\033[0m"
  echo -e "========================================================================\n"

  clean_up_git_clone

  mkdir -p "/usr/local/src/speed-cicd/${project_name}" || {
    echo_error_basic "创建项目目录失败，脚本将退出"
    return 1
  }

  echo_info "正在克隆 Git 仓库：\033[44m【${git_url}】\033[0m"
  echo_info "正在克隆分支：\033[44m【${branch_name}】\033[0m"
  echo_info "克隆位置为： \033[44m【/usr/local/src/speed-cicd/${project_name}/${package_name}】\033[0m"

  # 尝试克隆用户选择的分支
  if ! git clone -b "${branch_name}" --single-branch "${git_url}" "/usr/local/src/speed-cicd/${project_name}/${package_name}"; then
    # 如果克隆 main 分支失败，尝试克隆 master 分支
    if [ "${branch_name}" == "main" ]; then
      echo_info "克隆 main 分支失败，尝试克隆 master 分支"
      git clone -b "master" --single-branch "${git_url}" "/usr/local/src/speed-cicd/${project_name}/${package_name}" || {
        echo_error_basic "克隆 Git 仓库失败，脚本将退出"
        return 1
      }
    else
      echo_error_basic "克隆 Git 仓库失败，脚本将退出"
      return 1
    fi
  fi
}


#######################################
# 删除下载的源代码
# Arguments:
#  None
#######################################
function clean_up_git_clone() {
  if [ -d "/usr/local/src/speed-cicd/${project_name}" ]; then
    echo_warn "目录 /usr/local/src/speed-cicd/${project_name} 已存在，正在删除......"
    rm -rf "/usr/local/src/speed-cicd/${project_name}" || {
      echo_error_basic "删除目录失败，脚本将退出"
      return 1
    }
  fi
}



#######################################
# main function: 用于调用
# Arguments:
#  None
#######################################
function git_clone_main() {
  git_clone
}

#######################################
# main function
# Arguments:
#  None
#######################################
function main() {
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    import_output_logs
    git_env_check
    git_clone
  fi
}

main "$@"
