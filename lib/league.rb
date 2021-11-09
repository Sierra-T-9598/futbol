require_relative './game'
require_relative './team'
require_relative './game_team'
require_relative './stat_tracker.rb'
require_relative './summable'
require_relative './hashable'
require_relative './averageable'

class League
  include Summable
  include Hashable
  include Averageable
  attr_reader :games,
              :teams,
              :game_teams

  def initialize(data)
    @games = data[:games]
    @teams = data[:teams]
    @game_teams = data[:game_teams]
  end

  def highest_total_score
    sum_of_goals_each_game.max
  end

  def lowest_total_score
    sum_of_goals_each_game.min
  end

  def count_of_teams
    @teams.count
  end

  def percentage_home_wins
    home_games = @game_teams.find_all do |game_team|
      game_team.home_or_away["home"]
    end
    home_game_wins = @game_teams.find_all do |game_team|
      game_team.home_or_away["home"] && game_team.result == "WIN"
    end
    ((home_game_wins.length.to_f)/(home_games.length.to_f)).round(2)
  end

  def percentage_visitor_wins
    away_games = @game_teams.find_all do |game_team|
      game_team.home_or_away["away"]
    end
    away_game_wins = @game_teams.find_all do |game_team|
      game_team.home_or_away["away"] && game_team.result["WIN"]
    end
    ((away_game_wins.length.to_f)/(away_games.length.to_f)).round(2)
  end

  def percentage_ties
    tie_games = @game_teams.select {|game| game.result == "TIE"}
    ((tie_games.uniq.count / 2.0) / (@game_teams.count / 2.0)).round(2)
  end

  def count_of_games_by_season
    games_by_season = @games.group_by {|game| game.season}
    games_by_season.transform_values! {|value| value.count}
  end

  def average_goals_per_game
    ((sum_of_goals_each_game.sum.to_f) / (@game_teams.uniq {|game_team| game_team.game_id}.length.to_f)).round(2)
  end

  def average_goals_by_season
    goals = []
    games_by_season = @games.group_by {|game| game.season}

    goals << away = games_by_season.map {|season, game| game.map {|game| game.away_goals.to_f}.inject(:+)}
    goals << home = games_by_season.map {|season, game| game.map {|game| game.home_goals.to_f}.inject(:+)}
    total_games_season = games_by_season.map {|season, game| game.map {|game| game.game_id}.count}
    goals_array = goals.transpose.map(&:sum)
    average_goals_per_game_season = goals_array.zip(total_games_season).map {|thing| thing.inject(:/).round(2)}
    average_goals_by_season_hash = Hash[games_by_season.keys.zip(average_goals_per_game_season)]
  end

  def best_offense
    team_id = averaging_hash.key(averaging_hash.values.max)
    team_name_from_id(team_id)
  end

  def worst_offense
    team_id = averaging_hash.key(averaging_hash.values.min)
    team_name_from_id(team_id)
  end

  def highest_scoring_home_team
    team_id = home_team_goals_per_game_avg.key(home_team_goals_per_game_avg.values.max)
    team_name_from_id(team_id)
  end

  def highest_scoring_visitor
    team_id = away_team_goals_per_game_avg.key(away_team_goals_per_game_avg.values.max)
    team_name_from_id(team_id)
  end

  def lowest_scoring_visitor
    team_id = away_team_goals_per_game_avg.key(away_team_goals_per_game_avg.values.min)
    team_name_from_id(team_id)
  end

  def lowest_scoring_home_team
    team_id = home_team_goals_per_game_avg.key(home_team_goals_per_game_avg.values.min)
    team_name_from_id(team_id)
  end

  def winningest_coach(season)
    games_played_in_season(season)
    games_played_by_coach = games_played_in_season(season).group_by {|game| game.head_coach}
    number_of_games_coached = games_played_by_coach.transform_values {|value| value.count}
    games_won = games_played_by_coach.transform_values {|value| value.select {|game| game.result == "WIN"}}.transform_values {|value| value.count}
    combined_average = number_of_games_coached.merge(games_won){|key, games_played, games_won| games_won.to_f / games_played.to_f}
    coach_name = combined_average.key(combined_average.values.max)
  end

  def worst_coach(season)
    games_played_in_season(season)
    games_played_by_coach = games_played_in_season(season).group_by {|game| game.head_coach}
    number_of_games_coached = games_played_by_coach.transform_values {|value| value.count}
    games_won = games_played_by_coach.transform_values {|value| value.select {|game| game.result == "WIN"}}.transform_values {|value| value.count}
    combined_average = number_of_games_coached.merge(games_won){|key, games_played, games_won| games_won.to_f / games_played.to_f}
    coach_name = combined_average.key(combined_average.values.min)
  end

  def most_accurate_team(season)
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
    team_name_from_id(min_ratio)
  end

  def least_accurate_team(season)
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
    team_name_from_id(min_ratio)
    # require "pry"; binding.pry
  end

  def most_tackles(season)
    team_tackles_totals = game_stats_by_team_id(season).transform_values{|values| values.map{|game_team| game_team.tackles.to_i}.inject(:+)}
    team_id = team_tackles_totals.key(team_tackles_totals.values.max)
    team_name_from_id(team_id)
  end

  def fewest_tackles(season)
    team_tackles_totals = game_stats_by_team_id(season).transform_values{|values| values.map{|game_team| game_team.tackles.to_i}.inject(:+)}
    team_id = team_tackles_totals.index(team_tackles_totals.values.min)
    team_name_from_id(team_id)
  end

   def team_info(team_id)
    team_keys = ["team_id", "franchise_id", "team_name", "abbreviation", "link"]
    team_values = []
    teams_by_team_id = @teams.group_by {|team| team.team_id}
    team_in_question = teams_by_team_id.keep_if {|key, value| key == team_id}
    team_values << team_in_question.map {|key, team| team.map {|team| team.team_id}}.flatten
    team_values << team_in_question.map {|key, team| team.map {|team| team.franchise_id}}.flatten
    team_values << team_in_question.map {|key, team| team.map {|team| team.team_name}}.flatten
    team_values << team_in_question.map {|key, team| team.map {|team| team.abbreviation}}.flatten
    team_values << team_in_question.map {|key, team| team.map {|team| team.link}}.flatten
    team_values_array = team_values.flatten
    team_info_hash = Hash[team_keys.zip(team_values_array)]
  end

  def best_season(team)
    game_teams_team = @game_teams.select{|game_team| game_team.team_id == team}
    team_wins = game_teams_team.find_all{|game_team| game_team.result == "WIN"}
    winning_game_ids = team_wins.map{|game_team| game_team.game_id}
    winning_season_arrays = winning_game_ids.map{|id| season_from_game_id(id)}.flatten
    sorted_by_season = winning_season_arrays.group_by{|season| season}
    sorted_by_season.values.max_by{|array| array.length}[0]
  end

  # def worst_season(team)
  #   game_teams_team = @game_teams.select{|game_team| game_team.team_id == team}
  #   team_wins = game_teams_team.find_all{|game_team| game_team.result == "WIN"}
  #   losing_game_ids = team_wins.map{|game_team| game_team.game_id}
  #   losing_season_arrays = losing_game_ids.map{|id| season_from_game_id(id)}.flatten
  #   sorted_by_season = losing_season_arrays.group_by{|season| season}
  #   sorted_by_season.values.min_by{|array| array.length}[0]
  # end

  def average_win_percentage(team)
    total_games = @game_teams.select {|game_team| game_team.team_id == team}
    total_wins = total_games.select {|game| game.result["WIN"]}
    average(total_wins.count, total_games.count)
  end

  def most_goals_scored(team)
    team_games = @game_teams.select{|game_team| game_team.team_id == team}
    goals = team_games.map{|game_team| game_team.goals.to_i}
    goals.max
  end

  def fewest_goals_scored(team)
    team_games = @game_teams.select{|game_team| game_team.team_id == team}
    goals = team_games.map{|game_team| game_team.goals.to_i}
    goals.min
  end

  def favorite_opponent(team)
    games_by_game_id = @games.select do |game|
      if game.home_team_id == team || game.away_team_id == team
       game.game_id
       end
     end
     games_vs_opponent = games_by_game_id.map {|game_id| @game_teams.select {|game| game.game_id == game_id.game_id}}
     total_games_lost = games_vs_opponent.flatten.keep_if {|game| game.result == "WIN" || game.result == "TIE" && game.team_id != team}
     total_losses_by_name = total_games_lost.map {|game| team_name_from_id(game.team_id)}
     grouped_losses = total_losses_by_name.group_by{ |x| x }.values
     grouped_losses.min_by{|array| array.length}[0]
     #sorted_by_season.values.max_by{|array| array.length}[0]
     # team_id = total_losses_by_id.key(total_losses_by_id.values.max)
     # team_name_from_id(team_id)
  end

  def rival(team)
    games_by_game_id = @games.select do |game|
      if game.home_team_id == team || game.away_team_id == team
       game.game_id
       end
     end
     games_vs_opponent = games_by_game_id.map {|game_id| @game_teams.select {|game| game.game_id == game_id.game_id}}

     total_games_won = games_vs_opponent.flatten.keep_if {|game| game.result == "WIN" && game.team_id != team}
     total_games_played = games_vs_opponent.flatten.keep_if {|game| game.result == "WIN" || game.result == "LOSS" && game.team_id != team}

     total_wins_by_name = total_games_won.map {|game| team_name_from_id(game.team_id)}
     total_games_played_by_name = total_games_played.map {|game| team_name_from_id(game.team_id)}

     grouped_wins = total_wins_by_name.group_by{ |x| x }.values
     grouped_games = total_games_played_by_name.group_by{ |x| x }.values
     require "pry"; binding.pry

     #grouped_.max_by{|array| array.length}[0]
     # team_id = total_losses_by_id.key(total_losses_by_id.values.max)
     # team_name_from_id(team_id)
   end
end
