FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-devel

ARG UID
ARG USERNAME

RUN useradd -u ${UID} -m ${USERNAME}

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y git fish net-tools vim python3
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN pip3 --no-cache-dir install torch torchvision torchaudio jupyter

# USER root
# RUN mkdir -p /home/${USERNAME}/workspace
# RUN chown ${USERNAME} /home/${USERNAME}/workspace

USER ${USERNAME}
WORKDIR /home/${USERNAME}/workspace
