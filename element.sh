#!/bin/bash

# for retrieving elements' properties

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


# if arg1
if [[ $1 ]]
then
  # if arg1 not a number
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    # get atomic number from symbol or name
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")

    # if symbol or name not exist
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo -e "I could not find that element in the database."

    # if element exist
    else
      # get symbol & name
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
      # get properties for this element
      TYPE=$($PSQL "SELECT types.type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

      # display
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    fi
  
  # if arg1 a number
  else
    # get symbol or name
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")

    # if atomic number not exist
    if [[ -z $SYMBOL ]]
    then
      echo -e "I could not find that element in the database."

    # if atomic exist
    else
      # get properties for this element
      TYPE=$($PSQL "SELECT types.type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$1")
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")

      # display
      echo -e "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    fi
  fi

# if no argument 
else
  echo -e "Please provide an element as an argument."
fi
