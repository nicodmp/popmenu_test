# README

Test for Popmenu by Nicolas de Melo Proença.

* :gem: Ruby version: 3.3.7

* :railway_car: Rails version: 8.0.2

* :elephant: Database: PostgreSQL

## Installation

It is assumed that you have previously setup and are familiar with Ruby, Rails and PostgreSQL.

Don't forget to modify the config/database.yml with your Postgres credentials, or references to a .env file:

```yaml
ddefault: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>git
  username: YOUR USERNAME
  password: YOUR PASSWORD
```

Navigate to the project folder in the terminal and enter the following commands:

`bundle install` to install gems.

`rails db:setup` to create, migrate and seed the database.

`rails s` to run the project, default port is `localhost:3000`.

`rspec` to run the tests.

Send a curl or use Postman to POST the restaurant_data json to the `/import` endpoint, like so:

```

```


## Comments

### Level 1

Because the project is, initially, API-only with a Postgres database, the Rails project was created with the following options:

`rails new popmenutest --api --database=postgresql`

The `Menu` model has the attributes 'name', 'description', 'open_time' and 'close_time', and the `MenuItem` model has the attributes 'name', 'description', 'price' and 'category', with a foreign key to `Menu`. As instructed in the project outline, there are only routes for `index` and `show` actions for both models. Rspec was used to setup unit tests for both models, and will be used for all tests going forward.

### Level 2

The `Restaurant` model was created with a `has_many` association to the `Menu `model through a foreign key in `Menu`.

In order to comply with the instructions, that is:

- `MenuItem `names should not be duplicated in the database
- `MenuItem` can be on multiple `Menu `s of a Restaurant

as well as allowing a `MenuItem` to be present in different menus with different price points, a join model `MenuMenuItem` was created, allowing for the many-to-many association between `Menu` and `MenuItem` while enforcing the name uniqueness of the `MenuItem` objects in the database. The foreign key from `MenuItem` to `Menu` was removed as a result of this change, and the `price` attribute was moved from `MenuItem` to the new join model.

I had initially created a controller for `MenuMenuItem`, but later decided to remove it due to seeing no practical use for it, considering the  existing endpoints for `Menu` and `MenuItem`.

### Level 3

A new endpoint, `POST /import` was created to receive the JSON for data to be added to the database. Internally, the process for serializing the JSON and committing it to the database is handled by a new service, `import_service.rb`. This service serializes the JSON input received from the API, performs validations and assembles logs for each `MenuItem` created, also displaying the status (Success or Failure) and any errors. The processing occurs in a transaction, and will rollback the database changes if an error occurs. At this point, I also incorporated factory_bot and Faker into the unit tests, for the sake of changeability in future iterations of the system.