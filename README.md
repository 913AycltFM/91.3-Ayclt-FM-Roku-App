# 91.3 Ayclt FM Roku App

A Roku SceneGraph app for listening to the 91.3 Ayclt FM radio streams and watching the live TV feed.

## Stations and feeds

- **Main radio:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm/roku
- **HD2 radio:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd2/roku
- **HD3 radio:** https://radio.913aycltfm.com/listen/91.3_aycltfm_hd3/roku
- **TV live HLS feed:** https://tv.913aycltfm.com/memfs/37c1cf56-8954-42d5-b7a4-7c80abb86c48.m3u8

The app reads the matching AzuraCast now-playing API endpoint for each radio station using `/api/nowplaying/{station-slug}`.

## Controls

- **Left / Right:** Switch between Main, HD2, HD3, and TV
- **OK / Play:** Start the selected radio station or TV feed
- **Pause:** Pause the selected stream
- **Back:** Stop the TV feed and return to the app screen

## Source layout

- `manifest` — Roku channel metadata
- `source/main.brs` — app entry point
- `components/RadioScene.xml` and `components/RadioScene.brs` — station selector, radio playback, and live TV playback
- `components/NowPlayingTask.xml` and `components/NowPlayingTask.brs` — background now-playing API request

## Testing and publishing

The TV URL is configured as an HLS stream using Roku SceneGraph's `Video` node. The URL could not be verified from the web check, so the feed's availability and actual codecs are not yet confirmed. Test it on a physical Roku device before submitting an update.

This repository is source code; it is not automatically synchronized with a published Roku channel. Build and test a package, preserve the existing channel's signing requirements, increment the package version as required, and upload the tested update to the existing channel only after confirming compatibility with the currently published app.
