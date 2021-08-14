#Spawn searches

How to use the script:

- Download the script
- Fix encoding issues by running the following command:  sed -i 's/\r//' spawnSearchesV1.sh
- This script requires 5 arguments to run
- startSearchId = The search id number of the search where you want to start"
- numberOfSearchesToSpawn = The number of searches you want to spawn Example: Start SearchId=1000000+numberOfSearchesToSpawn=100 = final search id 1000001"
- isLocalSearch = boolean value, false for peer searches true for local"
- searchTimeOut = the timeout of a search, default value might be 6000000" (10 min)
- HOST_IP = the ip of the box you want to send the events"
- In the following order ./spawnSearchesV1.sh StartSearchId numberOfSearchesToSpawn isLocalSearch searchTimeOut HOST_IP
- Example: ./spawnSearchesV1.sh 1000000 100 true 600000 <targetHost>

CAVEAT: you must run this script in the machine where you want to send the events, (it will be part of a future improvement to run it everywhere)
