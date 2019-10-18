.PHONY: build clean rebuild

rebuild: clean build

build: ./build/index.html
	ls ./build


clean:
	mv ./build ./build.old
	mkdir ./build
	rm -rf build.old

./build/index.html:
	@echo "Copying index.html over"
	cp ./public/index.html ./build/index.html

