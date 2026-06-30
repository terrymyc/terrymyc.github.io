-- _extensions/highlight-author.lua

local function highlight_author(inlines)
  local out = {}
  local i = 1
  while i <= #inlines do
    -- Check for "Ma," -> Space -> "Y." OR "Y.," OR "Yongchao" OR "Yongchao,"
    if i + 2 <= #inlines
       and inlines[i].t == "Str" and inlines[i].text == "Ma,"
       and inlines[i+1].t == "Space"
       and inlines[i+2].t == "Str" 
       and (inlines[i+2].text == "Yongchao" or inlines[i+2].text == "Yongchao," 
            or inlines[i+2].text == "Y." or inlines[i+2].text == "Y.,") then
      
      -- Wrap the matching elements in bold (Strong)
      out[#out+1] = pandoc.Strong({ inlines[i], inlines[i+1], inlines[i+2] })
      i = i + 3
    else
      -- Pass through unchanged
      out[#out+1] = inlines[i]
      i = i + 1
    end
  end
  return out
end

return {
  {
    Div = function(div)
      if div.classes:includes("csl-entry") then
        return pandoc.walk_block(div, {
          Plain = function(el)
            el.content = highlight_author(el.content)
            return el
          end,
          Para = function(el)
            el.content = highlight_author(el.content)
            return el
          end
        })
      end
    end
  }
}
