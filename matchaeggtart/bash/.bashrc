#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# User config
# nvm（懒加载版）
#   node/npm 常驻 PATH，只懒加载 nvm 函数本身，避免每次启动 source 整个 nvm.sh。
#   node 版本动态取「已安装的最高版本」——只装 --lts 时即 default，换电脑 / 升级 LTS 无需改。
#   注意：原 --no-use（bash 默认不激活 node）改为常驻 PATH，现在 bash 里也能直接用 node/npm。
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

# node/npm 常驻 PATH：取已安装的最高版本
if [ -d "$NVM_DIR/versions/node" ]; then
  _nvm_ver=$(ls -1 "$NVM_DIR/versions/node" 2>/dev/null | sort -V | tail -1)
  [ -n "$_nvm_ver" ] && export PATH="$NVM_DIR/versions/node/$_nvm_ver/bin:$PATH"
  unset _nvm_ver
fi

# 只懒加载 nvm 函数本身
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# autojump
# [[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
