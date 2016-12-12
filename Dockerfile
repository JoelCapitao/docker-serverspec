FROM ruby:2.3.3

# Install docker, see:
# https://github.com/docker-library/docker/blob/0c44c1c6c25a34eb9abe320805e0f89bf5b0ace2/1.12/Dockerfile
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.12.3
ENV DOCKER_SHA256 626601deb41d9706ac98da23f673af6c0d4631c4d194a677a9a1a07d7219fa0f

RUN set -x \
	&& curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
	&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

COPY docker-entrypoint.sh /usr/local/bin/

# Install our gem dependencies:
COPY Gemfile /Gemfile
RUN cd / && bundle install

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
