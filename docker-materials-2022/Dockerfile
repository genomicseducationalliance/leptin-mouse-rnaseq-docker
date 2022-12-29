FROM ubuntu:bionic-20210930
# Maintained by
LABEL name="Jupyter Lab for Genome Camp"
LABEL maintainer="Jason Williams"
LABEL maintainer_email="williams@cshl.edu"
LABEL version="3.3"
#
#
#
USER root
#
#
# Get some necessary packages
RUN apt update -y && apt upgrade -y && apt-get install -y --fix-missing\
 apt-utils\
 apt-transport-https\
 build-essential gcc\
 bzip2\
 ca-certificates\
 curl\
 dialog\
 dirmngr\
 git\
 gnupg2\
 libssl1.0-dev\
 nodejs-dev\
 node-gyp\
 npm nodejs\
 openssl\
 software-properties-common\
 tmux\
 sudo\
 unzip\
 wget\
 zip
#
#
#
# Install conda and add to path via symbolic links
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_22.11.1-1-Linux-x86_64.sh &&\
 bash Miniconda3-py38_22.11.1-1-Linux-x86_64.sh -b -p /opt/miniconda3
RUN /opt/miniconda3/bin/conda update -n base -c defaults conda
ENV CONDA_DIR=/opt/miniconda3
# upgrade python
RUN /opt/miniconda3/bin/conda install -y -q python=3.8
#
#
# Configure conda
RUN /opt/miniconda3/bin/conda config --add channels defaults
RUN /opt/miniconda3/bin/conda config --add channels bioconda
RUN /opt/miniconda3/bin/conda config --add channels conda-forge
#
#
# Install bioconda packages
RUN /opt/miniconda3/bin/conda install -y -q fastqc=0.11.7=5
RUN /opt/miniconda3/bin/conda install -y -q trimmomatic=0.39
RUN /opt/miniconda3/bin/conda install -y -q sra-tools
RUN /opt/miniconda3/bin/conda install -y -q parallel-fastq-dump
RUN /opt/miniconda3/bin/conda install -c "bioconda/label/cf201901" kallisto
RUN /opt/miniconda3/bin/conda install -y -q -c bioconda fastp
#
#
#
#
# Install iCommands
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/renci-irods.list\
    && apt-get update \
    && apt-get install -y irods-icommands \
    && apt-get clean \
    && rm -rf /usr/lib/apt/lists/*
#
#
# Install Jupyter and add Bash kernel
RUN /opt/miniconda3/bin/python3 -m pip install jupyterlab==3.2.1
RUN /opt/miniconda3/bin/pip3 install bash_kernel
RUN /opt/miniconda3/bin/python3 -m bash_kernel.install
#
#
# Genomeview essentials for python
RUN apt update -y && apt-get install -y --fix-missing\
 zlib1g-dev\
 libbz2-dev\
 libcurl4-openssl-dev\
 libssl-dev
RUN /opt/miniconda3/bin/pip3 install genomeview
COPY ./__init__.py /opt/miniconda3/lib/python3.8/site-packages/genomeview/__init__.py
#
#
#Get nodejs upgraded to 12+
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -\
  && apt-get update && apt-get install -y nodejs
#
#
# Add and enable plugins
#RUN /opt/miniconda3/bin/pip3 install jupyterlab_irods
#RUN jupyter serverextension enable --py jupyterlab_irods
#RUN /opt/miniconda3/bin/pip3 install jupyterlab_github
#RUN /opt/miniconda3/bin/pip3 install jupyterlab_git
RUN /opt/miniconda3/bin/pip3 install jlab-enhanced-cell-toolbar
#RUN jupyter labextension install ijab
#RUN jupyter serverextension enable --sys-prefix jupyterlab_github
#
#
#
# Configure shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && echo "SHELL=/bin/bash" >> /etc/environment
#
#
# Link conda executables to /bin and /usr/lib
RUN sudo ln -s /opt/miniconda3/bin/* /bin; exit 0
RUN sudo ln -s /opt/miniconda3/pkgs/*/lib/* /usr/lib; exit 0
#
#
#
# Install nodejs kernel
RUN npm config set user 0 \
 $$ npm install zeromq \
 && npm config set unsafe-perm true \
 && npm install ijavascript -g
#RUN ijsinstall --hide-undefined --install=global
#
#
RUN /opt/miniconda3/bin/jupyter server extension disable nbclassic
#
## Add the GEA user
RUN useradd -p $(openssl passwd -1 -salt xyz 'gea_user') -m -d /home/gea_user -s /bin/bash gea_user
RUN usermod -a -G sudo,root gea_user
RUN echo "gea_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#
#
# fix GEA user permissions
COPY ./jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json
COPY ./jupyter_notebook_config.py /home/gea_user/.jupyter/jupyter_notebook_config.py
#COPY ./.bashrc /home/gea_user/.bashrc
RUN chown -R gea_user:gea_user /home/gea_user/.jupyter
RUN chmod -R 777 /home/gea_user
RUN chown gea_user:gea_user /home/gea_user/.bashrc
#
# Switch to gea_user user
USER gea_user
ENV PATH="${PATH}:/opt/miniconda3/bin"
WORKDIR /home/gea_user
EXPOSE 8888
COPY entry.sh /bin
EXPOSE 8888
#
#
#
#
# Define entry point
ENTRYPOINT ["bash", "/bin/entry.sh"]
