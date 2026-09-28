rm -rf $HOME/.emacs.d

rm -rf $HOME/.bash_logout
rm -rf $HOME/.bashrc
rm -rf $HOME/.bash_profile

rm -rf $HOME/.zshrc
rm -rf $HOME/.zsh_profile

rm -rf $HOME/.config/emacs
rm -rf $HOME/.config/nvim
rm -rf $HOME/.config/kitty
rm -rf $HOME/.config/mako
rm -rf $HOME/.config/tofi
rm -rf $HOME/.config/waybar
rm -rf $HOME/.config/oh-my-posh
rm -rf $HOME/.config/cava
rm -rf $HOME/.config/pip
rm -rf $HOME/.config/opencode

rm -rf $HOME/.npmrc

cd "$(dirname "$0")/matchaeggtart"
stow --target=$HOME zsh
stow --target=$HOME bash
stow --target=$HOME npm
stow --target=$HOME/.config config

# mkdir -p $HOME/Pictures/Wallpapers
# cp -r hypr/* $HOME/.config/hypr/
