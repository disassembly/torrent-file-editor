set(ENV{LC_ALL} C)
execute_process(COMMAND date "+%a, %d %b %Y %H:%M:%S %z" OUTPUT_VARIABLE PUB_DATE OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND cpack -V -G DragNDrop CPackConfig.cmake WORKING_DIRECTORY "${CMAKE_BINARY_DIR}")
execute_process(
  COMMAND /usr/bin/openssl dgst -sha1 -binary
  COMMAND /usr/bin/openssl dgst -dss1 -sign "${CMAKE_CURRENT_LIST_DIR}/dsa_priv.pem"
  COMMAND /usr/bin/openssl enc -base64
  WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
  INPUT_FILE "${APP_NAME}-${APP_VERSION}.dmg"
  OUTPUT_VARIABLE DSA_SIGNATURE
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
set(DMG_URL "http://downloads.sourceforge.net/torrent-file-editor/${APP_NAME}-${APP_VERSION}.dmg")
execute_process(COMMAND stat -f "%z" "${CMAKE_BINARY_DIR}/${APP_NAME}-${APP_VERSION}.dmg" OUTPUT_VARIABLE DMG_LENGTH OUTPUT_STRIP_TRAILING_WHITESPACE)
configure_file(${CMAKE_CURRENT_LIST_DIR}/appcast.xml.in ${CMAKE_BINARY_DIR}/appcast.xml)
