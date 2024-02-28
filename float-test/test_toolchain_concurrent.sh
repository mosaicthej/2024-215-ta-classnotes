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

# Initialize log files with current date and time
current_date_time=$(date "+%Y-%m-%d %H:%M:%S")
echo "Test Date and Time: $current_date_time" > "$success_log"
echo "Test Date and Time: $current_date_time" > "$error_log"

# Function to compile with a specific march and mabi
compile() {
    local march=$1
    local mabi=$2

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
}

# Read and export march and mabi options for access in subshells
march_options=($(<"$march_options_file"))
mabi_options=($(<"$mabi_options_file"))
export -f compile
export compiler file_to_compile success_log error_log

# Max number of concurrent jobs
max_jobs=48

# Launch compilations concurrently
for march in "${march_options[@]}"; do
    for mabi in "${mabi_options[@]}"; do
        compile "$march" "$mabi" &

        # Simple job control to not exceed max_jobs
        while [ "$(jobs | wc -l)" -ge "$max_jobs" ]; do
            sleep 0.1
            jobs > /dev/null # Clean up job table
        done
    done
done

# Wait for all background jobs to finish
wait

echo "Compilation tests completed."

