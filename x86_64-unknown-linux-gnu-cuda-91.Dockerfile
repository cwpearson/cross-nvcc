FROM japaric/x86_64-unknown-linux-gnu:v0.1.4

ENV CUDA_HOST="/cuda"
ENV CUDA_TARGET "$CUDA_HOST"
ENV PATH "$PATH:$CUDA_HOST/bin"
ENV CUDA_URL "https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux"


RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        perl \
        python-software-properties \
    && rm -rf /var/lib/apt/lists/*

# Install a supported gcc
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        g++-5 \
    && rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5

## Install host CUDA version
RUN curl -sL -o cuda.run "$CUDA_URL" \
    && chmod +x cuda.run \
    && ./cuda.run --toolkit --silent --toolkitpath="$CUDA_HOST" \
    && rm -v cuda.run \
    && rm -r "$CUDA_HOST/doc" \
    && rm -r "$CUDA_HOST/libnsight" \
    && rm -r "$CUDA_HOST/libnvvp" \
    && rm -r "$CUDA_HOST/samples" \
    && rm -r "$CUDA_HOST/nsightee_plugins"

RUN ls $CUDA_HOST
RUN nvcc --version
