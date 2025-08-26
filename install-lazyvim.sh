#!/bin/bash

# LazyVim 自动安装脚本
# 支持 Linux 和 macOS 系统
# 作者: Corner
# 版本: 1.0.0

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        log_error "不支持的操作系统: $OSTYPE"
        exit 1
    fi
}

# 检测包管理器
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v yum &> /dev/null; then
        echo "yum"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v brew &> /dev/null; then
        echo "brew"
    else
        log_error "未找到支持的包管理器"
        exit 1
    fi
}

# 安装基础依赖 (Linux)
install_linux_deps() {
    local pkg_manager=$1
    
    log_info "正在安装基础依赖..."
    
    case $pkg_manager in
        "apt")
            sudo apt update
            sudo apt install -y git ripgrep cmake ninja-build gettext curl unzip build-essential fzf fd-find
            ;;
        "yum"|"dnf")
            sudo $pkg_manager update -y
            sudo $pkg_manager install -y git ripgrep cmake ninja-build gettext curl unzip gcc gcc-c++ make fzf fd-find
            ;;
    esac
    
    # 安装 lazygit
    log_info "正在安装 lazygit..."
    cd /tmp
    wget -O lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.42.0/lazygit_0.42.0_Linux_x86_64.tar.gz
    tar -xzf lazygit.tar.gz
    sudo mv lazygit /usr/local/bin/
    rm lazygit.tar.gz
    cd - > /dev/null
    
    log_success "基础依赖安装完成"
}

# 安装基础依赖 (macOS)
install_macos_deps() {
    log_info "正在安装基础依赖..."
    
    # 检查是否安装了 Homebrew
    if ! command -v brew &> /dev/null; then
        log_info "正在安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # 安装基础工具
    brew install neovim git curl fzf ripgrep fd lazygit
    
    # 安装 Xcode 命令行工具
    if ! command -v clang &> /dev/null; then
        log_info "正在安装 Xcode 命令行工具..."
        xcode-select --install
    fi
    
    log_success "基础依赖安装完成"
}

# 编译安装 Neovim (Linux)
install_neovim_linux() {
    log_info "正在编译安装 Neovim..."
    
    # 检查是否已经安装了足够新的版本
    if command -v nvim &> /dev/null; then
        local version=$(nvim --version | head -n1 | grep -o 'v[0-9]\+\.[0-9]\+')
        local major=$(echo $version | cut -d. -f1 | tr -d 'v')
        local minor=$(echo $version | cut -d. -f2)
        
        if [[ $major -gt 0 ]] || [[ $major -eq 0 && $minor -ge 9 ]]; then
            log_success "Neovim 版本已满足要求: $version"
            return 0
        fi
    fi
    
    # 克隆并编译 Neovim
    cd /tmp
    git clone https://github.com/neovim/neovim.git
    cd neovim
    
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    
    cd ..
    rm -rf neovim
    
    log_success "Neovim 安装完成"
}

# 安装 Nerd Font (Linux)
install_nerd_font_linux() {
    log_info "正在安装 Nerd Font..."
    
    mkdir -p ~/.local/share/fonts
    
    cd ~
    wget -O CascadiaCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip
    unzip -o CascadiaCode.zip -d ~/.local/share/fonts/
    rm CascadiaCode.zip
    
    fc-cache -fv
    
    log_success "Nerd Font 安装完成"
}

# 安装 Nerd Font (macOS)
install_nerd_font_macos() {
    log_info "正在安装 Nerd Font..."
    
    brew tap homebrew/cask-fonts
    brew install --cask font-caskaydia-cove-nerd-font
    
    log_success "Nerd Font 安装完成"
}

# 安装 LazyVim
install_lazyvim() {
    log_info "正在安装 LazyVim..."
    
    # 备份现有配置
    if [[ -d ~/.config/nvim ]]; then
        log_warning "发现现有 Neovim 配置，正在备份..."
        mv ~/.config/nvim ~/.config/nvim.bak.$(date +%Y%m%d_%H%M%S)
    fi
    
    # 清理缓存
    rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim 2>/dev/null || true
    
    # 克隆 LazyVim 配置
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    
    log_success "LazyVim 配置安装完成"
}

# 安装插件
install_plugins() {
    log_info "正在安装插件 (这可能需要几分钟)..."
    
    nvim --headless -c "Lazy! sync" -c "qa"
    
    log_success "插件安装完成"
}

# 显示安装完成信息
show_completion_info() {
    echo
    log_success "🎉 LazyVim 安装完成！"
    echo
    echo "下一步操作："
    echo "1. 重启终端或重新加载终端配置"
    echo "2. 运行 'nvim' 启动 LazyVim"
    echo "3. 查看 LazyVim-Installation-Guide.md 了解更多配置选项"
    echo "4. 运行 './check-system.sh' 验证安装"
    echo
    echo "常用快捷键："
    echo "- <Space> + f + f: 文件查找"
    echo "- <Space> + f + g: 文本搜索"
    echo "- <Space> + e: 文件浏览器"
    echo "- <Space> + h: 帮助菜单"
    echo
}

# 主函数
main() {
    echo "🚀 LazyVim 自动安装脚本"
    echo "=========================="
    echo
    
    # 检测操作系统
    local os=$(detect_os)
    log_info "检测到操作系统: $os"
    
    # 检测包管理器
    local pkg_manager=$(detect_package_manager)
    log_info "检测到包管理器: $pkg_manager"
    
    # 安装基础依赖
    if [[ $os == "linux" ]]; then
        install_linux_deps $pkg_manager
        install_neovim_linux
        install_nerd_font_linux
    else
        install_macos_deps
        install_nerd_font_macos
    fi
    
    # 安装 LazyVim
    install_lazyvim
    
    # 安装插件
    install_plugins
    
    # 显示完成信息
    show_completion_info
}

# 检查是否以 root 用户运行
if [[ $EUID -eq 0 ]]; then
    log_warning "检测到以 root 用户运行，请确保了解相关风险"
    # 继续执行，不退出
fi

# 运行主函数
main "$@"
