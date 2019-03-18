#!/bin/bash
for f in pass/*
do
f=$(echo $f | cut -d "/" -f 2)
d=$(date "+%Y-%m-%d")
#echo $d
#echo "$f"
d1=$(sed -n '/Interest/p' pass/$f |tail -n 1|cut -d " " -f 1)
d2=$(tail -n 1 pass/$f|cut -d " " -f 1)
 
#echo $((($(date +%s --date "2017-12-31")-$(date +%s --date "2017-11-1"))/(3600*24))) days
x=$((($(date +%s --date "$d")-$(date +%s --date "$d1"))/(3600*24))) 
w=$((($(date +%s --date "$d")-$(date +%s --date "$d2"))/(3600*24))) 

#echo $x
balance=$(sed '/^$/d' pass/$f |tail -n 1|rev|cut -d " " -f 1|rev)
#echo $balance
y=$(echo "$x / 30" | bc)
y1=$(echo "$w / 30" | bc)
if (( $(echo "$balance == 0" | bc -l) ))
then
if (( $(echo "$y1 > 1" |bc -l) ))
then
rm pass/$f
rm data/$f
else
d=$(sed -n '7p' data/$f)
curl -H "Content-Type: application/json" --request POST --data "{\"email\":\"$d\",\"subject\": \"SAS BANK\",\"body\":\"Your Account Has 0 balance.Deposit Some Ammount within One Month from First Notification or Your Account will be Closed \"}" "https://prod-13.centralindia.logic.azure.com:443/workflows/61db986ce74f4a54976360265b45e983/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=8YhGtaZ4GYw6pYibOEY8UhQ-dmfZXZBkClsI_NTGMAw"
fi
fi
if  (( $(echo "$balance < 3000 " | bc -l) )) &&  (( $(echo "$balance > 0" | bc -l ) ))
then
    	for((i=0;i<y1;i++))
	do
	z=$(echo "$balance*.005" | bc)
	balance=$(echo "$balance - $z" | bc)
	echo "$d          Less                              $z                           $balance" >> pass/$f
done
fi
#echo $balance
#echo "---------------------------------"
#echo "balance check"
#if [ $balance '>' 3000 ] 
#then
#echo "$d1"
#echo "$y"
if (( $(echo "$balance > 0" | bc -l ) ))
then
     for((i=0;i<y;i++))
      do
	z=$(echo "$balance*.005"| bc)
        balance=$(echo "$balance + $z" | bc )
	echo "$d           Interest                     $z                           $balance" >>pass/$f
done 
fi
done


