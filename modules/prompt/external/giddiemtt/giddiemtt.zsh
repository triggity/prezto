#
# A colorful, friendly, multiline theme with some handy features.
#
# Authors:
#   Paul Gideon Dann <pdgiddie@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Features:
#   - Simple VCS branch, staged, and unstaged indication.
#   - Prompt character is different in a VCS repository.
#   - Last command exit status is displayed when non-zero.
#
# Screenshots:
#   http://i.imgur.com/rCo3S.png
#

function +vi-set_novcs_prompt_symbol {
  _prompt_giddie_symbol=')'
}

function +vi-set_vcs_prompt_symbol {
  _prompt_giddie_symbol='±'
}

function +vi-git_precmd {
  # Check for untracked files, since vcs_info does not.
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    hook_com[unstaged]+='%F{green}?%f'
  fi
}

function prompt_giddie_precmd {
  # Replace '/home/<user>' with '~'.
  _prompt_giddie_pwd="${PWD/#$HOME/~}"
  vcs_info
}

function prompt_giddiemtt_setup {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)

  # Load required functions.
  autoload -Uz vcs_info
  autoload -Uz add-zsh-hook

  # Add hook to set up prompt parameters before each command.
  add-zsh-hook precmd prompt_giddie_precmd

  # Set editor-info parameters.
  zstyle ':prezto:module:editor:info:completing' format '%F{green}...%f'
  zstyle ':prezto:module:editor:info:keymap:alternate' format '%F{yellow}--- COMMAND ---%f'

  # Set vcs_info parameters.
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' formats ' %b%c%u'
  zstyle ':vcs_info:*' actionformats ' on %F{magenta}%b%f%c%u %F{yellow}(%a)%f'
  zstyle ':vcs_info:*' stagedstr '%F{green}+%f'
  zstyle ':vcs_info:*' unstagedstr '%F{green}!%f'

  # Set vcs_info hooks.
  # NOTE: Prior to Zsh v4.3.12, there are no static hooks, no vcs_info_hookadd
  #       function, and no 'no-vcs' hook.
  zstyle ':vcs_info:*+start-up:*' hooks set_novcs_prompt_symbol
  zstyle ':vcs_info:git*+set-message:*' hooks set_vcs_prompt_symbol git_precmd
  zstyle ':vcs_info:*+set-message:*' hooks set_vcs_prompt_symbol

  # only show user if you are not on your host
  [[ "$SSH_CONNECTION" != '' ]] && USER_PREFIX='%(?..%F{red}%B-> [%?]%b%f
)%F{magenta}%n%f@%F{yellow}%m%f'  || USER_PREFIX=""

  # Define prompts.
  PROMPT='%F{blue}%*%f $USER_PREFIX|%F{green}${_prompt_giddie_pwd}%f${vcs_info_msg_0_}
%F{blue}${_prompt_giddie_symbol}%f '
  # RPROMPT='${editor_info[keymap]}'
  SPROMPT='zsh: correct %F{magenta}%R%f to %F{green}%r%f [nyae]? '
}

prompt_giddiemtt_setup "$@"
