## Offshore wind farm development alters food web structure and carbon flows: insights from a 14-year data-driven study

  <img src="Icon.png" alt="OWF Icon" width="180" style="vertical-align:middle; margin-right:12px;"/> 

This repository contains the code and data used in the manuscript **"Offshore wind farm development alters food web structure and carbon flows: insights from a 14-year data-driven study**. It includes RMarkdown scripts, input files, and functions used to reproduce all results presented in the paper.

### 📁 Repository Structure

| File or Folder             | Description                                                                         |
|----------------------------|-------------------------------------------------------------------------------------|
| `functions/`               | Custom R functions used in the Rcode                                                |
| `Input_files_LIM/`         | Input files for Linear Inverse Modelling (LIM), stocks and compartment data         |
| `Results_sample_LIM/`      | Results form the LIM model runs as Rdata files                                      |
| `Topological_files/`       | Pred-prey matrices, data for topological food webs and species topological roles    |
| `LIM_analysis.Rmd`         | Code for LIM-based quantitative food web analysis                                   |
| `Topological_analysis.Rmd` | Code for qualitative food web analysis and individual topological roles             |
| `code.Rproj`               | RStudio project file                                                                |
| `LICENSE`                  | License for use                                                                     |
| `README.md`                | This file                                                                           |

Please read the Materials and Methods section of the article and references therein to understand the models.

### 📦 Code Archive

This repository is archived on Zenodo: [![DOI](badge-link)](https://doi.org/10.5281/zenodo.XXXXXXX)
To reproduce the analyses, open `code.Rproj` in RStudio, then run:
`LIM_analysis.Rmd` — quantitative food web analysis (Linear Inverse Modelling)
`Topological_analysis.Rmd` — qualitative food web analysis and topological roles

### 📖 Citation

If you use this code or data, please cite both the paper and the code archive:

**Paper:** Reynés-Cardona, A., De Borger, E., Vanaverbeke, J., Marina, T.I., Buyse, J., Braeckman, U. (2026). Offshore wind farm development alters food web structure and carbon flows: insights from a 14-year data-driven study. Ecological Indicators. DOI: [to be added upon publication]

**Code archive:** Reynés-Cardona, A. et al. (2026). Code and data for: Offshore wind farm development alters food web structure and carbon flows [Software/Data]. Zenodo. DOI: https://doi.org/10.5281/zenodo.22254096 

### License

This project is licensed under the GPL-3.0 License — see the LICENSE file for details.

---

#### Please contact Abril Reynés Cardona - abril.reynescardona@ugent.be for any issue or remark.

