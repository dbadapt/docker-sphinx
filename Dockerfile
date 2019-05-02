#
# ddidier/sphinx-doc
#
# A Docker image for the Sphinx documentation builder (http://sphinx-doc.org).
#
# docker build -t ddidier/sphinx-doc .

FROM       python:2.7.16-slim-stretch
MAINTAINER David DIDIER

RUN mkdir -p /usr/share/man/man1 \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        gosu sudo \
        curl make \
        dvipng graphviz \
        openjdk-8-jre-headless \
        latexmk texlive-fonts-recommended texlive-latex-extra texlive-latex-recommended \
        texlive-lang-french \
        git \
        wget \
    \
 && apt-get autoremove -y \
 && rm -rf /var/cache/* \
 && rm -rf /var/lib/apt/lists/*
 \
RUN pip install --upgrade pip \
 && pip install 'Sphinx                        == 1.5.6'  \
                'alabaster                     == 0.7.12' \
                'recommonmark                  == 0.5.0'  \
                'sphinx-autobuild              == 0.7.1'  \
                'sphinx_bootstrap_theme        == 0.7.1' \
                'sphinx-prompt                 == 1.1.0'  \
                'sphinx_rtd_theme              == 0.4.3'  \
                'sphinxcontrib-actdiag         == 0.8.5'  \
                'sphinxcontrib-blockdiag       == 1.5.5'  \
                'sphinxcontrib-exceltable      == 0.2.2'  \
                'sphinxcontrib-googleanalytics == 0.1'    \
                'sphinxcontrib-googlechart     == 0.2.1'  \
                'sphinxcontrib-googlemaps      == 0.1.0'  \
                'sphinxcontrib-nwdiag          == 0.9.5'  \
                'sphinxcontrib-plantuml        == 0.15'  \
                'sphinxcontrib-seqdiag         == 0.8.5'  \
                'livereload                    == 2.5.1'

COPY files/opt/plantuml/*  /opt/plantuml/
COPY files/usr/local/bin/* /usr/local/bin/

RUN chown root:root /usr/local/bin/* \
 && chmod 755 /usr/local/bin/*

ENV DATA_DIR=/doc

WORKDIR $DATA_DIR

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
