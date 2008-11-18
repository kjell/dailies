%w{rubygems sinatra haml active_support}.each {|lib| require lib}

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production,
  :views_directory => 'views'
) if $passenger

def photos(year, month, day=nil)
  base = '/Users/Shared/dailies/'
  Dir["#{base}#{year}/#{month}/#{day || '**'}/*.jpg"].map do |loc|
    sym_loc = loc.gsub(base, '/imgs/')
    "#{sym_loc}" # symlink the photos, apparently I can't just render file:// uris
  end
end

helpers do
  def fd(date, ymd=true)
    date.strftime(ymd ? '%Y-%m-%d' : '%Y-%m')
  end
end

Sinatra.application.options.views = '/Users/kjell/Sites/dailies/views'

get '/' do
  redirect "/#{fd(Date.today)}"
end

get '/:d' do
  @date = params[:d] ? Date.parse(params[:d]) : Date.today
  @photos = photos(*@date.strftime('%Y %m %d').split)
  haml :day
end

get '/m/:ym' do
  @date = Date.parse(params[:ym] + '-1')
  @photos = photos(*@date.strftime('%Y %m').split)
  haml :month
end

get '/ornamentation.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :ornamentation
end
