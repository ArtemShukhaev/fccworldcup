#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OP WGOALS OPGOALS
do
  if [[ $YEAR != "year" ]]
  then 
    TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")

    if [[ -z $TEAM_ID ]] 
    then
      INSTEAMRES=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSTEAMRES == "INSERT 0 1" ]]
      then 
        echo inserted into teams, $WINNER
      fi

      TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")

    fi

    TEAM_ID=$($PSQL "select team_id from teams where name='$OP'")

    if [[ -z $TEAM_ID ]] 
    then
      INSTEAMRES=$($PSQL "insert into teams(name) values('$OP')")
      if [[ $INSTEAMRES == "INSERT 0 1" ]]
      then 
        echo inserted into teams, $OP
      fi

      TEAM_ID=$($PSQL "select team_id from teams where name='$OP'")
    fi

    W_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    OP_ID=$($PSQL "select team_id from teams where name = '$OP'")
    
    INSGAMERES=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $W_ID, $OP_ID, $WGOALS, 
    $OPGOALS)")
    if [[ $INSGAMERES == "INSERT 0 1" ]]
    then 
      echo inserted into games, $WINNER vs $OP
    fi
  fi
done
