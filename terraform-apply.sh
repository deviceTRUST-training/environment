terraformapply(){
    if terraform apply --auto-approve
    then # apply executed successfully
         echo >&2 "Successfully applied!"
         retval=10
    else
         echo >&2 "Apply failed!"
         retval=0
    fi
    ((retval=retval+1))
}

retval=0

while [ "$retval" < 10 ]
do
  terraformapply
done