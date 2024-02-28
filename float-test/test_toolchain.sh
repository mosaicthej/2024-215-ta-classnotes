#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <compiler> <file_to_compile> <march_options_file> <mabi_options_file>"
    exit 1
fi

# Assign arguments to variables
compiler=$1
file_to_compile=$2
march_options_file=$3
mabi_options_file=$4

# Files to log successful and unsuccessful compilations
success_log="compilation_success.log"
error_log="compilation_errors.log"

# Empty previous logs
> "$success_log"
> "$error_log"

# Iterate over every combination of march and mabi
while IFS= read -r march; do
    while IFS= read -r mabi; do
        # Attempt to compile
        output=$($compiler -march=$march -mabi=$mabi $file_to_compile 2>&1)
        ret_code=$?

        # Check if compilation was successful
        if [ $ret_code -eq 0 ]; then
            echo "Success: -march=$march -mabi=$mabi" >> "$success_log"
        else
            echo "Error: -march=$march -mabi=$mabi" >> "$error_log"
            echo "$output" >> "$error_log"
        fi
    done < "$mabi_options_file"
done < "$march_options_file"

echo "Compilation tests completed."

