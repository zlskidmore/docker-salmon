# work from latest LTS ubuntu release
FROM ubuntu:18.04

# set the environment variables
ENV salmon_version 1.0.0

# run update and install necessary tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    cmake \
    libnss-sss \
    curl \
    vim \
    less \
    wget \
    libboost-all-dev \
    libtbb-dev \
    unzip \
    libbz2-dev \
    liblzma-dev \
    libjemalloc-dev

# install kallisto
WORKDIR /usr/local/bin/
RUN curl -SL https://github.com/COMBINE-lab/salmon/archive/v${salmon_version}.tar.gz \
    | tar -zxvC /usr/local/bin/
RUN mkdir -p /usr/local/bin/salmon-${salmon_version}/build
WORKDIR /usr/local/bin/salmon-${salmon_version}/build
RUN cmake -DBOOST_ROOT=/usr/include/boost -DTBB_INSTALL_DIR=/usr/include/tbb -DCMAKE_INSTALL_PREFIX=/usr/local/ ..
RUN make
RUN make install
WORKDIR /usr/local/bin/

# set env variables
ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

# set default command
CMD ["salmon"]
