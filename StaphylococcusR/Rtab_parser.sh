#!/usr/bin/env bash

#data="/media/daria_der/linuxdata/neisseria_virulence/W_sg/concatenated_fasta.csv"
folder="/media/daria_der/linuxdata/Report/Staphylococcus/saureus/Roary_out/"
data="/media/daria_der/linuxdata/Report/Staphylococcus/saureus/Roary_out/gene_presence_absence.csv"
touch "$folder""resulting_dataframe.csv"
final_file="$folder""resulting_dataframe.csv"
to_past_file="$folder""to_past"
temp_file="$folder""resulting_dataframe_2.csv"

i=$(head -1 $data| sed 's/\t/\n/g'| wc -l)
for((n = 1; n<i; n++))
 do
  echo "$n"
  column=$(awk -F'\t' -v var="$n" '{print $var}' $data| sed '1d') ## array without first row
  draft_levels=$(echo $column|sed 's/\t/\n/g'|sort -u) ## set of true aminoacids in array
  levels=$(printf '%s\n' $draft_levels| sort -u)
  echo $levels
  length_levels=$(printf '%s\n' $levels| wc -l) #number of different aminoacids
  to_past=$(awk -F'\t' -v var="$n" '{print $var}' $data)
  one=$([ "$length_levels" -gt 1 ] && echo "1" || echo "0") ## test if there is at least one different aminoacid
  #echo "one is $one"
  #echo "length_levels $length_levels"
  printf '%s\n' $to_past > $to_past_file
  [ "$one" -eq "1" ] && paste $final_file $to_past_file > $temp_file && rm $final_file && mv $temp_file $final_file ## append new column to res df
  done
