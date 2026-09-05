SHELL := /bin/bash

.PHONY: install serve build css clean

install:
	bundle install
	npm install

css:
	npx @tailwindcss/cli -i _css/styles.css -o styles.css --minify

serve: css
	npx @tailwindcss/cli -i _css/styles.css -o styles.css --watch & \
	CSS_PID=$$!; \
	trap "kill $$CSS_PID 2>/dev/null" EXIT; \
	bundle exec jekyll serve --livereload --host 0.0.0.0

build: css
	bundle exec jekyll build

clean:
	rm -rf _site .jekyll-cache
