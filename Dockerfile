FROM starrocks/dev-env-ubuntu:3.2-latest

RUN apt update && \
    apt install -y openssh-server lsb-release wget software-properties-common gnupg vim && \
    wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 15 && \
    echo "root:3897" |chpasswd && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "Port 2222" >> /etc/ssh/sshd_config && \
    mkdir /var/run/sshd

ENV STARROCKS_HOME ${starrockshome}
RUN echo "export STARROCKS_THIRDPARTY=/var/local/thirdparty" >> ~/.bashrc && \
    echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.bashrc && \
    echo "export STARROCKS_LINKER=lld" >> ~/.bashrc && \
    echo "export CC=clang-15" >> ~/.bashrc && \
    echo "export CXX=clang++-15" >> ~/.bashrc && \
    echo "process handle -s false SIGSEGV" >> ~/.lldbinit && \
    echo "handle SIGSEGV nostop noprint pass" >> ~/.gdbinit

# Default ssh port is 2222, you can change it.
EXPOSE 22 80 443 2222 5005 5555 8001 8030 9020 9030 9060 8040 
CMD ["/usr/sbin/sshd", "-D"]

