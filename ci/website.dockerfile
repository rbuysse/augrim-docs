# Copyright 2021-2022 Cargill Incorporated
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -------------=== jekyll build ===-------------

FROM jekyll/jekyll:3.8 as jekyll

RUN gem install \
    bundler \
    jekyll-default-layout \
    jekyll-optional-front-matter \
    jekyll-readme-index \
    jekyll-redirect-from \
    jekyll-seo-tag \
    jekyll-target-blank \
    jekyll-titles-from-headings

ARG jekyll_env=development
ENV JEKYLL_ENV=$jekyll_env

COPY . /srv/jekyll

RUN rm -rf /srv/jekyll/_site \
 && if [ -f _userconfig.yml ] ; then \
       jekyll build --config _config.yml,_userconfig.yml --verbose --destination /tmp ; \
    else \
       jekyll build --config _config.yml --verbose --destination /tmp ;\
    fi

# -------------=== log commit hash ===-------------

FROM alpine as git

RUN apk update \
 && apk add \
    git

COPY .git/ /tmp/.git/
WORKDIR /tmp
RUN git rev-parse HEAD > /commit-hash

# -------------=== apache docker build ===-------------

FROM httpd:2.4

COPY --from=jekyll /tmp/ /usr/local/apache2/htdocs/
COPY --from=git /commit-hash /commit-hash
COPY apache/rewrite.conf /usr/local/apache2/conf/rewrite.conf

RUN echo "\
\n\
ServerName augrim.org\n\
Include /usr/local/apache2/conf/rewrite.conf\n\
AddDefaultCharset utf-8\n\
\n\
" >>/usr/local/apache2/conf/httpd.conf

EXPOSE 80/tcp
