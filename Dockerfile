FROM opencpu/base

RUN R -e 'remotes::install_github("resplab/accept", auth_token = ${{ secrets.GITHUB_TOKEN }})'
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_github("resplab/acceptPrism", auth_token = ${{ secrets.GITHUB_TOKEN }}'
RUN echo "opencpu:opencpu" | chpasswd
