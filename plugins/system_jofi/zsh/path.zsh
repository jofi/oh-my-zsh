if [[ ("$JOFIPATHS" != "loaded") ]]
then
  export PATH="$HOME/bin:$HOME/.local/bin:$ZSH/bin:$PATH"
  export JOFIPATHS="loaded"
fi
