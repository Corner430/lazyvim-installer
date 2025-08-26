#!/bin/bash

# LazyVim 系统检查脚本
# 用于验证所有依赖是否正确安装
# 支持 Linux 和 macOS 系统

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[信息]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查版本
check_version() {
    local cmd="$1"
    local min_version="$2"
    local version_cmd="$3"
    
    if command_exists "$cmd"; then
        local version
        if [[ -n "$version_cmd" ]]; then
            version=$($version_cmd 2>/dev/null | head -n1)
        else
            version=$($cmd --version 2>/dev/null | head -n1)
        fi
        
        echo "$version"
        return 0
    else
        return 1
    fi
}

# 检查版本是否满足要求
version_gte() {
    local version="$1"
    local min_version="$2"
    
    if [[ "$version" == "$min_version" ]]; then
        return 0
    fi
    
    # 提取版本号中的数字部分
    local version_clean=$(echo "$version" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
    local min_version_clean=$(echo "$min_version" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
    
    if [[ -z "$version_clean" || -z "$min_version_clean" ]]; then
        # 如果无法解析版本号，返回成功（假设已安装）
        return 0
    fi
    
    # 简单的版本比较 (适用于大多数情况)
    local IFS='.'
    read -ra V1 <<< "$version_clean"
    read -ra V2 <<< "$min_version_clean"
    
    for i in "${!V1[@]}"; do
        if [[ -z "${V2[$i]}" ]]; then
            return 0
        fi
        if (( 10#${V1[$i]} > 10#${V2[$i]} )); then
            return 0
        elif (( 10#${V1[$i]} < 10#${V2[$i]} )); then
            return 1
        fi
    done
    
    return 0
}

# 检查系统信息
check_system_info() {
    echo "=== 系统信息 ==="
    echo "操作系统: $(uname -s)"
    echo "架构: $(uname -m)"
    echo "内核版本: $(uname -r)"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS 版本: $(sw_vers -productVersion)"
        SYSTEM_TYPE="macos"
    else
        SYSTEM_TYPE="linux"
        # 尝试检测 Linux 发行版
        if [[ -f /etc/os-release ]]; then
            source /etc/os-release
            echo "Linux 发行版: $PRETTY_NAME"
        fi
    fi
    echo
}

# 检查基础依赖
check_basic_deps() {
    echo "=== 基础依赖检查 ==="
    
    # 检查 Neovim
    if command_exists nvim; then
        local nvim_version=$(check_version "nvim" "0.9.0" "nvim --version | head -n1 | sed 's/.*v//'")
        if version_gte "$nvim_version" "0.9.0"; then
            print_success "Neovim: $nvim_version"
        else
            print_error "Neovim: $nvim_version (需要 >= 0.9.0)"
        fi
    else
        print_error "Neovim: 未安装"
    fi
    
    # 检查 Git
    if command_exists git; then
        local git_version=$(check_version "git" "2.19.0" "git --version | sed 's/git version //'")
        if version_gte "$git_version" "2.19.0"; then
            print_success "Git: $git_version"
        else
            print_error "Git: $git_version (需要 >= 2.19.0)"
        fi
    else
        print_error "Git: 未安装"
    fi
    
    # 检查 curl
    if command_exists curl; then
        local curl_version=$(check_version "curl" "7.0.0" "curl --version | head -n1 | sed 's/curl //' | sed 's/ .*//'")
        print_success "curl: $curl_version"
    else
        print_error "curl: 未安装"
    fi
    
    # 检查 C 编译器
    if command_exists clang; then
        local clang_version=$(check_version "clang" "10.0.0" "clang --version | head -n1 | sed 's/.*version //' | sed 's/ .*//'")
        print_success "C 编译器 (clang): $clang_version"
    elif command_exists gcc; then
        local gcc_version=$(check_version "gcc" "8.0.0" "gcc --version | head -n1 | sed 's/.*) //' | sed 's/ .*//'")
        print_success "C 编译器 (gcc): $gcc_version"
    else
        print_error "C 编译器: 未安装"
    fi
    
    echo
}

# 检查可选工具
check_optional_tools() {
    echo "=== 可选工具检查 ==="
    
    # 检查 fzf
    if command_exists fzf; then
        local fzf_version=$(check_version "fzf" "0.25.1" "fzf --version")
        if version_gte "$fzf_version" "0.25.1"; then
            print_success "fzf: $fzf_version"
        else
            print_warning "fzf: $fzf_version (建议 >= 0.25.1)"
        fi
    else
        print_warning "fzf: 未安装 (推荐)"
    fi
    
    # 检查 ripgrep
    if command_exists rg; then
        local rg_version=$(check_version "rg" "12.0.0" "rg --version | head -n1 | sed 's/ripgrep //' | sed 's/ .*//'")
        print_success "ripgrep: $rg_version"
    else
        print_warning "ripgrep: 未安装 (推荐)"
    fi
    
    # 检查 fd
    if command_exists fd; then
        local fd_version=$(check_version "fd" "8.0.0" "fd --version | sed 's/fd //' | sed 's/ .*//'")
        print_success "fd: $fd_version"
    else
        print_warning "fd: 未安装 (推荐)"
    fi
    
    # 检查 lazygit
    if command_exists lazygit; then
        local lazygit_version=$(check_version "lazygit" "0.30.0" "lazygit --version | sed 's/lazygit version //'")
        print_success "lazygit: $lazygit_version"
    else
        print_warning "lazygit: 未安装 (推荐)"
    fi
    
    echo
}

# 检查字体
check_fonts() {
    echo "=== 字体检查 ==="
    
    local font_found=false
    
    if [[ "$SYSTEM_TYPE" == "macos" ]]; then
        # macOS 字体目录
        local font_dirs=(
            "/System/Library/Fonts"
            "/Library/Fonts"
            "$HOME/Library/Fonts"
            "/opt/homebrew/share/fonts"
            "/usr/local/share/fonts"
        )
        
        for dir in "${font_dirs[@]}"; do
            if [[ -d "$dir" ]]; then
                if find "$dir" -name "*CaskaydiaCove*" -o -name "*Caskaydia*" 2>/dev/null | grep -q .; then
                    print_success "CaskaydiaCove Nerd Font 已安装"
                    font_found=true
                    break
                fi
            fi
        done
        
        if [[ "$font_found" == false ]]; then
            print_warning "CaskaydiaCove Nerd Font 未找到"
            echo "  建议运行: brew install --cask font-caskaydia-cove-nerd-font"
        fi
    else
        # Linux 字体目录
        local font_dirs=(
            "$HOME/.local/share/fonts"
            "/usr/share/fonts"
            "/usr/local/share/fonts"
            "/opt/share/fonts"
        )
        
        for dir in "${font_dirs[@]}"; do
            if [[ -d "$dir" ]]; then
                if find "$dir" -name "*CaskaydiaCove*" -o -name "*Caskaydia*" 2>/dev/null | grep -q .; then
                    print_success "CaskaydiaCove Nerd Font 已安装"
                    font_found=true
                    break
                fi
            fi
        done
        
        # 使用 fc-list 检查字体
        if command_exists fc-list; then
            if fc-list | grep -i "caskaydia" >/dev/null 2>&1; then
                print_success "CaskaydiaCove Nerd Font 已安装 (通过 fc-list 检测)"
                font_found=true
            fi
        fi
        
        if [[ "$font_found" == false ]]; then
            print_warning "CaskaydiaCove Nerd Font 未找到"
            echo "  建议手动下载并安装字体到 ~/.local/share/fonts/"
        fi
    fi
    
    echo
}

# 检查终端
check_terminal() {
    echo "=== 终端检查 ==="
    
    local terminal_found=false
    
    if [[ "$SYSTEM_TYPE" == "macos" ]]; then
        # macOS 终端检查
        local terminals=(
            "iTerm2"
            "kitty"
            "wezterm"
            "alacritty"
        )
        
        for terminal in "${terminals[@]}"; do
            if command_exists "$terminal" || [[ -d "/Applications/$terminal.app" ]]; then
                print_success "$terminal 已安装"
                terminal_found=true
            fi
        done
        
        if [[ "$terminal_found" == false ]]; then
            print_warning "未找到推荐的终端应用"
            echo "  建议安装: iTerm2, Kitty, WezTerm 或 Alacritty"
        fi
    else
        # Linux 终端检查
        local terminals=(
            "kitty"
            "wezterm"
            "alacritty"
            "gnome-terminal"
            "konsole"
            "xterm"
        )
        
        for terminal in "${terminals[@]}"; do
            if command_exists "$terminal"; then
                print_success "$terminal 已安装"
                terminal_found=true
            fi
        done
        
        if [[ "$terminal_found" == false ]]; then
            print_warning "未找到推荐的终端应用"
            echo "  建议安装: Kitty, WezTerm, Alacritty 或使用系统默认终端"
        fi
    fi
    
    # 检查终端颜色支持
    if [[ -n "$TERM_PROGRAM" ]]; then
        print_info "当前终端: $TERM_PROGRAM"
    fi
    
    if [[ -n "$COLORTERM" ]]; then
        print_info "颜色支持: $COLORTERM"
    fi
    
    echo
}

# 检查 LazyVim 配置
check_lazyvim_config() {
    echo "=== LazyVim 配置检查 ==="
    
    local config_dir="$HOME/.config/nvim"
    
    if [[ -d "$config_dir" ]]; then
        print_success "LazyVim 配置目录存在: $config_dir"
        
        # 检查关键文件
        local files=(
            "init.lua"
            "lua/config/init.lua"
            "lua/plugins/init.lua"
        )
        
        for file in "${files[@]}"; do
            if [[ -f "$config_dir/$file" ]]; then
                print_success "配置文件存在: $file"
            else
                print_warning "配置文件缺失: $file"
            fi
        done
    else
        print_error "LazyVim 配置目录不存在: $config_dir"
        echo "  建议运行: git clone https://github.com/LazyVim/starter ~/.config/nvim"
    fi
    
    echo
}

# 检查包管理器
check_package_manager() {
    if [[ "$SYSTEM_TYPE" == "macos" ]]; then
        echo "=== Homebrew 检查 ==="
        
        if command_exists brew; then
            local brew_version=$(check_version "brew" "2.0.0" "brew --version | head -n1 | sed 's/Homebrew //'")
            print_success "Homebrew: $brew_version"
            
            # 检查 Homebrew 路径
            local brew_path=$(which brew)
            print_info "Homebrew 路径: $brew_path"
            
            # 检查 Homebrew 状态
            if brew doctor >/dev/null 2>&1; then
                print_success "Homebrew 状态正常"
            else
                print_warning "Homebrew 可能需要修复，运行: brew doctor"
            fi
        else
            print_error "Homebrew 未安装"
            echo "  建议运行: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        fi
    else
        echo "=== 包管理器检查 ==="
        
        # 检查常见的 Linux 包管理器
        if command_exists apt; then
            print_success "包管理器: apt (Ubuntu/Debian)"
        elif command_exists yum; then
            print_success "包管理器: yum (CentOS/RHEL)"
        elif command_exists dnf; then
            print_success "包管理器: dnf (Fedora)"
        elif command_exists pacman; then
            print_success "包管理器: pacman (Arch Linux)"
        else
            print_warning "未检测到常见的包管理器"
        fi
    fi
    
    echo
}

# 检查网络连接
check_network() {
    echo "=== 网络连接检查 ==="
    
    local hosts=(
        "github.com"
        "raw.githubusercontent.com"
        "api.github.com"
    )
    
    for host in "${hosts[@]}"; do
        if ping -c 1 "$host" >/dev/null 2>&1; then
            print_success "网络连接正常: $host"
        else
            print_error "网络连接失败: $host"
        fi
    done
    
    echo
}

# 生成报告
generate_report() {
    echo "=== 检查报告 ==="
    
    echo
    echo "检查完成！"
    echo
    echo "建议:"
    echo "1. 如果所有检查都通过，您可以开始使用 LazyVim"
    echo "2. 如果有错误，请按照提示安装缺失的依赖"
    echo "3. 如果有警告，建议安装相关工具以获得更好的体验"
    echo "4. 运行 'nvim' 启动 LazyVim"
    echo "5. 在 Neovim 中运行 ':LazyHealth' 检查插件状态"
    
    if [[ "$SYSTEM_TYPE" == "macos" ]]; then
        echo
        echo "macOS 特定建议:"
        echo "- 确保在终端中设置了 CaskaydiaCove Nerd Font"
        echo "- 推荐使用 iTerm2 以获得最佳体验"
    else
        echo
        echo "Linux 特定建议:"
        echo "- 确保字体已正确安装并刷新字体缓存: fc-cache -fv"
        echo "- 推荐使用支持真彩色的终端模拟器"
    fi
}

# 主函数
main() {
    echo "🔍 LazyVim 系统检查工具"
    echo "=========================="
    echo
    
    check_system_info
    check_package_manager
    check_basic_deps
    check_optional_tools
    check_fonts
    check_terminal
    check_lazyvim_config
    check_network
    generate_report
}

# 运行主函数
main "$@"
