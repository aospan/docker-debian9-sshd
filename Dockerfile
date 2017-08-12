FROM debian:stretch

MAINTAINER Abylay Ospan <aospan@netup.ru>

RUN apt-get update \
	    && apt-get -q -y dist-upgrade \
	    && apt-get -q -y install --no-install-recommends openssh-server \
	    && apt-get clean \
	    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /var/run/sshd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# not secure !
# not for production use
# use this only for experiments 
# TODO: rework to public keys and regular user
RUN echo "root:docker" | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
