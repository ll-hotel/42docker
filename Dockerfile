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

COPY conf/ssh/.ssh.tar .
RUN tar xf .ssh.tar; \
	rm .ssh.tar;

RUN mkdir .config/ .local/;
COPY conf/neovim/nvim.tar .config/
RUN cd .config/; \
	tar xf nvim.tar; \
	rm nvim.tar;

WORKDIR $HOME
RUN chown $USER $HOME;

ENTRYPOINT /bin/zsh
