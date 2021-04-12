sudo docker network create rabbits
sudo docker run -d --rm --net rabbits -v ${PWD}/config/rabbit-1/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=REQOXZAYHMVTAAKXYDDU --hostname rabbit-1 --name rabbit-1 -p 8081:15672 rabbitmq:management
sudo docker run -d --rm --net rabbits -v ${PWD}/config/rabbit-2/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=REQOXZAYHMVTAAKXYDDU --hostname rabbit-2 --name rabbit-2 -p 8082:15672 rabbitmq:management
sudo docker run -d --rm --net rabbits -v ${PWD}/config/rabbit-3/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=REQOXZAYHMVTAAKXYDDU --hostname rabbit-3 --name rabbit-3 -p 8083:15672 rabbitmq:management


sudo docker exec -it rabbit-1 rabbitmq-plugins enable rabbitmq_federation 
sudo docker exec -it rabbit-2 rabbitmq-plugins enable rabbitmq_federation
sudo docker exec -it rabbit-3 rabbitmq-plugins enable rabbitmq_federation

sudo docker exec -it rabbit-1 rabbitmqctl stop_app
sudo docker exec -it rabbit-1 rabbitmqctl reset
sudo docker exec -it rabbit-1 rabbitmqctl start_app
sudo docker exec -it rabbit-1 rabbitmqctl cluster_status

sudo docker exec -it rabbit-1 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues