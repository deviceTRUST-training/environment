terraformdestroy(){
    if terraform destroy --auto-approve
    then # destroy executed successfully
         echo >&2 "Successfully destroyed!"
         retval=10
    else
         echo >&2 "Destroy failed!"
         ((retval=retval+1))
    fi
    return "$retval"     
}

retval=0

while [ "$retval" -lt 10 ]
do
  terraformdestroy  
  echo >&2 "$retval"
done