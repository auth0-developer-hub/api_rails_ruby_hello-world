# Hello World API: Ruby on Rails Authorization Sample

You can use this sample project to learn how to secure a simple Rails API server using Auth0.

The `starter` branch offers a working API server that exposes three public endpoints. Each endpoint returns a different type of message: public, protected, and admin.

The goal is to use Auth0 to only allow requests that contain a valid access token in their authorization header to access the protected and admin data. Additionally, only access tokens that contain a `read:admin-messages` permission should access the admin data, which is referred to as [Role-Based Access Control (RBAC)](https://auth0.com/docs/authorization/rbac/).

## Run the Project

Install the project dependencies:

```bash
bundle install
```

Copy the `.env.example` file and paste it as `.env` under the root project directory:

```bash
cp .env.example .env
```

Replace the example values with the ones found in your [Auth0 Dashboard](https://manage.auth0.com/):
- `AUTH0_AUDIENCE`
- `AUTH0_DOMAIN`

> This project uses the [`dotenv` gem](https://github.com/bkeepers/dotenv) to load environment variables from a `.env` file into `ENV` in development.

Run the project:

```bash
bundle exec rails s
```

## Security Configuration
### HTTP Headers

Rails comes with some defaults which needs to be overridden, please see the [documentation](https://edgeguides.rubyonrails.org/configuring.html#config-action-dispatch-default-headers) for more details.

We need to set up the Content Security Policy on an [initializer](config/initializers/content_security_policy.rb), please see the [documentation](https://edgeguides.rubyonrails.org/security.html#content-security-policy) for more details

### Remove HTTP Headers

  - `X-Powered-By`: Not added by Rails.
  - `Server`: There is no easy way to remove this header since it's mostly the responsibility of the environment server. On development it doesn't matter, but on production its usually `NGINX`, `Apache`, etc. which handles this header.

### CORS
Rails comes with CORS built-in, but needs to be enabled and [configured](config/initializers/cors.rb).

See the [documentation](https://github.com/cyu/rack-cors#rack-configuration) for more details.

## API Endpoints

The API server defines the following endpoints:

### ???? Get public message

```bash
GET /api/messages/public
```

#### Response

```bash
Status: 200 OK
```

```json
{
  "text": "The API doesn't require an access token to share this message."
}
```

### ???? Get protected message

> You need to protect this endpoint using Auth0.

```bash
GET /api/messages/protected
```

#### Response

```bash
Status: 200 OK
```

```json
{
  "text": "The API successfully validated your access token."
}
```

### ???? Get admin message

> You need to protect this endpoint using Auth0 and Role-Based Access Control (RBAC).

```bash
GET /api/messages/admin
```

#### Response

```bash
Status: 200 OK
```

```json
{
  "text": "The API successfully recognized you as an admin."
}
```

## Error Handling

### 400s errors

#### Response

```bash
Status: Corresponding 400 status code
```

```json
{
  "message": "Message that describes the error that took place."
}
```

**Request without authorization header**
```bash
curl localhost:6060/api/messages/admin
```
```json
{"message":"Requires authentication"}
```
HTTP Status: `401`

**Request with malformed authorization header**
```bash
curl localhost:6060/api/messages/admin --header "authorization: <valid_token>"
```
```json
{
  "error": "invalid_request",
  "error_description": "Authorization header value must follow this format: Bearer access-token",
  "message": "Requires authentication"
}
```
HTTP Status: `401`

**Request with wrong authorization scheme**
```bash
curl localhost:6060/api/messages/admin --header "authorization: Basic <valid_token>"
```
```json
{"message":"Requires authentication"}
```
HTTP Status: `401`

**Request without token**
```bash
curl localhost:6060/api/messages/admin --header "authorization: Bearer"
```
```json
{
  "error": "invalid_request",
  "error_description": "Authorization header value must follow this format: Bearer access-token",
  "message": "Requires authentication"
}
```
HTTP Status: `401`

**JWT validation error**
```bash
curl localhost:6060/api/messages/admin --header "authorization: Bearer asdf123"
```
```json
{
  "error":"invalid_token",
  "error_description":"Not enough or too many segments",
  "message":"Requires authentication"
}
```
HTTP Status: `401`

**Token without required permissions**
```bash
curl localhost:6060/api/messages/admin --header "authorization: Bearer <token_without_permissions>"
```
```json
{
  "error":"insufficient_permissions",
  "error_description":"The access token does not contain the required permissions",
  "message":"Permission denied"
}
```
HTTP Status: `403`

### 500s errors

#### Response

```bash
Status: 500 Internal Server Error
```

```json
{
  "message": "Message that describes the error that took place."
}
```
