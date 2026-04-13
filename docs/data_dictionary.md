# Data Dictionary

## Dataset: School Dropout and Flow Rates - Brazil

### Source
INEP - Indicadores Educacionais: Taxas de Transição (2021–2022)

---

## Identification Variables

- `REGIAO`: Brazilian region  
- `UF`: State  
- `COD_MUNIC`: Municipality code  
- `MUNIC`: Municipality name  
- `AREA`: School location (urban or rural)  
- `DEPENDENCIA`: Administrative dependency (public or private)  

---

## Educational Indicators

### Promotion Rate (TPROM)
- Proportion of students who progressed to the next grade

Examples:
- `TPROM_EF`: Promotion rate in Elementary School  
- `TPROM_EFAI`: Promotion rate in Elementary School – Early Years  
- `TPROM_EFAF`: Promotion rate in Elementary School – Final Years  
- `TPROM_EM`: Promotion rate in High School  
- `TPROM_EF1`–`TPROM_EF9`: Promotion rate by grade (1st to 9th year of Elementary School)  
- `TPROM_EM1`–`TPROM_EM3`: Promotion rate by grade (1st to 3rd year of High School)  

---

### Repetition Rate (TREP)
- Proportion of students who failed and repeated the grade

Examples:
- `TREP_EF`: Repetition rate in Elementary School  
- `TREP_EFAI`: Repetition rate in Elementary School – Early Years  
- `TREP_EFAF`: Repetition rate in Elementary School – Final Years  
- `TREP_EM`: Repetition rate in High School  
- `TREP_EF1`–`TREP_EF9`: Repetition rate by grade (1st to 9th year of Elementary School)  
- `TREP_EM1`–`TREP_EM3`: Repetition rate by grade (1st to 3rd year of High School)  

---

### Dropout Rate (TEV)
- Proportion of students who abandoned school

Examples:
- `TEV_EF`: Dropout rate in Elementary School  
- `TEV_EFAI`: Dropout rate in Elementary School – Early Years  
- `TEV_EFAF`: Dropout rate in Elementary School – Final Years  
- `TEV_EM`: Dropout rate in High School  
- `TEV_EF1`–`TEV_EF9`: Dropout rate by grade (1st to 9th year of Elementary School)  
- `TEV_EM1`–`TEV_EM3`: Dropout rate by grade (1st to 3rd year of High School)  

---

## Notes

- All indicators are expressed as percentages (%)  
- Data is aggregated at the municipal level  
- Indicators allow comparisons across:
  - Regions  
  - School administrative dependency (public vs private)  
  - School location (urban vs rural)  