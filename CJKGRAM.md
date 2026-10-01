# CJKGram for iOS

CJKGram is an independent iOS client based on the official
[Telegram-iOS](https://github.com/TelegramMessenger/Telegram-iOS) source.
The first platform change is CJK-friendly local message search.

## What changed

Telegram's message text index normally groups words by whitespace. CJKGram
splits Chinese, Japanese and Korean characters into searchable terms and
intersects their results. A query such as `東京駅` therefore matches a message
containing those characters even when the text has no spaces. Latin words stay
grouped, so mixed queries such as `東京 station` continue to work.

The change is deliberately inside Postbox's existing index path. It does not
add a second database, upload message text, or alter the Telegram protocol.

## Build on macOS

Use the upstream prerequisites and project-generation steps in
[README.md](README.md). Before building, create an application configuration
with your own Telegram `api_id`, application identifier, Apple Team ID and
bundle identifiers. CJKGram is an unofficial client and must use its own API
credentials and branding.

```sh
git clone --recursive -j8 https://github.com/githubhjs/CJKGram-iOS.git
cd CJKGram-iOS
python3 build-system/Make/Make.py \
  --cacheDir="$HOME/cjkgram-bazel-cache" \
  generateProject \
  --configurationPath=build-system/template_minimal_development_configuration.json \
  --xcodeManagedCodesigning
```

The repository's GitHub Actions workflow can be used as a macOS build
reference. Signing and App Store distribution require the maintainer's Apple
certificates and provisioning profiles; they are intentionally not committed.

## Upstream sync

```sh
git remote add upstream https://github.com/TelegramMessenger/Telegram-iOS.git
git fetch upstream master
git rebase upstream/master
```

Telegram-iOS is licensed under GPLv2. Keep the upstream notices and publish
corresponding source for distributed builds.
