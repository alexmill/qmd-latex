
# A/B Testing Document Pipeline

This repository contains two document pipelines:

## 1. Legacy R/LaTeX Pipeline (main.Rtex)

### Build image
```bash
docker build -t ab .
```

### Run container
```bash
docker run -v $(pwd):/home/document -it ab bash
```

### Compile document
```bash
docker run --rm -v $(pwd):/home/document ab bash -c "Rscript -e \"knitr::knit2pdf('main.Rtex')\""
```

---

## 2. Quarto → LaTeX/PDF Pipeline (quarto-project/)

This is the recommended modern pipeline using Quarto with TinyTeX.

### Build the Quarto Docker image
```bash
docker build -f Dockerfile.quarto -t ab-quarto .
```

### Run the container interactively
```bash
docker run -v $(pwd):/home/document -it ab-quarto bash
```

Inside the container, you can then run:
```bash
cd quarto-project
make pdf
# or
quarto render examples/sample.qmd
```

### One-line render (without entering container)
```bash
docker run --rm -v $(pwd):/home/document ab-quarto bash -c "cd /home/document && make -C quarto-project pdf"
```

### Render the minimal working example
```bash
docker run --rm -v $(pwd):/home/document ab-quarto bash -c "cd /home/document && quarto render quarto-project/mwe.qmd --to pdf"
```

### Open in VS Code Dev Container (auto-render on save)

This repo includes a `.devcontainer` configuration. When you open the folder in VS Code and choose "Reopen in Container", it will:

- Provision Quarto, TinyTeX, Python, and R in the container
- Install the VS Code extensions: Quarto and Python
- Automatically render the current `.qmd` to PDF on save using the Quarto extension

Notes:
- On save, the Quarto extension runs `quarto render <current-file> --to pdf` inside the container.
- Rendering is handled by the Quarto extension
- Generated artifacts like `_build/`, `_freeze/`, and `*_files/` are excluded from file watching for performance.

### What's included in the Quarto pipeline:
- **Quarto CLI**: Markdown → LaTeX → PDF rendering
- **TinyTeX**: Lightweight LaTeX distribution with xelatex
- **Python support**: Execute Python code chunks (pandas, matplotlib, numpy)
- **R support**: Execute R code chunks (knitr)
- **Custom LaTeX**: Full control via templates and raw LaTeX passthrough
- **Minted**: Syntax highlighting for code blocks
- **Custom fonts**: Libertinus Serif, Libertinus Math

See `quarto-project/README.md` for detailed documentation.