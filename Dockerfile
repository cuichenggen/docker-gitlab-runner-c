FROM  senggen/clang-ubuntu

# install clang lint tool
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install clang-tidy cppcheck splint llvm && \
    apt-get -y install gcc g++ lcov && \
    apt-get -y install valgrind && \
    apt-get -y install wget curl && \
    apt-get -y install libpcap-dev && \
    apt-get clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

#install cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5.tar.gz && \
    tar -xvzf cmake-3.14.5.tar.gz && \
    cd cmake-3.14.5/ && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf cmake-3.14.5

# install gitlab-runner
ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init

RUN apt-get -y update && \
    apt-get -y install curl && \
    curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | bash && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install gitlab-ci-multi-runner && \
    apt-get clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /usr/local/sonarscanner
ADD sonarscanner /usr/local/sonarscanner
ENV PATH="/usr/local/sonarscanner/bin:${PATH}"

VOLUME ["/etc/gitlab-runner/c", "/etc/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "gitlab-runner"]
CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
