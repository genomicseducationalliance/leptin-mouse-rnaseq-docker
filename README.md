# leptin-mouse-rnaseq
Docker files and lesson materials for GEA RNA-Seq lesson


## To run image locally 

1. Get the docker container: 

        $ docker pull genomicseducationalliance/rna-seq-leptin:dev_0.2
    
    
2. Clone the repository with notebooks 


        $ git clone https://github.com/genomics-education-alliance/leptin-mouse-rnaseq.git
        

3. Run the docker container, mounting the `persistant-dev` directory - move the notebooks and any test data into this directory first.  Example: 

        $ docker run --name leptin -d -p 8888:8888 -v /some-absolute-path/persistant-dev:/home/gea_user/work genomicseducationalliance/rna-seq-leptin:dev_0.2 
