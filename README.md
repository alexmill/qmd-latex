
<div align="center">
<h1>Quarto → LaTeX/PDF Authoring</h1>
<strong>Minimal, reproducible pipeline for writing technical documents in Quarto and producing high‑quality PDFs with a custom LaTeX template.</strong>
</div>

## Quick Start (Dev Container Recommended)

1. Clone:
	```bash
	git clone https://github.com/alexmill/qmd-latex.git
	cd qmd-latex
	```
2. Open the folder in VS Code. When prompted, choose: Reopen in Container (or run from the Command Palette: "Dev Containers: Reopen in Container").
3. Wait for build (installs Quarto, TinyTeX, Python, R; extensions: Quarto + Python).  
4. Open or create a `.qmd` under `document/` (e.g. `document/mwe.qmd`).
5. Save the file. It auto-renders to PDF (thanks to workspace settings). Output goes into `_build/` preserving relative paths (e.g. `_build/document/mwe.pdf`).
6. View the PDF either via the Quarto sidebar, file explorer, or external viewer.

## Editing & Dependencies

| Task | Where | Notes |
|------|-------|-------|
| Add Python libs | `document/requirements.txt` | On change: rebuild container or run install command below |
| Add R packages | dev container terminal | Install via `R -e "install.packages('pkg')"` |
| Adjust LaTeX styling | `document/template/header.tex` & `document/template/template.tex` | Header: packages & macros; Template: structure |
| Project-wide defaults | `document/_quarto.yml` | Output dir, fonts, engine, render targets |
| Example source | `document/examples/sample.qmd` | Demonstrates features |

Install updated Python deps inside the running container:
```bash
uv pip install --system --break-system-packages -r document/requirements.txt
```

## Manual Rendering (Optional)

Inside container:
```bash
quarto render document/mwe.qmd --to pdf
```
Using the Makefile conveniences (renders sample):
```bash
make -C document pdf   # builds examples/sample.qmd → _build/examples/sample.pdf
```

## Auto-Render Behavior

Configured in `.devcontainer/devcontainer.json` and `.vscode/settings.json`:
```jsonc
"quarto.render.onSave": "current",
"quarto.render.targetFormat": "pdf"
```
So every save of the active `.qmd` triggers a PDF build via the Quarto extension. For portability the same settings are checked into the repo.

## Updating Tooling

- Rebuild container after major changes to `devcontainer.json` or system dependencies: Command Palette → "Dev Containers: Rebuild Container".
- If LaTeX complains about missing packages, install with `tlmgr install <pkg>` (auto-install is disabled for reproducibility). For emoji output ensure the apt package `fonts-noto-color-emoji` is installed (it is in the dev container) and use `\emoji{😀}` in your `.qmd`; if the font is missing the glyph falls back gracefully.

## Legacy Pipeline (Optional / Deprecated)

The older R/LaTeX `.Rtex` workflow remains (file `main.Rtex`) but Quarto is the recommended path. You can safely ignore it unless migrating old sources.

## Troubleshooting

- No auto-render? Ensure the Quarto extension is installed; reopen folder in container; check Settings for the two Quarto keys above.
- Font errors (`fontspec`): confirm fonts specified in `_quarto.yml` exist. Libertinus now comes via TeX Live (`tlmgr install libertinus`) rather than a system apt font package.
- Python import errors: add package to `document/requirements.txt`, reinstall with `uv pip install ...`.
- R chunk failures: ensure required R packages are installed in the container.

## See Also

Detailed feature documentation lives in `document/README.md`.

---
Enjoy writing! Save often; the PDF will always be fresh.