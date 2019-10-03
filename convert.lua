if not arg[1] then error("please specify a .cub file") end

local file = io.open(arg[1], "rb")
if not file then error("file not found") end

local inputname = arg[2] or "Model"

local model_xml = {
	begin = ([[
<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
	<Meta name="ExplicitAutoJoints">true</Meta>
	<External>null</External>
	<External>nil</External>
	<Item class="Model">
		<Properties>
			<CoordinateFrame name="ModelInPrimary">
				<X>0</X>
				<Y>0</Y>
				<Z>0</Z>
				<R00>1</R00>
				<R01>0</R01>
				<R02>0</R02>
				<R10>0</R10>
				<R11>1</R11>
				<R12>0</R12>
				<R20>0</R20>
				<R21>0</R21>
				<R22>1</R22>
			</CoordinateFrame>
			<string name="Name">%s</string>
			<Ref name="PrimaryPart">null</Ref>
			<BinaryString name="Tags"></BinaryString>
		</Properties>
]]):format(inputname);
	ending = [[
	</Item>
</roblox>
]];

}

local make_block_xml = function(x, y, z, c)
	return ([[
		<Item class="Part">
			<Properties>
				<bool name="Anchored">true</bool>
				<float name="BackParamA">-0.5</float>
				<float name="BackParamB">0.5</float>
				<token name="BackSurface">0</token>
				<token name="BackSurfaceInput">0</token>
				<float name="BottomParamA">-0.5</float>
				<float name="BottomParamB">0.5</float>
				<token name="BottomSurface">4</token>
				<token name="BottomSurfaceInput">0</token>
				<CoordinateFrame name="CFrame">
					<X>%u</X>
					<Y>%u</Y>
					<Z>%u</Z>
					<R00>1</R00>
					<R01>0</R01>
					<R02>0</R02>
					<R10>0</R10>
					<R11>1</R11>
					<R12>0</R12>
					<R20>0</R20>
					<R21>0</R21>
					<R22>1</R22>
				</CoordinateFrame>
				<bool name="CanCollide">true</bool>
				<bool name="CastShadow">true</bool>
				<int name="CollisionGroupId">0</int>
				<Color3uint8 name="Color3uint8">%u</Color3uint8>
				<PhysicalProperties name="CustomPhysicalProperties">
					<CustomPhysics>false</CustomPhysics>
				</PhysicalProperties>
				<float name="FrontParamA">-0.5</float>
				<float name="FrontParamB">0.5</float>
				<token name="FrontSurface">0</token>
				<token name="FrontSurfaceInput">0</token>
				<float name="LeftParamA">-0.5</float>
				<float name="LeftParamB">0.5</float>
				<token name="LeftSurface">0</token>
				<token name="LeftSurfaceInput">0</token>
				<bool name="Locked">false</bool>
				<bool name="Massless">false</bool>
				<token name="Material">272</token>
				<string name="Name">Part</string>
				<float name="Reflectance">0</float>
				<float name="RightParamA">-0.5</float>
				<float name="RightParamB">0.5</float>
				<token name="RightSurface">0</token>
				<token name="RightSurfaceInput">0</token>
				<int name="RootPriority">0</int>
				<Vector3 name="RotVelocity">
					<X>0</X>
					<Y>0</Y>
					<Z>0</Z>
				</Vector3>
				<BinaryString name="Tags"></BinaryString>
				<float name="TopParamA">-0.5</float>
				<float name="TopParamB">0.5</float>
				<token name="TopSurface">3</token>
				<token name="TopSurfaceInput">0</token>
				<float name="Transparency">0</float>
				<Vector3 name="Velocity">
					<X>0</X>
					<Y>0</Y>
					<Z>0</Z>
				</Vector3>
				<token name="formFactorRaw">1</token>
				<token name="shape">1</token>
				<Vector3 name="size">
					<X>1</X>
					<Y>1</Y>
					<Z>1</Z>
				</Vector3>
			</Properties>
		</Item>
]]):format(x, y, z, c)
end

local read_uint = function(data)
	local int = {data:byte(1,4)}
	local num = 0
	for i = 1, #int do
		num = num + int[i]*2^((i - 1)*8)
	end
	return num
end

local model_size = {
	x = read_uint(file:read(4));
	y = read_uint(file:read(4));
	z = read_uint(file:read(4));
}

local model = model_xml.begin
for z = 1, model_size.z do
	for y = 1, model_size.y do
		for x = 1, model_size.x do
			local r,g,b = file:read(3):byte(1,3)
			if r > 0 or g > 0 or b > 0 then
				model = model .. make_block_xml(x, y, z, read_uint(string.char(b, g, r, 255)))
			end
		end
	end
end
model = model .. model_xml.ending

local filename = ("%s.rbxmx"):format(arg[1])
local outfile
local success, errmsg = pcall(function()
	outfile = io.open(filename, "w+")
end)
if success then
	io.output(outfile)
	io.write(model)
	io.close(outfile)
	print(("Wrote %s%s"):format(filename, arg[2] and (" as %q"):format(arg[2]) or ""))
else
	print(("Failed to write %s: %s"):format(filename, errmsg))
end
