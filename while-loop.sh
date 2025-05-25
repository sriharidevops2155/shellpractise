#!/bin/bash

# a=0

# while [ $a -lt 10 ]
# do
#     echo $a
#     a=`expr $a + 1`
# done

while IFS= read -r line #Internal Field Separator and -r is it to print for special characters as well 
do 
    echo $line
done < delete-oldlogs.sh