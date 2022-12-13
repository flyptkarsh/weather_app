# Rails Weather

- Ruby Version

  3.1.2

- Rails Version

  7.0.4

- To Run the application locally

```
rails db:create
rails db:migrate
rails s
```

then navigate to `localhost:3000`

- Running the Test Suite

This application has Unit and Request specs built with Rspec.

To run the test suite run:

```
bundle exec rspec spec
```

There are 10 specs.

- System dependencies

This application uses the rails [Geocoder](https://github.com/alexreisner/geocoder) and the [Open Meteo Weather API](https://open-meteo.com/en). This is an open source weather API and does not require API keys to function.
