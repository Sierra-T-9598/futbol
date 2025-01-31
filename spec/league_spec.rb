require './lib/league.rb'
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

  it 'can find the lowest total score' do
    expect(league.lowest_total_score).to eq(1)
  end

  it 'can find the percentage of games won by a home team' do
    expect(league.percentage_home_wins).to eq(0.44)
  end

  it 'can find the percentage of games won by an away team' do
    expect(league.percentage_visitor_wins).to eq(0.22)
  end

  it 'can find the percentage of ties' do
    expect(league.percentage_ties).to eq(0.33)
  end

  it 'can count games by season' do
    expected = {
      "20122013" => 6,
      "20132014" => 5
    }
    expect(league.count_of_games_by_season).to eq(expected)
  end

  it 'can average goals per game across a season' do
    expect(league.average_goals_per_game).to eq(3.56)
  end

  it 'can organize average goals per game by season' do
    expected = {
      "20122013" => 3.33,
      "20132014" => 4.20
    }
    expect(league.average_goals_by_season).to eq(expected)
  end

  ###LEAGUE STATS

  it 'can count total number of teams' do
    expect(league.count_of_teams).to eq(12)
  end

  it 'can calculate best offense' do
    expect(league.best_offense).to eq("FC Dallas")
  end

  it 'can calculate worst offense' do
    expect(league.worst_offense).to eq("Houston Dynamo")
  end

  it 'can calculate highest scoring visitor' do
    expect(league.highest_scoring_visitor).to eq("FC Dallas")
  end

  it 'can calculate highest scoring home team' do
    expect(league.highest_scoring_home_team).to eq("Sky Blue FC")
  end

  it 'can calculate lowest scoring visitor' do
    expect(league.lowest_scoring_visitor).to eq("Houston Dynamo")
  end

  it 'can calculate lowest scoring home team' do
    expect(league.lowest_scoring_home_team).to eq("Houston Dynamo")
  end

  ###SEASON STATS METHODS
  it 'can calculate the coach with the best win percentage' do
    expect(league.winningest_coach("20122013")).to eq("Claude Julien").or eq("Mike Babcock")
    expect(league.winningest_coach("20132014")).to eq("Claude Julien")
  end

  it 'can calculate coach with the worst win percentage' do
    expect(league.worst_coach("20122013")).to eq("John Tortorella")
    expect(league.worst_coach("20132014")).to eq("John Tortorella")
  end

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
end

###MODULES
RSpec.describe League do
  game_path = './data/games_dummy.csv'
  team_path = './data/teams_dummy.csv'
  game_teams_path = './data/game_teams_dummy.csv'
  let(:games) {CSV.parse(File.read(game_path), headers: true).map {|row| Game.new(row)}}
  let(:teams) {CSV.parse(File.read(team_path), headers: true).map {|row| Team.new(row)}}
  let(:game_teams) {CSV.parse(File.read(game_teams_path), headers: true).map {|row| GameTeam.new(row)}}
  let(:data) {{games: games, teams: teams, game_teams: game_teams}}

  let(:league) {League.new(data)}

  ### Unit Tests for Summable
  it '#sum_of_goals_each_game' do
    expect(league.sum_of_goals_each_game).to eq([5, 5, 1, 5, 4, 4, 3, 3, 2])
  end

  ### Unit Tests for Averageable
  it '#average' do
    expect(league.average(3, 4)).to eq(0.75)
  end

  ### Unit Tests for Hashable
  it '#combined_home_and_away_team_goals' do
    expect(league.combined_home_and_away_team_goals).to eq({"3"=>2, "6"=>10, "16"=>9, "17"=>6, "12"=>7, "14"=>7})
  end

  it '#averaging_hash' do
    expect(league.averaging_hash).to eq({"3"=>0.5, "6"=>2.5, "16"=>2.25, "17"=>1.5, "12"=>2.33, "14"=>2.33})
  end

  it '#total_games' do
    expect(league.total_games).to eq({"3"=>4, "6"=>4, "16"=>4, "17"=>4, "12"=>3, "14"=>3})
  end

  it '#games_played_in_season' do
    expect(league.games_played_in_season("20122013")).to be_a(Array)
  end

  it '#game_stats_by_team_id' do
    expect(league.game_stats_by_team_id("20122013")).to be_a(Hash)
  end

  it '#away_teams_goals_by_id' do
    expect(league.away_teams_goals_by_id).to eq({"6"=>7, "3"=>1, "17"=>2, "16"=>5, "14"=>5, "12"=>2})
  end

  it '#away_team_goals_per_game_avg' do
    expect(league.away_team_goals_per_game_avg).to eq({"6"=>3.5, "3"=>0.5, "17"=>1.0, "16"=>2.5, "14"=>2.5, "12"=>2.0})
  end

  it '#home_team_goals_by_id' do
    expect(league.home_team_goals_by_id).to eq({"3"=>1, "6"=>3, "16"=>4, "17"=>4, "12"=>5, "14"=>2})
  end

  it '#home_team_goals_per_game_avg' do
    expect(league.home_team_goals_per_game_avg).to eq({"3"=>0.5, "6"=>1.5, "16"=>2.0, "17"=>2.0, "12"=>2.5, "14"=>2.0})
  end

  it '#team_name_from_id' do
    expect(league.team_name_from_id("6")).to eq("FC Dallas")
  end

  it '#combined_games_by_team_id' do
    expect(league.combined_games_by_team_id).to be_a(Hash)
  end

  it '#combined_goals_by_team_id' do
    expect(league.combined_goals_by_team_id).to eq({"3"=>2, "6"=>10, "16"=>9, "17"=>6, "12"=>7, "14"=>7})
  end

  it '#games_by_season' do
    expect(league.games_by_season("20122013")).to be_a(Hash)
  end

  it '#game_teams_by_season' do
    expect(league.game_teams_by_season("20122013")).to be_a(Array)
  end

  it '#season_from_game_id' do
    expect(league.season_from_game_id("2012030221")).to be_a(Array)
  end
  ### Unit Tests for Fractionable
  it '#worst_ratio_shots_to_goals' do
    expect(league.worst_ratio_shots_to_goals("20122013")).to eq("2")
  end

  it '#best_ratio_shots_to_goals' do
    expect(league.best_ratio_shots_to_goals("20122013")).to eq("17")
  end
end
