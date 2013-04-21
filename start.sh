#source ~/.rvm/scripts/rvm
#rvm use 1.6.8 
source $(rvm 1.6.8 do rvm env --path)



# Note: make sure you are in **jruby**
#jruby -J-XstartOnFirstThread rspec spec/create_project_swtbot.rb
#jruby -J-XstartOnFirstThread rspec spec/main_spec.rb
jruby -J-XstartOnFirstThread rspec $1
