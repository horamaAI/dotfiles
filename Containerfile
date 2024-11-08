# FROM --platform=linux/amd64 debian:bookworm-slim
FROM debian:bookworm
ARG CONTAINER_USER=sandboxuser
# for container to know it's one (useful for containerised development)
ENV RUNNING_IN_DOCKER true
ENV USER $CONTAINER_USER
ENV HOME /home/$CONTAINER_USER
WORKDIR $HOME

#RUN useradd -m -c "sandbox the brave" $CONTAINER_USER -s /bin/bash
# workaround for issue with dialog when installing through apt
RUN apt update
#RUN apt install dialog
RUN apt update && apt install -y vim git
RUN mkdir -p $HOME/repos && cd $HOME/repos && git clone https://github.com/horamaAI/dotfiles.git
RUN apt -y install sudo
RUN adduser --system --group $CONTAINER_USER \
  && echo "${CONTAINER_USER}:${CONTAINER_USER}" | chpasswd \
  && usermod -aG sudo $CONTAINER_USER
#RUN adduser --system --group $CONTAINER_USER
RUN chown -R "${CONTAINER_USER}:${CONTAINER_USER}" $HOME
USER $USER
# run dummy sudo required command to load password from standard input (sudo -S
# option for accepting the password from standard input)
RUN cd $HOME/repos/dotfiles && echo "${CONTAINER_USER}" | sudo -S apt update \
  && yes Y | bash install.sh
#RUN cd $HOME/repos/dotfiles && echo "${CONTAINER_USER}" | sudo -S apt update \
#  && yes Y | ./install.sh

#RUN chown -R tester:tester /home/tester && \
#    echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester && \
#    chmod 0440 /etc/sudoers.d/tester
