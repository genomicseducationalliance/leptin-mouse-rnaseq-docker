
FROM jupyter/scipy-notebook
# Maintained by
LABEL maintainer="Genomics Education Alliance"
LABEL maintainer_email="genomicseducationalliance@gmail.com"
LABEL version="1.0"
LABEL lesson=leptin-mouse-rnaseq
#
#
#
USER root
#
#
# Un-minimize the image to get back Ubuntu
# goodies for teaching Linux/bash (e.g. man files, etc)
# this makes the container big
RUN apt-get update && apt-get upgrade -y --fix-missing && \
(echo y | DEBIAN_FRONTEND=noninteractive sh -x /usr/local/sbin/unminimize)
RUN apt update -y && apt upgrade -y && apt-get install -y --fix-missing\
 bzip2\
 curl\
 git\
 gnupg2\
 sudo\
 zip\
 unzip\
 wget
#
#
# Install iCommands
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" > /etc/apt/sources.list.d/renci-irods.list \
    && apt-get update \
    && apt-get install -y irods-icommands \
    && apt-get clean \
    && rm -rf /usr/lib/apt/lists/*
   # && fix-permissions $CONDA_DIR
#
#
# Install Jupyter lab
RUN pip install jupyterlab==1.0.9 \
    && conda update -n base conda \
    && conda install -c conda-forge nodejs \
    && jupyter lab build
#
#
# install the irods plugin for jupyter lab
RUN pip install jupyterlab_irods \
    && jupyter serverextension enable --py jupyterlab_irods \
    && jupyter labextension install ijab
#
#
# install jupyterlab hub-extension, lab-manager, bokeh
RUN jupyter lab --version \
    && jupyter labextension install @jupyterlab/hub-extension \
                                    @jupyter-widgets/jupyterlab-manager \
                                    jupyterlab_bokeh
#
#
# install jupyterlab git extension
RUN jupyter labextension install @jupyterlab/git && \
        pip install --upgrade jupyterlab-git && \
        jupyter serverextension enable --py jupyterlab_git
#
#
# install jupyterlab github extension
RUN jupyter labextension install @jupyterlab/github
#
#
# add Bash kernel
RUN pip install bash_kernel && python3 -m bash_kernel.install
#
#
# Configure conda
RUN /opt/conda/bin/conda config --add channels defaults
RUN /opt/conda/bin/conda config --add channels bioconda
RUN /opt/conda/bin/conda config --add channels conda-forge
#
#
# Install bioconda packages
RUN /opt/conda/bin/conda install -y -q fastqc=0.11.7=5
RUN /opt/conda/bin/conda install -y -q trimmomatic=0.38=0
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
