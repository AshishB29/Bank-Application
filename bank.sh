#!/bin/sh
clear
f="nit2k18"
i=3
echo ""
echo "******************************************************************************************************************"
echo -e "\t\tWelcome To SAS BANK"
while [ $i -ge 1 ]
do
echo -n "Enter Password:" `stty -echo`
read  p
if test $f = $p
then
echo ""
i=$(( i-4 ))
echo "Welcome To Bank Server"
echo "" `stty echo`
bash d.sh

bash a.sh
else
echo  ""
echo "Access Denied"
i=$(( i-1 ))
if [ $i -ne 0 ]
then
echo "$i more Tries"
fi
echo ""
fi
done
echo "" `stty echo`

