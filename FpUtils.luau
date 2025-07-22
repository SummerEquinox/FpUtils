--[=[
    FpUtils is a set of utility functions programmed with functional programming
    academic integrity in mind. Some liberties are taken due to writing
    entirely stateless code in Luau costing performance.
    
    SummerEquinox
    Last Edit: 7/22/2025
]=]

--!strict

type Dictionary <K, V> = { [K]: V }
type Array <T> = Dictionary<number, T>
type PredicateFn <T> = (T) -> boolean
type MapFn <T, U> = (T) -> U

local FpUtils = {}

-- Key an array into a dictionary using mapFn to determine keys.
function FpUtils.keyBy<T, K>(
	array: Array<T>, 
	mapFn: MapFn<T, K>
): Dictionary<K, T>
	
	local inputLength = #array
	
	local function helper(dictionary, index)
		dictionary = dictionary or {}
		index = index or 1

		if index > inputLength then
			return dictionary
		end

		local value = array[index]
		local key = mapFn(value)
		dictionary[key] = value

		return helper(dictionary, index + 1)
	end

	return helper({}, 1)
end

-- Transform array entries by mapFn.
function FpUtils.map<T, U>(array: Array<T>, mapFn: MapFn<T, U>): Array<U>
	local inputLength = #array
	
	local function helper(index, accumulated)
		if index > inputLength then
			return accumulated
		end
		
		local item = array[index]
		table.insert(accumulated, mapFn(item))
		
		return helper(index + 1, accumulated)
	end
	
	return helper(1, {})
end

-- Reduce array to entries which pass predicateFn.
function FpUtils.filter<T>(
	array: Array<T>, 
	predicateFn: PredicateFn<T>
): Array<T>
	
	local inputLength = #array
	
	local function helper(index, accumulated)
		if index > inputLength then
			return accumulated
		end
		
		local item = array[index]
		if predicateFn(item) then
			table.insert(accumulated, item)
		end
		
		return helper(index + 1, accumulated)
	end
	
	return helper(1, {})
end

-- Reduce array to mapped entries which pass predicateFn.
function FpUtils.filterMap<T, U>(
	array: Array<T>, 
	predicateFn: PredicateFn<T>,
	mapFn: MapFn<T, U>
):  Array<U>
	
	local inputLength = #array
	
	local function helper(index, accumulated)
		if index > inputLength then
			return accumulated
		end

		local item = array[index]
		if predicateFn(item) then
			table.insert(accumulated, mapFn(item))
		end

		return helper(index + 1, accumulated)
	end

	return helper(1, {})
end

return FpUtils
