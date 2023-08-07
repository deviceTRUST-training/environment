terraformplan(){
    if terraform plan
    then # Plan executed successfully
         echo >&2 "Successfully planned!"
         retval=0
    else
         echo >&2 "Plan failed!"
         retval=1
    fi
    return "$retval"
}

terraformplan
retval=$?
if [ "$retval" == 0 ]
then
     echo "Successfully planned! lala"
else
     echo "Plan failed! lala"
fi