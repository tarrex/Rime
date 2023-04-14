--[[
unicode_translator: 输入Unicode字符

Reference：
  https://github.com/shewer/librime-lua-script
--]]

local function unicode_translator(input, seg, env)
  -- local ucodestr = seg:has_tag('unicode') and input:match('U(%x+)')
  local ucodestr = input:match('U(%x+)')
  if ucodestr and #ucodestr > 1 then
    local code = tonumber(ucodestr, 16)
    local text = utf8.char(code)
    yield(Candidate('unicode', seg.start, seg._end, text, string.format('U%x', code)))
    if #ucodestr < 5 then
      for i = 0, 15 do
        local text = utf8.char(code * 16 + i)
        yield(Candidate('unicode', seg.start, seg._end, text, string.format('U%x~%x', code, i)))
      end
    end
  end
end

return unicode_translator
