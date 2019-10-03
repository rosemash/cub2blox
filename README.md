# cub2blox
cub2blox is a simple Lua script that converts Cube World model files (.cub) to Roblox Studio model files (.rbxmx).

![img](https://i.imgur.com/022eXqA.png)

## How to Use
```bash
lua convert.lua <cubfile> [modelname]
```
The Lua script takes a single .cub file as an argument and outputs a .rbxmx file in the same directory. Example usage:
```bash
lua convert.lua some_blocky_house.cub
```
You may also optionally provide a string to use as the Roblox model's Name property. For instance:
```bash
lua convert.lua iron-greatsword5.cub greatsword
```
The resulting Roblox model contains all voxels as size 1,1,1 parts with the correct color values. No optimizations are done, so be careful how many blocks are in the Cube World model, as Roblox's engine isn't designed to handle large amount of parts.
