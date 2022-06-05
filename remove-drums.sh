#!/bin/bash

set -e

WORK_DIR=${PWD}
AUDIO_FILE=$(readlink -f "${1}")

TEMP_DIR=$(mktemp -d)

echo "Splitting..."
# for NUMBA_CACHE_DIR see https://github.com/librosa/librosa/issues/1156
docker run --name remove-drums-spleeter -u $(id -u):$(id -g) \
	-e NUMBA_CACHE_DIR=/tmp/ -ti --rm \
	-v ${TEMP_DIR}:/output/ \
	-w /tmp/ \
	-v "${AUDIO_FILE}:/input.m4a:ro" \
	deezer/spleeter:3.8-4stems \
	separate -f "{instrument}.{codec}" \
	-o /output/ -p "spleeter:4stems" -c m4a \
	/input.m4a

echo "Merging..."
OUTPUT_FILE="$(basename "${AUDIO_FILE}" .m4a) - Drumless.m4a"
docker run --name remove-drums-ffmpeg -u $(id -u):$(id -g) -ti --rm \
	-v ${TEMP_DIR}:/input/:ro \
	-v ${WORK_DIR}:/output/ \
	-w /tmp/ \
	jrottenberg/ffmpeg:4.3-alpine312 \
	-i /input/bass.m4a -i /input/other.m4a -i /input/vocals.m4a -filter_complex amerge=inputs=3 -ac 2 "/output/${OUTPUT_FILE}"

if [ -d "${TEMP_DIR}" ]; then
  rm -rf ${TEMP_DIR}
fi

