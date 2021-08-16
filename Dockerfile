FROM opencpu/base
RUN git config --global url."https://${GIT_ACCESS_TOKEN}@github.com".insteadOf "ssh://git@github.com"
RUN R -e 'remotes::install_github("resplab/accept")'
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_github("resplab/acceptPrism")'
RUN echo "opencpu:opencpu" | chpasswd
