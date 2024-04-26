FROM ruby:3.0-alpine

WORKDIR /usr/src

COPY . .

RUN bundle install

EXPOSE 4567

CMD ["ruby", "sinatra_purchase.rb"]
