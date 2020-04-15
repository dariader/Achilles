#!/usr/bin/env bash
for stuff in {a..g}
    do
        sem -j+0 echo $stuff
    done

for((z = 1; z<10; z++))
#for((n = 3; n<10; n++))
 do
 sem -j 2 echo $z
  done

sem --wait