[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/jahbini/site-master)


### installation harness for site-master syndication system

This repository defines the host directory structure
for multiple sites running in syndication with static serving via nginx.

subdirectories in `./sites` are the sources of the static sites
subdirectory `site-loader` is the static content generator and comes
from `github/jahbini/site-loader`

The currently suported sites are celarien.com, stjohnsjim.com and bamboosnow.com,
each is a separate repository on github.

The scripts in this repository are to set up a bare Ubuntu system eg. Digital Ocean droplet.
They install global requireents, load up the sites and site-loader, 
and to start off the nginx process.



