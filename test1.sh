#!/bin/bash

argTest ()
{

if [ $# == 0 ]; then
    printf 'No arguments given, 3 expected '$#' given.\n' >&2
    printf 'Usage: arg1 = path/to/file, arg2 = directory name, arg3 = system name\n' >&2
    exit 1
elif [ $# -lt 3 ]; then
    printf 'Not enough arguments given, 3 expected '$#' given.\n' >&2
    exit 1
elif [ $# -gt 3 ]; then
    printf 'Too many arguments given, 3 expected '$#' given.\n' >&2
    exit 1
else
    exit 0
fi
}

symLink ()
{

if [ "$filename" != "$oldFile" ] && [ -L $dir/$i ]; then
    echo "remove $oldFile"
    #rm $oldFile
    echo "create symlink"
    #ln -sf $latest $2/$filename
    printf ''$now'  removed '$oldFile', added symlink to '$latest'\n\n' >> latest.log
elif [ ! -L $dir/$i ]; then
    printf ''$now'  '$i' is not a symlink, consider cleaning up directory\n\n' >> latest.log &2
    echo "create symlink"
    #ln -sf $latest $2/$filename
elif [ "$filename" == "$oldFile" ] && [ -L $dir/$i ]; then
    echo "remove $oldFile"
    #rm $oldFile
    echo "create symlink"
    #ln -sf $latest $2/$filename
    printf ''$now'  File names match, removed '$oldFile', added symlink to '$latest'\n\n' >> latest.log &2
else
    echo "create symlink"
    #ln -sf $latest $2/$filename
    printf ''$now'  something else happened, added symlink to '$latest'\n\n' >> latest.log &2
fi
}

main ()
{
    $(argTest $1 $2 $3)

if [ $? == 1 ]; then
   printf 'Failed argTest\n\n' >> latest.log &2
    exit 1
fi

echo "next step"

#Finds the latest modified file
latest=$(/usr/bin/find $1 | xargs ls -tr | tail -1)

#Date format YYYY-MM-DD-HH-MM-SS
now=`date +"%Y-%m-%d-%H-%M-%S"`

#Unique name of the system
system=$3

#Change to suit naming convention
filename="$system-backup-$now"
oldFile=$(/usr/bin/find "$dir" -name ''$system'-backup-*')
dir=$2
getFiles=(`ls $dir`)

if [ -d "$2" ]; then 
    for i in "${getFiles[@]}"
        do
            $(symLink)
        done
fi
}

main $1 $2 $3