# Short Linkly

## Welcome to Short Linkly a link shortening service!

Built with Rails 5.2.3 and Ruby 2.5.1

Requires Bundler 2.0.1

This app is an unfinished URL shortening service, similar to [bit.ly](https://bitly.com/). For the first deliverable, a completed test suite has been written out for you. Please do not change any existing tests; you will need to write your code in order to pass the test suite.

- You will implement unique encoded shortened URLs for users (check the existing spec files for specifications on how the URLs should be encoded).
- All short links require a unique & valid long link (includes protocol) and user_id.
- You do not need a users table in order to complete any part of this exercise.
- Here is an example request to your service:

```
POST http://localhost:8080/short_link
{
  "long_link": "<long_link>",
  "user_id": "<user_id>"
}
```
- If the long_url has already been shortened for a user, you should return the previously created short_link. Otherwise, you should return a new short_link. The response should look something like:

```
{
  "long_link": "<long_link>",
  "short_link": "<short_link>"
}
```

For the second deliverable, a test suite has not been previously written.

- Implement an analytics endpoint, which takes an encoded id and renders the short link, the long link, and the number of times the short link has been accessed.
- Please use the following URI pattern: `/:id/analytics`

If you do not finish, err on the side of completeness of individual features, over completing all features. You can use any tools you'd like. Thanks in advance for taking the time do this exercise!


## Setup - Mac OS

Install dependencies:

```shell
bundle install
```

### postgresql

If you have not already have postgresql installed

```shell
brew install postgresql
```

and start postgresql

```shell
brew services start postgresql
```

### Create Databse

```shell
rails db:create db:migrate
```

### Start Rails Server

```shell
rails s
```

## Setup - Docker

Install dependencies:

### Docker Intallation

This is an alternative to the Mac OS setup mentioned in the prior section.  Completely optional.
[Link to Docker's install page](https://docs.docker.com/install/)

### Build Images

From within the directory for th-short-linkly:
```shell
docker-compose up
```

### Crate Database

```shell
docker-compose run short rake db:create db:migrate
```

### Running Tests

```shell
docker-compose run short bundle exec rspec
```
