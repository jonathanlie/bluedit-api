# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## API Usage Examples

### Authentication

Obtain a JWT token (see `/api/v1/auth/google` for Google OAuth2 flow). Use the token in the `Authorization` header for protected endpoints:

```
Authorization: Bearer <your-jwt-token>
```

### Create a Subbluedit

```
POST /api/v1/subbluedits
Authorization: Bearer <token>
Content-Type: application/json

{
  "subbluedit": {
    "name": "mycommunity",
    "description": "A place for my people."
  }
}
```

### Show a Subbluedit

```
GET /api/v1/subbluedits/:id
```

### Create a Post in a Subbluedit

```
POST /api/v1/subbluedits/:subbluedit_id/posts
Authorization: Bearer <token>
Content-Type: application/json

{
  "post": {
    "title": "Hello World",
    "body": "This is my first post!"
  }
}
```

### Error Responses
- 401 Unauthorized: If the `Authorization` header is missing or invalid for protected endpoints.
- 422 Unprocessable Entity: If required parameters are missing or invalid.
