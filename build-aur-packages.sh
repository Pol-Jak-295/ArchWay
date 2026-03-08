#!/bin/bash
# save as build-aur-packages.sh

CUSTOM_REPO_DIR="/home/$USER/archway_project/custom_repo"
mkdir $CUSTOM_REPO_DIR
AUR_PACKAGES=(
    "ani-cli"
    "ani-skip-git"
    "bibata-cursor-theme"
    "catppuccin-cursors-mocha"
    "catppuccin-gtk-theme-mocha"
    "catppuccin-qt5ct-git"
    "gradience"
    "maple-mono-nf-cn-unhinted"
    "sddm-sugar-candy-git"
    "tela-circle-icon-theme-blue-git"
    "tty-clock"
    "waybar-lyric"
    "waybar-module-music-git"
    "wleave-git"
    "wlogout"
    "yay"
    "portage-manifest"
    "zsh-syntax-highlighting-git"
)

cd /tmp
for pkg in "${AUR_PACKAGES[@]}"; do
    git clone "https://aur.archlinux.org/$pkg.git"
    cd "$pkg"
    makepkg -si --noconfirm  # This installs deps, you might want to handle differently
    cp *.pkg.tar.zst "$CUSTOM_REPO_DIR/"
    cd ..
done

# Update repo database
cd "$CUSTOM_REPO_DIR"
repo-add archway_repo.db.tar.gz *.pkg.tar.zst
