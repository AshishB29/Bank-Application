#!/bin/sh
echo ""
source form.sh
i=0
while [ $i -eq 0 ]
do
echo "            How much Amount you Want to Deposit"
echo "            Amount should be more 3000"
read -p "         Amount:" a
if [ "$a" -lt 3000 ]
then
echo " "
echo "            You cant open account in Amount less than 3000"
else

echo "            Account has been created with deposite  of $a"
i=$(($i+1))
d=$(date +%y-%m-%d)
z=$(echo "$a*0.01" | bc )
echo "Date            Deposite/Withdrawn                  TranscationAmount                 TotalAmount">>"./pass/$x"
 
echo "$d         New Account First Deposite             $a                         $a">>"./pass/$x"
a=$(echo "$z+$a" |bc)
echo "$d           Interest                               $z                        $a">>"./pass/$x"
#echo "$x"
echo "            Your Account has been Created Successfully"
echo " "
echo "Your Account Mini Statement"
tail  ./pass/$x && sleep 3
fi
done
echo "**************************************************************************************"
echo " "
echo "**********************************************************"
echo "*                                                        *"
echo "*             THANKYOU For Joining With US               *"
echo "*                                                        *"
echo "**********************************************************"

sleep 5
