# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# zsh 补全缓存文件位置（默认 ~/.zcompdump-<host>-<version>，挪到 ~/.cache 保持 home 干净）
# 必须在 source $ZSH/oh-my-zsh.sh 之前设置才会生效；~/.cache/zsh 目录由安装脚本 mkdir 创建
export ZSH_COMPDUMP="$HOME/.cache/zsh/compdump"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf
  autojump

  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Personnal config
alias rm="rm -i"
alias mv="mv -i"

# eza（保留 GNU ls 上服务器用，ez 前缀 = eza）
alias eza="eza --icons"
alias ezal='eza -lh --git --icons --group-directories-first'
alias ezall='eza -lah --git --icons --group-directories-first'
alias ezat='eza -T --level=2 -lh --git --icons --group-directories-first'

# Vim
# alias vim='gvim -v'
# alias vim="vimx"
alias nv="nvim"

# Edge
alias edge="microsoft-edge-beta"
alias pedge="proxy-ns microsoft-edge-beta"

# open QQMusic
alias qqmusic="/opt/tencent/qqmusic/qqmusic-1.1.8.AppImage --no-sandbox"
# close QQMusic
alias killqqmusic="killall -9 qqmusic"

# neofetch | lolcat
# alias nfl="neofetch --source ~/.config/neofetch/ascii-art-neofetch/communist | lolcat"
# alias nfll="neofetch --source ~/.config/neofetch/ascii-art-neofetch/communist -L | lolcat"
# alias lol="fastfetch --logo $HOME/.config/fastfetch/ascii-art-fastfetch/new-communsit | lolcat"
alias fff="clear && fastfetch"

# default editor
export EDITOR=emacs

# vterm
vterm_printf() {
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# nvm（懒加载版）
#   node/npm 常驻 PATH，只懒加载 nvm 函数本身，避免每次启动 source 整个 nvm.sh（约省 100ms）。
#   node 版本动态取「已安装的最高版本」——只装 --lts 时即 default，换电脑 / 升级 LTS 无需改这里。
#   若以后同时装多个版本并想固定用旧版本，需改用 current 软链方案。
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

# node/npm 常驻 PATH：取已安装的最高版本
if [[ -d "$NVM_DIR/versions/node" ]]; then
  _nvm_ver=$(command ls -1 "$NVM_DIR/versions/node" | sort -V | tail -1)
  [[ -n "$_nvm_ver" ]] && export PATH="$NVM_DIR/versions/node/$_nvm_ver/bin:$PATH"
  unset _nvm_ver
fi

# 只懒加载 nvm 函数本身（node/npm 一直在 PATH 上，不影响其他程序找 node）
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# nvidia
alias nvsmi="watch -n 1 nvidia-smi"

# delete record
# delete record (safe for empty directories)
alias clear_record="rm -rf $HOME/Videos/Record/*(N) $HOME/Pictures/Screenshots/*(N)"
# Hyprland Use

# ~/.backup hyprland
alias hypr_backup="$HOME/dotfiles/hypr_script/hypr_backup.sh"
# ~/.zprofile
source $HOME/.zsh_profile

# wallpaper
alias mpvshow="mpvpaper -o \"no-audio --loop-playlist --terminal=no --panscan=1\" \"*\" $HOME/Videos/Wallpapers/0.mp4 &"
alias mpvkill="killall -e mpvpaper"

# fcitx
# export GTK_IM_MODULE=fcitx5
# export QT_IM_MODULE=fcitx5
# export XMODIFIERS=@im=fcitx

# export PATH=$PATH:/home/matchaeggtart/.local/bin

# oh-my-posh
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/oh-my-post.theme.json)"

# emacs exec-path-from-shell
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# ssh kitty
# [ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
