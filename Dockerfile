FROM ubuntu:18.04


RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:avsm/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      opam \
      ocaml \
      build-essential \
      jq \
      aspcud \
      vim \
      gcc \
      m4 && \
    echo "yes" >> /tmp/yes.txt && \
    opam init --disable-sandboxing -y < /tmp/yes.txt && \
    opam switch create 4.12.0 && \
    opam switch 4.12.0 && \
    opam install -y num && \
    opam pin -y cil https://github.com/pdreiter/cil.git

RUN mkdir -p /opt/genprog/gp-src
WORKDIR /opt/genprog/gp-src

RUN ls
RUN git clone https://github.com/squaresLab/genprog-code.git
RUN mv genprog-code/Makefile ../ && \
    mv genprog-code/src ../

WORKDIR /opt/genprog

RUN mkdir bin && \
    eval $(opam config env) && \
    make && \
    make -C src repair.byte && \
    mv src/repair bin/genprog && \
    mv src/repair.byte bin/genprog.byte && \
    ln -s bin/genprog bin/repair && \
    mv src/distserver bin/distserver && \
    mv src/nhtserver bin/nhtserver

ENV PATH "/opt/genprog/bin:${PATH}"

VOLUME /opt/genprog

RUN apt-get install time
RUN mkdir -p /opt/codeflaws/repo
WORKDIR /opt/codeflaws/repo
RUN git clone https://github.com/pdreiter/codeflaws.git 

WORKDIR /opt/codeflaws
RUN apt-get install -y wget
RUN wget http://www.comp.nus.edu.sg/~release/codeflaws/codeflaws.tar.gz && \
tar xf codeflaws.tar.gz

RUN cp repo/codeflaws/all-script/* .
RUN head -n 1 repo/codeflaws/all-script/codeflaws-defect-detail-info.txt > run1

RUN mkdir -p /opt/codeflaws/genprog-run

RUN perl -pi -e's#/home/ubuntu/codeforces-crawler/CodeforcesSpider#/opt/codeflaws#' run-version-genprog.sh validate-fix-genprog.sh
RUN perl -pi -e's#/home/ubuntu/genprog-source-v3.0/src/repair#/opt/genprog/bin/genprog#' run-version-genprog.sh validate-fix-genprog.sh

ENV PATH "${PATH}:/root/.opam/4.12.0/bin"