# leptin-mouse-rnaseq
Docker files and lesson materials for GEA RNA-Seq lesson (https://github.com/genomics-education-alliance/leptin-rna-seq-lesson). This container provides a Jupyter Lab interface and the software tools for doing the demonstration RNA-Seq analysis. 


## To run image locally

1. Get the docker container:

        $ docker pull genomicseducationalliance/rna-seq-leptin:dev_3.0


2. Clone the repository with notebooks


        $ git clone https://github.com/genomics-education-alliance/leptin-mouse-rnaseq.git

3. Example:

        $ docker run --name leptin -d -p 8888:8888 -v /some-absolute-path/:/home/gea_user/ genomicseducationalliance/rna-seq-leptin:dev_3.0

# Try it!

Datasets, worked-examples, and notebooks available on CyVerse:
/iplant/home/shared/gea/rna-seq-leptin

You can launch a Jupyter lab session pre-loaded with data and notebooks on CyVerse:

<a href="https://de.cyverse.org/de/?type=quick-launch&quick-launch-id=5427183c-19a5-4105-8ce3-ebbf5313ac9d&app-id=f109453a-21be-11ea-b74e-008cfa5ae621" target="_blank"><img src="https://de.cyverse.org/Powered-By-CyVerse-blue.svg"></a>
