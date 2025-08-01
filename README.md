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

### Create a Comment on a Post

```
POST /api/v1/subbluedits/:subbluedit_id/posts/:post_id/comments
Authorization: Bearer <token>
Content-Type: application/json

{
  "comment": {
    "body": "Great post!",
    "parent_comment_id": "optional-uuid-for-replies"
  }
}
```

### Vote on a Post

```
POST /api/v1/subbluedits/:subbluedit_id/posts/:post_id/vote
Authorization: Bearer <token>
Content-Type: application/json

{
  "vote": {
    "value": 1
  }
}
```

### Vote on a Comment

```
POST /api/v1/comments/:comment_id/vote
Authorization: Bearer <token>
Content-Type: application/json

{
  "vote": {
    "value": -1
  }
}
```

### Error Responses
- 401 Unauthorized: If the `Authorization` header is missing or invalid for protected endpoints.
- 422 Unprocessable Entity: If required parameters are missing or invalid.
- 404 Not Found: If the requested resource doesn't exist.

### Vote Values
- `1`: Upvote
- `-1`: Downvote
