terraformdestroy(){
    if terraform destroy --auto-approve
    then # destroy executed successfully
         echo >&2 "Successfully destroyed!"
         retval=1
    else
         echo >&2 "destroy failed!"
         retval=0
    fi
    return "$retval"
}

retval=0

while [ "$retval" == 0 ]
do
  terraformdestroy
done