FROM alpine:latest

ENV USER=ll-hotel
ENV HOME=/home/$USER

RUN apk update;
RUN apk add zsh bash fzf ripgrep;
RUN apk add git clang make openssh curl;
RUN apk add neovim;

RUN adduser -D $USER -s /bin/zsh;
USER $USER
WORKDIR $HOME

COPY conf/zsh/install-omz.sh .
RUN bash install-omz.sh; \
	rm install-omz.sh;

COPY conf/ssh/.ssh.tar.gz .
RUN tar xzf .ssh.tar.gz; \
	rm .ssh.tar.gz;

RUN mkdir .config/;
COPY conf/neovim/nvim.tar.gz .config/
RUN cd .config/; \
	tar xzf nvim.tar.gz; \
	rm nvim.tar.gz;

COPY conf/.local.tar.gz .
RUN tar xzf .local.tar.gz; \
	rm .local.tar.gz;

COPY conf/gitconfig.sh gitconfig.sh
RUN bash gitconfig.sh; rm gitconfig.sh;
COPY conf/zshrc .zshrc

WORKDIR $HOME
RUN chown $USER $HOME;

ENTRYPOINT /bin/zsh
