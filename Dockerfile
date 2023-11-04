# This is the dockerfile to build a preparation and evaluation server
# The training data is made by this preparation server
# A GPU server with publick key in id_rsa.pub downloads the training data and trains the model and sends the models to this server
# This server evaluates the models and sends the results to the GPU server

# Base image
FROM python:3.8-slim-bullseye

# Set working directory
WORKDIR /root

RUN git clone https://github.com/tkgsn/priv_traj_gen.git
RUN pip install -r priv_traj_gen/requirements.txt

# Install OpenSSH
RUN apt-get update && apt-get install -y openssh-server

EXPOSE 22

# Create OpenSSH privilege separation directory
RUN mkdir /var/run/sshd

# add public key for ssh
RUN mkdir /root/.ssh
COPY id_rsa.pub /root/.ssh/authorized_keys

# move to priv_traj_gen directory and run prepare.sh
WORKDIR /root/priv_traj_gen
RUN ./prepare.sh

# Run sshd
CMD ["/usr/sbin/sshd", "-D"]