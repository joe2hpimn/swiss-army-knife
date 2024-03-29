#!/usr/bin/env bash

which-ruby(){
	green "$(rvm current)"
}

ruby-tests(){
	# source ~/.rvm/scripts/rvm
	# source $(rvm 2.3.0 do rvm env --path)

	# rvm use 2.3.0 --default
	# rvm gemset use opsman

	# pushd ${HOME}/git_work/$1
	# git pull
	# bin/rspec
	# popd
	echo "done"
}

ruby-project(){
	mkdir bin conf lib scripts spec

	cat << EOF > GemFile
source 'https://rubygems.org'

gem 'rake'

group :development, :test do
	gem 'rspec'
	gem 'simplecov'
end
EOF

	cat << EOF > LICENSE.txt
The MIT License (MIT)

Copyright (c) 2017 Tingfang Bao

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
EOF

	cat << EOF > Rakefile
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
EOF

	cat << EOF > spec/spec_helper.rb
#!/usr/bin/env ruby
# encoding: utf-8
# _*_ coding: utf-8 _*_
# vim:set fileencoding=utf-8
#
require 'simplecov'

SimpleCov.start do
	add_filter 'spec/'
end

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path(lib, __FILE__)

Dir.glob(File.join(lib, '/**/*.rb')) do |f|
	require f
end
EOF

	touch .gitignore

	bundler install
}