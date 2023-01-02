# get shiny server and R from the rocker project
# build and run Docker image with
#
# docker build -t userreg .
# docker run --rm -dp 3838:3838 -v /Volumes/blitshare/data:/srv/shiny-server/data userreg
#
# docker build -t $AZURE_CONTAINER_REGISTRY/userregapp . 
#
FROM rocker/shiny:4.1.1

# install system libraries
# (noting rocker/shiny uses Ubuntu 20.04)
# Package Manager is a good resource to help
# discover system deps:
# https://packagemanager.rstudio.com/client/#/repos/2/packages/A3

RUN apt-get update 
RUN apt-get install -y make 
RUN apt-get install -y zlib1g-dev libicu-dev
RUN apt-get install -y libsodium-dev
RUN apt-get install -y sqlite3

# install required R packages but fix the date
# for future reproducibility

RUN R -e 'install.packages(c(\
              "shiny", \
              "stringr", \
              "RSQLite", \
              "sodium", \
              "dplyr", \
              "dbplyr" \
            ), \
            repos="https://packagemanager.rstudio.com/cran/__linux__/focal/2021-10-29" \
          )'

# copy the app directory into the image
COPY . srv/shiny-server
WORKDIR srv/shiny-server

# run app
CMD ["/usr/bin/shiny-server"]
