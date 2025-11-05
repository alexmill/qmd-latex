# Quarto to LaTeX/PDF Authoring Pipeline

This repository provides a complete, reproducible pipeline for authoring documents in Quarto Markdown (`.qmd`) and rendering them to high-quality PDFs via LaTeX. It is designed for technical and academic writing, with a focus on customization, automation, and typographic quality.

## Features

- **Quarto First**: Uses Quarto as the primary rendering engine.
- **LaTeX Backend**: Renders PDFs via `xelatex` for full Unicode and font support.
- **TinyTeX Integration**: Designed to work seamlessly with a local TinyTeX installation.
- **Custom Theming**: Includes a custom LaTeX template and header for styling:
  - Fonts, page geometry, and line spacing.
  - Professional section and subsection titles.
    - Numbered theorem, lemma, definition, and proof environments.
    - Fast, built-in syntax highlighting (Pandoc highlighting macros; no minted).
- **Code Execution**: Supports executing code chunks in both **Python** and **R**.
- **Raw LaTeX**: Passthrough supported via native Pandoc syntax (`{=latex}`) for raw blocks.
- **Automation**: Comes with a `Makefile` and a `render.sh` script for easy, one-command builds.
- **CI/CD Ready**: Includes a sample GitHub Actions workflow to automate builds and testing.

## Project Structure

```
.
├─ _quarto.yml         # Main project configuration
├─ template/
│  ├─ template.tex     # Core LaTeX template (Pandoc variables)
│  └─ header.tex       # Preamble with custom styles and packages
├─ filters/                # (unused – native raw LaTeX used)
├─ examples/
│  ├─ sample.qmd       # Example document showcasing all features
│  └─ data.csv         # Sample data for code chunks
├─ scripts/
│  ├─ render.sh        # Main build script (POSIX compliant)
│  └─ detect-tex.sh    # Helper to find TeX distribution
├─ Makefile            # Makefile for common tasks (pdf, clean, check)
└─ README.md           # This file
```

## Prerequisites

1.  **Quarto**: You must have Quarto installed. Get it from [quarto.org](https://quarto.org/docs/get-started/).
2.  **TinyTeX**: A lightweight, portable TeX distribution. Install it via R or the command line:
    ```sh
    # Using R
    install.packages('tinytex')
    tinytex::install_tinytex()

    # Or via shell script (macOS/Linux)
    wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh
    ```
3.  **LaTeX Packages**: The template requires a few extra packages. Install them using TinyTeX's manager, `tlmgr`:
    ```sh
    tlmgr install libertinus-type1 lm-math fontspec titlesec unicode-math fancyvrb framed xcolor hyperref bookmark microtype enumitem geometry setspace caption csquotes booktabs
    ```
    The `check` command in the Makefile can help identify missing packages.

4.  **Python & R**: To execute code chunks, you need Python (with `matplotlib`, `pandas`) and R (with `knitr`) installed.

## How to Use

### Using the Makefile (Recommended)

The `Makefile` provides the simplest interface.

1.  **Check Dependencies**:
    ```sh
    make check
    ```
    This command verifies that Quarto, TinyTeX, and required LaTeX packages are installed.

2.  **Build the PDF**:
    ```sh
    make pdf
    ```
    This will render `examples/sample.qmd` and place the output in `_build/examples/sample.pdf`.

3.  **Clean Up**:
    ```sh
    make clean
    ```
    This removes all generated files, including the `_build` directory, logs, and other intermediate files.

### Using the Render Script

If you don't have `make`, you can use the `render.sh` script directly.

```sh
./scripts/render.sh examples/sample.qmd
```

The script will automatically detect your Quarto and TeX installations and render the document.

## Customization

-   **Project-wide Settings**: Modify `_quarto.yml` to change default settings like fonts, document class, code execution options, and more.
-   **LaTeX Preamble**: Add or modify LaTeX packages, commands, and environments in `template/header.tex`.
-   **LaTeX Template**: For advanced structural changes, edit `template/template.tex`. This file controls the overall document structure using Pandoc's template variables.

## Troubleshooting

-   No `minted` dependency: Code highlighting uses Pandoc's built-in macros, so `-shell-escape` is not required.

-   **Font Not Found**: If you get an error like `fontspec error: "font-not-found"`, make sure the font specified in `_quarto.yml` (e.g., `Libertinus Serif`) is installed on your system or accessible to `xelatex`.

-   **Package Not Found**: If the LaTeX build fails with an error like `! LaTeX Error: File 'somepackage.sty' not found.`, install it with `tlmgr`:
    ```sh
    tlmgr install somepackage
    ```
