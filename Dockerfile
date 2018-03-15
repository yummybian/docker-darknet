FROM yummybian/docker-gpu-opencv-ubuntu:latest

MAINTAINER yummy.bian@gmail.com

# Install Darknet
WORKDIR /darknet
RUN git clone --depth=1 https://github.com/ZanLabs/darknet.git && \
    cd darknet && make OPENCV=1 GPU=1 CUDNN=1 && make install && \
    cd .. && rm -rf darknet
RUN sh -c "echo '/usr/local/lib' >> /etc/ld.so.conf"
RUN ldconfig


