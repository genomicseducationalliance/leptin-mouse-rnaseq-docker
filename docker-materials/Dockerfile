
FROM ubuntu:bionic-20210930
# Maintained by
LABEL maintainer="Genomics Education Alliance"
LABEL maintainer_email="genomicseducationalliance@gmail.com"
LABEL version="3.3"
LABEL lesson=leptin-mouse-rnaseq
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
RUN wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh &&\
 bash Anaconda3-2021.05-Linux-x86_64.sh -b -p /opt/conda
RUN /opt/conda/bin/conda update -n base -c defaults conda
ENV CONDA_DIR=/opt/conda
RUN sudo ln -s /opt/conda/pkgs/*/bin/* /bin; exit 0
RUN sudo ln -s /opt/conda/pkgs/*/lib/* /usr/lib; exit 0
# Configure conda
RUN /opt/conda/bin/conda config --add channels defaults
RUN /opt/conda/bin/conda config --add channels bioconda
RUN /opt/conda/bin/conda config --add channels conda-forge
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
RUN /opt/conda/bin/python3 -m pip install jupyterlab==3.2.1
RUN /opt/conda/bin/pip3 install bash_kernel
RUN /opt/conda/bin/python3 -m bash_kernel.install
#
# Configure conda
RUN /opt/conda/bin/conda config --add channels defaults
RUN /opt/conda/bin/conda config --add channels bioconda
RUN /opt/conda/bin/conda config --add channels conda-forge
#
#
# Install bioconda packages
RUN /opt/conda/bin/conda install -y -q fastqc=0.11.7=5
RUN /opt/conda/bin/conda install -y -q trimmomatic
RUN /opt/conda/bin/conda install -y -q sra-tools=2.9.6=hf484d3e_0
RUN /opt/conda/bin/conda install -y -q parallel-fastq-dump=0.6.5=py_0
RUN /opt/conda/bin/conda install -y -q kallisto=0.46.0=hb6a4e58_0
RUN /opt/conda/bin/conda install -y -q fastp=0.20.0=hdbcaa40_0
#
#
#
# Genomeview essentials for python
RUN apt update -y && apt-get install -y --fix-missing\
 zlib1g-dev\
 libbz2-dev\
 libcurl4-openssl-dev\
 libssl-dev
RUN /opt/conda/bin/pip install genomeview
COPY ./__init__.py /opt/conda/lib/python3.7/site-packages/genomeview/__init__.py
#
#
# Install nodejs kernel
RUN npm config set user 0 \
 $$ npm install zeromq \
 && npm config set unsafe-perm true \
 && npm install ijavascript -g

RUN ijsinstall --hide-undefined --install=global
#
#
# Configure shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && echo "SHELL=/bin/bash" >> /etc/environment
#
#
# Add the GEA user
RUN useradd -p $(openssl passwd -1 -salt xyz 'gea_user') -m -d /home/gea_user -s /bin/bash gea_user
RUN usermod -a -G sudo,root gea_user
RUN echo "gea_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#
#
# Switch to GEA user
COPY ./jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json
COPY ./jupyter_notebook_config.py /home/gea_user/.jupyter/jupyter_notebook_config.py
#COPY ./.bashrc /home/gea_user/.bashrc
RUN chown -R gea_user:gea_user /home/gea_user/.jupyter
RUN chmod -R 777 /home/jovyan
#RUN chown gea_user:gea_user /home/gea_user/.bashrc
USER gea_user
#
#
# Link conda executables to /bin and /usr/lib
RUN sudo ln -s /opt/conda/pkgs/*/bin/* /bin; exit 0
RUN sudo ln -s /opt/conda/pkgs/*/lib/* /usr/lib; exit 0
#
# Define entry point and startup commands
ENTRYPOINT ["jupyter"]
CMD ["lab", "--no-browser", "--ip=0.0.0.0", "--NotebookApp.token=''", "--NotebookApp.password=''", "--notebook-dir='/home/gea_user'", "--Session.username='gea_user'"]
