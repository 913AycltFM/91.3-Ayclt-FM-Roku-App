# 91.3 Ayclt FM Roku App

A Roku SceneGraph starter app for listening to the 91.3 Ayclt FM radio streams.

## Stations

- **Main:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm/roku
- **HD2:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd2/roku
- **HD3:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd3/roku

The app also reads the matching AzuraCast now-playing API endpoint for each station using `/api/nowplaying/{station-slug}`.

## Controls

- **Left / Right:** Switch between Main, HD2, and HD3
- **OK / Play:** Start the selected live stream
- **Pause:** Pause the stream

If audio is playing while you switch stations, the app attempts to start playback on the newly selected station.

## Source layout

- `manifest` — Roku channel metadata
- `source/main.brs` — app entry point
- `components/RadioScene.xml` and `components/RadioScene.brs` — station screen, selector, and playback controls
- `components/NowPlayingTask.xml` and `components/NowPlayingTask.brs` — background now-playing API request

## Testing and publishing

This repository contains app source code; it is not yet a published Roku channel. Playback and station switching must be tested on a physical Roku device before submission. The code currently declares MP3 stream format for all three streams; verify that each endpoint is Roku-compatible and adjust formats if needed. Complete the required artwork, testing, and Roku developer publishing/review steps before distributing the channel.
