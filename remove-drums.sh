#!/bin/bash

WORK_DIR=${PWD}
AUDIO_FILE=${1}

TEMP_DIR=$(uuidgen)
mkdir -p ${WORK_DIR}/${TEMP_DIR}

echo "Splitting..."
# for NUMBA_CACHE_DIR see https://github.com/librosa/librosa/issues/1156
docker run --name spleeter -u $(id -u):$(id -g) -e NUMBA_CACHE_DIR=/tmp/ -ti --rm \
	-v ${WORK_DIR}:/work/ -w /work/ deezer/spleeter:3.8-4stems \
	separate -f "{instrument}.{codec}" \
	-o /work/${TEMP_DIR}/ -p "spleeter:4stems" -c m4a \
	"${AUDIO_FILE}"

echo "Merging..."
OUTPUT_DIR=${WORK_DIR}/${TEMP_DIR}/
OUTPUT_FILE="$(basename "${AUDIO_FILE}" .m4a) - Drumless.m4a"
ffmpeg -i ${OUTPUT_DIR}/bass.m4a -i ${OUTPUT_DIR}/other.m4a -i ${OUTPUT_DIR}/vocals.m4a -filter_complex amerge=inputs=3 -ac 2 "${WORK_DIR}/${OUTPUT_FILE}"
if [ -d "${WORK_DIR}/${TEMP_DIR}" ]; then
  rm -rf ${WORK_DIR}/${TEMP_DIR}
fi

