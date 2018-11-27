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
      user/
        [TBD]
```

The following content lists all apis used by Akali:

## Picture-related

| Method | Path                                       | Response  |
|--------|--------------------------------------------|-----------|
| `GET`  | `/api/v1/pic/list?tags=tags&author=author` | List<Pic> |

TBD.

## Comment-related

TBD.

## Picture Search

TBD.

## Accounts

TBD.

## Utilities

TBD.
