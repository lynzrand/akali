# ![Akali](res/akali_logo_long.png)

**AKALI IS NOT USABLE YET. KEY FEATURES NOT IMPLEMENTED.**

**IMPORTANT!** 
Akali is currently under heavy development. 
Things could break between commits, or the whole program may not be able to work at all. 
Please use at your own risk.



Akali is an experimental _scalable and expandable_ pic site (booru) server written in Dart.

Main repository: [GitLab](https://gitlab.com/01010101lzy/akali)  
Mirror: [GitHub](https://github.com/01010101lzy/akali)

## Development

Developing Akali (and running as well) requires the following software environment:

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

| Abbr | Name                     | Default value            | Description                            |
|------|--------------------------|--------------------------|----------------------------------------|
| `-d` | `--debug`                |                          | Run Akali in debug mode (does nothing) |
| `-D` | `--database=<uri>`       | `127.0.0.1:27017`        | Run Akali with database on `uri`       |
| `-p` | `--port=<port>`          | `8086`                   | Run Akali on port `port`               |
| `-i` | `--isolates=<num>`       | `1`                      | Run Akali with `num` isolates.         |
| `-S` | `--storage-path=<path>`  | `./akali/`               | Store files in `path`                  |
|      | `--web-root-path=<path>` | `http://localhost:8086/` | Root path for all relative links       |
| `-v` | `--version`              |                          | Show version and exit                  |
| `-h` | `--help`                 |                          | Show help message                      |

## APIs

Akali uses a RESTful api system. See [docs/api/readme.md]() (unfinished) for more information.

## FAQ

### Why do you create this project?

Danbooru is more than 7 years old, and Moebooru is more than 5. I looked for many other solutions in the web, but none of them satisfies my need. What we are going to create here is a new image board framework for the modern web, which is fast, flexible, modular, easy-to-work-with, ~~and not written in PHP~~.

And we need a project in our school's competetion.



### Is it Danbooru compatible?

Considering. We are just starting to build up this whole thing, and a lot of things aren't determined yet. We may choose to be compatible with Danbooru/Moebooru frameworks only on the database side, but not on the API side.

### Plugins?

Yes, but not now. Plugin supports are in our to-do list for stable versions after 1.0.

### When will this be usable?

We are aiming at early 2019, with 1.0 releasing in summer 2019. Times may vary due to our pressure in study. Contributions are welcomed if you want to speed up our development!

## Techinical FAQs

### Why use Dart? Shouldn't you use Go or something like that?

Because Dart is easy (and fluent!) to write while still having a relatively high performance (compared to, maybe, Ruby and older solutions?). We may consider rewriting this project or create another compatible project using Go, but Dart is enough for now.

### And why Aqueduct?

Because Aqueduct is one of the best HTTP server frameworks we could find in Dart which:

- Has high performance;
- Supports multithreading;
- Supports the OAuth2 stuff out of the box;
- Is flexible enough to add custom features;
- Is easy to write server logic with.

### PostgreSQL support?

Yes, but not now. Aqueduct comes with PostgreSQL support out-of-the-box, but we decided to stick with MongoDB for now. An abstraction of the database is being built, so that Akali accepts custom database implementations if needed.

## License

**Akali is released under MIT license**.

---

2018 -- 2019 © Rynco Li / WFCRS.

p.s. The name of the project, Akali, came from "alkali". Therefore, it is preferably pronounced `/'aka﹑lai/`_(aka-lai)_, with the "i" pronouncing `/ai/` like that in "alkali".
