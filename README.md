# utils-shell

> [!NOTE]
> 重新构建整个脚本库
> 脚本应该是独立的，每一个脚本都可以直接拿来直接使用，尽可能的减少与其他文件的耦合。

## 目录结构

```bash
/
  modules/: 模块部分，内容为 function 函数，用于实现相同函数的复用
  contents/: 内容部分，内容为可以直接使用的单个脚本内容
```

## Contents 目录下脚本说明

### server_inspection.sh

> [!NOTE]
> 服务器巡检脚本
