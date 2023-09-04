# PaNDiv_competition_networks
Data from PaNDiv experiment and code for the analysis of "Resource economics traits predict competition network structure and its response to resources and enemies"

## What can you find in this project?

### PaNDiv_competition_network.Rproject file

This R project should first be opened in order to run code or to do any work in this repository.

### code folder

In the code folder, you will find the Rmarkdown that contains the full analysis, called "PaNDiv_competition_network_full_analysis.Rmd". You will also find its .html output which is identical to the "index.html" file used for webpage deployment.

The "custom.css" file is used to specify some appeareance settings for the Rmarkdown file.

The "function_competition_network.R" file contains personal functions that are used in the analysis.

**WARNING:** In order to knit the Rmarkdown properly, make sure the knit directory is the project directory and not the document directory, it can be changed in the *knit options* as follow:

<img width="273" alt="image" src="https://user-images.githubusercontent.com/55712198/232017558-f8c2e2ac-05cf-4f1c-a3ad-466b39f42172.png">


### data folder

In the data folder, you can find all competition matrices used during the analysis, as text files which names start with "biommatrix", and their associated standard errors, which are named "SE_biommatrix". A total of 8 matrices are present, one per treatment (4) per sampling period (2).

The "SLA_PaNDiv_2016-2019.txt" contains species level information about the Specific Leaf Area sampled in PaNDiv experiment between 2016 and 2019.

The "SLA shift.xlsx" contains information about the measure of the shift in SLA (Delta_SLA) in PaNDiv communities sampled in June between 2016 and 2022. 

The two "perco.txt" files are percentage cover of the experimental field from June and August 2020 used in order to obtain the Supplementary figure 7. This file is also associated with the "plot_all.txt" file which contains information on PaNDiv experiment plots (name and treatment).

### results folder

This folder contains useful Renvironment files, that allow a quick loading and knitting of the Rmarkdown file.

**WARNING:** Here, only the files under 100Mb are available. To get all Renvironment files useful for quick loading, go to : https://www.dropbox.com/scl/fo/2mjx547h3lm1j3jri2xkk/h?dl=0&rlkey=at1hez2lt3iib9nq0mt2yg6ec, download the files and *put them in the results folder with the other Renvironment files*. 

For any questions, contact : caroline.daniel@ips.unibe.ch
