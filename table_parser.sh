#!/usr/bin/env bash
#!/usr/bin/sh
date
#data="/media/daria_der/linuxdata/neisseria_virulence/W_sg/concatenated_fasta.csv"
data="concatenated_fasta.csv"
#data="test_df.csv"
export data
#data="/media/daria_der/linuxdata/Report/Staphylococcus/saureus/Roary_out/gene_presence_absence.csv"
rm "resulting_dataframe.csv"
touch "resulting_dataframe.csv"
mkdir temp
echo "in data n rows == "
wc -l $data

i=$(head -1 $data| sed 's/,/\n/g'| wc -l)
echo $i

parser(){
  n=$1
  echo $n
  column=$(awk -F',' -v var="$n" '{print $var}' $data| sed '1d') ## array without first row
  draft_levels=$(echo $column|sed 's/,/\n/g'|sort -u|sed 's/X//g'| sed 's/-//g') ## set of true aminoacids in array
  levels=$(printf '%s\n' $draft_levels| sort -u)
  length_levels=$(printf '%s\n' $levels| wc -l) #number of different aminoacids
  to_past=$(awk -F',' -v var="$n" '{print $var}' $data)
  one=$([ "$length_levels" -gt 1 ] && echo "1" || echo "0") ## test if there is at least one different aminoacid
  [ "$one" -eq "1" ] && printf '%s\n' $to_past > ./temp/to_past_"$n".csv
}

export -f parser

runner(){
export -f parser
#echo "runner"
i=$(head -1 $data| sed 's/,/\n/g'| wc -l)
#echo "i is "$i""
for((z=1; z<="$i"; z++))
# do sem -j 6 parser $z;
#    sem --wait
# done
 do parser $z ;done
}

export -f runner
shutdown -r +3
    runner
    cd temp
        for i in to_past_*.csv; do
        paste resulting_dataframe.csv "$i" > tmp; mv tmp resulting_dataframe.csv ## append new column to res df
        done
    mv resulting_dataframe.csv ..
    cd ..
    rm -rf ./temp
shutdown -c
date

#for((z = 1; z<"$i"; z++)); do sem -j+0 parser "$z"; done ; sem --wait
#for((z = 1; z<"$i"; z++))
# do parser "$z"
#  sem -j+0 --will-cite runner
#  echo 'done'
#done

    #echo 'done'
#shutdown -c
#for((z = 1; z<"$i"; z++)); do parser "$z"; done

#mv resulting_dataframe.csv /media/daria_der/linuxdata/Report/Staphylococcus/saureus/Roary_out/gene_presence_absence_res.csv