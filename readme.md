# remove-drums

### Remove drums from audio file with spleeter

This uses the docker images [deezer/spleeter](https://hub.docker.com/r/deezer/spleeter) for splitting and [jrottenberg/ffmpeg](https://hub.docker.com/r/jrottenberg/ffmpeg) for mixing afterwards.

## Prerequisites

* bash
* docker


## Usage

```bash
./remove-drums.sh <audio.m4a>
```
## License

Copyright (c) 2022 by [Cornelius Buschka](https://github.com/cbuschka).

[MIT](./license.txt)
