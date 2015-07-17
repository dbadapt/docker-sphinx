# NDD Docker Sphinx

A Docker image for the [Sphinx documentation](http://sphinx-doc.org) builder.

The image is based upon [envygeeks/ubuntu](https://github.com/envygeeks/docker-ubuntu) which is an `Ubuntu 15.04`.

The image contains:

- The Sphinx documentation builder ([sphinx-doc](http://sphinx-doc.org))
- The Sphinx documentation watcher ([sphinx-autobuild](https://github.com/GaretJax/sphinx-autobuild))
- The Sphinx documentation themes ([sphinx-themes](http://docs.writethedocs.org/tools/sphinx-themes))
- A reStructuredText to PDF converter ([rst2pdf](https://github.com/rst2pdf/rst2pdf))



## Installation

### From source

```
git clone https://ddidier@bitbucket.org/ndd-docker/ndd-docker-sphinx.git
cd ndd-docker-sphinx
docker build -t ddidier/ndd-docker-sphinx .
```

### From Docker Hub

```
docker pull ddidier/ndd-docker-sphinx
```



## Usage

The documentation directory must be mounted as a volume under `/doc`:

### Interactive

```
docker run -i -t -v <HOST_DOC_DIR>:/doc ddidier/ndd-docker-sphinx
```

You should now be in the `/doc` directory, otherwise just `cd` to `/doc`.

To create a new Sphinx project, call `sphinx-init`.

To create HTML documents, call `make html`.

To create a PDF document, call `make pdf`.

To watch changes and create HTML documents, call `make livehtml`.

### Non interactive

```
docker run -i -v <HOST_DOC_DIR>:/doc ddidier/ndd-docker-sphinx make html
docker run -i -v <HOST_DOC_DIR>:/doc ddidier/ndd-docker-sphinx make pdf
```
