
#!/bin/bash

declare -a A[]={""}

function Form ()
{
	exec 3>&1
VALUES=$(dialog --ok-label "SUBMIT" \
        --backtitle "Bank Account Form" \
	  --title "New Account" \
	  --form "Create a new Account" \
20 100 0 \
	"Name:" 1 1	"${A[0]}" 	1 15 50 0 \
	"Fathers Name:"    3 1	"${A[1]}"  	3 15 30 0 \
	"Mothers Name:"    3 50	"${A[2]}"  	3 65 30 0 \
	"Aadhar No.:"     5 1	"${A[3]}" 	5 15 30 0 \
	"Date Of Birth:"   5 50   "${A[4]}"  5 65 30 0 \
	"Mobile No.:"      7 1   "${A[5]}"    7 15 30 0 \
	"Email:"           7 50  "${A[6]}"    7 65 30 0 \
	"Address:"        9 1   "${A[7]}"     9 15 30 0 \
2>&1 1>&3)
rt=$?
if [ $rt -eq 1 ]
then
	return $rt
else
exec 3>&-
return $rt
fi
}
Form $A
start()
{
echo "$VALUES" > "data.txt"
x=$(echo $((1000 + RANDOM% 999)))
i=0
for (( i=0;i<=7;i++))
do
j=$(($i+1))
A[$i]=$(sed -ne $j\p data.txt)
done

z=$(wc -l < data.txt)
w=$(grep  -c "^$" data.txt)
if [ $z -ne 8  -o $w -ne 0 ]
then
echo "Some Enteries are Missing" && sleep 2
Form $A
start
fi
z=$(echo ${A[5]} | wc -c)
if [ $z -ne 11  -a $z -ne 1 ]
then
   
    echo "Mobile No. is Wrong" && sleep 2
    Form $A
fi

}

print()
{
x=$(echo $((1000 + RANDOM % 999 )))
if test -f data/$x
then
print
else
echo "*************************************************************************************************************************"
echo "*                      Your Account No. is $x    "
echo "*                      Your Password Has been sent to your Email ID"
echo "*************************************************************************************************************************"

echo "$VALUES" > "./data/$x"
y=$(echo $((1000 + RANDOM % 999 )))
echo "$y">>"./data/$x"
d=$(sed -n '7p' data/$x)
curl -H "Content-Type: application/json" --request POST --data "{\"email\":\"$d\",\"subject\": \"SAS BANK\",\"body\":\" Your Account has been Successfully Created.Your Account No. is $x and Your Password is : $y.. Don't Share this Password with Anybody  \"}" "https://prod-13.centralindia.logic.azure.com:443/workflows/61db986ce74f4a54976360265b45e983/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=8YhGtaZ4GYw6pYibOEY8UhQ-dmfZXZBkClsI_NTGMAw"
echo " "
fi
}

start
for ((i=0;i<20;i++))
do
clear
done
echo " "
print
