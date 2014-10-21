alias vi='vim'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [[ -z $(command cdhistory) ]]; then
  # Over-ride the build cd function so that visited directories can be
  # recorded and used to quickly navigate to the most frequently visited.
  function cd(){
    if [[ ${1:0:1} = ":" ]]; then
      builtin cd $(cdhistory -r -n 1 -m ${1:1})
      echo $(pwd)
    else
      cdhistory -a $1
      builtin cd $1
    fi
  }

  _cd()
  {
    local cur=${COMP_WORDS[COMP_CWORD]}
    if [[ "${COMP_WORDS[1]}" == ":" ]];
    then
      COMPREPLY=( $(cdhistory -n 1 -m ${cur:1}) )
    fi
  }

  complete -o dirnames -F _cd cd
fi
