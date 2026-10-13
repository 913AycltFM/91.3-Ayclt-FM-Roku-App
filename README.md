# 91.3 Ayclt FM Roku App

A Roku SceneGraph app for listening to the 91.3 Ayclt FM radio streams and watching the live TV feed.

## Stations and feeds

- **Main radio:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm/roku
- **HD2 radio:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd2/roku
- **HD3 radio:** https://radio.913aycltfm.com/listen/91.3_aycltfm_hd3/roku
- **TV live HLS feed:** https://tv.913aycltfm.com/memfs/b502bd6f-86eb-4ca0-91c0-f09fb6a8f76e.m3u8

The app reads the matching AzuraCast now-playing API endpoint for each radio station using `/api/nowplaying/{station-slug}`.

## Controls

- **Left / Right:** Switch between Main, HD2, HD3, and TV
- **OK / Play:** Start the selected radio station or TV feed
- **Pause:** Pause the selected stream
- **Back:** Stop TV playback and return to the app menu

## Source layout

- `manifest` — Roku channel metadata
- `source/main.brs` — app entry point
- `components/RadioScene.xml` and `components/RadioScene.brs` — station selector, radio playback, and live TV playback
- `components/NowPlayingTask.xml` and `components/NowPlayingTask.brs` — background now-playing API request

## Testing and publishing

The TV URL is configured as an HLS stream using Roku SceneGraph's `Video` node and `streamFormat = "hls"`. The feed's availability and actual codecs have not been confirmed, so test it on a physical Roku device. Roku's HLS support depends on the stream using supported codecs and segment formats; see the [Roku streaming specifications](https://developer.roku.com/dev/docs/media).

This repository is source code; it is not automatically synchronized with a published Roku channel. Build and test a package, preserve the existing channel's signing requirements, and use the version number required by your current published app before uploading an update to that same channel.
