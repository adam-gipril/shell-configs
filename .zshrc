### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# --------------------------------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------------------------------

# Set up rbenv in your shell. See https://github.com/rbenv/rbenv#how-rbenv-hooks-into-your-shell
eval "$(rbenv init -)"

# Set up terraform autocomplete (automatically installed by `terraform -install-autocomplete`)
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# Set up fzf and fzf-tab for a better autocomplete experience
zinit pack'bgn' for fzf
zinit light Aloxaf/fzf-tab

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Install the "pure" theme
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

# --------------------------------------------------------------------------------------------------
# Aliases - Basic
# --------------------------------------------------------------------------------------------------

# Enables opening a file or directory in VSCode with `c <path-to-file-or-directory>`
# You need to have followed these instructions first:
#   https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
alias c='code'

# Opens the current directory in VSCode
alias c.='c .'

# Convenient access to edit shell configuration files in VSCode
alias cz='c ~/.zshrc'
alias cze='c ~/.zshenv'

# Convenient ways to reload shell configuration without needing to restart the shell
# See https://linuxize.com/post/bash-source-command/
alias sz='source ~/.zshrc'
alias sze='source ~/.zshenv'

# Convenient access to open any file or directory in the default program for the resource type
alias o='open'

# Open the current directory in Finder
alias o.='o .'

# Shorten the mkdir command to `m` to more conveniently create directories
alias m='mkdir'

# Shorten the touch command to `t` to more conveniently create files
alias t='touch'

# Shorten `rm -rf` to more conveniently delete entire directories
alias rf='rm -rf'

# --------------------------------------------------------------------------------------------------
# Aliases & Functions - Git
# --------------------------------------------------------------------------------------------------

alias g='git'
alias ga='g add .'
alias gap='g add -p'
alias gb='g branch'
alias gbd='g branch -d'
alias gbD='g branch -D'
alias gcl='g clone'
alias gcm='g commit -a'
alias gco='g checkout'
alias gdf='g diff'
alias gdn='g diff --name-only'
alias gds='g diff --stat'
alias gf='g fetch'
alias ghi='g log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias glm='g log main --pretty="%h %s - %an"'
alias gpf='g push --force'
alias gpl='g pull'
alias gra='g rebase --abort'
alias grb='g rebase'
alias grc='g rebase --continue'
alias grl='g remote -v'
alias grp='g remote prune origin'
alias grs='g rebase --skip'
alias grt='g reset --keep'
alias gsa='g stash apply'
alias gsh='g stash'
alias gsl='g stash list'
alias gsm='g stash push -m'
alias gst='g status'
alias gsw='g show'
alias gt='g tag'

# Pull the latest changes then create a new branch with passed-in name
gob() {
  g pull
  g checkout -b $1
}

# Push and set the current branch to track upstream
gph() {
  BRANCH=$(g rev-parse --abbrev-ref HEAD)
  g push -u origin $BRANCH
}

# Perform an interactive rebase of previous passed-in number of commits
gri() {
  g rebase -i HEAD~$1
}

# --------------------------------------------------------------------------------------------------
# Aliases - Node
# --------------------------------------------------------------------------------------------------

alias n='npm'
alias na='n audit'
alias naf='na fix'
alias ni='n i'
alias nid='n i -D'
alias nr='n run'
alias nrm='n rm'
alias ns='n start'
alias nt='n test'
alias nu='n up'
alias nud='nu -D'
alias nv='n version'
alias nvj='nv major'
alias nvn='nv minor'
alias nvp='nv patch'

# List all packages installed with npm globally
alias nls='n list -g --depth 0'

# --------------------------------------------------------------------------------------------------
# Aliases - Web V2/Vue
# --------------------------------------------------------------------------------------------------

# Open pando-vue or web-v2 with VSCode
alias cpv='c ~/Developer/pando-vue'
alias cwv='c ~/Developer/web-v2'

alias nrb='nr build'
alias nrl='nr lint'
alias nrs='nr serve'
alias nsb='nr storybook:build'
alias nss='nr storybook:serve -- --ci'

# Run only the test at the passed-in path
alias ntf='nr test:jest -- --runTestsByPath'

# --------------------------------------------------------------------------------------------------
# Aliases - saml2aws
# --------------------------------------------------------------------------------------------------

alias sal='saml2aws login \
            --role=<role-arn-here> \
            --session-duration=43200 \
            --skip-prompt'

# --------------------------------------------------------------------------------------------------
# Auto-use NVM
# --------------------------------------------------------------------------------------------------

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version $(cat $nvmrc_path))

    if [[ "$nvmrc_node_version" = "N/A" ]]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
