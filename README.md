# Merlin

A blazingly fast Static Site Generator written in Vala.

## Features (TODO)

Core:
- [x] Command line interface with basic commands (build, serve, new)
- [ ] Parse content directory structure
- [ ] Markdown to HTML conversion
- [ ] Support for front matter (YAML)
- [ ] Basic templating system
- [ ] Live reload development server
- [ ] Asset handling (copy static files)

Content:
- [ ] Blog post support
- [ ] Pages support
- [ ] Automatic index generation
- [ ] Category and tag support
- [ ] RSS/Atom feed generation

Templates & Themes:
- [ ] Basic theme structure
- [ ] Template inheritance
- [ ] Partial templates
- [ ] Built-in default theme
- [ ] Custom themes support

Advanced Features:
- [ ] Code syntax highlighting
- [ ] Table of contents generation
- [ ] Sitemap generation
- [ ] Search functionality
- [ ] Image optimization
- [ ] Minification (HTML, CSS, JS)
- [ ] Draft posts
- [ ] Scheduled posts

## Development

### Prerequisites

- Vala compiler
- Meson build system
- Ninja

### Building

```bash
meson setup builddir
cd builddir
ninja
```

### Running

```bash
./merlin
```

## Current Status

Initial project setup with basic structure. Working on implementing core features.

## Contributing

Project is in early development stages. Contributions are welcome!

## License

MIT License