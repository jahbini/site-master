FROM theiaide/theia:latest
MAINTAINER jim@bamboocando.com

RUN mkdir /site-master && apk update
RUN apk add curl python git make
RUN yarn global add gulp-cli

WORKDIR /site-master
ADD . /site-master
RUN node -v
RUN yarn install
RUN rm -rf /site-master/site/*

#RUN curl -LOu jahbini:Tqbfj0tlD https://github.com/jahbini/Stagserv/archive/mas
RUN ls -lisa site || ls 

expose 3000
expose 3001
CMD yarn run gitget; gulp  || sleep 5000

