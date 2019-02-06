# Akali API documentation

Akali uses a RESTful api system.

The following shows an overview of Akali's API:

```
your.akali.site/
  file/
    img/
      :id
  api/
    v1/
      img/          GET, POST
        :id         GET, PUT, DELETE
      tags/         GET, POST
        [TBD]
      auth/
        code        GET
        
```

The following content lists all apis used by Akali:

**Since all APIs are prepended with `/api/v1`, we will omit this term below.**

## Picture-related

| Method   | Path       | Description                               | Success Response |
|----------|------------|-------------------------------------------|------------------|
| `GET`    | `/img`     | Search image by `tags`, `author` and more | `List<Pic>`      |
| `POST`   | `/img`     | Upload a binary image file                | Success Message  |
| `GET`    | `/img/:id` | Get metadata for image `id`               | `Pic`            |
| `PUT`    | `/img/:id` | Update image `id`'s metadata              | Success Message  |
| `DELETE` | `/img/:id` | Deletes image `id` and its metadata       | Success Message  |

TBD.

## Comment-related

TBD.

## Picture Search

TBD.

## Accounts

TBD.

## Utilities

TBD.
