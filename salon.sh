#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICE_ID_1=$($PSQL "select service_id from services where service_id = 1" | sed -r 's/ *$|^ *//g')
  SERVICE_ID_2=$($PSQL "select service_id from services where service_id = 2" | sed -r 's/ *$|^ *//g')
  SERVICE_ID_3=$($PSQL "select service_id from services where service_id = 3" | sed -r 's/ *$|^ *//g')

  echo -e "\n$SERVICE_ID_1) Haircut\n$SERVICE_ID_2) Pedicure\n$SERVICE_ID_3) Massage"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SCHEDULE_APPOINTMENT 1 ;;
    2) SCHEDULE_APPOINTMENT 2 ;;
    3) SCHEDULE_APPOINTMENT 3 ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

SCHEDULE_APPOINTMENT() {
  #get service id from args
  SERVICE_ID=$1
  SERVICE_NAME=$($PSQL "select name from services where service_id = '$SERVICE_ID'" | sed -r 's/ *$|^ *//g')

  #get customer info
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
  
  # if not found
  if [[ -z $CUSTOMER_ID ]]
  then
    # get info for new customer, and overwrite the previous variable assignments
    echo -e "What is your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
  fi

  #Get appointment info
  echo -e "\nWhat time would you like to schedule your appointment?"
  read SERVICE_TIME
  INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(service_id, customer_id, time) values('$SERVICE_ID', '$CUSTOMER_ID', '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

} 



MAIN_MENU