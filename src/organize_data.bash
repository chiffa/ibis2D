#!/bin/bash


if [ $# -ne 2 ];
then
	echo "Usage: DataFolder[DIC|K14|XY] OutputFolder"
	exit 1
fi

DataFolder=$1
Output=$2
OutputSubFolder=${Output}/${DataFolder}

mkdir -p ${OutputSubFolder}

Folders=($(find ${DataFolder} -iname "PyMTTumor*" ))

echo "Info: Processing ${#Folders[@]} folders ..."

for folder in ${Folders[@]};
do
	NewFolderName=$(echo ${folder} | awk -F"[#|_]" '{print $2 "_" $3 "_" $4}')
	mkdir -p ${OutputSubFolder}/${NewFolderName}
	#Sorted_Files=($(ls ${folder} | sort -h))
	if [ "${DataFolder}" == "XY" ];
	then
		Sorted_Files=($(ls ${folder}/*.txt | xargs -n1 basename | sort -h))
	else
		Sorted_Files=($(ls ${folder}/*.tif | xargs -n1 basename | sort -h))
	fi

	echo "Info: ${#Sorted_Files[@]} files in ${folder} found for renaming ..."
	echo "Info: Renaming ..."
	i=0
	for file in ${Sorted_Files[@]};
	do
		NewName=$(echo ${file} | awk -F. '{$1 ="'$i'"; print $1 "." $2}')
		cp ${folder}/${file} ${OutputSubFolder}/${NewFolderName}/${NewName}
		let i+=1
	done
done



