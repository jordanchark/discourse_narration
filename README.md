# Discourse structure and the reorganisation of the Icelandic aspectual system
Last Updated: December 2024

## Overview
This repository contains the files necessary to reproduce analyses in the paper titled "Discourse structure and the reorganisation of the Icelandic aspectual system" by Jordan Chark. To appear in Ulrike Demske (ed.), Discourse structure and narration: A diachronic view from Germanic. Berlin: Language Science Press.

## Directory Structure
All full data files for analysis are located in the `/data` directory:
```
repo/
├── README.txt
└── data/
    ├── buinn_all.csv
    ├── progpost.csv
    ├── merged_data.csv
    ├── buinn_tense_filtered.csv
    ├── buinn_tense_agg.csv
    ├── progpost_agg.csv
    ├── progpost_agg2.csv
    ├── subset_merged_data.csv
    ├── temporal_subordinate_combined.csv
    ├── temporal_subordinate_narrative.csv
    ├── temporal_subordinate_filtered.csv
    ├── andi_all.csv
    ├── andi_filtered.csv
    ├── subject_position_filtered.csv
    ├── subject_position_narrative.csv
    └── model_results.md
```
## Dataset Descriptions

### 1. Búinn and Progressive
#### Core Data Files
- **buinn_all.csv**: Processed búinn construction data
  - Contains relative frequencies, genre information, and temporal data
  - Key columns: textid, year, genre, hits, total, relative_frequency

- **progpost.csv**: Raw progressive construction data
  - Contains base annotations of progressive constructions
  - Key columns: textid, year, genre, tense, label

#### Processed Analysis Files
- **buinn_tense_filtered.csv**: Filtered búinn data by tense
- **buinn_tense_agg.csv**: Aggregated búinn data by century
- **progpost_agg.csv**: Aggregated progressive data by text
- **progpost_agg2.csv**: Aggregated progressive data by century
- **merged_data.csv**: Combined analysis data
- **subset_merged_data.csv**: Filtered merged data

### 2. Temporal Subordinate Analysis
- **temporal_subordinate_combined.csv**: Combined dataset of temporal subordinate clauses
  - Key variables: year, text, t.T, total_rT, relative_frequency, Genre
- **temporal_subordinate_narrative.csv**: Subset for narrative texts only
- **temporal_subordinate_filtered.csv**: Time-filtered dataset (1540-1900)

### 3. -andi Participle Analysis
- **andi_all.csv**: Complete dataset of -andi participle occurrences
  - Key variables: year, hits, total, relative_frequency, simplified_genre
- **andi_filtered.csv**: Filtered dataset excluding pseudo-historical texts

### 4. þegar vs. þá Analysis
- **thegar_tha_combined.csv**: Analysis of temporal conjunctions
- **thegar_tha_predictions.csv**: Model predictions for diachronic development

### 5. Tail Linking Analysis
Note: File names retain "subject_position" for compatibility with existing scripts and analyses
- **subject_position_filtered.csv**: Post-New Testament data for tail linking analysis
  - Key variables: Year, Text, Genre, XP-V-subjtopic %
- **subject_position_narrative.csv**: Narrative-specific subset for tail linking analysis

## Variable Coding and Classifications

### Genre Classifications
- `nar`: Narrative texts
- `rel`: Religious texts
- `sci`: Scientific texts
- `law`: Legal texts

### Tense Categories
- `PRS`: Present tense
- `PST`: Past tense
- `PRS-SBJ`: Present subjunctive
- `PST-SBJ`: Past subjunctive
- `INF`: Infinitive

### Clause Types
- `IP-MAT`: Matrix clauses
- `IP-SUB`: Subordinate clauses
- `IP-INF`: Infinitival clauses

## Data Collection and Processing
- Source: Icelandic Parsed Historical Corpus (IcePaHC)
- Time period: 1150-2008
- Processing: R version 4.x
- Key packages: dplyr, ggplot2, viridis, ggrepel

## Source Files
- summarythaprevb.txt
- summarythegar.txt
- pplandi.txt
- complete_data.csv (tail linking analysis source data)
- icepahc_allptcp.csv
- infbuinnsum.txt

## Usage Notes
1. Relative frequencies are calculated per 100 tokens unless otherwise specified
2. Year values are standardized for statistical analysis
3. Genre classifications follow IcePaHC conventions
4. Missing values are coded as `NA`
5. Datasets with 'filtered' in their names have specific exclusion criteria

## Scripts
All scripts include data processing steps and are provided for reproduction:
- buinn_analysis.R
- progressive_analysis.R
- data_export.R
- Temporal subordinate analysis script
- BÚINN/PROG correlation analysis script
- -andi participle analysis script
- þegar/þá temporal conjunction analysis script
- Tail linking analysis script

## Version History
- v1.0.0 (2024-12-17): Initial release

## Citation
Chark, Jordan. Discourse structure and the reorganisation of the Icelandic aspectual system. To appear in Ulrike Demske (ed.), Discourse structure and narration: A diachronic view from Germanic. Berlin: Language Science Press.

## License
Creative Commons Zero v1.0 Universal

## Contact
Jordan Chark: jordan.chark@gmail.com (Current affiliation: Humboldt-Universität zu Berlin)

## Acknowledgments
Wallenberg, Joel C., Anton Karl Ingason, Einar Freyr Sigurðsson and Eiríkur Rögnvaldsson. 2011. 
Icelandic Parsed Historical Corpus (IcePaHC). Version 0.9. http://www.linguist.is/icelandic_treebank
