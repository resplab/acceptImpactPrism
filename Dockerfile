FROM opencpu/base:v2.2.7
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_github("resplab/accept@impact")'
RUN R -e 'remotes::install_github("resplab/acceptPrism")'
RUN echo "opencpu:opencpu" | chpasswd
