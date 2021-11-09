require_relative './game'
require_relative './team'
require_relative './game_team'
require_relative './stat_tracker.rb'
require_relative './summable'
require_relative './hashable'
require_relative './averageable'
require_relative './fractionable'

class TeamManager

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

    def team_info(team_id)
      generate_team_info_hash(team_id)
    end

    def best_season(team)
      game_teams_team = @game_teams.select{|game_team| game_team.team_id == team}
      team_wins = game_teams_team.find_all{|game_team| game_team.result == "WIN"}
      winning_game_ids = team_wins.map{|game_team| game_team.game_id}
      winning_season_arrays = winning_game_ids.map{|id| season_from_game_id(id)}.flatten
      sorted_by_season = winning_season_arrays.group_by{|season| season}
      sorted_by_season.values.max_by{|array| array.length}[0]
    end

    def worst_season(team)
      game_teams_team = @game_teams.select{|game_team| game_team.team_id == team}
      team_wins = game_teams_team.find_all{|game_team| game_team.result == "WIN"}
      losing_game_ids = team_wins.map{|game_team| game_team.game_id}
      losing_season_arrays = losing_game_ids.map{|id| season_from_game_id(id)}.flatten
      sorted_by_season = losing_season_arrays.group_by{|season| season}
      sorted_by_season.values.min_by{|array| array.length}[0]
    end

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

end
