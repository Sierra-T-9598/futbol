require './spec_helper.rb'
require './lib/stat_tracker.rb'
require './runner.rb'

RSpec.describe StatTracker do
  before :each do
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams_dummy.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end



  it 'exists' do
    expect(@stat_tracker).to be_instance_of(StatTracker)
  end

  ##Game Statistics Methods

  it 'can display the highest total score' do
    #game_teams_dummy
    expect(@stat_tracker.highest_total_score).to eq(5)
  end

  it 'it can display lowest total score' do
    #game_teams_dummy
    expect(@stat_tracker.lowest_total_score).to eq(1)
  end

  it 'it can display total wins by home team as percentage' do
    #game_teams_dummy
    expect(@stat_tracker.percentage_home_wins).to eq(0.44)
  end

  it 'can find the percentage of games that a visitor has won' do
    #game_teams_dummy
    expect(@stat_tracker.percentage_visitor_wins).to eq(0.22)
  end

  it 'can find the percentage of games that resulted in a tie' do
    #game_teams_dummy
    expect(@stat_tracker.percentage_ties).to eq(0.33)
  end

  it 'can sort the number of games attributed to each season' do
    #games_dummy
    expected = {
      "20122013" => 6,
      "20132014" => 5
    }

    expect(@stat_tracker.count_of_games_by_season).to eq(expected)
  end

  it 'can calculate average goals per game across seasons' do
    #games_dummy
    expect(@stat_tracker.average_goals_per_game).to eq(3.56)
  end

  it 'can organize average goals per game by season' do
    #games_dummy
    expected = {
      "20122013" => 3.33,
      "20132014" => 4.20
    }
    expect(@stat_tracker.average_goals_by_season).to eq(expected)
  end
  ##League Stats Methods

  it 'count the total number of teams' do
    #teams_dummy
    expect(@stat_tracker.count_of_teams).to eq(12)
  end

  it 'can calculate the best offense' do
    #games_dummy & #teams_dummy
    # Name of the team with the highest average
    # number of goals scored per game across all seasons.
    expect(@stat_tracker.best_offense).to eq("FC Dallas")
  end

  it 'can calculate the worst offense' do
    #games_dummy & #teams_dummy
    # Name of the team with the worst average
    # number of goals scored per game across all seasons.
    expect(@stat_tracker.worst_offense).to eq("Houston Dynamo")
  end

  it 'can calculate the highest scoring visitor' do
      #games_dummy & #teams_dummy
    expect(@stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
  end

  it 'can calculate the highest scoring home_team' do
    #games_dummy & #teams_dummy
    expect(@stat_tracker.highest_scoring_home_team).to eq("Sky Blue FC")
  end

  it 'can calculate the lowewst scoring visitor' do
    #games_dummy & #teams_dummy
    expect(@stat_tracker.lowest_scoring_visitor).to eq("Houston Dynamo")
  end

  it 'can calculate the lowest scoring home team' do
    #games_dummy & #teams_dummy
    expect(@stat_tracker.lowest_scoring_home_team).to eq("Houston Dynamo")
  end

  ##Season Statistics

  it 'can name the coach with the best win percentage' do
    #coach in games_teams_dummy, season in games_dummy
    expect(@stat_tracker.winningest_coach("20122013")).to eq("Claude Julien")
    expect(@stat_tracker.winningest_coach("20132014")).to eq("Claude Julien")
  end

  it 'can name the coach with the worst win percentage' do
    #coach in games_teams_dummy, season in games_dummy
    expect(@stat_tracker.worst_coach("20132014")).to eq("John Tortorella")
    expect(@stat_tracker.worst_coach("20122013")).to eq("John Tortorella")
  end

  it 'can calculate the most accurate team' do

    expect(@stat_tracker.most_accurate_team("20122013")).to eq("LA Galaxy")
  end

  it 'can calculate the least accurate team'do

    expect(@stat_tracker.least_accurate_team("20122013")).to eq("Seattle Sounders FC")
  end

  it 'can find the team with the most tackles' do

    expect(@stat_tracker.most_tackles("20122013")).to eq("FC Dallas")
  end

  it 'can find the team with the least tackles' do

    expect(@stat_tracker.fewest_tackles("20122013")).to eq("LA Galaxy")
  end

  ## TEAM Statistics
  it 'can provide team info' do
    expected = {
      "team_id" => "1",
      "franchise_id" => "23",
      "team_name" => "Atlanta United",
      "abbreviation" => "ATL",
      "link" => "/api/v1/teams/1"
    }

    expect(@stat_tracker.team_info("1")).to eq(expected)
  end

  it 'can calculate the team with the best season' do
    expect(@stat_tracker.best_season("6")).to eq("20122013")
  end

  it 'can calculate the team with the worst season' do
    expect(@stat_tracker.worst_season("3")).to eq("20122013")
  end

  it 'can calcuate the average win percentage' do

    expect(@stat_tracker.average_win_percentage("6")).to eq(0.75)
  end

  it 'can report the highest goals in a single game' do

    expect(@stat_tracker.most_goals_scored("6")). to eq(3)
  end

  it 'can report the fewest goals scored in a game' do

    expect(@stat_tracker.fewest_goals_scored("19")). to eq(0)
  end

  xit 'can show which opponent cant beat bae' do

    expect(@stat_tracker.favorite_opponent("6")).to eq("Houstoun Dynamo")
  end

  xit 'can show a teams rival' do

    expect(@stat_tracker.rival("3")).to eq("FC Dallas")
  end
end
