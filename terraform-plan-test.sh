terraformplan(){
    if terraform plan
    then # Plan executed successfully
         echo >&2 "Successfully planned!"
         retval=1
    else
         echo >&2 "Plan failed!"
         retval=0
    fi
    return "$retval"
}

retval=0

while [ "$retval" == 0 ]
do
  terraformplan
done