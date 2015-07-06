FROM phusion/baseimage:0.9.16
MAINTAINER Stian Larsen <lonixx@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM screen


#Applying stuff
RUN add-apt-repository ppa:webupd8team/java 
RUN apt-get update -q 
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections 
RUN apt-get install oracle-java7-installer oracle-java7-set-default  wget zip unzip git -y 
RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O /tmp/BuildTools.jar 
RUN wget http://mcmyadmin.com/Downloads/MCMA2_glibc26_2.zip -O /tmp/MCMA2_glibc26_2.zip 
RUN wget http://mcmyadmin.com/Downloads/etc.zip -O /tmp/etc.zip 
RUN unzip /tmp/etc.zip -d /usr/local 
RUN unzip /tmp/MCMA2_glibc26_2.zip -d /tmp 
RUN rm /tmp/etc.zip /tmp/MCMA2_glibc26_2.zip 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*


#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh

#Adding abc user
RUN useradd -u 911 -U -s /bin/false abc && usermod -G users abc


# Use baseimage-docker's init system
CMD ["/sbin/my_init"]


# Volums and Ports
VOLUME /minecraft
EXPOSE 8080
EXPOSE 25565

#sample run command:
# docker create --name=minecraft -v /appdata/minecraft:/minecraft -e  -e PUID=911 -e PGID=911 -e REV=1.8.3 -p 8080:8080 -p 25565:25565 lonix/minecraft:2 