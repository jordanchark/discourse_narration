# Discourse structure and the reorganisation of the Icelandic aspectual system
Last Updated: December 2024

## Overview
This repository contains the files necessary to reproduce analyses in the paper titled "Discourse structure and the reorganisation of the Icelandic aspectual system" by Jordan Chark. To appear in Ulrike Demske (ed.), Discourse structure and narration: A diachronic view from Germanic. Berlin: Language Science Press.

## Directory Structure
All full processed data files for analysis are located in the `/data` folder. Unprocessed files are in the main folder. Scripts can be run in RStudio by selecting the option to set the working directory to the data folder.
```
repo/
├── README.txt
└── data/
    ├── buinn_all.csv
    ├── progpost.csv
    ├── merged_data.csv
    ├── buinn_tense_filtered.csv
    ├── buinn_tense_agg.csv
    ├── fornrit_buinn.csv
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
    ├── model_results.md
    ├── 161718.csv
    ├── icepahc_1900.csv
    ├── 1920_progcolfix.csv
```
## Dataset Descriptions

### 1. Búinn and Progressive (Descriptive analysis)
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
- **fornrit_buinn.csv**: Búinn in Fornrit subcorpus of Íslenskt textasafn (frequency of infinitival complement)

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
- **subject_position_filtered.csv**: Post-New Testament data for tail linking analysis
  - Key variables: Year, Text, Genre, XP-V-subjtopic %
- **subject_position_narrative.csv**: Narrative-specific subset for tail linking analysis

### 6. Collocational analysis
- **161718.csv**: búinn in Íslenskt textasafn (16th-18th century subcorpus) (for collocating adverbials)
- **icepahc_1900.csv**: búinn in IcePAHC (for collocating adverbials)
- **1920_progcolfix.csv**: PROG in IcePAHC (for collocating adverbials)

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

## Source Files in main folder (Require further processing)
- summarythaprevb.txt (foregrounding, pre-verbal þá in IcePAHC)
- summarytha.txt (subordinating þá in IcePAHC)
- summarythegar.txt (þegar in IcePAHC)
- pplandi.txt (participle -andi in IcePAHC)
- complete_data.csv (tail linking analysis source data, summary of IcePAHC query)
- infbuinnsum.txt (búinn construction in IcePAHC)

## Usage Notes
1. Relative frequencies are calculated per 100 tokens unless otherwise specified
2. Year values are standardized for statistical analysis
3. Genre classifications follow IcePaHC conventions
4. Missing values are coded as `NA`
5. Datasets with 'filtered' in their names have specific exclusion criteria

## Scripts
All scripts include data processing steps and are provided for reproduction.
- buinn_timecourse_IcePAHC.R -- descriptive time-course analysis of the búinn construction in IcePAHC
- corr_buinn_prog.R -- correlation between búinn and PROG in IcePAHC
- corr_foregroundingtha_subordinating_thegar.R - correlation between foregrounding þá and subordinating þegar in IcePAHC
- collocation_script.R - frequency of associated adverbials 
- icepahc_pres_past_buinn_descr.R - descriptive búinn/hafa alternation data from IcePAHC
- prog_descriptive.R -- descriptive analysis of PROG in IcePAHC
- prog_focal.R -- focalised progressives in IcePAHC
- tail_linking.R -- tail-linking analysis
- tempsub.R -- temporal subordinate clauses in IcePAHC
- thegar_tha_temporal.R -- þegar and þá as temporal subordinators in IcePAHC

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
