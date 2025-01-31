require_relative './game'
require_relative './team'
require_relative './game_team'
require_relative './stat_tracker.rb'
require_relative './summable'
require_relative './hashable'
require_relative './averageable'
require_relative './fractionable'

class League
  include Summable
  include Hashable
  include Averageable
  include Fractionable
  attr_reader :games,:teams,:game_teams

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
    team_name_from_id(best_ratio_shots_to_goals(season))
  end

  def least_accurate_team(season)
    team_name_from_id(worst_ratio_shots_to_goals(season))
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
end
