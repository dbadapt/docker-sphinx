#
# ddidier/ndd-docker-sphinx
#
# A Docker image for the Sphinx documentation builder (http://sphinx-doc.org).
#
# docker build -t ddidier/ndd-docker-sphinx .

FROM  debian:8.1
MAINTAINER David DIDIER

RUN   apt-get update

RUN   DEBIAN_FRONTEND=noninteractive apt-get install -y python-pip
RUN   DEBIAN_FRONTEND=noninteractive apt-get install -y texlive-latex-recommended texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended

RUN   pip install 'Sphinx >= 1.3.0, < 1.4.0'
RUN   pip install 'alabaster'
RUN   pip install 'sphinx_bootstrap_theme'
RUN   pip install 'sphinx_rtd_theme'

VOLUME /doc

WORKDIR /doc

CMD ["/bin/bash"]
