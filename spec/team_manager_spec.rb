require './lib/team_manager.rb'
require './lib/stat_tracker.rb'

RSpec.describe TeamManager do
  game_path = './data/games_dummy.csv'
  team_path = './data/teams_dummy.csv'
  game_teams_path = './data/game_teams_dummy.csv'
  let(:games) {CSV.parse(File.read(game_path), headers: true).map {|row| Game.new(row)}}
  let(:teams) {CSV.parse(File.read(team_path), headers: true).map {|row| Team.new(row)}}
  let(:game_teams) {CSV.parse(File.read(game_teams_path), headers: true).map {|row| GameTeam.new(row)}}
  let(:data) {{games: games, teams: teams, game_teams: game_teams}}

  let(:team_manager) {TeamManager.new(data)}

  it 'can provide team info' do
    expected = {"team_id" => "1", "franchise_id" => "23", "team_name" => "Atlanta United", "abbreviation" => "ATL", "link" => "/api/v1/teams/1"}
    expect(team_manager.team_info("1")).to eq(expected)
  end

  it 'can calculate the team with the best season' do
    expect(team_manager.best_season("17")).to eq("20122013")
  end

  it 'can calculate the team with the worst season' do
    expect(team_manager.worst_season("17")).to eq("20122013")
  end

  it 'can calculate the average win percentage' do
    expect(team_manager.average_win_percentage("6")).to eq(0.75)
  end

  it 'can report most goals scored' do
    expect(team_manager.most_goals_scored("6")).to eq(3)
  end

  it 'can report fewest goals scored' do
    expect(team_manager.fewest_goals_scored("19")).to eq(0)
  end
end
