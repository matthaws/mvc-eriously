# XANTHUS
A lightweight backend framework in Ruby.

## Implemented features
### __Models__

Flexible ORM implementation with a ModelBase parent class, with dynamically generated SQL queries via a SQLite3 databse for methods like `::all`, `::find`, `::where`, and `#save`. Also included is `::parse_all`, which converts SQL results into instances of the class that inherits from ModelBase. This is achieved by utilizing metaprogramming to define get and set instance methods:

### __Associations__

`belongs_to` and `has_many` are employed to define methods that will generate the necessary SQL queries and table joins to return the appropriate associated data.

### __Router and Routes__

Router class allows for routes to be defined, finds the route that matches the incoming request path. The matching route creates a new instance of the appropriate controller and invokes the associated action:

### __Controllers__

ControllerBase implements `#render` and `#redirect_to` to appropriately build up HTTP response.

### __Cookies__

Both `session` and `flash` are available in the controllers, are parsed from the request, and are packaged up in the response. Both `flash` and `flash.now` are implemented.

### __Views__

Using the `erb` gem, html.erb views can be fetched, parsed, and used to generate the HTML response. Instance variables defined in the controller are available in the view template via use of Ruby's `Kernel#binding`.

### __Middleware__

`Exception` middleware catches raised errors in the app and returns an error screen response with detailed message and stack trace.

`StaticAssets` middleware parses requests for assets, sets the appropriate `Content-Type` based on the file extension, reads the file, and packages it into the HTTP response.
