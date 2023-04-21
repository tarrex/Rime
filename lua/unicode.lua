--[[
unicode_translator: 输入Unicode字符

Reference：
  https://github.com/shewer/librime-lua-script
--]]

local function unicode_translator(input, seg, env)
  local config = env.engine.schema.config
  local prefix = config:get_string(env.name_space .. '/prefix') or 'U'

  if string.sub(input, 1, 1) ~= prefix or #input < 2 then
    return
  end

  local codestr = string.sub(input, 2)
  local code = tonumber(codestr, 16)

  -- 校验是否为有效的 Unicode 编码
  if not code or code < 0x0000 or (code > 0xd7ff and code < 0xe000) or code > 0x10ffff then
    return
  end

  -- 构建候选项
  local yield_cand = function(text, comment)
    local cand = Candidate('unicode', seg.start, seg._end, text, comment)
    yield(cand)
  end

  -- 生成候选词
  local text = utf8.char(code)
  yield_cand(text, string.format('U%x', code))

  if code < 0x10000 then
    for i = 0, 15 do
      local text = utf8.char(code * 16 + i)
      yield_cand(text, string.format('U%x~%x', code, i))
    end
  end
end

return unicode_translator
