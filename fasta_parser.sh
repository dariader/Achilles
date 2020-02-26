#!/usr/bin/env bash
#file="/media/daria_der/linuxdata/neisseria_virulence/W_sg/BIGSdb_028077_1580937472_69979.xmfa"
#xmfa="/media/daria_der/linuxdata/neisseria_virulence/pen_res/BIGSdb_014516_1582581087_34991_core.xmfa"
xmfa="/media/daria_der/linuxdata/neisseria_virulence/pen_res/abres_core.xmfa"
sed 's/-//g' $xmfa| sed 's/ + /___/g' > "$xmfa"_edited
/home/daria_der/Downloads/Soft/faTrans "$xmfa"_edited "$xmfa"_translated
file="$xmfa"_translated


```
Скрипт чтобы парсить фасту в таблицу.  Очень тяжелые файлы на выходе. Надо делать предобработку.
```
#linearize fasta

expected_number_of_samples="647"

linearized_fasta=$(cat $file|sed '/^>/ s/$/;/'|sed ':a;N;$!ba;s/\n//g' | sed 's/>/\n>/g'| sed 's/+/_/g'| sed 's/ //g')
#proteins=$(cat $file| grep ">"|awk '{print $3}'|sort -u) ## list of proteins to grep
proteins=$(cat $file| grep ">"|awk -F'___' '{print $2}'| sort -u)
	for i in $proteins; do
	echo $i;
	fasta_to_align=$(printf '%q\n' $linearized_fasta|grep $i| sed 's/;/\n/g')
	prep_fasta=$(printf '%q\n' $fasta_to_align|sed 's/\\//g'| mafft - |sed '/^>/ s/$/;/'|sed ':a;N;$!ba;s/\n//g' | sed 's/>/\n>/g'| sed 's/+/_/g'| sed 's/ //g'| sed 's/;/\n/g'| grep -v ">");
	num_of_samples=$(printf '%q\n' $prep_fasta| wc -l)
	echo $num_of_samples
	[ "$num_of_samples" -ne "$expected_number_of_samples" ] && echo "num of samples is weird" && continue || echo "num samples is OK"
	length_fasta=$(printf '%q\n' $prep_fasta|awk '{ print length }'| head -1)
	echo $length_fasta;
	prep_fasta_fin=$(printf '%q\n' $prep_fasta|sed 's/=//g'|sed 's/>u.*\|/,/g'| sed 's/^,//g'); # fasta with commas
	header=$(for (( j=1; j < ${length_fasta}; j++ )); do echo $j"."$i; done| sed ':a;N;$!ba;s/\n/,/g');
	printf '%s\n' "$header" "$prep_fasta_fin"> "$i"_parsed.fasta;
      done
paste *_parsed.fasta| sed 's/\t1./,1./g'|sed 's/,\t/,/g'| sed 's/,,/,/g'| sed 's/,$//g' > concatenated_fasta.csv
rm *_parsed.fasta