#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


CLEAN_SLATE=$($PSQL "truncate table teams, games;")

# filling the teams table 
# adding the team's names to the team table 
# a while loop that check if any team winner or opponent is there or not 
# only if it is not registered does it insert it
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
 if [[ $WINNER != 'winner' && $OPPONENT != 'opponent' ]]
 then 
 # checking if the team name exists
  WINNER_THERE=$($PSQL "select team_id from teams where name='$WINNER';")
  OPPONENT_THERE=$($PSQL "select team_id from teams where name='$OPPONENT';")
  
  #It does not exist 
  if [[ -z $WINNER_THERE ]] 
  then 
  # add it 
  WTEAM_INSERTED=$($PSQL "insert into teams (name) values ('$WINNER');")
  fi 

  #It does not exist 
  if [[ -z $OPPONENT_THERE ]] 
  then 
  # add it 
  OTEAM_INSERTED=$($PSQL "insert into teams (name) values ('$OPPONENT');")
  fi 

 fi

done 

# filling the games table 
# adding the team's names to the team table 
# a while loop that check if any team winner or opponent is there or not 
# only if it is not registered does it insert it
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 

if [[ $YEAR != 'year' ]]
then 
# gathering winner_id, and opponent id 
OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")

INSERT_ROW=$($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
fi

done


