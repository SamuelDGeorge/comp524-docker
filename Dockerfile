FROM ubuntu:18.04

#update packages
RUN apt-get update \
    && apt-get install -y software-properties-common wget build-essential\
    && apt-get clean

#Install Lisp Interpreter
RUN apt-get install -y clisp

#Test LISP 
COPY LispTest.lisp LispTest.lisp
RUN clisp LispTest.lisp

#Install Prolog
RUN apt-add-repository ppa:swi-prolog/stable \
    && apt-get update \
    && apt-get install -y swi-prolog

#Test Prolog
COPY PrologTest.pl PrologTest.pl
RUN swipl -s PrologTest.pl 

#Install SML
RUN wget https://smlnj.org/dist/working/110.95/config.tgz \
    && tar -xzf config.tgz \
    && config/install.sh -default 64

#Test SML
COPY SmlTest.sml SmlTest.sml 
RUN sml SmlTest.sml

# Install Java 
RUN wget https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz \
    && tar xvf openjdk-10.0.2_linux-x64_bin.tar.gz \
    && rm openjdk-10.0.2_linux-x64_bin.tar.gz
ENV PATH="/jdk-10.0.2/bin:${PATH}"

#Test Java
COPY JavaTest.java JavaTest.java
RUN javac JavaTest.java \
    && java JavaTest

#clean up installs 
RUN apt-get update \
    && apt-get upgrade \
    && apt-get clean