# cub2blox
cub2blox is a simple Lua script that converts Cube World model files (.cub) to Roblox Studio model files (.rbxmx).

## How to Use
The Lua script takes a single .cub file as an argument and outputs a .rbxmx file in the same directory. Example usage:

```bash
lua convert.lua some_blocky_house.cub
```

The resulting Roblox model contains all voxels as size 1,1,1 parts with the correct color values. No optimizations are done, so be careful how many blocks are in the Cube World model, as Roblox's engine isn't designed to handle large amount of parts.
