%w{rubygems sinatra haml active_support}.each {|lib| require lib}
{:run => false, :environment => :production}.each {|k, v| set k, v} if $passenger

def photos(year, month, day=nil, base='/Users/Shared/dailies/')
  Dir["#{base}#{year}/#{month}/#{day || '**'}/*.jpg"].map {|loc| loc.gsub(base, '/imgs/')}
end

helpers do
  def fd(date, ymd=true); date.strftime(ymd ? '%Y-%m-%d' : '%Y-%m'); end
end

get '/' do
  redirect "/#{fd(Date.today)}"
end

get '/:d' do
  headers['Cache-Control'] = 'public, max-age=300'
  
  @date = params[:d] ? Date.parse(params[:d]) : Date.today
  @photos = photos(*@date.strftime('%Y %m %d').split)
  haml :day
end

get '/m/:ym' do
  headers['Cache-Control'] = 'public, max-age=900'
  
  @date = Date.parse(params[:ym] + '-1')
  @photos = photos(*@date.strftime('%Y %m').split)
  haml :month
end

get '/ornamentation.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :ornamentation
end
