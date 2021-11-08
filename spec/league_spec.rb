require "./lib/league.rb"
require './lib/stat_tracker.rb'

RSpec.describe League do
  game_path = './data/games_dummy.csv'
  team_path = './data/teams_dummy.csv'
  game_teams_path = './data/game_teams_dummy.csv'
  let(:games) {CSV.parse(File.read(game_path), headers: true).map {|row| Game.new(row)}}
  let(:teams) {CSV.parse(File.read(team_path), headers: true).map {|row| Team.new(row)}}
  let(:game_teams) {CSV.parse(File.read(game_teams_path), headers: true).map {|row| GameTeam.new(row)}}
  let(:data) {{games: games, teams: teams, game_teams: game_teams}}

  let(:league) {League.new(data)}

  it 'exists' do
    league = League.new(data)
    expect(league).to be_instance_of(League)
  end

  it 'has attributes' do

    expect(league.games).to be_a(Array)
    expect(league.games).to include(Game)
    expect(league.teams).to be_a(Array)
    expect(league.teams).to include(Team)
    expect(league.game_teams).to be_a(Array)
    expect(league.game_teams).to include(GameTeam)
  end

  ###GAME STATS METHODS

  it 'can find the highest total score' do
    expect(league.highest_total_score).to eq(5)
  end
  #game_teams_dummy
  it 'can find the lowest total score' do
    expect(league.lowest_total_score).to eq(1)
  end
  #game_teams_dummy
  it 'can find the percentage of games won by a home team' do
    expect(league.percentage_home_wins).to eq(0.44)
  end
  #game_teams_dummy
  it 'can find the percentage of games won by an away team' do
    expect(league.percentage_visitor_wins).to eq(0.22)
  end
  #game_teams_dummy

  it 'can find the percentage of ties' do
    expect(league.percentage_ties).to eq(0.33)
  end
  #game_teams_dummy

  it 'can count games by season' do
    expected = {
      "20122013" => 6,
      "20132014" => 5
    }
    expect(league.count_of_games_by_season).to eq(expected)
  end
  #games_dummy

  it 'can average goals per game across a season' do
    expect(league.average_goals_per_game).to eq(3.56)
  end
  #games_dummy

  it 'can organize average goals per game by season' do
    expected = {
      "20122013" => 3.33,
      "20132014" => 4.20
    }
    expect(league.average_goals_by_season).to eq(expected)
  end
  #games_dummy

  ###LEAGUE STATS

  it 'can count total number of teams' do
    expect(league.count_of_teams).to eq(12)
  end
  #teams_dummy

  it 'can calculate best offense' do
    expect(league.best_offense).to eq("FC Dallas")
  end
  #games_dummy and teams_dummy

  it 'can calculate worst offense' do
    expect(league.worst_offense).to eq("Houston Dynamo")
  end
  #games_dummy and teams_dummy

  it 'can calculate highest scoring visitor' do
    expect(league.highest_scoring_visitor).to eq("FC Dallas")
  end
  #games_dummy and teams_dummy

  it 'can calculate highest scoring home team' do
    expect(league.highest_scoring_home_team).to eq("Sky Blue FC")
  end
  #games_dummy and teams_dummy

  it 'can calculate lowest scoring visitor' do
    expect(league.lowest_scoring_visitor).to eq("Houston Dynamo")
  end
  #games_dummy and teams_dummy
  it 'can calculate lowest scoring home team' do
    expect(league.lowest_scoring_home_team).to eq("Houston Dynamo")
  end
  #games_dummy and teams_dummy

  ###SEASON STATS METHODS
  it 'can calculate the coach with the best win percentage' do
    expect(league.winningest_coach("20122013")).to eq("Claude Julien").or eq("Mike Babcock")
    expect(league.winningest_coach("20132014")).to eq("Claude Julien")
  end
  #coach name in game_teams_dummy, season in games_dummy

  it 'can calculate coach with the worst win percentage' do
    expect(league.worst_coach("20122013")).to eq("John Tortorella")
    expect(league.worst_coach("20132014")).to eq("John Tortorella")
  end
  #coach name in game_teams_dummy, season in games_dummy
  it 'can calculate the most accurate team' do
    expect(league.most_accurate_team("20122013")).to eq("LA Galaxy")
  end

  it 'can calculate the least accurate team' do
    expect(league.least_accurate_team("20122013")).to eq("Seattle Sounders FC")
  end

  it 'can calculate the most tackles' do
    expect(league.most_tackles("20122013")).to eq("FC Dallas")
  end

  it 'can calculate the fewest tackles' do
    expect(league.fewest_tackles("20122013")).to eq("LA Galaxy")
  end


###TEAM STATS METHODS
  it 'can provide team info' do
    expected = {"team_id" => "1", "franchise_id" => "23", "team_name" => "Atlanta United", "abbreviation" => "ATL", "link" => "/api/v1/teams/1"}
    expect(league.team_info("1")).to eq(expected)
  end

  xit 'can calculate the team with the best season' do
    expect(league.best_season("6")).to eq("20122013")
  end

  xit 'can calculate the average win percentage' do
    expect(league.average_win_percentage("6")).to eq(0.75)
  end

  it 'can report most goals scored' do
    expect(league.most_goals_scored("6")).to eq(3)
  end

  it 'can report fewest goals scored' do
    expect(league.fewest_goals_scored("19")).to eq(0)
  end

  xit 'can show which opponent cant beat bae' do
    expect(league.favorite_opponent("6")).to eq("Houston Dynamo")
  end

  xit 'can show a teams rival' do
    expect(league.rival("3")).to eq("FC Dallas")
  end
end


#require "pry"; binding.pry
