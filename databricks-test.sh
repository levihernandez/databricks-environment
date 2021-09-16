%sh 

##############################################################################
# Test if any of the syntax below fails:
# Please toggle the dbdriver to TRUE and ${DB_IS_DRIVER}
# Run both times to see which 'if/else' syntax breaks
##############################################################################
dbdriver=TRUE
# dbdriver=${DB_IS_DRIVER}

# Function will produce sections for the output format
pr(){
  printf "\n"
  printf %60s"\n" |tr " " "="
  printf "   ${message}\n"
  printf %60s"\n" |tr " " "="
}

message="Test 'if/else' operators"
pr ${message}

# Julian detected that this statement would fail if DB_IS_DRIVER does not exist
sy='[ ${dbdriver}  = "TRUE" ]'
if [ ${dbdriver}  = "TRUE" ]; then
  echo "This spark host is the driver 1: ${dbdriver} >>> " ${sy}

else
  echo "Not the driver 1: ${dbdriver} >>> " ${sy}
fi

# Recommended approach
sy='[ "${dbdriver}"  = "TRUE" ]'
if [ "${dbdriver}"  = "TRUE" ]; then
  echo "This spark host is the driver 2: ${dbdriver} >>> " ${sy}
else
  echo "Not the driver 2: ${dbdriver} >>> " ${sy}
fi

sy='[ ${dbdriver} ]'
if [ ${dbdriver} ]; then
  echo "This spark host is the driver 3: ${dbdriver} >>> " ${sy}
else
  echo "Not the driver 3: ${dbdriver} >>> " ${sy}
fi

sy='[[ "${dbdriver}" == "TRUE" ]]'
if [[ "${dbdriver}" == "TRUE" ]]; then
  echo "This spark host is the driver 4: ${dbdriver} >>> " ${sy}
else
  echo "Not the driver 4: ${dbdriver} >>> " ${sy}
fi

# Recommended approach
sy='[[ ${dbdriver} == "TRUE" ]]'
if [[ ${dbdriver} == "TRUE" ]]; then
  echo "This spark host is the driver 5: ${dbdriver} >>> " ${sy}
else
  echo "Not the driver 5: ${dbdriver} >>> " ${sy}
fi

# Julian uses this in the script
sy='[[ ${dbdriver} = "TRUE" ]]'
if [[ ${dbdriver} = "TRUE" ]]; then
  echo "This spark host is the driver 6: ${dbdriver} >>> " ${sy}
else
  echo "Not the driver 6: ${dbdriver} >>> " ${sy}
fi


message="GET IP: extract ip from different locations"
pr ${message}
echo "GET \$SPARK_LOCAL_IP from env: ${SPARK_LOCAL_IP}"
echo "GET "$(cat /tmp/custom-spark.conf | grep "spark.driver.host")
echo "GET 'cluster ip' from 'env': " $(env | grep SUDO_COMMAND | cut -f17 -d " " | awk '{print "cluster_ip:" $1}')


message=" GET SPARK UI PORT: extract port from different locations"
pr ${message}
echo "GET master-params port: " $(cat /tmp/master-params | cut -d' ' -f2)
echo "GET driver-env.sh CONF_UI_PORT port: " $(grep -i "CONF_UI_PORT" /tmp/driver-env.sh | cut -d'=' -f2)
echo "GET JAVA_OPTS Dspark.ui.port: " $(env | grep JAVA_OPTS | sed 's/.*Dspark.ui.port=\([^ ]*\).*/\1/')
echo "GET driver-env.sh Dspark.ui.port: " $(cat /tmp/driver-env.sh | grep "CONF_DRIVER_JAVA_OPTS" | sed 's/.*Dspark.ui.port=\([^ ]*\).*/\1/')
echo "GET 'spark ui port' from 'env':" $(env | grep SUDO_COMMAND | cut -f18 -d " " | awk '{print "spark_ui_port:" $1}')


message="GET HOST INFO: extract driver & worker info"
pr ${message}
echo "GET JAVA_OPTS Ddatabricks.serviceName: " $(env | grep JAVA_OPTS | sed 's/.*Ddatabricks.serviceName=\([^ ]*\).*/\1/')
echo "GET 'cluster id' from 'env': " $(env | grep SUDO_COMMAND | cut -f3 -d " " | awk '{print "cluster_id:"$1}')

message="GET DATADOG SPARK URL: extract IP & Port info"
pr ${message}
echo "GET Datadog Spark Config YAML:" $(sudo cat /etc/datadog-agent/conf.d/spark.d/conf.yaml)
