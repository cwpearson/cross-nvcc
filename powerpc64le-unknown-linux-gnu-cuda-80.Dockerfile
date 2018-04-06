FROM japaric/powerpc64le-unknown-linux-gnu:v0.1.4

ENV CUDA_HOST="/cuda"
ENV CUDA_TARGET "/cuda-powerpc64le"
ENV PATH "$PATH:$CUDA_HOST/bin"
ENV CUDA_URL "https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        perl \
    && rm -rf /var/lib/apt/lists/*


## Install host CUDA version
RUN curl -sL -o cuda.run "$CUDA_URL" \
    && chmod +x cuda.run \
    && ./cuda.run --toolkit --silent --toolkitpath="$CUDA_HOST" \
    && rm -v cuda.run \
    && rm -r "$CUDA_HOST/doc" \
    && rm -r "$CUDA_HOST/libnsight" \
    && rm -r "$CUDA_HOST/libnvvp" \
    && rm -r "$CUDA_HOST/samples"

RUN ls $CUDA_HOST
RUN nvcc --version

## Install cross-compiling libraries
ENV CUDA_TARGET_URL https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2v2_8.0.61-1_ppc64el-deb
RUN curl -sL -o cuda.deb "$CUDA_TARGET_URL" \
    && dpkg -x cuda.deb tmp \
    && rm cuda.deb \
    && for d in `find tmp -name "*cudart*.deb" -o -name "*headers*.deb"`; do echo $d; dpkg -x $d tmp2; done \
    && rm -r tmp \
    && mkdir -p "$CUDA_TARGET" \
    && mv tmp2/usr/local/cuda-8.0/* "$CUDA_TARGET/." \
    && rm -r tmp2

RUN mkdir /tmp
