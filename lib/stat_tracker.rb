require 'csv'
# require_relative 'pry'
require_relative './game'
require_relative './team'
require_relative './game_team'
require_relative './league'


class StatTracker
  attr_reader :league

  def initialize(locations)
    games = CSV.parse(File.read(locations[:games]), headers: true).map {|row| Game.new(row)}
    teams = CSV.parse(File.read(locations[:teams]), headers: true).map {|row| Team.new(row)}
    game_teams = CSV.parse(File.read(locations[:game_teams]), headers: true).map {|row| GameTeam.new(row)}

    @league = League.new({games: games, teams: teams, game_teams: game_teams})
  end

  def self.from_csv(locations)
     StatTracker.new(locations)
  end

  def highest_total_score
    @league.highest_total_score
  end

  def lowest_total_score
    @league.lowest_total_score
  end

  def percentage_home_wins
    @league.percentage_home_wins
  end

  def percentage_visitor_wins
    @league.percentage_visitor_wins
  end

  def percentage_ties
    @league.percentage_ties
  end

  def count_of_games_by_season
    @league.count_of_games_by_season
  end

  def average_goals_per_game
    @league.average_goals_per_game
  end

  def average_goals_by_season
    @league.average_goals_by_season
  end

  def count_of_teams
    @league.count_of_teams
  end

  def best_offense
    @league.best_offense
  end

  def worst_offense
    @league.worst_offense
  end

  def most_tackles(season)
    @league.most_tackles(season)
  end

  def fewest_tackles(season)
    @league.fewest_tackles(season)
  end

  def highest_scoring_home_team
    @league.highest_scoring_home_team
  end

  def highest_scoring_visitor
    @league.highest_scoring_visitor
  end

  def lowest_scoring_visitor
    @league.lowest_scoring_visitor
  end

  def lowest_scoring_home_team
    @league.lowest_scoring_home_team
  end

  def most_accurate_team(season)
    @league.most_accurate_team(season)
  end

  def least_accurate_team(season)
    @league.least_accurate_team(season)
  end

  def team_info(team_id)
    @league.team_info(team_id)
  end

  def most_goals_scored(team)
    @league.most_goals_scored(team)
  end

  def fewest_goals_scored(team)
    @league.fewest_goals_scored(team)
  end
end
