# ![Akali](res/akali_logo_long.png)

**Akali 0.1.0 contains breaking updates on object model and database.**

**IMPORTANT!** 
Akali is currently under heavy development. Things could break between commits, or the whole program may not be able to work at all. 

Please use at your own risk.

---

Akali is an experimental image board server written in Dart. Akali seeks to build an easy-to-use API with refined object models.

Main repository: [GitLab](https://gitlab.com/01010101lzy/akali)  
Mirror: [GitHub](https://github.com/01010101lzy/akali)

## Development

Akali requires the following software environment:

- Dart VM: `^2.1.0`
- MongoDB: `^3.6.0`

## Installation

After Akali is published to [Dart Pub](https://pub.dartlang.com/), you may install it with `pub global activate akali`. But before that, you should activate with either way listed below:


Clone and run in local repository (Development use)
```sh
git clone https://gitlab.com/01010101lzy/akali.git
cd akali
pub get
# The executed script is bin/main.dart
dart bin/main.dart
```

Or let `pub` to clone and activate it (Production use?)

```sh
pub global activate -sgit https://gitlab.com/01010101lzy/akali.git
# executable is named akali
akali
```

An alternative to above is clone as a local repo and activate in `pub`

```sh
pub global activate --source path /path/to/akali
```


## Usage

After installation, spin up your database and run the executable with

```sh
# remember to replace these with your own values!
akali \
  -D username:password@host/database \
  -i NUM_OF_INSTANCE \
  -p PORT \
  -S /path/to/your/akali_storage
```

We will introduce other run methods in the future, like using a configuration file (like most programs do), only activating part of its functions (when running in a cluster of servers), or running in docker.

### Arguments

| Abbr                     | Name                     | Default value                    | Description                            |
|--------------------------|--------------------------|----------------------------------|----------------------------------------|
| `-d`                     | `--debug`                |                                  | Run Akali in debug mode (does nothing) |
| `-D`                     | `--database=<uri>`       | `127.0.0.1:27017`                | Run Akali with database on `uri`       |
| `-p`                     | `--port=<port>`          | `8086`                           | Run Akali on port `port`               |
| `-i`                     | `--isolates=<num>`       | `1`                              | Run Akali with `num` isolates.         |
| `-S`                     | `--storage-path=<path>`  | `./akali/`                       | Store files in `path`                  |
| `--web-root-path=<path>` | `http://localhost:8086/` | Root path for all relative links |                                        |
| `-v`                     | `--version`              |                                  | Show version and exit                  |
| `-h`                     | `--help`                 |                                  | Show help message                      |

## APIs

Akali uses a RESTful api system. See [docs/api/readme.md]() (unfinished) for more information.

## FAQ

### Why do you create this project?

Danbooru is more than 7 years old, and Moebooru is more than 5. I looked for many other solutions in the web, but none of them satisfies my need. What we are going to create here is a new image board framework for the modern web, which is fast, flexible, modular, easy-to-work-with, ~~and not written in PHP~~.

And we need a project in our school's competetion.

### Is it Danbooru compatible?

Nope. This is a rather personal choice, but the PostgreSQL driver is rather hard to use (especially in the other repository of this project, AkaliSharp). Plus, we also get file storage covered with GridFS of MongoDB!

### Plugins?

Yes, but not now. We will eventually add hooks and other things in our whole processing and responding procedure, but for now we are focusing on other more important things, like dealing with buggy APIs (really!).

### When will this be usable?

Well... Will **Soon™** be a good answer? (Obviously no)

## Techinical FAQs

### Why use Dart? Shouldn't you use Go or something like that?

Because Dart is easy (and fluent!) to write while still having a relatively high performance (compared to, maybe, Ruby and older solutions?). We may consider rewriting this project or create another compatible project using Go, but Dart is enough for now.

### And why Aqueduct?

Because Aqueduct is one of the best HTTP server frameworks we could find in Dart which:

- Has high performance;
- Supports multithreading;
- Supports the OAuth2 stuff out of the box (though it needs fiddling by hand);
- Is flexible enough to add custom features;
- Is easy to write server logic with.

### PostgreSQL support?

Yes, but not now. Aqueduct comes with PostgreSQL support out-of-the-box, but we decided to stick with MongoDB for now. An abstraction of the database is being built, so that Akali accepts custom database implementations if needed.

## License

**Akali is released under MIT license**.

---

2018 -- 2019 © Rynco Li / WFCRS.
