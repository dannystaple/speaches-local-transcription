export SPEACHES_BASE_URL="http://localhost:8087"
export TRANSCRIPTION_MODEL_ID="Systran/faster-whisper-medium.en"
# TRANSCRIPTION_PROMPTS did not seem to effect output

input_filename=$1
output_filename="${input_filename%.*}.md"
echo "Will output to $output_filename"
echo "Input file information $(ls -lh "$input_filename")"
echo

curl -s "$SPEACHES_BASE_URL/v1/audio/transcriptions" \
    -F model="$TRANSCRIPTION_MODEL_ID" \
    -F "response_format=text" \
    -F "file=@$input_filename" | \
    perl -0777 -pe 's/\r\n?/\n/g; s/[ \t]+/ /g; s/\n+/ /g; s/\s*([.!?])\s+/$1\n/g; s/\s+$//;' | \
    awk '1; END { print "" }' | \
    tee "$output_filename"
