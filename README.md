# 91.3 Ayclt FM Roku App

A Roku SceneGraph starter app for listening to 91.3 Ayclt FM.

## Station endpoints

- **Live stream:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm/roku
- **AzuraCast now-playing API:** https://radio.913aycltfm.com/api/nowplaying/91.3_ayclt_fm

## Features in this starter

- Station-branded radio screen
- Live audio playback controls
- Current song and artist from AzuraCast
- On-air streamer name when supplied by the API
- Refreshes now-playing information every 30 seconds

## Source layout

- `manifest` — Roku channel metadata
- `source/main.brs` — app entry point
- `components/RadioScene.xml` and `components/RadioScene.brs` — screen and playback controls
- `components/NowPlayingTask.xml` and `components/NowPlayingTask.brs` — background API request

## Status and next steps

This repository contains source code; it is **not yet a published Roku channel**. Playback has not been tested on a physical Roku device from this repository.

Before publishing:
1. Test the stream and verify its actual media format on a Roku device.
2. Add Roku-compliant channel artwork and any other assets required by the current Roku submission flow.
3. Test playback, pause/resume, now-playing updates, and network-error behavior.
4. Submit the channel through the Roku developer dashboard and complete Roku's review/publishing requirements.

The player is configured for an MP3 stream. If the provided AzuraCast /roku endpoint serves another format or redirects in a way Roku does not support, adjust the content stream format and endpoint after testing.
