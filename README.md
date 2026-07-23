# random

A self-hosted password and text generator that runs entirely in the browser from a single HTML file. No backend, no build step, no runtime dependencies — just `index.html` plus a bundled wordlist. Randomness for the text tools and passphrases comes from the Web Crypto API (`crypto.getRandomValues` / `crypto.randomUUID`), not `Math.random`.

![random](preview.png)

## Features

- **Two tabs — Password and Text** — in one card, dark/light aware (follows the OS `prefers-color-scheme`).
- **Password tab**
  - **Length** slider (4–64) paired with a number box.
  - **Choose** — generates five options; click any one to copy it.
  - **Copy** — generates a fresh password straight to the clipboard.
  - **Options** drawer — uppercase, numbers, special characters, and exclusions for similar (`Il1O0`), vowels, and ambiguous (`{}[]()/\'"~,;:.<>`) characters.
  - **Correct Horse Battery Staple** — passphrase mode. Selecting it switches the length to a word count, locks the other options, and builds passphrases from random dictionary words.
- **Text tab**
  - **IDs** — UUID (v4), ULID (sortable, Crockford base32), MAC (random 6-byte).
  - **Encodings** — Base64URL, raw bytes (space-separated decimals), and hex, each `N` units long from the length slider.
  - Output slides in; click it to copy.
- **Copy feedback** — every copyable element flashes the same ping; a "new random password copied to clipboard" notice appears beneath the card on **Copy**.

## Passphrase wordlist

Passphrase mode reads `words.txt`, fetched from the same origin on page load. The bundled list is **14,129 unique words** (3–9 letters), merged and deduplicated from three sources:

| Source | Purpose |
|--------|---------|
| [google-10000-english](https://github.com/first20hours/google-10000-english) (no-swears) | Common, memorable words |
| [EFF Large Wordlist](https://www.eff.org/dice) | Curated for passphrases (distinct prefixes, edit distance ≥ 3) |
| [BIP-39 English](https://github.com/bitcoin/bips/blob/master/bip-0039/bip-0039-wordlists.md) | Clean crypto seed-phrase list |

That is ≈13.8 bits per word, so a 4-word passphrase carries ≈55 bits of entropy. Adding a word beats expanding the list: each extra word adds ~13.8 bits, while doubling the list adds only 1 bit per word.

To regenerate or extend `words.txt`, merge the sources, filter to `^[a-z]{3,9}$`, then `sort -u`.

## Running locally

The character password generator and all text tools work by simply opening `index.html` in any modern browser — no server required.

**Passphrase mode is the exception:** it fetches `words.txt`, and browsers block `fetch` over `file://`. To use it locally, serve the directory over HTTP:

```bash
python3 -m http.server 8799
# then open http://localhost:8799/
```

## Deployment

The site is packaged as a static Nginx image (`nginx:1.27-alpine`) serving `index.html` and `words.txt` — see `Dockerfile`.

```bash
docker build -t random .
docker run -p 8080:80 random
# then open http://localhost:8080/
```

## License

MIT — see [LICENSE](LICENSE).
