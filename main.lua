--!nonstrict

--[[
	--* Written by SinfulAccusations
	--* PerlinNoise.luau, An OOP module made to simulate Perlin Noise instances for flexibility
	--* Think of it as like Random.new() but for Perlin noise
	--* I will add random vector functions soon, as of now it only supports standard number operations
	
	MIT License

	Copyright (c) 2024 SinfulAccusations

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

local perlinNoise: { [string]: () -> () } = {}

export type PerlinNoise = {
	__type: string,
	seed: number,
	Generate: (self: PerlinNoise, x: number, y: number, z: number?) -> number,
	Interpolate: (self: PerlinNoise, alpha: number, min: number, max: number) -> number
}

--[[
	@TODO: Creates a new PerlinNoise instance
	@param seed (number?): Optional preset seed for the PerlinNoise object
	@return (PerlinNoise): The new PerlinNoise instance created
]]
function perlinNoise.new(seed: number?): PerlinNoise
	seed = seed or DateTime.now().UnixTimestampMillis
	local argType: string = typeof(seed)
	
	assert(argType == "number", `bad argument #1 to PerlinNoise.new (number expected, got {argType})`)
	
	return {
		__type = "PerlinNoiseInstance",
		seed = seed,

		--[[
			@TODO: Generates a brand new standard perlin noise value between -0.5 and 0.5 (can be below/above range)
			@param x (number): x argument for math.noise
			@param y (number): y argument for math.noise
			@param z (number?): z argument for math.noise (defaults to the seed)
			@return (number): The generated number
		]]
		Generate = function(self: PerlinNoise, x: number, y: number, z: number?): number
			local argType1: string = typeof(x)
			local argType2: string = typeof(y)
			z = z or self.seed
			local argType3: string = typeof(z)

			assert(argType1 == "number", `bad argument #1 to PerlinNoiseInstance.Generate (number expected, got {argType1})`)
			assert(argType2 == "number", `bad argument #2 to PerlinNoiseInstance.Generate (number expected, got {argType2})`)
			assert(argType3 == "number", `bad argument #3 to PerlinNoiseInstance.Generate (number expected, got {argType3})`)

			return math.noise(x, y, z)
		end,

		--[[
			@TODO: Generates a perlin noise, interpolated between a min and max range by alpha
			@param alpha (number): positional argument for noise generator
			@param min (number): min size for return value
			@param max (number): max size for return value
			@return (number): The generated number
		]]
		Interpolate = function(self: PerlinNoise, alpha: number, min: number, max: number): number
			local argType1: string = typeof(alpha)
			local argType2: string = typeof(min)
			local argType3: string = typeof(max)

			assert(argType1 == "number", `bad argument #1 to PerlinNoiseInstance.Generate (number expected, got {argType1})`)
			assert(argType2 == "number", `bad argument #2 to PerlinNoiseInstance.Generate (number expected, got {argType2})`)
			assert(argType3 == "number", `bad argument #3 to PerlinNoiseInstance.Generate (number expected, got {argType3})`)
			
			return min + (max - min) * math.clamp(math.noise(alpha, alpha / min, self.seed) + 0.5, 0, 1)
		end
	}
end

return perlinNoise
