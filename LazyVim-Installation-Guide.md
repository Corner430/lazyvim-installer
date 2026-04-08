# LazyVim 完整安装教程

> 本教程提供在 Linux 和 macOS 系统上安装配置 LazyVim 的完整指南

## 目录

- [系统要求](#系统要求)
- [Linux 安装指南](#linux-安装指南)
- [macOS 安装指南](#macos-安装指南)
- [开箱即用配置](#开箱即用配置)
- [系统检查](#系统检查)

## 系统要求

- **Neovim >= 0.9.0** (需要 LuaJIT 支持)
- **Git >= 2.19.0** (支持部分克隆)
- **Nerd Font v3.0+** (用于显示图标)
- **C 编译器** (用于 nvim-treesitter)
- **curl** (用于 blink.cmp 补全引擎)
- **支持真彩色和下划线的终端**

## Linux 安装指南

### 第一步：系统更新和基础依赖安装

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git ripgrep cmake ninja-build gettext curl unzip build-essential wget libicu-dev
```

**CentOS/RHEL/TencentOS:**
```bash
sudo yum update -y
sudo yum install -y git cmake ninja-build gettext curl unzip gcc gcc-c++ make wget tar gzip fontconfig libicu
```

### 第二步：安装 Neovim 0.9.0+

由于大多数 Linux 发行版仓库中的 Neovim 版本较旧，需要从源码编译：

```bash
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd .. && rm -rf neovim

# 验证
nvim --version
```

### 第三步：安装辅助工具

```bash
# lazygit
wget https://github.com/jesseduffield/lazygit/releases/download/v0.42.0/lazygit_0.42.0_Linux_x86_64.tar.gz
tar -xzf lazygit_0.42.0_Linux_x86_64.tar.gz
sudo mv lazygit /usr/local/bin/

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --bin
sudo cp ~/.fzf/bin/fzf /usr/local/bin/

# fd
wget https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-v9.0.0-x86_64-unknown-linux-musl.tar.gz
tar -xzf fd-v9.0.0-x86_64-unknown-linux-musl.tar.gz
sudo cp fd-v9.0.0-x86_64-unknown-linux-musl/fd /usr/local/bin/
```

### 第四步：处理 tree-sitter CLI 兼容性

如果系统 GLIBC 版本低于 2.39（通过 `ldd --version` 查看），需要从源码编译 tree-sitter CLI：

```bash
# 安装 Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# 编译 tree-sitter CLI
cargo install tree-sitter-cli

# 链接到系统路径
sudo ln -sf "$HOME/.cargo/bin/tree-sitter" /usr/local/bin/tree-sitter
```

### 第五步：安装 Nerd Font

```bash
mkdir -p ~/.local/share/fonts
cd ~
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip
unzip CascadiaCode.zip -d ~/.local/share/fonts/
rm CascadiaCode.zip
fc-cache -fv
```

### 第六步：配置 LazyVim

```bash
# 备份现有配置
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true

# 清理缓存
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

# 克隆 LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# 安装插件
nvim --headless -c "Lazy! sync" -c "qa"
```

## macOS 安装指南

### 第一步：安装基础依赖

```bash
# 安装 Homebrew (如果尚未安装)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装工具
brew install neovim git curl fzf ripgrep fd lazygit

# Xcode 命令行工具
xcode-select --install
```

### 第二步：安装 Nerd Font

```bash
brew tap homebrew/cask-fonts
brew install --cask font-caskaydia-cove-nerd-font
```

### 第三步：配置 LazyVim

```bash
mv ~/.config/nvim{,.bak} 2>/dev/null || true
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

nvim --headless -c "Lazy! sync" -c "qa"
```

## 开箱即用配置

安装脚本会自动创建以下配置文件：

### Lazy Extras 插件 (`~/.config/nvim/lazyvim.json`)

通过 `lazyvim.json` 预装 Lazy Extras，与在 LazyVim 中执行 `:LazyExtras` 后按 `x` 启用效果完全一致。安装后可随时通过 `:LazyExtras` 界面自由启用/禁用。

预装的 extras 包括 C/C++、CMake、Python、Go、Java、TypeScript、Tailwind CSS、JSON、Markdown 语言支持，DAP 调试，以及 mini-surround、yanky、inc-rename、treesitter-context 等增强插件。

### OSC52 剪贴板（SSH 环境，`~/.config/nvim/lua/plugins/osc52.lua`）

在 SSH 环境下自动配置 Neovim 内置的 OSC52 剪贴板 provider（Neovim 0.10+ 原生支持，无需第三方插件），使 `yy` 等复制操作通过 OSC52 协议同步到本地剪贴板。

LazyVim 默认已设 `clipboard = "unnamedplus"`，无需额外配置。

**本地终端需要支持 OSC52：** iTerm2、WezTerm、Alacritty、Windows Terminal、kitty 均支持。

如果使用 tmux，需在 `~/.tmux.conf` 添加：
```bash
# tmux 3.3+
set -g allow-passthrough on
# 或者（旧版 tmux）
set -g set-clipboard on
```

### Markdown 远程预览 (`~/.config/nvim/lua/plugins/markdown.lua`)

marksman LSP、lint、format 等已由 `lang.markdown` extra 提供。此文件只配置远程预览的 IP 和端口，使 SSH 环境下可通过本地浏览器访问 `http://<服务器IP>:8888` 预览 Markdown。

## 系统检查

```bash
chmod +x check-system.sh
./check-system.sh
```

检查脚本会验证：
- 系统信息和 GLIBC 版本
- Neovim、Git 等基础依赖
- tree-sitter CLI、Rust/cargo
- fzf、ripgrep、fd、lazygit 等可选工具
- Nerd Font 安装状态
- LazyVim 配置完整性
- 预装插件配置（lazyvim.json extras、OSC52、Markdown 远程预览）
- 网络连接
