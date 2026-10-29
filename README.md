# kernoid Whitepaper

The whitepaper of **kernoid** – a sovereign, integrated core of email, identity and storage, built as free software.
A [falkOSS](https://falkoss.org) project.

| File | Content | Status |
|---|---|---|
| [whitepaper.md](whitepaper.md) | the whitepaper – the only source | v0.2 in review: all chapters drafted, OPEN points remain |

> **v0.1 is an unrevised import** of an earlier draft under a different name. Statements marked **OPEN** are not
> verified and must not be quoted. v0.2 revises positioning, landscape and sources.

## Building

`whitepaper.md` is the only source. `whitepaper.typ` (Typst) and `whitepaper.pdf` are generated from it – rebuild
after every change and commit all three:

```sh
./build.sh               # all documents (needs pandoc 3.7.0.2 and typst 0.15.1, otherwise uses nix)
./build.sh whitepaper.md # only this one
```

Title, version, date and status come from the YAML front matter. With `status: Draft` a light DRAFT is drawn behind
every page. The footer shows status, the date of the document's last commit and the short hash of its content
(`git log --find-object=<hash>` finds the commit a PDF was made from). Notes for authors (`> [!NOTE]`, a section
"Open points") stay in the Markdown only.

CI (`.github/workflows/pdf.yml`) rebuilds on every push, checks that the committed `.typ` is current, attaches the
PDF to the run and, for a tag `v*`, to a GitHub release.

| Path | Content |
|---|---|
| `template/kernoid.typ` | the document template (A4, IBM Plex) |
| `template/pandoc.typ` | pandoc template: Markdown → Typst using `kernoid.typ` |
| `template/notes.lua` | drops author notes from `.typ` and PDF |
| `template/fonts/` | IBM Plex Sans and Mono (SIL Open Font License 1.1) |

## Contributing

Issues and pull requests are welcome. Every claim needs a source; unverified statements are marked **OPEN**.
Contributions are accepted under the [Developer Certificate of Origin](https://developercertificate.org)
(`git commit -s`).

## License

- Text (`whitepaper.md` and the generated `.typ`/`.pdf`): [CC BY 4.0](LICENSES/CC-BY-4.0.txt)
- Build scripts and templates: [AGPL-3.0-or-later](LICENSES/AGPL-3.0-or-later.txt)
- Fonts: [SIL Open Font License 1.1](LICENSES/OFL-1.1.txt)
- The lockup in `template/assets/`: a copy from [kernoid/brand](https://github.com/kernoid/brand), [CC BY-ND 4.0](LICENSES/CC-BY-ND-4.0.txt)
- The name and logo “kernoid” are not covered by these licenses.
