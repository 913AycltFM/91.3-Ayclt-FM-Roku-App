# 91.3 Ayclt FM Roku App

A Roku SceneGraph app for listening to the 91.3 Ayclt FM radio streams and watching five live HLS TV feeds.

## Radio stations

- **Main radio:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm/roku
- **HD2 radio:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd2/roku
- **HD3 radio:** https://radio.913aycltfm.com/listen/91.3_ayclt_fm_hd3/roku

## TV feeds

The Roku app includes five selectable TV feed entries. Their labels are temporary placeholders (TV Feed 1–5) until the preferred channel names are provided.

1. **TV Feed 1:** https://tv.913aycltfm.com/memfs/37c1cf56-8954-42d5-b7a4-7c80abb86c48.m3u8
2. **TV Feed 2:** https://tv.913aycltfm.com/memfs/b502bd6f-86eb-4ca0-91c0-f09fb6a8f76e.m3u8
3. **TV Feed 3:** https://tv.913aycltfm.com/memfs/c421623b-6171-4fc8-8514-86993233d910.m3u8
4. **TV Feed 4:** https://tv.913aycltfm.com/memfs/02f36ef2-64c7-446c-a5c8-ca2fca15d02e.m3u8
5. **TV Feed 5:** https://tv.913aycltfm.com/memfs/034825aa-0374-40a9-8ebb-5cf4d3b05dfe.m3u8

The app configures these URLs as HLS using Roku SceneGraph's `Video` node and `streamFormat = "hls"`. The availability, actual codecs, and successful playback of each URL have not been verified.

## Controls

- **Left / Right:** Switch among Main, HD2, HD3, and TV Feed 1–5
- **OK / Play:** Start the selected radio stream or TV feed
- **Pause:** Pause the selected stream
- **Back:** Stop TV playback and return to the app menu

## Source layout

- `manifest` — Roku channel metadata
- `source/main.brs` — app entry point
- `components/RadioScene.xml` and `components/RadioScene.brs` — station selector, radio playback, and TV playback
- `components/NowPlayingTask.xml` and `components/NowPlayingTask.brs` — background now-playing API request

## Testing and publishing

An `.m3u8` URL is commonly an HLS playlist, but the extension alone does not confirm that a URL is reachable or compatible. Test each feed on a physical Roku device and confirm supported codecs, segment formats, and playback stability before publishing.

This repository is source code; it is not automatically synchronized with a published Roku channel. Compare the updated source with the original published app, preserve the existing channel's signing requirements, use the correct version number, build and test a package, and upload it to the existing channel only after compatibility checks pass.
