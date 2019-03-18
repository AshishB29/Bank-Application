#!/bin/bash
echo ""
echo "##################################################################################################################################"
read -p "                Enter the Account No.:" account
echo ""
account=$(echo "$account % 10000" | bc)
if test -f data/$account
	then
balance=$(tail -n 1 pass/$account |rev|cut -d " " -f 1|rev)

	i=3
	while [ $i -gt 0 ]
do
	echo -e -n "\t\tEnter the Password:"
	stty -echo
	read password
	stty echo
	a=$(sed '/^$/d' data/$account | tail -n 1)
	if [ $a = $password ]
	then
	i=-1
	else
	echo  -e  "\t\tPassword is Wrong"
	i=$((i-1))
	echo  -e "\t\tYou have $i chances Left"	
fi
	if [ $i -eq 0 ]
then
	echo -e "\t\t You have Entered Wrong Password Many Times"
	fi
	done

while [ $i -eq -1 ]
do
		echo ""
		echo -e  "\t\t------------------------------------------------------------------------------------------"
		echo -e "\t\t|\t\t1. Deposit \t\t\t    2. Withdraw \t\t\t |"
		echo -e "\t\t|\t\t3. To Change Password \t\t    4. Mini Statement \t\t\t |"
		echo -e "\t\t|\t\t5. Transfer To Other Account        0. Exit\t\t\t\t |"
		echo -e "\t\t------------------------------------------------------------------------------------------"
if (( $(echo  "$balance < 3000 "| bc ) ))
then
d=$(sed  -n '7p' data/$account)
curl -H "Content-Type: application/json" --request POST --data "{\"email\":\"$d\",\"subject\": \"SAS BANK\",\"body\":\"Your Balance is less Than 3000. Plz Maintain the Minimum Balance.\"}" "https://prod-13.centralindia.logic.azure.com:443/workflows/61db986ce74f4a54976360265b45e983/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=8YhGtaZ4GYw6pYibOEY8UhQ-dmfZXZBkClsI_NTGMAw"
fi
		read -p "                 Your Choice:" choice
echo ""

case $choice in
0) i=5 
clear;;
1)
read -p "        Amount to be Deposited:" amt
if (( $(echo "$amt > 0" | bc -l ) ))
then
bl=$(echo "$amt +$balance" | bc)
echo "$(date +%y-%m-%d)          Deposited                             $amt                          $bl" > at
cat at >> pass/$account
d=$(sed  -n '7p' data/$account)
curl -H "Content-Type: application/json" --request POST --data "{\"email\":\"$d\",\"subject\": \"SAS BANK\",\"body\":\"Amount $amt is Deposited in Your Account. Remaining Balance is $bl.\"}" "https://prod-13.centralindia.logic.azure.com:443/workflows/61db986ce74f4a54976360265b45e983/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=8YhGtaZ4GYw6pYibOEY8UhQ-dmfZXZBkClsI_NTGMAw"
balance=$bl
rm at
echo -e  "\tDo You want to Display Balance"
read -p "ChoiceY/N:" ch
if [ $ch = "Y" ] || [ $ch = "y" ]
then
echo -ne "Your Remaining Balance:$balance  \r" && sleep 3
echo ""
fi
else
echo "Amount Entered is Invalid"

fi;;
2)

