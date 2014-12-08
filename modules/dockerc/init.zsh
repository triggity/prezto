# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.


# Aliases

alias dk='docker'

#with better information
alias 'dps'='docker ps -a'
alias 'dmi'='docker images'


# accessories for removing easily
# alias 'dk-rm-all-images'="docker rmi -f $(dmi | grep -v REP | tr -s ' ' ' ' | cut -f3 -d' ' | xargs echo -n)"
# alias 'dk-rm-all-containers'="docker rm -f $(dps | grep -v CONT | tr -s ' ' ' ' | cut -f1 -d' ' | xargs echo -n)"



# get IP
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

# remove all containers
drm() { docker rm $@ $(dps -q) }
# stop all containers
dsm() { docker stop $@ $(dps -q) }
# remove all images 
dri() { docker rmi $@ $(dmi -q) }



