--[[
long_word_filter: 长词优先

长词优先（提升「西安」「提案」「图案」「饥饿」等词汇的优先级），不提升英文和中英混输的

Reference：
  https://github.com/tumuyan/rime-melt
  https://github.com/iDvel/rime-ice
--]]

function long_word_filter(input, env)
  -- 提升 count 个词语，插入到第 idx 个位置，默认 2、4。
  local config = env.engine.schema.config
  local count = config:get_int(env.name_space .. '/count') or 2
  local idx = config:get_int(env.name_space .. '/idx') or 4

  local l = {}
  local firstWordLength = 0 -- 记录第一个候选词的长度，提前的候选词至少要比第一个候选词长
  local s = 0 -- 记录筛选了多少个词条(只提升 count 个词的权重)

  local i = 1
  for cand in input:iter() do
    local leng = utf8.len(cand.text)
    if (firstWordLength < 1 or i < idx) then
      i = i + 1
      firstWordLength = leng
      yield(cand)
    elseif ((leng > firstWordLength) and (s < count)) and (string.find(cand.text, '[%w%p%s]+') == nil) then
      yield(cand)
      s = s + 1
    else
      table.insert(l, cand)
    end
  end
  for _, cand in ipairs(l) do
    yield(cand)
  end
end

return long_word_filter
