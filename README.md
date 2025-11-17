# Inventory UI

A Factorio mod that adds a toggleable dialog box with a progress bar showing how full your inventory is.

## Features

- **Real-time Inventory Tracking**: Visual progress bar showing current inventory capacity
- **Toggleable UI**: Show or hide the inventory display with a simple button click
- **Customizable Settings**: Configure the mod to suit your preferences
- **Factorio 2.0 Compatible**: Built for the latest version of Factorio

## Installation

### Via Factorio Mod Portal (Recommended)
1. Open Factorio
2. Go to the Mods menu
3. Search for "Inventory UI"
4. Click "Download" and enable the mod

### Manual Installation
1. Download the latest release from the [Releases page](https://github.com/timspeedle/inventory-gauge/releases)
2. Extract the zip file to your Factorio mods folder:
   - **Windows**: `%AppData%\Factorio\mods`
   - **macOS**: `~/Library/Application Support/factorio/mods`
   - **Linux**: `~/.factorio/mods`
3. Restart Factorio and enable the mod in the Mods menu

## Usage

1. Start or load a game
2. Click the toggle button to show/hide the inventory display
3. The progress bar updates in real-time as you collect or use items

## Configuration

Access mod settings through:
- Main Menu → Settings → Mod Settings
- In-game → Settings → Mod Settings

### Overlay Format Tokens

The `inventory-gauge-overlay-format` setting lets you customize the text label shown over the segmented inventory bar. Use placeholder tokens to insert dynamic values:

Tokens:
- `%F` Full stacks (slots at max stack size)
- `%P` Partial stacks (slots containing items but not full)
- `%U` Used (non-empty) slots = full + partial
- `%R` Reserved (filtered) empty slots
- `%E` Free empty slots (unreserved and empty)
- `%T` Total inventory slots
- `%I` Percent of slots containing items (rounded)
- `%%` Literal percent sign

Example template (default):

```
%I%% full (%E empty)
```

If an unknown token is referenced (e.g. `%X`), it is left as-is.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/timspeedle/inventory-gauge/issues)
- **Discussions**: [GitHub Discussions](https://github.com/timspeedle/inventory-gauge/discussions)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.

## Author

**timspeedle**

## Acknowledgments

- Thanks to the Factorio development team for creating an amazing modding API
- Thanks to all contributors and users of this mod

## AI Usage Disclaimer

Generative AI technology has been used in the creation of this mod. Code, graphics,
localization, and other components of this mod may have been created and/or improved
upon by generative AI.
