FROM ubuntu:22.04

ENV HOME=/root
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p $HOME/pwnbox

WORKDIR $HOME/


RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    nano \
    vim \
    python3 \
    python3-pip \
    ruby \
    ruby-dev \
    tmux \
    gcc \
    make

RUN gem install one_gadget
RUN gem install seccomp-tools
RUN python3 -m pip install ROPgadget

RUN apt install -y gdb

RUN git clone https://github.com/scwuaptx/Pwngdb.git && \
    cp $HOME/Pwngdb/.gdbinit $HOME/

RUN git clone https://github.com/pwndbg/pwndbg $HOME/pwndbg && \
    cd /root/pwndbg && ./setup.sh

RUN rm /root/.gdbinit

RUN echo "source /root/pwndbg/gdbinit.py" >> /root/.gdbinit && \
    echo "source /root/Pwngdb/pwngdb.py" >> /root/.gdbinit && \
    echo "source /root/Pwngdb/angelheap/gdbinit.py" >> /root/.gdbinit && \
    echo "" >> /root/.gdbinit && \
    echo "define hook-run" >> /root/.gdbinit && \
    echo "python" >> /root/.gdbinit && \
    echo "import angelheap" >> /root/.gdbinit && \
    echo "angelheap.init_angelheap()" >> /root/.gdbinit && \
    echo "end" >> /root/.gdbinit && \
    echo "end" >> /root/.gdbinit

WORKDIR $HOME/pwnbox

CMD ["/bin/bash"]
