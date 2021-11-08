require "rspec"
require "./lib/game_team"

RSpec.describe GameTeam do

    game_team_path = './data/game_teams_dummy.csv'
    let(:data) {CSV.parse(File.read(game_team_path), headers: true)}

  it 'exists' do
    game_team = GameTeam.new(data)
    expect(game_team).to be_an_instance_of(GameTeam)
  end
end
