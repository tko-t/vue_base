FROM node:17-alpine

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo
ENV HOST=0.0.0.0
# これがないとserveもbuildもできない
# https://stackoverflow.com/questions/69692842/error-message-error0308010cdigital-envelope-routinesunsupported
ENV NODE_OPTIONS=--openssl-legacy-provider

ARG WORKDIR
ARG USER
ARG USER_ID
ARG GROUP
ARG GROUP_ID

RUN apk add --update shadow \
 && yarn global add @vue/cli
 #&& yarn global add @vue/cli-init
 #&& npm install -g @vue/cli

# && vue init webpack app
# && yarn install

# WSL2のuserIDとgroupIDが1000:1000で
# コンテナのnodeユーザーとかぶってたので名前とホームだけ変更
RUN usermod -l $USER node \
 && usermod -c $USER $USER \
 && usermod -d /home/$USER $USER \
 && groupmod -n $USER node \
 && mkdir /home/$USER \
 && mkdir $WORKDIR \
 && chown -R $USER:$GROUP /home/$USER \
 && chown -R $USER:$GROUP $WORKDIR

# ローカル環境のIDが1000:1000じゃないときは新しく作ればいいと思う
#RUN addgroup -S -g $GROUP_ID $GROUP && \
#    adduser -u $USER_ID -G $USER -D $USER

WORKDIR $WORKDIR

USER $USER

CMD sh
