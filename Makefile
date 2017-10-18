
PREFIX := $(HOME)/.local
VERSION := 8.0.1203

FEATURES := \
	--enable-cscope \
	--enable-luainterp \
	--enable-multibyte \
	--enable-perlinterp \
	--enable-pythoninterp \
	--enable-rubyinterp \
	--with-features=huge \
	--without-x


all: image vim/$(VERSION)/src/vim

image:
	@docker build \
		--tag=$(USER)/vim-build-dependencies \
		.

vim/$(VERSION):
	@mkdir -p vim
	@curl --location --progress-bar \
		https://github.com/vim/vim/archive/v$(VERSION).tar.gz \
		| tar --extract --gzip --directory=vim --transform 's/vim-//'


vim/$(VERSION)/src/vim: vim/$(VERSION)
	cd vim/$(VERSION) && \
		docker run \
			--rm \
			--user=$(shell id --user):$(shell id --group) \
			--volume=/etc/passwd:/etc/passwd:ro \
			--volume=/etc/group:/etc/group:ro \
			--volume=$(shell pwd)/vim/$(VERSION):$(shell pwd)/vim/$(VERSION) \
			--volume=$(PREFIX):$(PREFIX) \
			--workdir=$(shell pwd)/vim/$(VERSION) \
			$(USER)/vim-build-dependencies \
				sh -c './configure --prefix=$(PREFIX) $(FEATURES) && make -j'

build-vim: vim/$(VERSION)/src/vim

install: vim/$(VERSION)/src/vim
	make -C vim/$(VERSION) install

clean:
	make -C vim/$(VERSION) clean

uninstall:
	make -C vim/$(VERSION) uninstall
