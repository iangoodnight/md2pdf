#!/usr/bin/env ruby

# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require 'base64'
require 'sinatra'
require 'sinatra/cors'
require 'markdown'
require 'pdfkit'

set :server, :puma

configure do
  set :bind, '0.0.0.0'
  set :port, 8008
end

register Sinatra::Cors

configure do
  enable :cross_origin
end

options '*' do
  response.headers['Allow'] = 'GET,POST'
  response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept'
  response.headers['Access-Control-Allow-Origin'] = '*'
  200
end

get '/health' do
  'Alive'
end

post '/convert' do
  request.body.rewind
  markdown_content = Base64.decode64(request.body.read)
  html_content = Markdown.new(markdown_content).to_html
  pdf = PDFKit.new(html_content).to_pdf

  content_type 'application/pdf'
  pdf
end
