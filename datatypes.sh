#!bin/bash

NAME=Sree
PHONE=9949504909
SKILL=("devops" "aws" "cicd")

echo " $NAME with $PHONE having skills ${SKILL[0]}"

if [ "${SKILL[0]}" == "devops" ] ; then


    echo "skill is devops"

fi
