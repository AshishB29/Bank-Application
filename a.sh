#!/bin/sh
#read -p  "Continue:" x
loop=1
while [ $loop -eq 1 ]
do
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "|                                                                                           |"
echo "|        1.Create New Account                          2.Existing Account                   |"
echo "|                                    0. To Exit                                             |"
echo "--------------------------------------------------------------------------------------------"
echo " "
read -p "===>>   Your Choice:" o
if [ $o -eq 1 ]
then
bash na.sh
clear
elif [ $o -eq 2 ]
then
bash atms.sh
elif [ $o -eq 0 ]
then
loop=$((loop+1))
clear
fi
done

