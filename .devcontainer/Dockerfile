# Dev container Dockerfile for Quarto + TinyTeX + Python
FROM r-base:latest

# Base deps and Quarto CLI
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
                ghostscript \
                lmodern \
                qpdf \
                wget \
                curl \
                ca-certificates \
                python3 \
                python3-pip \
                git \
                make \
    && ARCH=$(dpkg --print-architecture) \
    && curl -L https://quarto.org/download/latest/quarto-linux-${ARCH}.deb -o quarto.deb \
    && apt-get install -y ./quarto.deb \
    && rm quarto.deb

# R side packages for knitr + TinyTeX
RUN apt-get install -y --no-install-recommends \
                r-cran-formatr \
                r-cran-ggplot2 \
                r-cran-knitr \
		        r-cran-rmarkdown \
                r-cran-reticulate \
                r-cran-tinytex \
        && cd /usr/local/bin \
        && ln -s /usr/lib/R/site-library/littler/examples/render.r .

# uv (fast Python installer)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# TinyTeX
RUN R -e "tinytex::install_tinytex()" \
        && /root/.TinyTeX/bin/*/tlmgr path add

# PATH for TinyTeX
ENV PATH="/root/.TinyTeX/bin/x86_64-linux:/root/.TinyTeX/bin/aarch64-linux:${PATH}"

# Preinstall LaTeX packages used by the template (minted omitted)
RUN /root/.TinyTeX/bin/*/tlmgr install \
        fontspec \
        unicode-math \
        titlesec \
        geometry \
        setspace \
        microtype \
        enumitem \
        booktabs \
        caption \
        csquotes \
        xcolor \
        hyperref \
        bookmark \
        libertinus-type1 \
        lm-math \
        upquote \
        framed \
        fancyvrb

# Disable on-the-fly installs at render time
ENV TEXLIVE_DISABLE_AUTO_INSTALL=1

# Default workdir gets overridden by devcontainer.json workspaceFolder
WORKDIR /workspaces
