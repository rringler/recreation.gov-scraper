RecreationGovScraper::App.controllers :pages do

  get :index, map: '/' do
    @query = Query.latest

    render 'home'
  end

  get :about, map: '/about' do
    render 'about'
  end
end
