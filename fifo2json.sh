#!/bin/ash

# JSON_FILE,StatusCode,PAC,UAC,UDC,Temperature,Timestamp,DeviceId,DAY_ENERGY
gen_json() 
{
   JSON_FILE=$1
   StatusCode=$2
   PAC=$3
   UAC=$4
   UDC=$5
   Temperature=$6
   Timestamp=$7
   DeviceId=$8
   DAY_ENERGY=$9
   echo -n "{\"Body\": {\"Data\": {\"DeviceStatus\": {\"StatusCode\": ${StatusCode} }," > $JSON_FILE
   echo -n "\"PAC\": { \"Unit\": \"W\", \"Value\": ${PAC} }, \"UAC\": { \"Unit\": \"V\",\"Value\": ${UAC} }" >> $JSON_FILE
   echo -n ", \"UDC\": { \"Unit\": \"V\",\"Value\": ${UDC} }, \"DAY_ENERGY\": { \"Unit\": \"Ws\",\"Value\": ${DAY_ENERGY} }" >> $JSON_FILE
   echo -n ", \"Temperature\": { \"Unit\": \"C\", \"Value\": ${Temperature} }" >> $JSON_FILE
   echo -n "} },\"Head\": {\"RequestArguments\": {\"DataCollection\": \"CommonInverterData\",\"DeviceClass\": \"Inverter\"," >> $JSON_FILE
   echo -n "\"DeviceId\": \"${DeviceId}\", \"Scope\": \"Device\" }, \"Status\": { \"Code\": 0, \"Reason\": \"\", \"UserMessage\": \"\" }," >> $JSON_FILE
   echo "\"Timestamp\": \"${Timestamp}\" } }" >> $JSON_FILE
}
 
if [ "$#" -lt 3 ]; then
 echo "fifo2json.sh fifo json InverterNo BigLog"
 exit 1
elif [ "$3" = "1" ]; then
 ENERGY_SUM=/tmp/energy_sum1.txt
elif [ "$3" = "2" ]; then
 ENERGY_SUM=/tmp/energy_sum2.txt
else
 echo Invalid inverter number.
 exit 1
fi

FIFO_FILE=$1
JSON_FILE=$2

if [ ! -p "$FIFO_FILE" ]; then
 rm -f $FIFO_FILE
 mkfifo $FIFO_FILE
fi

if [ -z "$4" ]; then 
 BIG_LOG=/dev/null
else
 BIG_LOG=$4
fi

if [ ! -f "$ENERGY_SUM" ]; then
 echo "0.0" > $ENERGY_SUM 
 if [ ! "$?" -eq 0 ]; then
  echo Error initializing ENERGY_SUM
  exit 1
 fi
fi

while true; do
 
 v1=0;v2=0;v3=0;v4=0;v5=0;v6=0
 while [ -z "$v1" ] || [ "$v1" -eq 0 ]; do
  read -t 3 v1 v2 v3 v4 v5 v6 < $FIFO_FILE
 done

  STATUS_LINE="Data: ${v1}-${v2}-${v3}-${v4}-${v5}-${v6}"

  echo $STATUS_LINE>>$BIG_LOG
 
  Timestamp=`date +"%Y-%m-%dT%H:%M:%S%z"`
  
  StatusCode=`echo $((($v1&240)>>4))`

  # CRC by Fronius: Upper 5 bits of v6 equals upper 5 bits of (SUM(v1 .. v5) mod 256)
  CheckSum=`echo $(((($v1+$v2+$v3+$v4+$v5)%256)>>3))`
 
  if [ "$StatusCode" = 1  ]; then

   CheckSumFromV6=`echo $(($v6>>3))`

   if [ "$CheckSum" = "$CheckSumFromV6" ]; then
    # AC power in watts during last 4.8 secs
    PAC=`printf '%.3f' "$(echo "scale=3; $v2 * 110 / 8" | bc -l)"`
    read DAY_ENERGY < $ENERGY_SUM
    # Add up AC energy in watt seconds
    v7=`printf '%.1f' "$(echo "scale=1;${DAY_ENERGY}+(${PAC}*48/10)" | bc -l)"`
    DAY_ENERGY=$v7
    echo $DAY_ENERGY > $ENERGY_SUM
    # AC voltage
    UAC=$v4
    # DC/solar voltage
    UDC=$v3
    # Inverter temperature
    Temperature=`printf '%.1f' "$(echo "scale=1;($v5-180)*3/2" | bc -l)"`
    # Device id/number as configured on inverter
    DeviceId=$(($v1&15))
   
    gen_json $JSON_FILE $StatusCode $PAC $UAC $UDC $Temperature $Timestamp $DeviceId $DAY_ENERGY

    echo "$STATUS_LINE Normal Operation. Checksum $v6 correct."
   else
    rm -f $JSON_FILE
    echo "$STATUS_LINE Error 4: Checksum Error, $CheckSum unequal $CheckSumFromV6"
   fi
 
  elif [ "$StatusCode" = 2 ]; then
   # Indication of inverter shutdown
   echo "$STATUS_LINE Possible StatusCode 2 ..."
   read DAY_ENERGY < $ENERGY_SUM
   gen_json $JSON_FILE $StatusCode 0 0 0 "" $Timestamp $DeviceId $DAY_ENERGY
   sleep 30
   rm $JSON_FILE
   echo Shutdown. JSON deleted.

  else
   echo "$STATUS_LINE Unknown StatusCode ..."
   sleep 3
  fi

done

exit 0
