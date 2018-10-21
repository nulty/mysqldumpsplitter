# mysqldumpsplitter

Inspired by Kedarvj's shell script by the same name.

https://github.com/kedarvj/mysqldumpsplitter

## Installation


## Build

```crystal
$ crystal build --release -o bin/mysqldumpsplitter
```


## Usage

### Help
```shell
bin/mysqldumpsplitter --help
```

### List all the tables in a dump file
```shell
bin/mysqldumpsplitter --desc ./path/to/file.sql
```

### Extract a single table from an *.sql dump file to .sql.gz
```shell
# Default output file is gzip compressed
bin/mysqldumpsplitter --extract TABLE --match some_table_name ./path/to/file.sql
```

### Decompressed output file
```shell
bin/mysqldumpsplitter --extract TABLE --match some_table_name --compression none ./path/to/file.sql
```

### Extract all tables from a dump file
```shell
bin/mysqldumpsplitter --extract ALLTABLES ./path/to/file.sql
```


## Development


 - Single database file
   - [x] Describe tables
   - [x] Extract single table
   - [x] Extract all tables
   - [x] Compression
   - [ ] Decompression
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

## Testing
 **_Build the project before running tests as some tests depend on the executable_

```shell
crystal spec
```

## Contributors

- [nulty](https://github.com/nulty) Iain McNulty - creator, maintainer
