ARG CUDA_VERSION=11.7.0
ARG CUDNN_VERSION=8
ARG UBUNTU_VERSION=22.04

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-ubuntu${UBUNTU_VERSION}
LABEL mantainer=" github.com/Fizmath "

ARG JULIA_RELEASE=1.8
ARG JULIA_VERSION=1.8.2

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get -qq install  \
    wget && \
    wget https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_RELEASE}/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    tar zxvf julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    rm -rf julia-${JULIA_VERSION}-linux-x86_64.tar.gz  && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge --auto-remove && \
    apt-get clean

ENV  PATH=$PATH:../julia-${JULIA_VERSION}/bin
ENV  JULIA_CUDA_USE_BINARYBUILDER=false

RUN  julia -e 'using Pkg;  Pkg.add([ \
#  ADD or REMOVE YOUR PACKAGES HERE THEN RE-BUILD THIS DOCKERFILE : 
"CUDA",\
"Flux", \
"MLDatasets", \
"Statistics", \
"Parameters", \
"Images", \
"Printf", \
"Random", \
])'

WORKDIR /myapp
