#  ~/.zshenv
# Core envionmental variables
# Locations configured here are requred for all other files to be correctly imported

# Set XDG directories
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_LIB_HOME="${HOME}/.local/lib"
export XDG_CACHE_HOME="${HOME}/.cache"

# Set default applications
export EDITOR="vim"
export TERMINAL="Kitty.app"
export BROWSER="Arc.app"
export PAGER="less"

## Respect XDG directories
export ADOTDIR="${XDG_CACHE_HOME}/zsh/antigen"
export OPENSSL_DIR="/usr/local/ssl"
export CURL_HOME="${XDG_CONFIG_HOME}/curl"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export GIT_CONFIG="${XDG_CONFIG_HOME}/git/.gitconfig"
export LESSHISTFILE="-" # Disable less history.
export PIP_CONFIG_FILE="${XDG_CONFIG_HOME}/pip/pip.conf"
export PIP_LOG_FILE="${XDG_DATA_HOME}/pip/log"
export TMUX_PLUGIN_MANAGER_PATH="${XDG_DATA_HOME}/tmux/plugins"
export WGETRC="${XDG_CONFIG_HOME}/wget/.wgetrc"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZLIB="${ZDOTDIR}/lib"

# Encodings, languges and misc settings
export LANG='en_GB.UTF-8';
export PYTHONIOENCODING='UTF-8';
export LC_ALL='C';

