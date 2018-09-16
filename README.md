# mysqldumpsplitter

Inspired by Kedarvj's shell script by the same name.

https://github.com/kedarvj/mysqldumpsplitter

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  mysqldumpsplitter:
    github: nulty/mysqldumpsplitter
```

## Usage

```crystal
require "mysqldumpsplitter"
```

## Build

```crystal
$ crystal build --release -o bin/mysqldumpsplitter
```


## Development

 - Single database file
   - [x] Describe tables
   - [x] Extract single table
   - [ ] Extract all tables
   - [ ] Compression
   - [ ] Estimate table size 
 - Multiple Databases in one file
   - [ ] Extract single database
   - [ ] Extract multiple databases

## Contributing

1. Fork it (<https://github.com/nulty/mysqldumpsplitter/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [nulty](https://github.com/nulty) Iain McNulty - creator, maintainer
