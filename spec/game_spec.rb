require './lib/game.rb'

RSpec.describe Game do
  game_path = './data/games_dummy.csv'
  let(:data) {CSV.parse(File.read(game_path), headers: true)}

  it 'exists' do
    game = Game.new(data)
    expect(game).to be_instance_of(Game)
  end
end
