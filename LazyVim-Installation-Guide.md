# LazyVim 完整安装教程

> 本教程提供在 Linux 和 macOS 系统上安装配置 LazyVim 的完整指南

## 📋 目录

- [系统要求](#-系统要求)
- [Linux 安装指南](#-linux-安装指南)
- [macOS 安装指南](#-macos-安装指南)
- [系统检查](#-系统检查)
- [学习资源](#-学习资源)

## 📋 系统要求

- **Neovim >= 0.9.0** (需要 LuaJIT 支持)
- **Git >= 2.19.0** (支持部分克隆)
- **Nerd Font v3.0+** (用于显示图标)
- **C 编译器** (用于 nvim-treesitter)
- **curl** (用于 blink.cmp 补全引擎)
- **支持真彩色和下划线的终端**

## 🐧 Linux 安装指南

### 系统环境
- **操作系统**: Linux (Ubuntu/Debian/CentOS/RHEL/TencentOS 等)
- **架构**: x86_64
- **包管理器**: apt/yum/dnf

### 第一步：系统更新和基础依赖安装

#### 1.1 更新系统包

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt upgrade -y
```

**CentOS/RHEL/TencentOS:**
```bash
sudo yum update -y
```

#### 1.2 安装基础开发工具

**Ubuntu/Debian:**
```bash
sudo apt install -y git ripgrep cmake ninja-build gettext curl unzip build-essential
```

**CentOS/RHEL/TencentOS:**
```bash
sudo yum install -y git ripgrep cmake ninja-build gettext curl unzip gcc gcc-c++ make
```

**说明**：
- `git`: 版本控制，LazyVim 需要 Git 2.19.0+
- `ripgrep`: 快速文本搜索工具
- `cmake`, `ninja-build`: 用于编译 Neovim
- `gettext`: 国际化支持
- `curl`, `unzip`: 下载和解压工具
- `build-essential`/`gcc`: C 编译器

### 第二步：安装 Neovim 0.9.0+

由于大多数 Linux 发行版仓库中的 Neovim 版本较旧，我们需要从源码编译安装最新版本。

#### 2.1 检查当前 Neovim 版本

```bash
nvim --version
```

#### 2.2 从源码编译安装 Neovim

```bash
# 克隆 Neovim 源码
git clone https://github.com/neovim/neovim.git
cd neovim

# 编译安装
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

#### 2.3 验证安装

```bash
nvim --version
# 应该显示 v0.9.0 或更高版本
```

### 第三步：安装其他必要工具

#### 3.1 安装 lazygit

```bash
# 下载最新版本
wget https://github.com/jesseduffield/lazygit/releases/download/v0.42.0/lazygit_0.42.0_Linux_x86_64.tar.gz

# 解压并安装
tar -xzf lazygit_0.42.0_Linux_x86_64.tar.gz
sudo mv lazygit /usr/local/bin/

# 验证安装
lazygit --version
```

#### 3.2 安装 fzf 和 fd

**Ubuntu/Debian:**
```bash
sudo apt install -y fzf fd-find
```

**CentOS/RHEL/TencentOS:**
```bash
sudo yum install -y fzf fd-find
```

### 第四步：安装 Nerd Font

#### 4.1 创建字体目录

```bash
mkdir -p ~/.local/share/fonts
```

#### 4.2 下载 CaskaydiaCove Nerd Font

```bash
cd ~
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip
```

#### 4.3 解压和安装字体

```bash
unzip CascadiaCode.zip -d ~/.local/share/fonts/
```

#### 4.4 刷新字体缓存

```bash
fc-cache -fv
```

#### 4.5 验证字体安装

```bash
fc-list | grep -i "caskaydia"
```

### 第五步：配置 LazyVim

#### 5.1 克隆 LazyVim 配置

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

#### 5.2 清理旧的 Neovim 配置

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

#### 5.3 安装插件

```bash
nvim --headless -c "Lazy! sync" -c "qa"
```

## 🍎 macOS 安装指南

### 系统环境
- **操作系统**: macOS 10.15+ (Catalina 或更高版本)
- **架构**: Intel/Apple Silicon
- **包管理器**: Homebrew

### 第一步：安装基础依赖

#### 1.1 安装 Homebrew (如果尚未安装)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 1.2 安装必需工具

```bash
# 安装 Neovim、Git 和 curl
brew install neovim git curl

# 安装 C 编译器 (Xcode 命令行工具)
xcode-select --install
```

### 第二步：安装推荐工具

#### 2.1 安装搜索和文件查找工具

```bash
# 安装搜索和文件查找工具
brew install fzf ripgrep fd lazygit
```

#### 2.2 安装 Nerd Font

```bash
# 安装 CaskaydiaCove Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-caskaydia-cove-nerd-font
```

#### 2.3 安装推荐终端 (可选)

```bash
# 安装 iTerm2 (macOS 专用)
brew install --cask iterm2
```

### 第三步：配置 LazyVim

#### 3.1 备份现有配置 (如果有)

```bash
mv ~/.config/nvim{,.bak} 2>/dev/null || true
mv ~/.local/share/nvim{,.bak} 2>/dev/null || true
mv ~/.local/state/nvim{,.bak} 2>/dev/null || true
mv ~/.cache/nvim{,.bak} 2>/dev/null || true
```

#### 3.2 安装 LazyVim

```bash
# 安装 LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# 自动安装所有插件（无头模式，无需手动操作）
nvim --headless -c "Lazy! sync" -c "qa"
```

### 第四步：终端配置

#### 4.1 iTerm2 配置 (推荐)

1. 打开 iTerm2
2. 进入 `Preferences` → `Profiles` → `Text`
3. 点击 `Change Font`
4. 选择 `CaskaydiaCove Nerd Font Mono`
5. 设置字体大小为 14-16

#### 4.2 VSCode 配置

```json
{
  "terminal.integrated.fontFamily": "CaskaydiaCove Nerd Font Mono",
  "terminal.integrated.fontLigatures.enabled": true,
  "editor.fontLigatures": true,
  "editor.fontFamily": "CaskaydiaCove Nerd Font Mono"
}
```

## 🔍 系统检查

### 运行系统检查脚本

我们提供了一个系统检查脚本来验证所有依赖是否正确安装：

```bash
# 给脚本执行权限
chmod +x check-system.sh

# 运行系统检查
./check-system.sh
```
