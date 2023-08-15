terraformapply(){
    if terraform apply --auto-approve
    then # apply executed successfully
         echo >&2 "Successfully applied!"
         retval=1
    else
         echo >&2 "Apply failed!"
         retval=0
    fi
    return "$retval"
}

retval=0

while [ "$retval" == 0 ]
do
  terraformapply
done