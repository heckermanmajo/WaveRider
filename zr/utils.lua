local Utils = {}

function Utils.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. Utils.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function Utils.getIndexOf(table, value)
   for k, v in pairs(table) do
      if v == value then
         return k
      end
   end
   return nil
end


return Utils