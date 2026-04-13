![R](https://img.shields.io/badge/language-R-blue)
![Status](https://img.shields.io/badge/status-in%20progress-yellow)

# Predicting School Dropout in Brazil

## Objective
This project aims to analyze and predict school dropout rates across Brazilian municipalities, considering:
- Urban vs Rural location
- Public vs Private schools
- Regional differences

## Data Source

The dataset was obtained from the Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira (Inep), through the Open Data Portal, specifically from:

**Indicadores Educacionais: Taxas de Transição (2021–2022)**

The data contains information at the municipal level, including school characteristics and student outcomes.

---

## Key Variables

### Target Variables
- `TEV_EF`: Dropout rate in Elementary School
- `TEV_EM`: Dropout rate in High School

### School Flow Indicators
- `TPROM_EF`: Promotion rate
- `TREP_EF`: Repetition rate

### School Characteristics
- `AREA`: Urban or rural
- `DEPENDENCIA`: Public or private

### Geographic Information
- `REGIAO`: Region of Brazil
- `UF`: State
- `COD_MUNIC`: Municipality code

## Methodology

* Data cleaning and preprocessing
* Exploratory data analysis (EDA)
* Modeling (to be defined)

## Project Structure

This repository is organized as follows:

```bash
data/
  ├── raw/        # original datasets
  └── processed/  # cleaned datasets

scripts/
  ├── 01_data_cleaning.R
  ├── 02_eda.R
  └── 03_modeling.R

outputs/
  ├── tables/
  └── figures/

docs/             # reports and documentation
```
## 📄 Documentation

- [Data Dictionary](docs/data_dictionary.md)

## Tools

* R
* tidyverse
* dplyr

## Future Steps

* Regional modeling
* Capital vs non-capital comparison
* Machine learning models
