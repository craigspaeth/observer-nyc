BIN = node_modules/.bin

s:
	$(BIN)/coffee index.coffee

commit:
	git add .
	git commit -a -m 'Comitting...'
	git push git@github.com:craigspaeth/observer-nyc.git master