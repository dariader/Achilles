#!/usr/bin/env bash
file="/media/daria_der/linuxdata/neisseria_virulence/W_sg/BIGSdb_028077_1580937472_69979.xmfa"
``` Скрипт чтобы парсить фасту в таблицу.  Очень тяжелые файлы на выходе. Надо делать предобработку.
```
#linearize fasta

linearized_fasta=$(cat $file|sed '/^>/ s/$/;/'|sed ':a;N;$!ba;s/\n//g' | sed 's/>/\n>/g'| sed 's/+/_/g'| sed 's/ //g')
proteins=$(cat $file| grep ">"|awk '{print $3}'|sort -u) ## list of proteins to grep
	for i in $proteins; do
	echo $i;
	prep_fasta=$(printf '%q\n' $linearized_fasta|grep $i| sed 's/;/\n/g'|grep -v ">");
	length_fasta=$(printf '%q\n' $prep_fasta|awk '{ print length }'| head -1)
	echo $length_fasta;
	prep_fasta_fin=$(printf '%q\n' $prep_fasta|sed 's/=//g'|sed 's/>u.*\|/,/g'| sed 's/^,//g'); # fasta with commas
	header=$(for (( j=1; j < ${length_fasta}; j++ )); do echo $j"."$i; done| sed ':a;N;$!ba;s/\n/,/g');
	printf '%s\n' "$header" "$prep_fasta_fin"> "$i"_parsed.fasta;
      done

paste *_parsed.fasta| sed 's/\t1./,1./g'|sed 's/,\t/,/g'| sed 's/,,/,/g'| sed 's/,$//g' > concatenated_fasta.csv