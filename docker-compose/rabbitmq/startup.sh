echo "Creating network for cluster ... "
sudo docker network create rabbits
echo "Creating first container ... "
sudo docker run -d --rm --net rabbits -v ${PWD}/config/rabbit-1/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=REQOXZAYHMVTAAKXYDDU --hostname rabbit-1 --name rabbit-1 -p 5671:5672 -p 8081:15672 rabbitmq:management
echo "Creating second container ... "
sudo docker run -d --rm --net rabbits -v ${PWD}/config/rabbit-2/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=REQOXZAYHMVTAAKXYDDU --hostname rabbit-2 --name rabbit-2 -p 5672:5672 -p 8082:15672 rabbitmq:management
echo "Creating third container ... "
sudo docker run -d --rm --net rabbits -v ${PWD}/config/rabbit-3/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=REQOXZAYHMVTAAKXYDDU --hostname rabbit-3 --name rabbit-3 -p 5673:5672 -p 8083:15672 rabbitmq:management

echo "enabling shovel plugin in first container ... "
sudo docker exec -it rabbit-1 rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management
echo "enabling shovel plugin in second container ... "
sudo docker exec -it rabbit-2 rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management
echo "enabling shovel plugin in third container ... "
sudo docker exec -it rabbit-3 rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management

echo "enabling federation plugin in first container ... "
sudo docker exec -it rabbit-1 rabbitmq-plugins enable rabbitmq_federation 
echo "enabling federation plugin in second container ... "
sudo docker exec -it rabbit-2 rabbitmq-plugins enable rabbitmq_federation
echo "enabling federation plugin in third container ... "
sudo docker exec -it rabbit-3 rabbitmq-plugins enable rabbitmq_federation

echo "Resetting first container to enable clustering ..."
echo "stopping ... "
sudo docker exec -it rabbit-1 rabbitmqctl stop_app
echo "resetting... "
sudo docker exec -it rabbit-1 rabbitmqctl reset
echo "starting node... "
sudo docker exec -it rabbit-1 rabbitmqctl start_app
echo "printing cluster status ... "
sudo docker exec -it rabbit-1 rabbitmqctl cluster_status

echo "adding policy federation-upstream-set = all to all nodes... "
sudo docker exec -it rabbit-1 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues

echo "listing containers ..."
sudo docker ps -a

echo "listing networks ..."
sudo docker network ls