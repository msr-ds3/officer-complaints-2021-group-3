#!/bin/bash

# use curl to download the data! 

curl -O https://raw.githubusercontent.com/new-york-civil-liberties-union/NYPD-Misconduct-Complaint-Database-Updated/main/CCRB%20Complaint%20Database%20Raw%2004.20.2021.csv

# update the timestamp on the resulting file using touch
# do not remove, this will keep make happy and avoid re-downloading of the data once you have it

touch https://raw.githubusercontent.com/new-york-civil-liberties-union/NYPD-Misconduct-Complaint-Database-Updated/main/#CCRB%20Complaint%20Database%20Raw%2004.20.2021.csv
