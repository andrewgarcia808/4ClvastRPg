# Ruby on Rails Exercise

## Overview

In this exercise, your task is to write a simple REST API to manage a collection of news articles. You must implement the specifications listed below and ensure all unit tests are passing. Open a pull request when you are finished.

## Specifications

Each article has the following attributes:
- `id`: The unique ID of the article. (Integer)
- `title`: The title of the article. (String)
- `content`: The content of the article. (String)
- `author`: The name of the author of the article. (String)
- `category`: The category of the article. (String)
- `published_at`: The original publishing date of the article. (Date)

All fields are required. Article title length is limited to 40 characters.

The REST API must expose the following endpoints:

`GET /articles`
- Returns a JSON collection of all articles, ordered by publishing date in descending order.

`POST /articles`
- Receives a JSON payload representing an article.
- If the request contains a valid article:
    - Insert the article into the SQLite database.
    - Return the newly-created article's information in JSON format.

`GET /articles/<id>`
- Returns an article with the given id in JSON format, if it exists.

`DELETE`, `PUT`, and `PATCH` requests to `/articles/<id>`
- Returns response code 405 because this public API does not allow articles to be deleted or modified.
