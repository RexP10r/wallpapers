#!/bin/bash

DEST_DIR=""
LIST_FILE=""

usage() {
    echo "Usage: $0 -d <destination_directory> -l <text_file>"
    echo ""
    echo "Flags:"
    echo "  -d, --dest   : Destination directory path"
    echo "  -l, --list   : Path to the .txt file containing the list of files to transfer"
    echo "  -h, --help   : Display this help message"
    echo ""
    echo "Example .txt format (one file per line):"
    echo "  asian-village.png"
    echo "  basement.jpg"
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--dest) DEST_DIR="$2"; shift 2 ;;
        -l|--list) LIST_FILE="$2"; shift 2 ;;
        -h|--help) usage ;;
        *) echo "Error: Unknown parameter '$1'"; usage ;;
    esac
done

if [[ -z "$DEST_DIR" || -z "$LIST_FILE" ]]; then
    echo "Error: Both destination (-d) and list file (-l) flags are required."
    usage
fi

if [[ ! -d "$DEST_DIR" ]]; then
    echo "Error: Destination directory '$DEST_DIR' does not exist or is not a directory."
    exit 1
fi

if [[ ! -f "$LIST_FILE" ]]; then
    echo "Error: List file '$LIST_FILE' does not exist."
    exit 1
fi

echo "Starting transfer..."
echo "Reading from: $LIST_FILE"
echo "Moving to:    $DEST_DIR"
echo "----------------------------------------"

while IFS= read -r line || [[ -n "$line" ]]; do
    file=$(echo "$line" | tr -d '\r' | xargs)

    [[ -z "$file" || "$file" == \#* ]] && continue

    if [[ -f "$file" ]]; then
        mv "$file" "$DEST_DIR"
        echo "✅ Successfully moved: $file"
    else
        echo "❌ Warning: File '$file' does not exist. Skipping."
    fi
done < "$LIST_FILE"

echo "----------------------------------------"
echo "Transfer complete."
