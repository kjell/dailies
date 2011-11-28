%w{rubygems sinatra haml sass active_support date}.each {|lib| require lib}
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

get '/ornamentation.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :ornamentation
end

get '/:date' do |d|
  headers['Cache-Control'] = 'public, max-age=300'

  @date   = Date.parse(d) rescue Date.today
  @photos = photos(*@date.strftime('%Y %m %d').split)
  haml :day
end

get '/m/:year_month' do |ym|
  headers['Cache-Control'] = 'public, max-age=900'
  
  @date   = Date.parse(ym + '-1')
  @photos = photos(*@date.strftime('%Y %m').split)
  haml :month
end
