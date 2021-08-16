FROM opencpu/base

RUN R -e 'remotes::install_github("resplab/accept", auth_token = "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")'
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_github("resplab/acceptPrism", auth_token = "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"'
RUN echo "opencpu:opencpu" | chpasswd
