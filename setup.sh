image_version=`date +%Y%m%d%H%M`;
echo $image_version;
# cd nichecomments
git pull --rebase origin master;
docker stop nichecomments;
docker rm nichecomments -f;
docker build -t nichecomments:$image_version .;
docker images;
docker run -p 82:80 -d --name nichecomments -v /data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /data/nginx/log:/var/log/nginx -v /data/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf -d nichecomments:$image_version;
# -v ~/docker-data/house-web/appsettings.json:/app/appsettings.json -v ~/docker-data/house-web/NLogFile/:/app/NLogFile   --restart=always
docker logs nichecomments;
#删除build过程中产生的镜像    #docker image prune -a -f
docker rmi $(docker images -f "dangling=true" -q)