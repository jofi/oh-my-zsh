autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

git_branch() {
  echo $(/usr/bin/git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$(/usr/bin/git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ $st == "nothing to commit, working tree clean" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info_jofi)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info_jofi)*%{$reset_color%}"
    fi
  fi
}

git_prompt_info_jofi() {
 ref=$(/usr/bin/git symbolic-ref HEAD 2>/dev/null) || return
 commit=$(git rev-parse --short HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}@${commit}"
}

unpushed () {
  /usr/bin/git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

webafis_customization () {
  client=$(cat ../commons/config.rb 2> /dev/null | grep WEBAFIS_CONFIG |awk -F: {'print $NF'})
  echo $client
}

rb_prompt(){
  if $(which rvm &> /dev/null)
  then
	  echo "%{$fg_bold[yellow]%}$(rvm current | awk '{print $1}')%{$reset_color%}"
	else
	  echo ""
  fi
}

# This keeps the number of todos always available the right hand side of my
# command line. I filter it to only count those tagged as "+next", so it's more
# of a motivation to clear out the list.
todo(){
  if $(which todo.sh &> /dev/null)
  then
    num=$(echo $(todo.sh ls +next | wc -l))
    let todos=num-2
    if [ $todos != 0 ]
    then
      echo "$todos"
    else
      echo ""
    fi
  else
    echo ""
  fi
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

collapse_pwd() {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}$(webafis_customization) $(todo)%{$reset_color%}"
}

precmd() {
  if [ "$DISABLE_AUTO_TITLE" != "true" ]; then
    title "zsh" "%m" "%55<...<%~"
  fi

  set_prompt
}
#PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
PROMPT=$'\n%{$fg_bold[magenta]%}➜ %n%{$reset_color%}@%{$fg_bold[yellow]%}%m%{$reset_color%}($(rb_prompt))\$ %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%} $(git_dirty)$(need_push)\n› '
#PROMPT=$'\n%{$fg_bold[magenta]%}➜ %n%{$reset_color%}@%{$fg_bold[yellow]%}%m%{$reset_color%}($(rb_prompt))\$ %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%} $(git_prompt_info)$(need_push)\n› '

#ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

#ZSH_THEME_GIT_PROMPT_PREFIX="on "
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✗%{$reset_color%}"
