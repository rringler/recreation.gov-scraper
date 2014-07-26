module RecreationGovScraper
  class App < Padrino::Application
    register SassInitializer
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    get '/' do
      render 'pages/home'
    end

    get '/about' do
      render 'pages/about'
    end
  end
end
