# Local whisper setup

Intent: A set of docker compose targets to run a local whisper text to speech server.

Requirement: NVidia card with CUDA, and the NVidia docker runtime installed. Docker compose. WSL.

Inspiration: https://github.com/nikdanilov/whisper-obsidian-plugin/pull/82/changes, 

## Usage

1. Start the local server:
    - If you have an NVIDIA GPU with CUDA support, run docker compose -f whisper-local-cuda.yaml up -d.
    - Otherwise, run docker compose -f whisper-local-cpu.yaml up -d.
    - Or just download the appropriate compose file and run the same command from any folder.
    - Both files expose the server on http://localhost:8087.

2. Configure the plugin settings:
   - API URL: `http://localhost:8000/v1/audio/transcriptions`
   - API Key: use any placeholder value like 'local' (the local server does not require a real key).
   - Model: use a Hugging Face model ID that the server can download (i.e., a faster-whisper/CTranslate2-compatible model).
3. Record audio as usual. Transcription stays local.

Notes:
- You need Docker installed on your machine.
<!-- - Only tested on Windows 11. -->
- Use `whisper-local-cpu.yaml` if you do not have an NVIDIA GPU with CUDA support.
- The first run will download the model; the Hugging Face cache is persisted in the `hf_hub_cache` volume.