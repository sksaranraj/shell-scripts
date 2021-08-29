#!/bin/bash
echo "alias kmz='kubectl'" >> ~/.bash_aliases
shopt -s expand_aliases
source ~/.bash_aliases

echo "***********************************2.1.1	Check LDAPDISP & HSSCALLP & HLRCALLP pods status********************************************"


for each in $(kubectl get pods --field-selector=status.phase=Running -n hsshlr01 | grep -e "hlrcallp" -e "ldapdisp" | awk '{ print $2 }');
do
  if [[ "$each" == "5/5" ]]; then
  echo ""
  echo ""
  else
    echo "!!!!!!!!!There are some containers not running"
  fi
done

echo "************************************2.1.2	Check running processes in LDAPDISP pods****************************************************"
for each in $(kubectl get pods -n hsshlr01 -o=name | grep ldapdisp | sed "s/^.\{4\}//");
do
  echo " Please Enter **status1** as the value"
  kubectl -it exec $each -n hsshlr01 -- bash 
  echo ""
  echo ""
done

echo "************************************2.1.3	Check running processes in HSSCALLP pods*****************************************************"
for each in $(kubectl get pods -n hsshlr01 -o=name | grep hsshlr01usw2d-hsscallp | sed "s/^.\{4\}//");
do
  echo "You are logged into the pod $each"
  echo " Please Enter **status1** as the value and at last give command as **exit**"
  kubectl -it exec $each -n hsshlr01 -- bash 
  echo ""
  echo ""
done

echo "************************************2.1.4	Check running processes in HLRCALLP pods ****************************************************"
for each in $(kubectl get pods -n hsshlr01 -o=name | grep hsshlr01usw2d-hlrcallp | sed "s/^.\{4\}//");
do
  echo "You are logged into the pod $each"
  echo " Please Enter **status1** as the value and at last give command as **exit**"
  kubectl -it exec $each -n hsshlr01 -- bash 
  kubectl -it exec $each -n hsshlr01 -- bash 
  echo ""
  echo ""
done

echo "************************************2.1.5	Check LDAP connections between HSS/HLR and UDR in LDAPDISP pods ***************************"
for each in $(kubectl get pods -n hsshlr01 -o=name | grep hsshlr01usw2d-ldapdisp | sed "s/^.\{4\}//");
do
  kubectl -it exec $each -n hsshlr01 -- bash -c "netstat -an  | grep 16611"
  echo ""
  echo ""
done

echo ""
echo ""
echo ""
echo "===========================================2.2 HSS with DRA======================================================================="

kubectl get pods -n hsshlr01usw2d | grep "hsshlr01usw2d-dlb"


echo "************************************2.2.2	Check running processes on DLB pods*****************************************************"
for each in $(kubectl get pods -n hsshlr01usw2d -o=name | grep hsshlr01usw2d-dlb | sed "s/^.\{4\}//");
do
  kubectl -it exec $each -n hsshlr01usw2d -- bash -c "status1"
  echo ""
  echo ""
done

echo "************************************2.2.3	Check DIAMETER connection with DRA*****************************************************"
for each in $(kubectl get pods -n hsshlr01usw2d -o=name | grep hsshlr01usw2d-dlb | sed "s/^.\{4\}//");
do
  kubectl -it exec $each -n hsshlr01usw2d -- bash -c "netstat -anp | grep 3868"
  echo ""
  echo ""
done


echo "===========================================2.3 HSS with UDM======================================================================="


echo "************************************2.3.1	Check HTTP2LB pod status*****************************************************"

kubectl get pods -n hsshlr01usw2d

echo "************************************2.3.2	Check HTP2 conection with UDM*****************************************************"
for each in $(kubectl get pods -n hsshlr01usw2d -o=name | grep hsshlr01usw2d-dlb | sed "s/^.\{4\}//");
do
  kubectl -it exec $each -n hsshlr01usw2d -- bash -c "netstat -an | grep 8080"
  echo ""
  echo ""
done