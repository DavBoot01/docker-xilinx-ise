
#Target: Xilinx ISE @ version 14.7

# Use Ubuntu 16.04 LTS as the basis for the Docker image.
FROM ubuntu:16.04


# Install essential host package need to install and use petalinux
ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y -q \ 
	git expect emacs24-nox locales libavahi-client3 \
  libglib2.0-0 libsm6 libxi6 libxrender1 libxrandr2 sudo \
  libfreetype6 libfontconfig1 wget curl build-essential libavahi-client3 \
  rsync avahi-daemon libusb-1.0-0


# Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
# Replace dash with bash
# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up the build environment in CMD. Use bash as an alias for sh.
RUN rm /bin/sh && ln -s bash /bin/sh


# Remove need of insert password for all user
RUN echo "%sudo ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Make a Xilinx user, intent to install Xilinx's tools (these do not allow installation as root user)
RUN adduser --disabled-password --gecos '' xilinx && \
  usermod -aG sudo xilinx && \
  echo "xilinx ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


ARG ISE_VERSION=14.7
ARG ISE_RUN_FILE=Xilinx_ISE_DS_Lin_14.7_1015_1.tar
ARG ISE_INSTALLER_FOLDER=Xilinx_ISE_DS_Lin_14.7_1015_1

ADD resources/${ISE_RUN_FILE} /
ADD resources/install/ /install/

RUN TERM=xterm /install/install.sh

RUN cd /opt/Xilinx/14.7/ISE_DS/common/bin/lin64/digilent && \
  /install/install_drivers.sh

##### NOT USED #####

#ADD resources/digilent/ /digilent/
#RUN cd /digilent/ && dpkg -i digilent.adept.runtime_2.26.1-amd64.deb && \
#	dpkg -i digilent.adept.utilities_2.7.1-amd64.deb

####################

RUN rm -rf /${ISE_INSTALLER_FOLDER}
RUN rm -rf /install
RUN rm -rf /digilent

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD image_addon/bashrc_add.txt /
RUN cat bashrc_add.txt >> /home/xilinx/.bashrc && \
  rm bashrc_add.txt

ADD entrypoint.sh /bin

RUN echo "root:root" | chpasswd
WORKDIR /home/xilinx/
ENTRYPOINT ["bash", "/bin/entrypoint.sh"]
