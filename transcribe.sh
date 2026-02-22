export SPEACHES_BASE_URL="http://localhost:8087"
export TRANSCRIPTION_MODEL_ID="Systran/faster-whisper-medium.en"

input_filename=$1
output_filename="${input_filename%.*}.md"
echo "Will output to $output_filename"
echo "Input file information $(ls -lh "$input_filename")"

curl -s "$SPEACHES_BASE_URL/v1/audio/transcriptions" \
    -F model="$TRANSCRIPTION_MODEL_ID" -F "file=@$input_filename" | \
    tee "$output_filename"
