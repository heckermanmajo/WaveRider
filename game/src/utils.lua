local Utils = {}

function Utils.get_rotation(x1,y1,x2,y2) 
  return math.atan2(x2 - x1, -(y2 - y1))
end

function Utils.distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

function Utils.CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function Utils.collision(object_1, object_2)
    return object_1.x < object_2.x+object_2.w and
         object_2.x < object_1.x+object_1.w and
         object_1.y < object_2.y+object_2.h and
         object_2.y < object_1.y+object_1.h
end

function Utils.GetXCollisionForce(x1,w1,x2,w2)
  local ax1 = x1
  local ax2 = x1 + w1
  local bx1 = x2
  local bx2 = x2 + w2
  
  --- b into the right side of a 
  if ax1 < bx2 then 
    return bx2 - ax1
  end 
    
  -- b into the right of a 
  if ax2 > bx1 then 
    return ax2 - bx1 
  end 
  
end 

function Utils.GetYCollisionForce(y1,h1,y2,h2)
  local ay1 = y1
  local ay2 = y1 + h1
  local by1 = y2
  local by2 = y2 + h2
  
  --- b at the top of a 
  if ay1 < by2 then 
    return by2 - ay1
  end 
    
  -- a at the top of b overlap
  if ay2 > by1 then 
    return ay2 - by1 
  end 
  
end


function Utils.uid()
  return tostring(math.random(0,999999)) .. os.date("%Y%m%d%H%M%S")
end


return Utils 