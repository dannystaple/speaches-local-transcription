# Local whisper setup

Intent: A set of docker compose targets to run a local whisper text to speech server.

Requirement: NVidia card with CUDA, and the NVidia docker runtime installed. Docker compose. WSL.


You get:
- A local server running faster-whisper with CTranslate2, exposing an OpenAI-compatible API for transcription.
- A script to transcribe local audio files using the same API, which you can use with any audio file (e.g., from your phone) without uploading to a third party.
- Some notes on connecting the Obsidian plugin to this local server, and testing it.

Inspiration: https://github.com/nikdanilov/whisper-obsidian-plugin/pull/82/changes, 
And then: https://speaches.ai/installation/ + https://github.com/speaches-ai/speaches/blob/master/compose.yaml

## Workflow for transcribing local audio files

(Using wsl)

Finding amr files:

`find . -type f -name "*.amr"`

Transcribing:

`transcribe.sh "path/to/file.amr"`

(I've made a link to this script in my path so I can run it from anywhere, but you can also just run it from the local folder with `./transcribe.sh`.)

Verifying output:

- Opening in VLC - "wslview path/to/file.amr"
- Opening the output file "code path/to/file.md"

Make edits, make it more "markdown". Split the lines.
Remove the amr when happy.

## Setup

1. Start the local server:
    - If you have an NVIDIA GPU with CUDA support, run docker compose -f whisper-local-cuda.yaml up -d.
    - Otherwise, run docker compose -f whisper-local-cpu.yaml up -d.
    - Or just download the appropriate compose file and run the same command from any folder.
    - Both files expose the server on http://localhost:8087.

2. Configure the whisper obsidian plugin settings:
   - API URL: `http://localhost:8087/v1/audio/transcriptions`
   - API Key: use any placeholder value like 'local' (the local server does not require a real key).
   - Model: use a Hugging Face model ID that the server can download (i.e., a faster-whisper/CTranslate2-compatible model). I'm using Systran/faster-whisper-medium.en
3. Record audio as usual. Transcription stays local.

Notes:
- You need Docker installed on your machine.
<!-- - Only tested on Windows 11. -->
- Use `whisper-local-cpu.yaml` if you do not have an NVIDIA GPU with CUDA support.
- The first run will download the model; the Hugging Face cache is persisted in the `hf_hub_cache` volume.

## Testing notes:

- 2026-02-22 12:41:19,259:INFO:faster_whisper_server.routers.stt:handle_default_openai_model:whisper-1 is not a valid model name. Using Systran/faster-whisper-large-v3 instead.

So it's downloading a model. That might be too large?

What about - Systran/faster-whisper-medium.en
https://huggingface.co/Systran/faster-whisper-medium.en

## Setting up models 

See https://speaches.ai/usage/model-discovery/.

- `uvx speaches-cli model download  Systran/faster-whisper-medium.en`
