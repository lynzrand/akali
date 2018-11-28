# ![Akali](res/akali_logo_long.png)

**AKALI IS NOT USABLE YET. KEY FEATURES NOT IMPLEMENTED.**

**IMPORTANT!** 
Akali is currently under heavy development. 
Things could break between commits, or the whole program may not be able to work at all. 
Please use at your own risk.

Akali is an experimental _scalable and expandable_ pic site (booru) server written in Dart.

## Development

Developing Akali (and running as well) requires the following software 
environment:

- Dart VM: `^2.1.0`
- MongoDB: `^3.6.0`

## Usage

With your database running, run:

```shell
# For development, first clone this project, then:
$ cd path/to/akali
$ dart bin/main.dart 

# You may want to use Dart's observatory:
$ dart --observe=<port> bin/main.dart

# In production, simply use:
$ pub global activate akali
$ akali
```

We will introduce other run methods in the future, like using a configuration file (like most programs do), only activating part of its functions (when running in a cluster of servers), or running in docker.

### Arguments

| Abbr | Name               | Default value     | Description                      |
|------|--------------------|-------------------|----------------------------------|
| `-d` | `--debug`          |                   | Run Akali in debug mode          |
| `-D` | `--database=<uri>` | `127.0.0.1:27017` | Run Akali with database on `uri` |
| `-p` | `--port=<port>`    | `8086`            | Run Akali on port `port`         |
| `-v` | `--version`        |                   | Show version and exit            |
| `-h` | `--help`           |                   | Show help message                |

## APIs

See [docs/api/readme.md]().

## FAQ

### Why use Dart? Shouldn't you use Go or something like that?

Because Dart is easy (and fluent!) to write while still having a relatively high performance (compared to, maybe, PHP and older solutions?). We may consider rewriting this project or create another compatible project using Go, but Dart is enough for now.

### And why Aqueduct?

Because Aqueduct is one of the best HTTP server frameworks we could find in Dart which:

- Has high performance;
- Supports multithreading;
- Is flexible enough to add custom features;
- Is easy to write server logic with.

### Will we be able to migrate from Danbooru to Akali?

We are thinking of making it compatible with Danbooru databases in the future, but we are focusing on other aspects for now.

## License

**Akali is released under MIT license**, which means you could use it for commercial projects. 
Though, we recommend you to open-source your own fork of Akali for a better community environment.

---

2018 © Rynco Li / WFCRS.

p.s. The name of the project, Akali, came from "alkali". Therefore, it is preferably pronounced `/'aka﹑lai/`_(aka-lai)_, with the "i" pronouncing `/ai/` like that in "alkali".
