#!/usr/bin/env bash

convert_arch() {
    case "$1" in
        aarch64)
            echo "arm64"
            ;;
        armhf)
            echo "arm"
            ;;
        *)
            echo "$1"
            ;;
    esac
}

space_string_to_array() {
  local space_separated_string="$1"
  local my_array=()

  while read -r -d ' ' word; do
    my_array+=("$word")
  done <<< "$space_separated_string "

  # Return the array
  echo "${my_array[@]}"
}

bash_array_to_json() {
  local -n array="$1"  # Declare a nameref to access the input array
  local json_array="["

  for element in "${array[@]}"; do
    json_array+="\"$element\","
  done

  # Remove the trailing comma
  json_array="${json_array%,}"

  json_array+="]"
  echo "$json_array"
}
