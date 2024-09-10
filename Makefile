
#
# Makefile

#NAME != \
#  ruby -e "s = eval(File.read(Dir['*.gemspec'][0])); puts s.name"
#VERSION != \
#  ruby -e "s = eval(File.read(Dir['*.gemspec'][0])); puts s.version"

index:
	time ruby lib/zek.rb index
clindex:
	time ruby lib/zek.rb clindex

indexspecrepo:
	ZEK_REPO_PATH=spec/repo/ ruby lib/zek.rb index
cleanspecrepo:
	rm -fR spec/repo/*
specrepo: cleanspecrepo
	ZEK_REPO_PATH=spec/repo/ ruby lib/zek.rb import spec/raw/
	tree spec/repo/
sr: specrepo indexspecrepo

spec:
	bundle exec rspec
test: spec


.PHONY: spec index clindex specrepo cleanspecrepo

