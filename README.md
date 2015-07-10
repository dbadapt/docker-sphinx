# NDD Docker Sphinx

A Docker image for the [Sphinx documentation](http://sphinx-doc.org) builder.

The image is based upon `Debian 8.1` and contains:

- The Sphinx documentation builder
- The LaTeX library
- The recommended [HTML themes](http://docs.writethedocs.org/tools/sphinx-themes)



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

```
docker run -i -t -v <HOST_DOC_DIR>:/doc ndd-docker-sphinx
```

You should now be in the `/doc` directory, otherwise just `cd /doc`.

To create a new Sphinx project, call `sphinx-quickstart`.

To create a PDF document, call `make latexpdf`.

To create a HTML document, call `make html`.



## Acknowledgments

Forked from [headstar/sphinx-doc-docker](https://github.com/headstar/sphinx-doc-docker). Thank you!
