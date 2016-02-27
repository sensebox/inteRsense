FROM opencpu/base

RUN apt-get update && apt-get install -y libgeos-dev && apt-get install -y libproj-dev && apt-get install -y libgdal-dev
 && rm -rf /var/lib/apt/lists/*
