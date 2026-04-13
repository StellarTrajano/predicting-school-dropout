# Data Processing

## Raw Data Issues

The original dataset obtained from INEP required preprocessing due to structural inconsistencies:

- Presence of headers and titles not aligned with tabular format  
- Embedded images in the spreadsheet  
- Merged cells, which prevented proper data import into R  
- Non-standard formatting across columns  

---

## Cleaning Steps

The following steps were performed in Excel before importing the data into R:

1. Removed non-data elements:
   - Titles
   - Headers outside the main table
   - Images

2. Unmerged cells:
   - Ensured each observation occupied a single row
   - Ensured each variable occupied a single column

3. Restructured the dataset:
   - Standardized column names
   - Created consistent variable naming (e.g., TPROM, TREP, TEV)
   - Ensured alignment of values across rows

---

## Final Dataset

After preprocessing:

- Each row represents a municipality  
- Each column represents an educational indicator or attribute  
- The dataset is structured in a tabular format suitable for analysis in R  

---

## Notes

- Initial cleaning was performed manually in Excel due to formatting issues  
- Further transformations and analysis are conducted in R scripts