#source ~/.rvm/scripts/rvm
#rvm use 1.6.8 
source $(rvm 1.6.8 do rvm env --path)


# Note: make sure you are in **jruby**
jruby -J-XstartOnFirstThread spec/create_project_swtbot.rb

