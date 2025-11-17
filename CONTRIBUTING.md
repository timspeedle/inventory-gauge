# Contributing to Inventory UI

First off, thank you for considering contributing to Inventory UI! It's people like you that make this mod better for everyone.

## Code of Conduct

This project and everyone participating in it is governed by common sense and mutual respect. Be kind, be constructive, and help create a positive environment for everyone.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** to demonstrate the steps
- **Describe the behavior you observed** and what you expected to see
- **Include screenshots** if relevant
- **Provide your Factorio version** and list of other mods installed
- **Include relevant log files** from `factorio-current.log`

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description** of the suggested enhancement
- **Explain why this enhancement would be useful** to most users
- **List any similar features** in other mods if applicable

### Pull Requests

- Fill in the pull request template
- Follow the Lua coding style used in the project
- Include comments for complex logic
- Update documentation if you're changing functionality
- Test your changes thoroughly in Factorio

## Development Setup

1. Fork the repository
2. Clone your fork to your Factorio mods directory:
   ```bash
   cd ~/Library/Application\ Support/factorio/mods  # macOS
   git clone https://github.com/YOUR-USERNAME/inventory-gauge.git
   ```
3. Make your changes
4. Test in Factorio
5. Commit and push to your fork
6. Create a pull request

## Coding Style

### Lua Style Guide

- Use 2 spaces for indentation
- Use `snake_case` for variable and function names
- Use descriptive variable names
- Add comments for complex logic
- Keep lines under 100 characters when possible
- Use local variables whenever possible

Example:
```lua
local function calculate_inventory_percentage(player)
  local inventory = player.get_main_inventory()
  if not inventory then return 0 end
  
  local used_slots = 0
  local total_slots = #inventory
  
  -- Count non-empty slots
  for i = 1, total_slots do
    if inventory[i].valid_for_read then
      used_slots = used_slots + 1
    end
  end
  
  return used_slots / total_slots
end
```

### Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Start with a prefix:
  - `feat:` for new features
  - `fix:` for bug fixes
  - `docs:` for documentation changes
  - `style:` for formatting changes
  - `refactor:` for code refactoring
  - `test:` for adding tests
  - `chore:` for maintenance tasks

Examples:
- `feat: add inventory sorting feature`
- `fix: correct progress bar calculation`
- `docs: update installation instructions`

## Testing

Before submitting a pull request:

1. Test your changes with a new game
2. Test with an existing save
3. Test with other popular mods if possible
4. Check the Factorio log for any errors or warnings
5. Verify the mod works in both single-player and multiplayer

## Questions?

Feel free to open an issue with the `question` label if you have any questions about contributing.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
