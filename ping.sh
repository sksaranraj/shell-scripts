podcount=$(kmz get pods -n zts215 | grep Running | wc | awk '{ print $1 }')
servicelist=$(helm list -n bcs1zts | grep deployed | wc | awk '{ print $1 }')
echo "********************Checking the number of pod counts***********************"
echo ""
#checking the number of the pod count in the zts215 name space
if [[ "$podcount" -eq 114 ]]; then
    echo "$podcount is the number of pods running"
else
  echo "fail"
  echo "$podcount is the number of pods mismatch, Please check"
fi

echo ""
echo "********************Checking the helm service status************************"
#checking the number of the services deployed by helm in bcs1zts
if [[ "$servicelist" -eq 5 ]]; then
    echo "$servicelist services are in the deployed state"
else
  echo "fail"
  echo "$servicelist is mismatching please check"
fi

echo ""
echo "********************Checking the ping***************************************"
#to check the ping status of the IP------------work under progress

while ! ping -w 2 -c1 8.8.8.8 &>/dev/null
        do echo "Ping Fail - `date`"
        exit 0
done
echo "Host Found - `date`"