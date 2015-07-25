docker build -t local/build-kernel .
docker run --rm -it --name build-kernel-temp -v $STORAGE:/repo local/build-kernel
docker rmi local/build-kernel
