FROM ubuntu:latest

LABEL maintainer="rajjoshi@comp.nus.edu.sg"

# Fix the locale warning
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Install packages 
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	apt-utils \
	openssh-server \
	sudo
RUN mkdir /var/run/sshd

# Do the user and ssh login setup
COPY setup.sh /root
COPY run.sh /root
RUN chmod +x /root/*.sh

EXPOSE 22
EXPOSE 80

CMD ["/root/run.sh"]