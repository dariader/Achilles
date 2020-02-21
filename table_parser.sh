#!/usr/bin/env bash

data="/media/daria_der/linuxdata/neisseria_virulence/W_sg/concatenated_fasta.csv"
touch "resulting_dataframe.csv"

i=$(head -1 $data| sed 's/,/\n/g'| wc -l)

for((n = 1; n<i+1; n++))
#for((n = 3; n<10; n++))
 do
  echo "$n"
  column=$(awk -F',' -v var="$n" '{print $var}' $data| sed '1d') ## array without first row
  draft_levels=$(echo $column|sed 's/,/\n/g'|sort -u|sed 's/X//g'| sed 's/-//g') ## set of true aminoacids in array
  levels=$(printf '%s\n' $draft_levels| sort -u)
  #echo $levels
  length_levels=$(printf '%s\n' $levels| wc -l) #number of different aminoacids
  to_past=$(awk -F',' -v var="$n" '{print $var}' $data)
  one=$([ "$length_levels" -gt 1 ] && echo "1" || echo "0") ## test if there is at least one different aminoacid
  #echo "one is $one"
  #echo "length_levels $length_levels"
  printf '%s\n' $to_past > to_past.csv
 /usr/bin/time [ "$one" -eq "1" ] && paste resulting_dataframe.csv to_past.csv > resulting_dataframe_2.csv && rm resulting_dataframe.csv && mv resulting_dataframe_2.csv resulting_dataframe.csv >> writing_time## append new column to res df
  done