read -p "        Amount to be Withdrawn:" amt
if (( $(echo "$amt <= $balance" | bc -l ) ))  &&  (( $(echo "$amt >= 0" | bc -l ) ))
then
bl=$(echo "$balance -$amt" | bc -l)
echo "$(date +%y-%m-%d)          Withdrawn                             $amt                          $bl" > at
cat at >> pass/$account
d=$(sed  -n '7p' data/$account)
curl -H "Content-Type: application/json" --request POST --data "{\"email\":\"$d\",\"subject\": \"SAS BANK\",\"body\":\"Amount $amt is been Withdrawin from Your Account. Remaining Balance is $bl.\"}" "https://prod-13.centralindia.logic.azure.com:443/workflows/61db986ce74f4a54976360265b45e983/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=8YhGtaZ4GYw6pYibOEY8UhQ-dmfZXZBkClsI_NTGMAw"
balance=$bl
rm at
if (( $(echo "$balance == 0" |bc -l ) ))
then
d=$(sed -n '7p' data/$account)
curl -H "Content-Type: application/json" --request POST --data "{\"email\":\"$d\",\"subject\": \"SAS BANK\",\"body\":\"Your Account ha 0 Balance. Deposite Some Amount within one Month from First Notification else Your Account will be Closed.\"}" "https://prod-13.centralindia.logic.azure.com:443/workflows/61db986ce74f4a54976360265b45e983/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=8YhGtaZ4GYw6pYibOEY8UhQ-dmfZXZBkClsI_NTGMAw"
fi
echo -e "\tDo You want to Display Balance"
read -p "ChoiceY/N:" ch
if [ $ch = "Y" ] || [ $ch = "y" ]
then
echo -ne "Your Remaining Balance:$bl  \r" && sleep 3
echo ""
fi
else
echo "Your balance is not sufficient or Amount is Invalid"
echo "Balance in Your Account is $balance"
fi;;
3)k=3
while [ $k -gt 0 ] 
do
echo "Enter Current  Password"
stty -echo
read pd
stty echo
if [ $pd != $password ];then
echo "Entered Password is Wrong"
k=$((k-1))
echo "You have $k chances left"
else
echo "Enter the New Password"
stty -echo
read pd1
stty echo
echo "Enter the Password Again"
stty -echo
read pd2
stty echo
if [ $pd1 = $pd2 ];then
echo "Your pssword is changed"
sed "s/$password/$pd1/" data/$account > at
cat at > data/$account
d=$(sed -n '7p' data/$account)
curl -H "Content-Type: application/json" --request POST --data "{\"email\":\"$d\",\"subject\": \"SAS BANK\",\"body\":\"Your Password has been changed Successfully.\"}" "https://prod-13.centralindia.logic.azure.com:443/workflows/61db986ce74f4a54976360265b45e983/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=8YhGtaZ4GYw6pYibOEY8UhQ-dmfZXZBkClsI_NTGMAw"
rm at
k=-1
else
echo "Your Entered Password is not Same "
k=$(($k-1))
echo "You have $k chances left"
fi
fi
done
if [ $k -eq 0 ];then
echo "Sorry You have entered Wrong Password So many Times,Try again"
fi
;;
4)
x=$(wc -l <pass/$account)
if [ $x -gt 6 ]
then
head -n 1 pass/$account
tail -n 5 pass/$account
else
tail -n 5 pass/$account
fi
;;
5)
read -p "                  Give Account No. of Recipient:"  rec
if test -f data/$rec
then
b=$(tail -n 1 pass/$rec |rev|cut -d " " -f 1|rev)
echo -en "\t\t Enter Amount to Deposit:"
read am
if (( $(echo "$am <= $balance" | bc -l ) ))  &&  (( $(echo "$am >= 0" | bc -l ) ))
then
bl=$(echo "$balance -$am" | bc -l)
echo "$(date +%y-%m-%d)          Withdrawn                             $am                          $bl" > at
cat at >> pass/$account
d=$(sed  -n '7p' data/$account)
curl -H "Content-Type: application/json" --request POST --data "{\"email\":\"$d\",\"subject\": \"SAS BANK\",\"body\":\"Amount $am is Transfered to Account No. $rec form Your Account. Remaining Balance is $bl.\"}" "https://prod-13.centralindia.logic.azure.com:443/workflows/61db986ce74f4a54976360265b45e983/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=8YhGtaZ4GYw6pYibOEY8UhQ-dmfZXZBkClsI_NTGMAw"
balance=$bl
rm at
bll=$(echo "$am +$b" | bc)
echo "$(date +%y-%m-%d)          Deposited                             $am                          $bll" > at
d=$(sed  -n '7p' data/$rec)
curl -H "Content-Type: application/json" --request POST --data "{\"email\":\"$d\",\"subject\": \"SAS BANK\",\"body\":\"Amount $amt is Transfered to Your Account. Remaining Balance is $bll.\"}" "https://prod-13.centralindia.logic.azure.com:443/workflows/61db986ce74f4a54976360265b45e983/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=8YhGtaZ4GYw6pYibOEY8UhQ-dmfZXZBkClsI_NTGMAw"
cat at >> pass/$rec
rm at
echo -e "\tDo You want to Display Balance"
read -p "ChoiceY/N:" ch
if [ $ch = "Y" ] || [ $ch = "y" ]
then
echo -ne "Your Remaining Balance:$bl  \r" && sleep 3
echo ""
fi
else
echo "Your balance is not sufficient or Amount is Invalid"
echo "Balance in Your Account is $balance"
fi
else
echo "Account No. of Recepient is Wrong"
fi
;;
esac
done
else 
echo "Account No. is Wrong"
fi
