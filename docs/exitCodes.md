# Akali Exit Codes

This should be useful in automated scripts.

| Code     | Meaning                                    |
|----------|--------------------------------------------|
| `0`      | Nothing is wrong.                          |
| `1--32`  | Things went wrong in initialization phase. |
| `1`      | Bad config file.                           |
| `4`      | Unable to bind port.                       |
| `5`      | Unable to connect database.                |
| `33--64` | Things went wrong when serving.            |
| `64+`    | Reserved                                   |
