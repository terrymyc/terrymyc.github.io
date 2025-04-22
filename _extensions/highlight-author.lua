-- highlight-my-name.lua

local SURNAME = "Ma,"
local GIVEN   = "Yongchao"

-- process a Para block of inlines, merging Surname + Space + Given into a Strong
local function process_para(para)
  local inls, out = para.content, {}
  local i = 1
  while i <= #inls do
    local el = inls[i]
    -- look ahead for the exact pattern: Str "Ma,", Space, Str "Yongchao"
    if i+2 <= #inls
      and el.t == "Str" and el.text == SURNAME
      and inls[i+1].t == "Space"
      and inls[i+2].t == "Str" and inls[i+2].text == GIVEN
    then
      -- wrap those three in a Strong
      out[#out+1] = pandoc.Strong({ el, inls[i+1], inls[i+2] })
      i = i + 3
    else
      out[#out+1] = el
      i = i + 1
    end
  end
  para.content = out
  return para
end

return {
  {
    -- target the Div that Quarto/Pandoc puts your bibliography into
    Div = function(div)
      if div.classes:includes("references") or div.classes:includes("csl-bib-body") then
        -- walk every block (usually Paras) and process them
        for idx, blk in ipairs(div.content) do
          if blk.t == "Para" then
            div.content[idx] = process_para(blk)
          end
        end
        return div
      end
    end
  }
}
