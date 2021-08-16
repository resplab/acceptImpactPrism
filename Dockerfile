FROM opencpu/base
RUN R -e 'remotes::install_github("resplab/accept")'
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_github("resplab/acceptPrism")'
RUN echo "opencpu:opencpu" | chpasswd
