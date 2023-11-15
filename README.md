# README

## Lunch and Learn
Lunch and Learn is the final (solo) project of Turing's 3rd module. The app is primarily focused on the consumption of multiple APIs and aggregation of their responses into singular endpoints.
- Expose an API that aggregates data from multiple external APIs
- Expose an API that requires an authentication token
- Implement Basic Authentication
- Expose an API for CRUD functionality

## Technologies
Primary:
- Ruby 3.2.2
- Rails 7.0.8
- PostgreSQL

Gems:
- bcrypt
- jsonapi-serializer
- faraday
- rspec
- capybara
- webmock
- vcr

## Installation
### Cloning and installing dependencies
- Fork Repository
- `git clone <repo_name>`
- `cd <repo_name>`
- `bundle install`
- `rails db:{drop,create,migrate}`

### Adding credentials
API keys for the following external APIs are required:
- [Edamame Recipe Search API](https://developer.edamam.com/edamam-recipe-api)
- [YouTube Search API](https://developers.google.com/youtube/v3/getting-started)
- [Unsplash Image API](https://unsplash.com/developers)

Keys need to be placed into Rails' standard encryption file (`EDITOR="<editor> --wait" rails credentials:edit`) with the following format:
```
edamame:
  app_id: <app_id>
  app_key: <app_key>

youtube:
  key: <api_key>

unsplash:
  access_key: <access_key>
```

### Testing
Once dependencies are installed and credentials are entered, testing may be done either via:
- Test suite (`bundle exec rspec`)
- `rails s` (for local testing)

## Endpoints
- GET /api/v1/recipes?country=#{country}<br>
Example Response:
```
{
    "data": [
        {
            "id": null,
            "type": "recipe",
            "attributes": {
                "title": "Andy Ricker's Naam Cheuam Naam Taan Piip (Palm Sugar Simple Syrup)",
                "url": "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html",
                "country": "thailand",
                "image": "https://edamam-product-images.s3.amazonaws.com..."
            }
        },
        {
            "id": null,
            "type": "recipe",
            "attributes": {
                "title": "Sriracha",
                "url": "http://www.jamieoliver.com/recipes/vegetables-recipes/sriracha/",
                "country": "thailand",
                "image": "https://edamam-product-images.s3.amazonaws.com/."
            }
        }
    ]
}
```

- GET /api/v1/learning_resources?country=#{country}<br>
Example Response:
```
{
    "data": {
        "id": null,
        "type": "learning_resource",
        "attributes": {
            "country": "laos",
            "video": {
                "title": "A Super Quick History of Laos",
                "youtube_video_id": "uw8hjVqxMXw"
            },
            "images": [
                {
                    "alt_tag": "standing statue and temples landmark during daytime",
                    "url": "https://images.unsplash.com/photo-1528181304800-259b08848526?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwxfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3"
                },
                {
                    "alt_tag": "five brown wooden boats",
                    "url": "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwyfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3"
                },
                {
                    "alt_tag": "orange temples during daytime",
                    "url": "https://images.unsplash.com/photo-1563492065599-3520f775eeed?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwzfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3"
                }
            ]
        }
    }
}
```

- POST /api/v1/users<br>
Expected request format:<br>
```
POST /api/v1/users
Content-Type: application/json
Accept: application/json

{
  "name": "Odell",
  "email": "goodboy@ruffruff.com",
  "password": "treats4lyf",
  "password_confirmation": "treats4lyf"
}
```
Example Response:
```
{
  "data": {
    "type": "user",
    "id": "1",
    "attributes": {
      "name": "Odell",
      "email": "goodboy@ruffruff.com",
      "api_key": "api_key"
    }
  }
}
```

- POST /api/v1/sessions<br>
Expected request format:<br>
```
POST /api/v1/users
Content-Type: application/json
Accept: application/json

{
  "email": "goodboy@ruffruff.com",
  "password": "treats4lyf",
}
```
Example Response:
```
{
  "data": {
    "type": "user",
    "id": "1",
    "attributes": {
      "name": "Odell",
      "email": "goodboy@ruffruff.com",
      "api_key": "api_key"
    }
  }
}
```

- POST /api/v1/favorites<br>
Expected request format:<br>
```
POST /api/v1/users
Content-Type: application/json
Accept: application/json

{
  "api_key": "jgn983hy48thw9begh98h4539h4",
  "country": "thailand",
  "recipe_link": "https://www.tastingtable.com/.....",
  "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)"
}
```
Example Response:
```
{
  "success": "Favorite added successfully"
}
```

- GET /api/v1/favorites?api_key=#{api_key}<br>
Example Response:
```
{
    "data": [
        {
            "id": "1",
            "type": "favorite",
            "attributes": {
                "recipe_title": "Recipe: Egyptian Tomato Soup",
                "recipe_link": "http://www.thekitchn.com/recipe-egyptian-tomato-soup-weeknight....",
                "country": "egypt",
                "created_at": "2022-11-02T02:17:54.111Z"
            }
        },
        {
            "id": "2",
            "type": "favorite",
            "attributes": {
                "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)",
                "recipe_link": "https://www.tastingtable.com/.....",
                "country": "thailand",
                "created_at": "2022-11-07T03:44:08.917Z"
            }
        }
    ]
 }  
```
