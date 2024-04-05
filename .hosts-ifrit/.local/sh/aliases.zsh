alias dmysql='docker exec -it $(docker ps | grep mysql | cut -f 1 -w) mysql -proot'
