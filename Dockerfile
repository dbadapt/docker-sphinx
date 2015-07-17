#
# ddidier/ndd-docker-sphinx
#
# A Docker image for the Sphinx documentation builder (http://sphinx-doc.org).
#
# docker build -t ddidier/ndd-docker-sphinx .

FROM       envygeeks/ubuntu
MAINTAINER David DIDIER

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y acl python-dev python-pip

RUN pip install 'Sphinx                 >= 1.3.0, < 1.4.0'
RUN pip install 'alabaster              >= 0.7.0, < 0.8.0'
RUN pip install 'rst2pdf                >= 0.0.0, < 1.0.0'
RUN pip install 'sphinx-autobuild       >= 0.5.0, < 0.6.0'
RUN pip install 'sphinx_bootstrap_theme >= 0.4.0, < 0.5.0'
RUN pip install 'sphinx_rtd_theme       >= 0.1.0, < 0.2.0'

ENV DOC_DIR /doc

VOLUME $DOC_DIR

WORKDIR $DOC_DIR

COPY files/etc/startup1.d/* /etc/startup1.d/
COPY files/usr/bin/*        /usr/bin/
COPY files/usr/local/bin/*  /usr/local/bin/
