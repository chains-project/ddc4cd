#!/bin/bash -e
# summarises results of DDC and fails if any hashes dont match
# assumes build-* are present in current directory and computes hashes
sha_tcc_all=""
sha_libtcc_all=""
sha_libtcc1_all=""
fail_on_exit=false

summarise_one_build () {
    
    {   echo "### DDC results ${1}" 
        echo "| File | sha256 |"
        echo "| :--- | :--- |"
    } >> $GITHUB_STEP_SUMMARY

    # calculate relevant hashes
    local sha_tcc=$(sha256sum $1/*stage2/tmp/build/tcc-root/bin/tcc)
    local sha_libtcc=$(sha256sum $1/*stage2/tmp/build/tcc-root/lib/libtcc.a)
    local sha_libtcc1=$(sha256sum $1/*stage2/tmp/build/tcc-root/lib/tcc/libtcc1.a)

    while read -r hash filename; do
        echo "| $filename | $hash |" >> $GITHUB_STEP_SUMMARY
        sha_tcc_all+="$hash"$'\n'
    done < <(echo "$sha_tcc") 

    echo "| :--- | :--- |"

    while read -r hash filename; do
        echo "| $filename | $hash |" >> $GITHUB_STEP_SUMMARY
        sha_libtcc_all+="$hash"$'\n'
    done < <(echo "$sha_libtcc")

    echo "| :--- | :--- |"

    while read -r hash filename; do
        echo "| $filename | $hash |" >> $GITHUB_STEP_SUMMARY
        sha_libtcc1_all+="$hash"$'\n'
    done < <(echo "$sha_libtcc1")
}

# find all build directories
for dir in build-*; do
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
echo "## DDC Summary: " >> $GITHUB_STEP_SUMMARY
if [ $(echo "$unique_hashes_tcc" | wc -l) -ne 1 ]; then
    echo "Error: All SHA256 hashes do not match for tcc!" >> $GITHUB_STEP_SUMMARY
    fail_on_exit=true
fi

if [ $(echo "$unique_hashes_libtcc" | wc -l) -ne 1 ]; then
    echo "Error: All SHA256 hashes do not match for libtcc!" >> $GITHUB_STEP_SUMMARY
    fail_on_exit=true
fi

if [ $(echo "$unique_hashes_libtcc1" | wc -l) -ne 1 ]; then
    echo "Error: All SHA256 hashes do not match for libtcc1!" >> $GITHUB_STEP_SUMMARY
    fail_on_exit=true
fi

if [ "$fail_on_exit" = true ]; then
    exit 1
else
    echo "Successful!" >> $GITHUB_STEP_SUMMARY
fi
