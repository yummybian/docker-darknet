FROM yummybian/docker-gpu-opencv-ubuntu:devel

MAINTAINER yummy.bian@gmail.com

ENV GO_VERSION 1.9.4

# Install Darknet
WORKDIR /darknet
RUN git clone --depth=1 https://github.com/ZanLabs/darknet.git && \
    cd darknet && make OPENCV=1 GPU=1 CUDNN=1 && make install && \
    cd .. && rm -rf darknet

FROM yummybian/docker-gpu-opencv-ubuntu:runtime
COPY --from=0 /usr/local/lib/libdarknet.a /usr/local/lib/
COPY --from=0 /usr/local/include/darknet.h /usr/local/include/

RUN sh -c "echo '/usr/local/lib' >> /etc/ld.so.conf" RUN ldconfig

# Install Go
# RUN wget -O go.tgz https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
#     tar -C /usr/local -xzf go.tgz && \
#     rm go.tgz && \
#     mkdir /go

# Install Go
COPY --from=golang:1.9.4 /usr/local/go /usr/local
RUN mkdir /go
# Set environment variables for go
ENV GOPATH=/go GOROOT=/usr/local/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin
