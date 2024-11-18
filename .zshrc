# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/opt/homebrew/bin:/Users/alanaro/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/alanaro/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="refined"
# default: "robbyrussell"

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

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
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
plugins=(git git-flow extract kubectl node npm)

source $ZSH/oh-my-zsh.sh

# Initialize zioxide
eval "$(zoxide init zsh)"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# BAT
export BAT_THEME="Catppuccin Macchiato"

# ZSH Highlights
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Golang
export PATH=$PATH:~/go/bin # Add path to GO binaries

# NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/Cellar/nvm/0.39.5/nvm.sh" ] && . "/opt/homebrew/Cellar/nvm/0.39.5/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/Cellar/nvm/0.39.5/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/Cellar/nvm/0.39.5/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

source /Users/alanaro/.docker/init-zsh.sh || true # Added by Docker Desktop

# Avoid brew auto updating on package install
export HOMEBREW_NO_AUTO_UPDATE=1

# Enable pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# FZF 
## Set up fzf key bindings and fuzzy completion
source /opt/homebrew/opt/fzf/shell/completion.zsh
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

## Customization
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border"

# Custom functions
load_env_file() {
  set -a; source $1; set +a
}

# Convert a mov file to an mp4
mov2mp4() {
 ffmpeg -i $1 -codec copy $2
}

# Custom aliases
alias speedtest="networkQuality -s"
alias cat="bat"
alias ls="exa"
alias cd="z"
alias grep="ag"
alias lg="lazygit"
alias lzd="lazydocker"
alias v="nvim"
alias t="tmux"
alias ta="tmux attach"
alias tn="tmux new -A -s \$(pwd | sed 's/.*\///g')"
alias k="kubectl"
alias kc="kubectx"
alias ke="kubens"
alias ff="fzf"
alias vf="fzf --preview 'bat --style=numbers --color=always {}' --print0 | xargs -0 -o nvim"
alias http="http --style=pie --format-options json.indent:2" 
alias rip="rip --graveyard /Users/alanaro/.Trash"

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

