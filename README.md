# Bloge

An attempt to create a static blog generator for a personal use.
Due to this, it won't be as much customisable as most popular generator available online.


# Concept

Bloge works mainly through a CLI to create, delete and publish articles.
An article materialized by a folder containing three base elements :

- A data.json file for article data like the date of publication.
- A ressources folder for ressources that are specific to the article.
- An index file for the article content.


# Commands

Here are the commands available for the moment :


## Init

Initializes the current folder as a blog folder or creates a new one if specified by the flag --name (or -n).
If --title (or -t) is specified, it will be set as the blog's title.


## Add NAME

Adds a base article in a folder named NAME.
If --title (or -t) is specified, it will be set as the article's title.


## Delete NAME

Deletes the unpublished article named NAME.


## Publish NAME

Publishes the unpublished article named NAME.


## Unpublish NAME

Unpublishes the published article named NAME.
