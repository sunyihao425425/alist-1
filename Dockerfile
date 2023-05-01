# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.7.1/ubuntu2204/devel/cudnn8/Dockerfile
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /content

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y sudo && apt-get install -y python3-pip && pip3 install --upgrade pip
RUN apt-get install -y curl tzdata aria2 gnupg wget htop sudo git git-lfs software-properties-common build-essential libgl1 zip unzip

# Config timezone
RUN  date -R && sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date -R

ENV PATH="/home/admin/.local/bin:${PATH}"
ENV ALIST_TAR="alist-linux-amd64.tar.gz"
# # Alist
# RUN wget https://github.com/alist-org/alist/releases/download/v3.12.2/alist-linux-amd64.tar.gz
RUN curl -s https://api.github.com/repos/alist-org/alist/releases/latest | grep $ALIST_TAR | grep "browser_download_url" | awk   '{print$2}' | xargs -I {} wget {} 
RUN ls  $ALIST_TAR || wget https://github.com/alist-org/alist/releases/download/v3.12.2/alist-linux-amd64.tar.gz
RUN tar -zxvf $ALIST_TAR ; rm *.gz && chmod 777 alist && ls -l

COPY *.sh .
RUN chmod a+x script.sh

RUN adduser --disabled-password --gecos '' admin
RUN adduser admin sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN chown -R admin:admin /content
RUN chmod -R 777 /content
RUN chown -R admin:admin /home
RUN chmod -R 777 /home
USER admin

EXPOSE 5244

CMD ["./script.sh"]