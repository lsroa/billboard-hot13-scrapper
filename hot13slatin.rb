#=======================Dependencias===========================

<<<<<<< HEAD
require	"nokogiri"
require	"json"
require	"mysql2"


=======
require"httparty"
require"nokogiri"
require"json"
require 'mysql2'
>>>>>>> refs/remotes/origin/luisRoa

#==============================================================


class Hit
	#  numero de canciones
	@@no_of_songs = 0

	#Getters y Setters

	attr_accessor :artista
	attr_accessor :url
	attr_accessor :titulo

	# Constructor

	def initialize (puesto,titulo,d)
		
		if !(@@no_of_songs>d-1)
			
  			@@date = Date.today.strftime("%Y%m%d")
			@@no_of_songs+=1
			@puesto = puesto
			@titulo = titulo
			@artista = 'Desconocido'
			@url = "https://www.youtube.com/results?search_query="

		end
	end
	
	def _tohash()
		hash = {
			'puesto' => @puesto,
			'titulo' => @titulo,
			'artista' => @artista,
			'url' => @url,
			'fecha'=> @@date
		}
		return hash			
	end	
	
end

#============================================================== 


def billbot(no_of_songs)

	page = HTTParty.get('http://www.billboard.com/charts/latin-songs')	
	n_page = Nokogiri::HTML(page)
	$songs = []
	$song_hash =[]	
	n_page.css('div').css('.chart-row__song').each_with_index do |a,b| 
		
		song = Hit.new(b+1,a.text,no_of_songs)	
		$songs.push(song)

	end
	n_page.css('div').css('.chart-row__artist').each_with_index do |a,b|
		if 	b < no_of_songs
			
			$songs[b].artista = a.text.gsub(/\p{Space}+/,' ')				
			$songs[b].url= "#{$songs[b].url}#{$songs[b].artista.gsub(/\p{Space}+/,'+')}#{$songs[b].titulo.gsub(/\p{Space}+/,'+')}"
			$song_hash.push($songs[b]._tohash)

		end
	end
	return $song_hash
end	



#======================= Output ===========================


app_path = '../../'
rails_db_config = "#{app_path}config/database.yml"
rails_env_config = "#{app_path}config/environment"

<<<<<<< HEAD
begin 

	  #Checks if ran under rail app and tries to use rails redentials and config
	  if File.file?(rails_db_config) && File.file?("#{rails_env_config}.rb")

	    require rails_env_config

	    # config = YAML::load_file(rails_db_config)[Rails.env]
	    config = YAML.load(ERB.new(File.read(rails_db_config)).result)[Rails.env]
	    config["host"] = "localhost"
	    config["encoding"] = "utf8"

	    client = Mysql2::Client.new(config)

	  #else uses local credentials
	  else

	    require './db_credentials'

	    client = Mysql2::Client.new(
	      :host      => "localhost",
	      :username  => 'root',
	      :password  => 'luisroa62',
	      :database  => 'vh',
	      :encoding  => 'utf8')
	    
	  end

	billbot(13).each_with_index do |a,b|
		
	result = client.query("INSERT INTO billboard_hot13s_latin(title,artist,date,search_url,position) 

			VALUES('#{a['titulo']}',
			'#{a['artista']}',
			'#{a['fecha']}','#{a['url']}'
			,'#{a['position']}') "
		)	
	end	
=======
$stdout.reopen("hot13s.log", "w")
$stdout.sync = true
$stderr.reopen($stdout)


begin

	#Checks if ran under rail app and tries to use rails redentials and config
	if File.file?(rails_db_config) && File.file?("#{rails_env_config}.rb")

	require rails_env_config

	# config = YAML::load_file(rails_db_config)[Rails.env]
	config = YAML.load(ERB.new(File.read(rails_db_config)).result)[Rails.env]
	config["host"] = "localhost"
	config["encoding"] = "utf8"

	client = Mysql2::Client.new(config)

	#else uses local credentials
	else

	require './db_credentials'

	client = Mysql2::Client.new(
		
	  :host      => "localhost",
	  :username  => $VH_DB_USERNM,
	  :password  => $VH_DB_PASSWD,
	  :database  => $VH_DB_PROD,
	  :encoding  => 'utf8')

	end
>>>>>>> refs/remotes/origin/luisRoa

	billbot(13).each_with_index do |a,b|
		puts "=)"
		result = client.query("INSERT INTO billboard_hot13s_latin(title,artist,date,search_url,position) 

				VALUES('#{a['titulo']}',
				'#{a['artista']}',
				'#{a['fecha']}','#{a['url']}'
				,'#{a['position']}') "
			)	
	end	

rescue Mysql2::Error => e
  puts e.errno
  puts e.error

ensure
  client.close if client

end

	