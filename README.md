# LazyVim 安装项目

> 🚀 一键安装 LazyVim 的完整解决方案

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-blue.svg)](https://github.com/LazyVim/starter)
[![GitHub stars](https://img.shields.io/github/stars/corner430/lazyvim-installer.svg?style=social&label=Star)](https://github.com/corner430/lazyvim-installer)
[![GitHub forks](https://img.shields.io/github/forks/corner430/lazyvim-installer.svg?style=social&label=Fork)](https://github.com/corner430/lazyvim-installer)

## 📖 项目简介

这是一个专为 LazyVim 设计的完整安装解决方案，包含：

- 🎯 **自动安装脚本** - 一键安装所有依赖
- 📋 **详细安装指南** - 手动安装的完整教程
- 🔍 **系统检查工具** - 验证安装是否成功
- 📚 **学习资源** - 快速上手指南

## ✨ 特性

- 🔄 **跨平台支持** - 支持 Linux 和 macOS
- 🤖 **自动化安装** - 无需手动配置
- 🛡️ **安全可靠** - 自动备份现有配置
- 📦 **依赖管理** - 自动安装所有必需工具
- 🎨 **字体配置** - 自动安装 Nerd Font
- 🔧 **智能检测** - 自动识别系统和包管理器

## 🚀 快速开始

### 方法一：自动安装（推荐）

```bash
# 克隆项目
git clone https://github.com/corner430/lazyvim-installer.git
cd lazyvim-installer

# 给脚本执行权限
chmod +x install-lazyvim.sh

# 运行自动安装脚本
./install-lazyvim.sh
```

### 方法二：手动安装

1. 查看详细安装指南：[LazyVim-Installation-Guide.md](./LazyVim-Installation-Guide.md)
2. 按照指南步骤手动安装

## 📋 系统要求

### 最低要求
- **Neovim >= 0.9.0**
- **Git >= 2.19.0**
- **支持真彩色的终端**

### 推荐配置
- **Nerd Font v3.0+**
- **C 编译器** (用于 treesitter)
- **ripgrep** (快速搜索)
- **fzf** (模糊查找)
- **lazygit** (Git 界面)

## 📁 项目结构

```
lazyvim-installer/
├── README.md                           # 项目说明文档
├── install-lazyvim.sh                  # 自动安装脚本
├── check-system.sh                     # 系统检查脚本
├── LazyVim-Installation-Guide.md      # 详细安装指南
├── LICENSE                             # MIT 许可证
└── .gitignore                          # Git 忽略文件
```

## 🔧 脚本说明

### install-lazyvim.sh
自动安装脚本，功能包括：
- 检测操作系统和包管理器
- 安装所有必需依赖
- 编译安装 Neovim (Linux)
- 安装 Nerd Font
- 配置 LazyVim
- 自动安装插件

### check-system.sh
系统检查脚本，验证：
- Neovim 版本
- 必需工具是否安装
- 字体是否正确安装
- 终端配置

## 🎯 安装后配置

### 终端字体设置

**Linux (GNOME Terminal):**
1. 打开终端设置
2. 选择字体为 "CaskaydiaCove Nerd Font Mono"
3. 启用连字支持

**macOS (iTerm2):**
1. 打开 iTerm2 偏好设置
2. 选择字体为 "CaskaydiaCove Nerd Font Mono"
3. 启用连字支持

### VSCode 配置

```json
{
  "terminal.integrated.fontFamily": "CaskaydiaCove Nerd Font Mono",
  "terminal.integrated.fontLigatures.enabled": true,
  "editor.fontLigatures": true,
  "editor.fontFamily": "CaskaydiaCove Nerd Font Mono"
}
```

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [LazyVim](https://github.com/LazyVim/LazyVim) - 优秀的 Neovim 配置框架
- [Neovim](https://neovim.io/) - 现代化的 Vim 编辑器
- [Nerd Fonts](https://www.nerdfonts.com/) - 优秀的编程字体

## 📞 联系方式

- 项目主页：[GitHub](https://github.com/corner430/lazyvim-installer)
- 问题反馈：[Issues](https://github.com/corner430/lazyvim-installer/issues)
- 邮箱：corner@88.com

---

⭐ 如果这个项目对你有帮助，请给它一个星标！
