$:.unshift File.dirname(__FILE__) + '/sinatra/lib'
%w{rubygems sinatra haml active_support}.each {|lib| require lib}
Sinatra::Application.default_options.merge!(:run => false, :env => ENV['RACK_ENV']) if $passenger

def photos(year, month, day=nil)
  Dir["/Users/kjell/Pictures/dailies/#{year}/#{month}/#{day || '**'}/*.jpg"].map do |loc|
    sym_loc = loc.gsub('/Users/kjell/Pictures/dailies/', '/imgs/')
    "#{sym_loc}" # symlink the photos, apparently I can't just render file:// uris
  end
end

helpers do
  def fd(date, ymd=true)
    date.strftime(ymd ? '%Y-%m-%d' : '%Y-%m')
  end
end

get('/') {redirect "/#{fd(Date.today)}"}

get '/:d' do
  @date = params[:d] ? Date.parse(params[:d]) : Date.today
  @photos = photos(*@date.strftime('%Y %m %d').split)
  redirect "/#{fd(@date.next)}" if @photos.empty? && @date != Date.today
  haml :day
end

get '/m/:ym' do
  @date = Date.parse(params[:ym] + '-1')
  @photos = photos(*@date.strftime('%Y %m').split)
  haml :month
end

get '/ornamentation.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :ornamentation
end