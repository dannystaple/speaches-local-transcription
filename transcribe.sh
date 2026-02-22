export SPEACHES_BASE_URL="http://localhost:8087"
export TRANSCRIPTION_MODEL_ID="Systran/faster-whisper-medium.en"
# TRANSCRIPTION_PROMPTS did not seem to effect output

input_filename=$1
output_filename="${input_filename%.*}.md"
input_epoch=$(stat -c '%Y' "$input_filename")
input_timestamp=$(date -d "@$input_epoch" --iso-8601=seconds)
echo "Will output to $output_filename"
echo "Input file information $(ls -lh "$input_filename")"
echo

{
    printf "# Transcription\n\n"
    printf -- "- Source file: %s\n" "$input_filename"
    printf -- "- Original timestamp: %s\n\n" "$input_timestamp"

    curl -s "$SPEACHES_BASE_URL/v1/audio/transcriptions" \
        -F model="$TRANSCRIPTION_MODEL_ID" \
        -F "response_format=text" \
        -F "file=@$input_filename" | \
        perl -0777 -pe 's/\r\n?/\n/g; s/[ \t]+/ /g; s/\n+/ /g; s/\s*([.!?])\s+/$1\n/g; s/\s+$//;'
    echo ""
} | tee "$output_filename"
