#Radarr
A Debian Linux based dockerfile to run Radarr. It expects a /config volume to store data, and a /media volume where your media is stored. Enjoy!

##Example run command
`docker run -d --restart=always --name Radarr --volumes-from Data --volumes-from media -p 7878:7878 adamant/radarr`
