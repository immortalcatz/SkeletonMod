#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cr=`echo $'\n>'`
cr=${cr%.}

modname=""
modnamelower=""
modid=""
basepackagename=""

defaultbasepackagename="com.fireball1725"

getInputs() {
	read -r -p "Enter your mod name:$cr" modname

	while [ "$modname" == "" ]
	do
		read -r -p "Mod Name cannot be empty:$cr" modname
	done

	modnamelower=$(echo $modname | tr -d ' ' | tr '[:upper:]' '[:lower:]')

	read -r -p "Enter your mod id [$modnamelower]:$cr" modid

	# If blank, use whitespace stripped lower case mod name instead
	if [ "$modid" == "" ]; then
		modid="$modnamelower"
	fi

	read -r -p "Enter your group name [$defaultbasepackagename]:$cr" basepackagename

	# If blank, use FireBall's domain
	if [ "$basepackagename" == "" ]; then
		basepackagename="$defaultbasepackagename"
	fi
}

setupMod()
{
	IFS='.' read -a basepackagedirs <<< "${basepackagename}.$modnamelower"

	newDir=""

	# build new dir
	for dir in ${basepackagedirs[@]}; do
		newDir="$newDir/$dir"
	done

	# Rename base package dir
	mkdir -p $DIR/src/main/java$newDir
	mv $DIR/src/main/java/com/fireball1725/skeleton/* $DIR/src/main/java$newDir

	# Rename assets folder
	mkdir -p $DIR/src/main/resources/assets/$modid
	mv $DIR/src/main/resources/assets/skeleton/* $DIR/src/main/resources/assets/$modid

	# Remove old dirs
	if [ "${basepackagedirs[0]}" != "com" ]; then
		rm -rf $DIR/src/main/java/com
	else
		rm -rf $DIR/src/main/java/com/fireball1725
	fi
	rm -rf $DIR/src/main/resources/assets/skeleton/

	find $DIR/src/main -type f -exec sed -i -e "s/com.fireball1725./$basepackagename./g" {} \;
	find $DIR/src/main -type f -exec sed -i -e "s/skeleton/$modid/g" {} \;
	find $DIR/src/main -type f -exec sed -i -e "s/Skeleton Mod/$modname/g" {} \;
	find $DIR/src/main -type f -exec sed -i -e "s/Skeleton/$modname/g" {} \;
	find $DIR/gradle.properties -type f -exec sed -i -e "s/skeleton/$modnamelower/g" {} \;

	printf "\n\n"
	printf "Finished!"
}

printf "\n\n"
printf "Welcome to FireBall1725's Skeleton Mod Setup script!\n"
printf "You'll be asked a few questions on how you'd like the skeleton to be set up\n\n"

getInputs

printf "\n\n"
printf "Okay, this is what you told me:\n\n"
printf "Mod Name:     $modname\n"
printf "Mod ID:       $modid\n"
printf "Base Package: $basepackagename\n\n"

read -r -p "Would you like to continue? [y/N]$cr" response
case $response in
    [yY][eE][sS]|[yY]) 
        setupMod
        ;;
    *)
        printf "Exiting script!\n"
        exit 1
        ;;
esac
