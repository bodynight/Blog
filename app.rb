#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'blog.db'
	@db.results_as_hash = true
end

def get_db_id id
	results = @db.execute 'select * from Posts where id=?', [id]
	@row = results[0]
	@coments = @db.execute 'select * from Coments where post_id = ?  order by id', [id]
end

configure do
	init_db
	@db.execute 'CREATE TABLE if not exists `Posts` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`created_date`	DATA,
	`content`	TEXT,
	name_autor  TEXT
		
	end
   )'

   @db.execute 'CREATE TABLE if not exists `Coments` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`created_date`	DATA,
	`content`	TEXT,
	post_id INTEGER
   )'
end

before do
	init_db
end

get '/' do

	@results = @db.execute 'select * from Posts order by id desc'

	erb :index			
end

get '/new' do
 erb :new
end

post '/new' do
	content = params[:content]
	@name_autor = params[:name_autor]

	if @name_autor.length <= 0
		@error = 'Введите имя автора'
		return erb :new
	end

	if content.length <= 0
		@error = 'Введите текст'
		return erb :new
	end

	@db.execute 'insert into Posts (content, created_date, name_autor) values (?, datetime(), ? )', [content, @name_autor]

 	redirect to '/'
end

get '/details/:id' do
	id = params[:id]

	get_db_id id

	erb :details
end

post '/details/:id' do
	id = params[:id]
	@coment = params[:coment]

	if @coment.length <= 0
		
		get_db_id id

		@error = 'Введите коментарий'

		return erb :details
	end

	@db.execute 'insert into Coments
	 (content, created_date, post_id)
	  values (?, datetime(), ? )', [@coment, id]

	redirect to ('/details/' + id )
end

