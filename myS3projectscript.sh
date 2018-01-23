#!/bin/bash

read -p "do you want to confiigure Aws [ yes=1 or enter ]" f

while [ "$f" == 1 ]
do
aws configure
aws s3 mb s3://test1234566789 2> mb.txt
if [ $? = 0 ]
then
echo " configured successfully "
break
else
echo " fail to configure "
fi
read -p "press ctrl+c to exit and enter to try again " f
done




while true

do
read -p "select a operation to be performed  |||list bucket content ->buckcontent,  copy -> copy , move -> move ,  sync -> sync , makebucket -> make , deletebucket -> del , listbucket -> list , emptybucket -> embuck ||| " a


if [ "$a" ==  "list" ]
then
echo "***************************************************"
echo " `aws s3 ls` "
echo "*************************************************"

elif [ "$a" == "embuck" ]
then
echo "****************************************************"
read -p " enter the bucket name which has to be flush " fbuc

aws s3 rm s3://$fbuc --recursive

echo "***********************************************************"



elif [ "$a" == "del" ]
then
read -p "enter the bucket name to be deleted " delb
echo "***************************************************"

aws s3 rb s3://$delb --force
echo " ***********************************************************"
elif [ "$a" == "make" ]
then
read -p "enter a unique bucket name " buckname
echo "***************************************************"

aws s3 mb s3://$buckname
echo "*****************************************************************"

elif [ "$a" == "copy" ]
then
#read -p "select a option to copy | s3 -> localPath (s32l) , local -> s3 (l2s3) , s3 -> s3 (s32s3) | " v
while true
do
read -p "select a option to copy | s3 -> localPath (s32l) , local -> s3 (l2s3) , s3 -> s3 (s32s3) | " v

case $v in
        s32l)    read -p "enter s3 bucket name " s3b
                read -p "enter local path " lop

                aws s3 cp s3://$s3b  $lop --recursive  ; break ;;
        l2s3) read -p "enter local path locaton" lp
                read -p "enter a bucket name " bn
                aws s3 cp $lp s3://$bn --recursive ; break ;;
        s32s3) read -p "enter source bucket name " sb
                read -p "enter destination bucket name " dbn
                 aws s3 cp s3://$sb s3://$dbn --recursive ; break ;;
         *) echo "invalid input try again"; break;;


esac
done

elif [ "$a" == "sync" ]
then
while true
do
read -p " sync between local storage -> s3 (lsss3) , s3 -> local storage (s3lss) , s3 -> s3 (s3ss3) " sy
case $sy in
        lsss3) read -p "enter local path location " lsl
                read -p "enter  destination s3 bucket name " s3b
                aws s3 sync $lsl s3://$s3b ; break ;;
        s3lss) read -p "enter bucket name " bckn
                read -p "enter local path " lpth
                aws s3 sync s3://$bckn $lpth ; break ;;
        s3ss3) read -p "enter bucket name " s3b1


                read -p "enter destination buck name " dbn
                aws s3 s3://$s3b1 s3://$dbn ; break ;;
        *) echo "invalid input "; break ;;


esac
done


elif [ "$a" == "move" ]
then
while true
do

read -p " move bucket or object | local -> s3 {lms3) , s3 - > s3 (s3ms3) , s3 -> local (s3ml) | " mov

case $mov in
        lms3) read -p "enter local storage source to b moved " lsm
                read -p "enter s3 bucket name destination " sbm
        aws s3 mv $lsm s3://$sbm --recursive ; break ;;

        s3ml) read -p " enter s3 bucket source to be moved " sbs
                read -p "enter local destination location " lmd
        aws s3 mv s3://$sbs $lmd --recursive ; break ;;

        s3ms3) read -p " enter source bucket location to be moved " s3ms3
                read -p "enter destination bucket location " ds3m
        `aws s3 mv s3://$s3ms3 s3://$ds3m --recursive`   ; break;;
        *) echo "invalid input try again " ; break ;;


esac

done

elif [ "$a" == "buckcontent" ]
then
read -p " enter the bucket name to be listed " buckname
echo " ********************************************** "

aws s3 ls s3://$buckname
echo " ************************************************* "
else
echo " ********************************************************************************** "
echo "INVALID INPUT"
echo " ************************************************************************************ "

fi
done
