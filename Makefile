
#
# Makefile

#NAME != \
#  ruby -e "s = eval(File.read(Dir['*.gemspec'][0])); puts s.name"
#VERSION != \
#  ruby -e "s = eval(File.read(Dir['*.gemspec'][0])); puts s.version"

index:
	echo "index" | time ruby lib/zek.rb
clindex:
	echo "clindex" | time ruby lib/zek.rb

spec:
	bundle exec rspec
test: spec


.PHONY: spec index clindex

