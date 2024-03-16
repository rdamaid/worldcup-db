#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do

  if [[ $YEAR != year ]]
  then
  
    # get winner id
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")"

    # if not found
    if [[ -z $WINNER_ID ]]
    then

      # insert new team
      INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"

      # get new winner id
      WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")"
      
    fi

    # get opponent id
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"

    # if not found
    if [[ -z $OPPONENT_ID ]]
    then

      # insert new team
      INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"

      # get new opponent id
      OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"

    fi

    # insert the match into database
    INSERT_MATCH_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WGOALS, $OGOALS)")"
    if [[ $INSERT_MATCH_RESULT == "INSERT 0 1" ]]
    then
      echo "INSERT DATA $YEAR - $WINNER"
    fi
  
  fi
done