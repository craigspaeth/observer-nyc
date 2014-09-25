BIN = node_modules/.bin

s:
	$(BIN)/coffee index.coffee

assets:
	$(BIN)/stylus stylesheets/index.styl -o public
	$(BIN)/browserify client/index.coffee -t caching-coffeeify > public/index.js

commit:
	git add .
	git commit -a -m 'Comitting...'
	git push git@github.com:craigspaeth/observer-nyc.git master

compress:
	$(foreach file, $(shell find public/slides -name '*.jpg' | cut -d '.' -f 1), \
		convert -strip -interlace Plane -quality 80% -resize 1000x1000 $(file).jpg $(file).jpg; \
	)

deploy: assets commit
	git push git@heroku.com:observer-nyc.git master