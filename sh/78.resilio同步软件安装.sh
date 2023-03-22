DATA_FOLDER=/work/resilio
WEBUI_PORT=18072

mkdir -p $DATA_FOLDER

docker pull resilio/sync

docker run -d --name sync \
           -p 28888:8888 \
           -p 55555 \
           -v /work/resilio:/mnt/sync \
           --restart on-failure \
           resilio/sync


