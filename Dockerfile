FROM dynverse/dynwrap:bioc

RUN R -e 'devtools::install_cran("destiny")'

# Patch was generated by making changes in the calista git repository,
# and then running:
# git diff --no-prefix > calista.patch

RUN apt-get update && apt-get install -y libcgal-dev libglu1-mesa-dev libglu1-mesa-dev libjpeg-dev libtiff-dev tcl-dev patch

RUN cd / && \
    git clone https://github.com/CABSEL/CALISTA.git && \
    cd CALISTA && \
    rm -rf .git && \
    find . -type f \( -iname \*.zip -o -iname \*.csv -o -iname \*.txt \) -exec rm {} + && \
    wget https://gist.githubusercontent.com/rcannood/ed97cacc2f373de6f3a6bb7320e2c677/raw/935044855cd204aee6eba821367b95669bb14784/calista.patch && \
    patch -p0 calista.patch

RUN Rscript /CALISTA/CALISTA-R/install_packs.R

LABEL version 0.1.3

ADD . /code

ENTRYPOINT Rscript /code/run.R
