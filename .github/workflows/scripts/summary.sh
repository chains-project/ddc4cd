#!/bin/bash -e
# summarises results of DDC and fails if any hashes dont match
# assumes build-* are present in current directory and computes hashes
sha_tcc_all=""
sha_libtcc_all=""
sha_libtcc1_all=""
fail_on_exit=false
summary_output=""
stage2_prefix="/usr/local"

summarise_one_build () {
    
    summary_output+="### DDC results ${1}\n" 
    summary_output+="| tcc | sha256 |\n"
    summary_output+="| :--- | :--- |\n"

    # calculate relevant hashes
    local sha_tcc=$(sha256sum $1/*stage2${stage2_prefix}/bin/tcc)
    local sha_libtcc=$(sha256sum $1/*stage2${stage2_prefix}/lib/libtcc.a)
    local sha_libtcc1=$(sha256sum $1/*stage2${stage2_prefix}/lib/tcc/libtcc1.a)

    while read -r hash filename; do
        summary_output+="| $filename | $hash |\n"
        sha_tcc_all+="$hash"$'\n'
    done < <(echo "$sha_tcc") 

    summary_output+="| **libtcc.a** | **sha256** |\n"

    while read -r hash filename; do
        summary_output+="| $filename | $hash |\n"
        sha_libtcc_all+="$hash"$'\n'
    done < <(echo "$sha_libtcc")

    summary_output+="| **libtcc1.a** | **sha256** |\n"

    while read -r hash filename; do
        summary_output+="| $filename | $hash |\n"
        sha_libtcc1_all+="$hash"$'\n'
    done < <(echo "$sha_libtcc1")
}

# find all build directories
for dir in build-artifacts/build-*; do
    if [ -d "$dir" ]; then
        summarise_one_build "$dir"
    fi
done

# filter out empty lines
sha_tcc_all=$(echo "$sha_tcc_all" | grep .)
sha_libtcc_all=$(echo "$sha_libtcc_all" | grep .)
sha_libtcc1_all=$(echo "$sha_libtcc1_all" | grep .)

# Extract unique hashes to be sure all match
unique_hashes_tcc=$(echo "$sha_tcc_all" | sort -u)
unique_hashes_libtcc=$(echo "$sha_libtcc_all" | sort -u)
unique_hashes_libtcc1=$(echo "$sha_libtcc1_all" | sort -u)
# Check if all hashes are the same for each relevant file
echo "## DDC Summary: tcc@${1}" >> $GITHUB_STEP_SUMMARY
if [ $(echo "$unique_hashes_tcc" | wc -l) -ne 1 ]; then
    echo ":x: Error: All SHA256 hashes do not match for tcc!" >> $GITHUB_STEP_SUMMARY
    fail_on_exit=true
fi

if [ $(echo "$unique_hashes_libtcc" | wc -l) -ne 1 ]; then
    echo ":x: Error: All SHA256 hashes do not match for libtcc!" >> $GITHUB_STEP_SUMMARY
    fail_on_exit=true
fi

if [ $(echo "$unique_hashes_libtcc1" | wc -l) -ne 1 ]; then
    echo ":x: Error: All SHA256 hashes do not match for libtcc1!" >> $GITHUB_STEP_SUMMARY
    fail_on_exit=true
fi

if [ "$fail_on_exit" = true ]; then
    echo -e $summary_output >> $GITHUB_STEP_SUMMARY
    exit 1
else
    echo ":white_check_mark: Successful!" >> $GITHUB_STEP_SUMMARY
    echo -e $summary_output >> $GITHUB_STEP_SUMMARY
fi
