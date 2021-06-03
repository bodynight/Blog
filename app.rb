#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'blog.db'
	@db.results_as_hash = true
end

configure do
	init_db
	@db.execute 'CREATE TABLE if not exists `Posts` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`created_date`	DATA,
	`content`	TEXT
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

	if content.length <= 0
		@error = 'Введите текст'
		return erb :new
	end

	@db.execute 'insert into Posts (content, created_date) values (?, datetime() )', [content]

 	redirect to '/'
end

get '/details/:id' do
	id = params[:id]

	results = @db.execute 'select * from Posts where id=?', [id]
	@row = results[0]

	erb :details
end