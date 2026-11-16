# 让 VSCode / Cursor 的 Outline 面板显示 Shell 脚本函数和符号

> 操作日期：2026-11-16
> 环境：macOS (darwin 24.3.0) + nvm node v24.15.0
> 适用项目：本仓库下大量 `entry.sh` 脚本（examples/all-in-one、leetcode、s3-boto3 等）

## 1. 问题现象

在 VSCode 和 Cursor 中打开 `.sh` 脚本：

- 大纲（Outline）面板**空白**，不显示函数、变量等符号
- `Cmd+Shift+O`（按符号跳转）搜不到任何函数

## 2. 根因

VSCode / Cursor 内置的 shellscript 语法支持**不附带语言服务器**，符号解析只靠一套简易正则（Cursor 中经常完全失效）。

要获得稳定的符号大纲，需要两样东西：

| 组件 | 作用 |
|---|---|
| **Bash IDE 扩展** | VSCode/Cursor 与语言服务器之间的桥梁，把符号信息送进 Outline 面板 |
| **`bash-language-server`** | 真正的解析引擎（基于 Tree-sitter），扩展本身**不包含**它，需单独安装 |

检查命令（确认两者都缺失）：

```bash
# 查看已安装的 bash 相关扩展（两者均为空）
code   --list-extensions | grep -iE 'bash|shell'
cursor --list-extensions | grep -iE 'bash|shell'

# 确认语言服务器不存在
which bash-language-server   # => not found
```

## 3. 安装步骤

### 3.1 安装 bash-language-server（npm 全局安装）

```bash
npm install -g bash-language-server

# 验证
which bash-language-server
# /Users/wu.feihu/.nvm/versions/node/v24.15.0/bin/bash-language-server

bash-language-server --version
# 5.8.1
```

> 其他安装方式（任选其一）：
> ```bash
> brew install bash-language-server
> # 或
> npm install -g bash-language-server@next   # 预发布版
> ```

### 3.2 安装 Bash IDE 扩展

⚠️ **重要**：网上旧教程写的扩展 ID `mads-hartmann.bash-ide` **已失效**
（marketplace 报 `Extension not found`），正确 ID 是：

```
mads-hartmann.bash-ide-vscode
```

两个编辑器都要装：

```bash
# VSCode
code --install-extension mads-hartmann.bash-ide-vscode
# Extension 'mads-hartmann.bash-ide-vscode' v1.43.2 was successfully installed.

# Cursor
cursor --install-extension mads-hartmann.bash-ide-vscode
# Extension 'mads-hartmann.bash-ide-vscode' v1.43.2 was successfully installed.
```

## 4. 生效与验证

1. 重启 VSCode / Cursor（或命令面板 → `Developer: Reload Window`）
2. 打开任意 `entry.sh`
3. 验证方式：
   - 侧栏资源管理器底部 **大纲** 面板 → 应列出全部函数/变量
   - `Cmd+Shift+O` → 输入函数名可直接跳转

额外获得的能力：函数定义跳转、变量引用查找、悬停文档、shellcheck 诊断集成。

## 5. 踩坑记录

### 坑 1：旧扩展 ID 失效

`mads-hartmann.bash-ide` → 报 `Extension not found`。
通过 Open VSX 的搜索 API 找到正确 ID：

```bash
curl -sL "https://open-vsx.org/api/-/search?query=bash-ide&size=10"
# 结果第一行：mads-hartmann.bash-ide-vscode  1.43.2  Bash IDE
```

（直接查 marketplace 的 gallery API 在本机网络下会超时/截断，Open VSX 更稳。）

### 坑 2：从 Dock/图标启动时找不到 bash-language-server

编辑器从 Dock 启动时**不继承 shell 的 PATH**，读不到 nvm 下的
`~/.nvm/versions/node/v24.15.0/bin`。若重启后 Outline 仍为空，在
`settings.json`（`Cmd+Shift+P` → `Preferences: Open User Settings (JSON)`）中
显式指定绝对路径：

```jsonc
{
  "bashIde.pathToBashLanguageServer": "/Users/wu.feihu/.nvm/versions/node/v24.15.0/bin/bash-language-server"
}
```

或者改用习惯：从终端里 `code .` / `cursor .` 启动编辑器（继承 shell PATH）。

### 坑 3：npm 全局安装报 EPERM

在受限环境（如沙箱终端）执行 `npm install -g` 写 `~/.nvm/...` 时可能报
`EPERM: operation not permitted`，换正常终端重跑即可。

## 6. 卸载方法（备忘）

```bash
npm uninstall -g bash-language-server
code   --uninstall-extension mads-hartmann.bash-ide-vscode
cursor --uninstall-extension mads-hartmann.bash-ide-vscode
```
