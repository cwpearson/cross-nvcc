FROM japaric/x86_64-unknown-linux-gnu:v0.1.4

ENV CUDA_HOST="/cuda"
ENV CUDA_TARGET "$CUDA_HOST"
ENV PATH "$PATH:$CUDA_HOST/bin"
ENV CUDA_URL "https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run"


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
        g++-4.8 \
    && rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8

## Install host CUDA version
RUN curl -sL -o cuda.run "$CUDA_URL" \
    && chmod +x cuda.run \
    && ./cuda.run --toolkit --silent --toolkitpath="$CUDA_HOST" \
    && rm -v cuda.run \
    && rm -rv "$CUDA_HOST/doc" \
    && rm -rv "$CUDA_HOST/libnsight" \
    && rm -rv "$CUDA_HOST/libnvvp" \
    && rm -rv "$CUDA_HOST/samples" \
    && rm -rv "$CUDA_HOST/nsightee_plugins"

RUN nvcc --version
