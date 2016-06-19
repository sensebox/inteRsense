FROM opencpu/base

RUN apt-get update && apt-get install -y libgeos-dev libproj-dev libgdal-dev && rm -rf /var/lib/apt/lists/*

COPY ./ /inteRsense

RUN R -e 'install.packages(c("gstat", "rgeos", "maptools", "sp", "rgdal", "fields"), repos="http://cran.rstudio.com/")' \
  && R CMD INSTALL  inteRsense -l /inteRsense --library=/usr/local/lib/R/site-library
