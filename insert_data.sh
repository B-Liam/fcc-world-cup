#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams");

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  
  WINNER_CHECK=$($PSQL "SELECT count(*) FROM teams WHERE name = '$WINNER'")
  OPPONENT_CHECK=$($PSQL "SELECT count(*) FROM teams WHERE name = '$OPPONENT'")

  if [[ $WINNER != "winner" ]]

    then
        if [[ $WINNER_CHECK = 0 ]]
          then
            INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
            echo $INSERT_TEAM
            echo Added $WINNER to Teams table;
          else
            echo Winner:$WINNER already exists
        fi

  fi

  if [[ $OPPONENT != "opponent" ]]

    then

      if [[ $OPPONENT_CHECK = 0 ]]
        then
          INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
          echo $INSERT_TEAM
          echo Added $OPPONENT to Teams table;
        else
          echo Opponent: $OPPONENT already exists
      fi

  fi

  #This retrieves the automatically generated IDs to insert into the games table
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

  echo Winner team_id is: $WINNER_ID, and Opponent team_id is: $OPPONENT_ID

  # This inserts the games into the games table
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS )")
  echo $INSERT_GAME_RESULT

done
