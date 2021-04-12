echo "listing containers ..."
sudo docker ps -a

echo "listing networks ..."
sudo docker network ls

echo "stopping first container ... "
sudo docker stop rabbit-1
echo "stopping second container ... "
sudo docker stop rabbit-2
echo "stopping third container ... "
sudo docker stop rabbit-3
echo "deleting network from cluster ... "
sudo docker network rm rabbits

echo "listing containers ..."
sudo docker ps -a

echo "listing networks ..."
sudo docker network ls