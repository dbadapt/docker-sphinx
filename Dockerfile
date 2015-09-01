#
# ddidier/ndd-docker-sphinx
#
# A Docker image for the Sphinx documentation builder (http://sphinx-doc.org).
#
# docker build -t ddidier/ndd-docker-sphinx .

FROM       python:2.7
MAINTAINER David DIDIER

RUN echo "deb     http://httpredir.debian.org/debian jessie contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends sudo

RUN pip install 'Sphinx                 == 1.3.1' \
                'alabaster              == 0.7.6' \
                'rst2pdf                == 0.93 ' \
                'sphinx-autobuild       == 0.5.2' \
                'sphinx_bootstrap_theme == 0.4.7' \
                'sphinx-prompt          == 1.0.0' \
                'sphinx_rtd_theme       == 0.1.8'

COPY files/usr/local/bin/* /usr/local/bin/
COPY files/etc/sudoers.d/* /etc/sudoers.d/

RUN useradd sphinx-doc && \
    chown root:root /etc/sudoers.d/* && \
    chmod 440 /etc/sudoers.d/*

ENV DOC_DIR /doc

VOLUME $DOC_DIR

WORKDIR $DOC_DIR

USER sphinx-doc

ENTRYPOINT ["/usr/local/bin/sphinx-startup"]
