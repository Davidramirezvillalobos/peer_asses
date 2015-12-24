---
title: "README"
author: "David Ramirez"
date: "24 de diciembre de 2015"
output: html_document
---

peer_asses.txt is a tidy data set produced by trasformation of test and train raw
data sets. This two raw data sets come from an important study on people movements
collected from the accelerometers from the Samsung Galaxy S smartphone

6 types of movements on 30 differents types of subjects were collected during
several months. This is the data

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

peer_asses.txt reduce original raw big data to a small data set to data average 
on every observation type (type of movement per type of subject)

run_analysis.R is the script that reduces raw to tidy data.