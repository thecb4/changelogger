# ChangeLogger

Take control of your changelogs!

Programmatically generate a [CHANGELOG.md](https://keepachangelog.com/en/1.0.0/) from a YAML formatted file.
Also generates a RELEASE.md with just the latest release info.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

## Built With

* [Swift Package Manager](https://github.com/apple/swift-package-manager) - Command Line Interface
* [Yams](https://github.com/jpsim/Yams) - Read/Write YAML
* [Path.swift](https://github.com/mxcl/Path.swift) - File path management

### Prerequisites

* [Swift](https://swift.org), 5.0.1 (swiftlang-1001.0.82.4 clang-1001.0.46.5)


### Installing

[Mint](https://github.com/yonaskolb/Mint) is a swift based package manager

```
mint install https://gitlab.com/thecb4/changelogger // install latest version
mint install https://gitlab.com/thecb4/changelogger@0.3.0 // install specific version
mint install https://gitlab.com/thecb4/changelogger --no-link // install locally
mint install https://gitlab.com/thecb4/changelogger --force // force reinstall
```

## Using

### Init
Initialize your current directory with two files
- commit.yml, Where you will keep track of your changes.
- .changelog/changelog.yml, Where the tool will keep track of all your changes

```
changelogger init
```

### Update commit.yml
Write whatever you need to write as a list of changes as specified by

```
summary: Fixing workflow

added:
  - Some new feature
changed: []
deprecated: []
removed: []
fixed: []
security: []

```

### Log commit.yml to changelog.yml
```
changelogger log
```

### Create CHANGELOG.md with unreleased logs
```
changelogger markdown
```

### Create new release in changelog.yml
Currently version tag can be anything
```
changelogger release "brilliant summary" --version-tag 0.2.0
```

### Release a new changelog
Currently version tag can be anything
```
changelogger markdown
```



## Roadmap and Contributing

### Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).



### Roadmap

Please read [ROADMAP](ROADMAP.md) for an outline of how we would like to evolve the library.

### Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for changes to us.

### Changes

Please read [CHANGELOG](CHANGELOG.md) for details on changes to the library.


## Authors

* **'Cavelle Benjamin'** - *Initial work* - [thecb4](https://thecb4.io)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
