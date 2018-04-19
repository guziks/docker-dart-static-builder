## About

Docker base image to build dart server side applications. Main feature is that app is statically built, resulting in creating [dart application snapshot](https://github.com/dart-lang/sdk/wiki/Snapshots). This way there is no need to keep whole dart sdk and pub dependencies inside an image.

Intended to be used with base runtime image: [dart-static-runtime](https://hub.docker.com/r/guziks/dart-static-runtime) (it can be replaced).

## Tags

Available tags correspond to those of [google/dart](https://hub.docker.com/r/google/dart/tags).

## Prerequisites

To work with this image an app must follow this simple rules:

1. App conforms to [Pub Package Layout Conventions](https://www.dartlang.org/tools/pub/package-layout). Main points:
    * there are `bin` and `lib` folders
    * there is/are `pubspeck.yaml` and (optionally) `pubspec.lock`
2. All dependencies can be fetched with `pub get`
3. Entrypoint is `bin/main.dart`
4. `main.dart` can be run with command `dart main.dart --help` and this invocation must return `0` exit code

## Usage

Create `Dockerfile` like this:

```
FROM guziks/dart-static-builder as builder
FROM guziks/dart-static-runtime
EXPOSE <port1> <port2> ...
CMD ["arg1", "arg2", ...]
```

For example if server can be launched with this command:

```
$ dart main.dart server --port 8080
``` 

then this is your `CMD`:

```
CMD ["server", "--port", "8080"]
```

**Tip:** if an app does not require any arguments to run then `Dockerfile` may be just two lines long (assuming `EXPOSE` is omitted).

**Important:** use square brackets syntax, do NOT write: `CMD server --port 8080`.

**Important:** `as builder` is required for the runtime image to work.

**Note:** Why `--help` is required? When dart does static compilation using `app-jit` snapshot kind, it makes what is called "training run". So we need a command that will temporarily launch the app. `--help` was chosen just because of its wide spread in dart apps, if the app uses `CommandRunner` from popular [args](https://pub.dartlang.org/packages/args) package then it's already compatible.
