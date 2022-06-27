#!/bin/bash
#==========================================
# Random password generator with file ouput
#==========================================
# Bastiaan Williams
# bastiaanwilliams@protonmail.com
#==========================================
clear
menu() {
printf "\n"
printf "=== RANDOM PASSWORD(S) GENERATOR ==="
printf "\n"
printf "\n"
}
menu_howpass() {
read -p "How many random passwords do you want to generate (max. 500)? " many
# lets check if the users input is a number
num='^[0-9]+$'
if ! [[ "$many" =~ $num ]] ;
then
        read -p "ERROR: You must input a number between 1-500 [ENTER]"
        menu_howpass
fi
# lets check if the value is correct
if [ $many -gt 500 ]
then
	read -p "ERROR: Too many passwords. The maximum is 500 [ENTER]"
	menu_howpass
fi
}
menu_chars() {
read -p "How many characters you would like the password(s) to have? (max. 500) " pass_lenght
# lets check if the users input is a number
num='^[0-9]+$'
if ! [[ $pass_lenght =~ $num ]] ;
then
        read -p "ERROR: You must input a number between 1-500 [ENTER]"
        menu_chars_
fi
# lets check if the value is correct
if [[ "$pass_lenght" -gt 500 ]]
then
        read -p "ERROR: Too many characters. The maximum is 500 [ENTER]"
        menu_chars
fi
}
menu_self() {
	read -p "Do you want to decide the characters that your password(s) should consist of? (y/n) " ansself
	if [ $ansself == "y" ]
then
	read -p "Give in your characters:" ansselfans
	size=${#ansselfans} 
	if [ "$size" -gt 500 ]
		then
			read -p "ERROR: Too many characters. The maximum is 500 [ENTER]"
			menu_self
	fi
	ansselfans=`echo $ansselfans|tr -d ' '`
	ansselfans="$ansselfans"
fi
}
menu_num() {
	if [ "$ansself" == "y" ]
		then
			ansself="y"
	else
		read -p "Do you want your passwords to contain number(s)? (y/n) " ansnum
		if [[ "$ansnum" = "y" ]] || [[ "$ansnum" = "n" ]]
			then
			ansnum=$ansnum
			else
				menu_num
		fi
	fi
}

menu_special() {
	 if [ "$ansself" == "y" ]
		 then
			 ansself="y"
else
	read -p "Do you want your password(s) to contain special characters? (y/n) " ansspecial
	 if [[ "$ansspecial" = "y" ]] || [[ "$ansspecial" = "n" ]]
                        then
                        ansspecial=$ansspecial
                        else
                                menu_special
                fi

	 fi
}

menu_file() {
read -p "Do you want to write the passwords to a file? (y/n) " file

# print random password x times ##
x=$many

if [ "$ansself" == "y" ]
then
	while [ $x -gt 0 ] ;
        do (tr -cd $ansselfans < /dev/urandom | fold -w${pass_lenght} | head -n 1 >> .temp);
        x=$(($x-1))
        done
fi
if [[ "$ansnum" == "y" && "$ansspecial" == "y" ]]
	then
	while [ $x -gt 0 ] ; 
	do (tr -cd 'A-Za-z0-9~`:,."$%^&*()!@#$}{][";]/\-_+=?!<>|' < /dev/urandom | fold -w${pass_lenght} | head -n 1 >> .temp);
	x=$(($x-1))
	done
fi
if [[ "$ansnum" == "y" && "$ansspecial" == "n" ]]
	then
	while [ $x -gt 0 ] ; 
	do (tr -cd 'A-Za-z0-9' < /dev/urandom | fold -w${pass_lenght} | head -n 1 >> .temp);
	x=$(($x-1))
	done
fi
if [[ "$ansnum" == "n" && "$ansspecial" == "y" ]]
        then
        while [ $x -gt 0 ] ;
        do (tr -cd 'A-Za-z~`[:,."$%^&*()!@#$}{][";]/\-_+=?!<>|' < /dev/urandom | fold -w${pass_lenght} | head -n 1 >> .temp);
        x=$(($x-1))
        done
fi
if [[ "$ansnum" == "n" && "$ansspecial" == "n" ]]
        then
        while [ $x -gt 0 ] ;
        do (tr -cd 'A-Za-z' < /dev/urandom | fold -w${pass_lenght} | head -n 1 >> .temp);
        x=$(($x-1))
        done
fi


# Print the strings
if [ "$file" == "y" ]
then
	clear
	date=`date "+%m%d%y%T%n"|tr -d ":"`
	cat .temp > passwords_$date.list
	printf " ============================================= \n"
	printf "      GENERATED $many RANDOM PASSWORD(S)       \n"
	printf " File written: passwords_$date.list\n"
	printf " ============================================= \n\n"
	rm -fR .temp
	
else
	clear
	printf " =============================================\n"
        printf "|     GENERATED $many RANDOM PASSWORD(S)      |\n"
        printf " =============================================\n\n"
	cat .temp
	rm -fR .temp
fi
printf "\n\n"
read -p "Do you want to generate more passwords? (y/n)" ans
if [ $ans == "y" ]
then
	clear
	menu
	menu_howpass
	menu_chars
	menu_self
	menu_num
	menu_special
	menu_file
else
	printf "\nGoodbye.\n"
	exit 0
fi
}
clear
menu
menu_howpass
menu_chars
menu_self
menu_num
menu_special
menu_file
