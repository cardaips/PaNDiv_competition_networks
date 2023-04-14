# PaNDiv_competition_networks
Data from PaNDiv experiment and code for the analysis of "Resource economics traits predict competition network structure and its response to resources and enemies"

## What can you find in this project?

### code folder

In the code folder, you will find the Rmarkdown that contains the full analysis, called "PaNDic_competition_network_full_analysis.Rmd". You will also find its .html output which is identical to the "index.html" file used for webpage deployment.

The "custom.css" file is used to specify some appeareance settings for the Rmarkdown file.

The "function_competition_network.R" file contains personal functions that are used in the analysis.

**WARNING:** In order to knit the Rmarkdown proprely, make sure the knit directory is the project directory and not the document directory, it can be changed in the *knit options*

### data folder

In the data folder, you can find all competition matrices used during the analysis, as text files which names start with "biommatrix", and their associated standard errors, which are named "SE_biommatrix". A total of 8 matrices are present, one per treatment (4) per sampling period (2).

The "SLA_PaNDiv_2016-2019.txt" contains species level information about the Specific Leaf Area sampled in PaNDiv experiment between 2016 and 2019.

The two "perco.txt" files are percentage cover of the experimental field from June and August 2020 used in order to obtain the Supplementary figure 6. This file is also associated with the "plot_all.txt" file which contains information on PaNDiv experiment plots (name and treatment).

### results folder

This folder contains useful Renvironment files, that allow a quick loading and knitting of the Rmarkdown file.

**WARNING:** Here, only the lighter files are available. To get all Renvironment files useful for quick loading, go to : ....... , download the files and *put them in the results folder with the other Renvironment files*. 

For any questions, contact : caroline.daniel@ips.unibe.ch
