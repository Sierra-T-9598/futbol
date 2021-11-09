module Fractionable
  def worst_ratio_shots_to_goals(season)
    games_in_question_array = games_played_in_season(season)
    games_in_question_hash = game_stats_by_team_id(season)
    goals_by_team_array = games_in_question_hash.map {|key, game| game.map {|stat| stat.goals.to_f}}
    total_goals = goals_by_team_array.map {|goal| goal.sum}
    shots_by_team_array = games_in_question_hash.map {|key, game| game.map {|stat| stat.shots.to_f}}
    total_shots = shots_by_team_array.map {|shot| shot.sum}

    team_id_array = games_in_question_array.map {|game| game.team_id}.uniq

    ratios_array = total_goals.zip(total_shots).map {|thing| thing.inject(:/)}
    ratios_by_team = Hash[team_id_array.zip(ratios_array)]
    min_ratio = ratios_by_team.key(ratios_by_team.values.min)
  end

  def best_ratio_shots_to_goals(season)
    games_in_question_array = games_played_in_season(season)
    games_in_question_hash = game_stats_by_team_id(season)
    goals_by_team_array = games_in_question_hash.map {|key, game| game.map {|stat| stat.goals.to_f}}
    total_goals = goals_by_team_array.map {|goal| goal.sum}
    shots_by_team_array = games_in_question_hash.map {|key, game| game.map {|stat| stat.shots.to_f}}
    total_shots = shots_by_team_array.map {|shot| shot.sum}

    team_id_array = games_in_question_array.map {|game| game.team_id}.uniq

    ratios_array = total_shots.zip(total_goals).map {|thing| thing.inject(:/)}
    ratios_by_team = Hash[team_id_array.zip(ratios_array)]
    min_ratio = ratios_by_team.key(ratios_by_team.values.min)
  end 
end
