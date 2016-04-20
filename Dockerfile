#
# ddidier/ndd-docker-sphinx
#
# A Docker image for the Sphinx documentation builder (http://sphinx-doc.org).
#
# docker build -t ddidier/ndd-docker-sphinx .

FROM       python:2.7
MAINTAINER David DIDIER

RUN echo "deb     http://httpredir.debian.org/debian jessie contrib non-free"   >> /etc/apt/sources.list                         && \
    echo "deb-src http://httpredir.debian.org/debian jessie contrib non-free"   >> /etc/apt/sources.list                         && \
    echo "deb     http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections                && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886                                                   && \
    apt-get update                                                                                                               && \
    apt-get install -y --no-install-recommends graphviz oracle-java8-installer sudo                                              && \
    apt-get autoremove -y                                                                                                        && \
    rm -rf /var/cache/*                                                                                                          && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install 'Sphinx                        == 1.3.6' \
                'alabaster                     == 0.7.7' \
                'recommonmark                  == 0.4.0' \
                'rst2pdf                       == 0.93 ' \
                'sphinx-autobuild              == 0.6.0' \
                'sphinx_bootstrap_theme        == 0.4.9' \
                'sphinx-prompt                 == 1.0.0' \
                'sphinx_rtd_theme              == 0.1.9' \
                'sphinxcontrib-actdiag         == 0.8.5' \
                'sphinxcontrib-blockdiag       == 1.5.5' \
                'sphinxcontrib-exceltable      == 0.2.2' \
                'sphinxcontrib-googleanalytics == 0.1'   \
                'sphinxcontrib-googlechart     == 0.2.1' \
                'sphinxcontrib-googlemaps      == 0.1.0' \
                'sphinxcontrib-libreoffice     == 0.2'   \
                'sphinxcontrib-nwdiag          == 0.9.5' \
                'sphinxcontrib-plantuml        == 0.7'   \
                'sphinxcontrib-seqdiag         == 0.8.5' \
                'livereload                    == 2.4.1'

COPY files/usr/local/bin/* /usr/local/bin/
COPY files/opt/plantuml/*  /opt/plantuml/
COPY files/etc/sudoers.d/* /etc/sudoers.d/

RUN useradd sphinx-doc && \
    chown root:root /etc/sudoers.d/* && \
    chmod 440 /etc/sudoers.d/*

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ENV DOC_DIR /doc

VOLUME $DOC_DIR

WORKDIR $DOC_DIR

USER sphinx-doc

ENTRYPOINT ["/usr/local/bin/sphinx-startup"]
