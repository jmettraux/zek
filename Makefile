
#
# Makefile

#NAME != \
#  ruby -e "s = eval(File.read(Dir['*.gemspec'][0])); puts s.name"
#VERSION != \
#  ruby -e "s = eval(File.read(Dir['*.gemspec'][0])); puts s.version"

spec:
	bundle exec rspec
test: spec


.PHONY: spec

