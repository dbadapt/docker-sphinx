#
# ddidier/sphinx-doc
#
# A Docker image for the Sphinx documentation builder (http://sphinx-doc.org).
#
# docker build -t ddidier/sphinx-doc .

FROM       python:3.6.6-slim-stretch
MAINTAINER David DIDIER

# OpenJDK installation issue
# - https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
# - mkdir -p /usr/share/man/man1

RUN mkdir -p /usr/share/man/man1 \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        gosu sudo \
        curl make \
        dvipng graphviz \
        openjdk-8-jre-headless \
        texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra latexmk \
    \
 && PLANTUML_VERSION=1.2018.11 \
 && mkdir /opt/plantuml \
 && curl https://netix.dl.sourceforge.net/project/plantuml/${PLANTUML_VERSION}/plantuml.${PLANTUML_VERSION}.jar --output /opt/plantuml/plantuml.${PLANTUML_VERSION}.jar \
 && ln -s /opt/plantuml/plantuml.${PLANTUML_VERSION}.jar /opt/plantuml/plantuml.jar \
    \
 && pip install 'Sphinx                        == 1.8.1'    \
                'alabaster                     == 0.7.11'   \
                'guzzle_sphinx_theme           == 0.7.11'   \
                'livereload                    == 2.5.2'    \
                'recommonmark                  == 0.4.0'    \
                'rinohtype                     == 0.2.1'    \
                'sphinx-autobuild              == 0.7.1'    \
                'sphinx_bootstrap_theme        == 0.6.5'    \
                'sphinx-prompt                 == 1.0.0'    \
                'sphinx_rtd_theme              == 0.4.1'    \
                'sphinxcontrib-actdiag         == 0.8.5'    \
                'sphinxcontrib-blockdiag       == 1.5.5'    \
                'sphinxcontrib-excel-table     == 1.0.4'    \
                'sphinxcontrib-fulltoc         == 1.2.0'    \
                'sphinxcontrib-googleanalytics == 0.1'      \
                'sphinxcontrib-googlechart     == 0.2.1'    \
                'sphinxcontrib-googlemaps      == 0.1.0'    \
                'sphinxcontrib-nwdiag          == 0.9.5'    \
                'sphinxcontrib-plantuml        == 0.12'     \
                'sphinxcontrib-seqdiag         == 0.8.5'    \
    \
 && apt-get autoremove -y \
 && rm -rf /var/cache/* \
 && rm -rf /var/lib/apt/lists/*

COPY files/usr/local/bin/*     /usr/local/bin/
COPY files/usr/share/ddidier/* /usr/share/ddidier/

RUN chown root:root /usr/local/bin/* \
 && chmod 755 /usr/local/bin/*

ENV DATA_DIR=/doc

WORKDIR $DATA_DIR

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
