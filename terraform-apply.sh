terraformapply(){
    if terraform apply --auto-approve
    then # apply executed successfully
         echo >&2 "Successfully applied!"
         retval=10
    else
         echo >&2 "Apply failed!"
         retval=0
    fi
}

retval=0

while [ "$retval" -lt 10 ]
do
  terraformapply
  ((retval=retval+1))
  echo >&2 "$retval"
done