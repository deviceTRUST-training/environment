terraformdestroy(){
    if terraform destroy --auto-approve
    then # destroy executed successfully
         echo >&2 "Successfully destroyed!"
         retval=1
    else
         echo >&2 "Destroy failed!"
         retval=0
    fi
    return "$retval"
     ((retval=retval+1))
}

retval=0

while [ "$retval" < 10 ]
do
  terraformdestroy
done