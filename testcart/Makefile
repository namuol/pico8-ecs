all: build run

pico-8/pico8:
	$(error You need to install pico8 into the ./pico-8 directory!)

utils/lua2pico.lua:
	git submodule init
	git submodule update

build: utils utils/lua2pico.lua
	@cp ../ecs.lua src/.
	@utils/png2pico.lua src/gfx.png src/cart.p8 > .tmp.p8
	@utils/pack.lua src | utils/lua2pico.lua - .tmp.p8 > src/cart.p8
	@rm .tmp.p8

run: pico-8/pico8 build
	@cd pico-8; ln -s ../src/cart.p8 .; ./pico8 -run cart.p8; unlink cart.p8

.PHONY: build