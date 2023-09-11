terraformapply(){
    if terraform apply --auto-approve
    then # apply executed successfully
         echo >&2 "Successfully applied!"
         retval=10
    else
         echo >&2 "Apply failed!"
         ((retval=retval+1))
    fi
}

retval=0

while [ "$retval" -lt 10 ]
do
  terraformapply
  echo >&2 "$retval"
done