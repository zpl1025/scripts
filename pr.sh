#!/bin/bash
# based on hub

param=$1
CON="[33m"
CERR="[31m"
COFF="[0m"

if [ "$param" != "translating" ]; then
	if [ "$param" != "translated" ]; then
		if [ "$param" != "update" ]; then
			echo "${CERR}[ERR] only support 'translating' 'translated' 'update'${COFF}";
			exit 1;
		fi
	fi
fi

if [ "$param" == "update" ]; then
	echo "${CON}[MSG] git fetch lctt${COFF}"
	git fetch lctt
	echo "${CON}[MSG] git pull lctt master${COFF}"
	git pull lctt master
	echo "${CON}[MSG] Done.${COFF}"
	exit 0
fi

count=`git status | grep modified -c`
if [ "$count" != "1" ]; then
	echo "${CON}[ERR] not only one modification!${COFF}"
	git status | grep modified
	exit 1;
fi

cmdgit=`which git`
if [ $? -ne 0 ]; then
	cmdgit="echo git"
fi
cmdhub=`which hub`
if [ $? -ne 0 ]; then
	cmdhub="echo hub"
fi

#modified=`git status | grep modified | cut -d':' -f 2 | xargs`
modified=`git status | grep modified | cut -d':' -f 2 | sed -e "s/^ *//"`
if [ "$modified" != "" ]; then
	if [ ! -f "$modified" ]; then
		echo "${CERR}[ERR] file not found: \"$modified\" "
		exit 1
	fi
	echo "${CON}[MSG] Updating repository...${COFF}"
	$cmdgit fetch lctt 
	$cmdgit pull lctt master
	$cmdgit push origin master

	filename=`basename "$modified"`
	echo "${CON}[MSG] Filename: $filename${COFF}"
	if [ "$param" == "translated" ]; then
		dstdir=`dirname "$modified" | sed -e "s/sources/translated/"`
		sed -i "" -e "s/译者ID/zpl1025/g" "$modified"
		$cmdgit mv "$modified" "$dstdir"
	fi
	echo "${CON}[MSG] Commit to repository...${COFF}"
	$cmdgit commit -am "[$param] $filename" 
	$cmdgit push origin master 
	echo "${CON}[MSG] Create pull request...${COFF}"
	$cmdhub pull-request -m "[$param] $filename" -b LCTT:master
	echo "${CON}[MSG] Done.${COFF}"
fi

# # add remote repo alias (the default alias for remote repo when cloned is origin)
# git remote add lctt https://github.com/LCTT/TranslateProject.git  
# 
# # sync the upstream repo
# git fetch lctt
# 
# # merge the upstream repo to mine
# git pull lctt master
# 
# # make your changes
# 
# # commit changed to your remote
# git push origin master
# 
# # invoke pull request on github.com
# # git pull-request [-o|--browse] [-f] [-m MESSAGE|-F FILE|-i ISSUE|ISSUE-URL] [-b BASE] [-h HEAD]
# # BASE/HEAD: branch, owner:branch, owner:repo/branch
# hub pull-request -m "Implemented feature X" -b LCTT:master -h mislav:feature
