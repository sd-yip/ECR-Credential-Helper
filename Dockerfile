FROM golang:1.9-stretch AS builder

RUN bash -c 'set -e;\
 mkdir -p src/github.com/awslabs/amazon-ecr-credential-helper; cd "$_";\
 git init; git remote add origin\
 https://github.com/awslabs/amazon-ecr-credential-helper.git;\
 git fetch --depth 1 origin refs/tags/v0.3.0; git checkout FETCH_HEAD;\
 make; cp bin/local/docker-credential-ecr-login /'


FROM docker/compose:1.24.0

RUN set -eC;\
 mkdir -p ~/.docker;\
 echo '{"credsStore":"ecr-login"}' > ~/.docker/config.json

COPY --from=builder docker-credential-ecr-login /usr/local/bin/
