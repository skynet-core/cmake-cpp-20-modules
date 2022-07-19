file(GLOB FILES "*.o")

foreach(FILE IN LISTS FILES)
    message(TRACE  "processing ${FILE}")
    string(REGEX REPLACE ".o$" ".pcm" NAME "${FILE}")
    message(TRACE "${NAME}")
    file(RENAME "${FILE}" "${NAME}")
endforeach()
