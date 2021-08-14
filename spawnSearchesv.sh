#!/bin/bash

#This script was created to work properly on appliances
#If you want to use software for this, you should change the psql path.
#You must be logged with your user in the UI

if [[ "$1" = "" || "$2" = "" || "$3" = "" || "$4" = "" || "$5" = "" ]]; then
   echo -e "\n[WARNING] You must specify the StartSearchId numberOfSearchesToSpawn isLocalSearch searchTimeOut HOST_IP"
   echo -e "\n[INFO] Example ./script 1000000 100 true 60000 15.214.X.X\n"

   echo -e "\n\n*****************************************************************************************************\n"
   echo -e "[1st argument] startSearchId = The search id number of the search where you want to start"
   echo -e "[2nd argument] numberOfSearchesToSpawn = The number of searches you want to spawn Example: Start SearchId=1000000+numberOfSearchesToSpawn=100 = final search id 1000001"
   echo -e "[3rd argument] isLocalSearch = boolean value, false for peer searches true for local"
   echo -e "[4th argument] searchTimeOut = the timeout of a search, default value might be 60000"
   echo -e "[5th argument] HOST_IP = the ip of the box you want to send the events"
   echo -e "\n****************************************************************************************************\n\n"
   exit
fi

#VARIABLES
START_SEARCH_ID=$1
MAX_SEARCHES=$2
IS_LOCAL=$3
SEARCH_TIMEOUT=$4
HOST_IP=$5
query="deviceVendor is not null"
#appliance path
PSQL_PATH=/opt/local/pgsql/bin/psql
#Software path - Under /opt/logger install
#PSQL_PATH=/opt/logger/current/arcsight/bin/psql
session_string=`$PSQL_PATH rwdb web -t -c "select session_string from sessions limit 1" | tr -d ' ' | tr --d '\n'`
FINAL_SEARCH_ID=$(($START_SEARCH_ID+$MAX_SEARCHES))
current_search_id=$START_SEARCH_ID

echo -e "\n\n[INFO] Checking variables..."
echo -e "[*] Start search ID: $START_SEARCH_ID"
echo -e "[*] Max searches to spawn: $MAX_SEARCHES"
echo -e "[*] Is local search: $IS_LOCAL"
echo -e "[*] Search Time Out: $SEARCH_TIMEOUT"
echo -e "[*] Target host ip: $HOST_IP"
echo -e "[*] Query: $query"
echo -e "[*] Expected final search id: $FINAL_SEARCH_ID"
echo -e "[*] User session ID found in the DB: $session_string"

echo -e "\n\n[WARNING] Are those parameters looking good?\n"
read -p ' Type 1 to continue Type 9 to exit   ' action

if [ -z $action ]; then
    echo -e "\n[*] Inputs cannot be blank please try again!"
    exit 0
fi

if [ "$action" == "1" ]; then
    echo -e "\n[INFO] Let's continue"
else
    echo -e "\n[INFO] Exiting..."
    exit
fi


while [ $current_search_id -le $FINAL_SEARCH_ID ]; do  
    echo "Spawning search id: $current_search_id"
    postDataJSON="{\"user_session_id\":\"$session_string\",\"search_session_id\":$current_search_id,\"local_search\":$IS_LOCAL,\"query\":\"$query\",\"timeout\":$SEARCH_TIMEOUT}"
    curl --noproxy $HOST_IP -k --location -X POST -d "$postDataJSON" https://$HOST_IP:443/server/search --header 'Content-Type: application/json' &
    current_search_id=$(($current_search_id+1))
done