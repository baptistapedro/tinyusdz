FROM fuzzers/libfuzzer:12.0

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev  meson libjpeg-dev uuid uuid-dev  pkg-config libssl-dev curl
RUN curl -OL https://github.com/Kitware/CMake/releases/download/v3.20.1/cmake-3.20.1.tar.gz
RUN  tar xvfz cmake-3.20.1.tar.gz
WORKDIR /cmake-3.20.1
RUN cmake .
RUN make
RUN make install
WORKDIR /
RUN git clone https://github.com/syoyo/tinyusdz.git
WORKDIR /tinyusdz
RUN cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ .
RUN make
WORKDIR ./tests/fuzzer
RUN CC=clang CXX=clang++ meson build .
RUN ninja -C build

#fuzz_intcoding
#fuzz_tinyusdz
#fuzz_usdaparser
ENTRYPOINT []
CMD ["/tinyusdz/tests/fuzzer/build/fuzz_usdaparser"]
