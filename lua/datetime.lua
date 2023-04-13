--[[
datetime_translator: 将 `date`，`time` 等翻译为当前日期时间

translator 的功能是将分好段的输入串翻译为一系列候选项。

欲定义的 translator 包含三个输入参数：
  - input: 待翻译的字符串
  - seg: 包含 `start` 和 `_end` 两个属性，分别表示当前串在输入框中的起始和结束位置
  - env: 可选参数，表示 translator 所处的环境（本例没有体现）

translator 的输出是若干候选项。
与通常的函数使用 `return` 返回不同，translator 要求您使用 `yield` 产生候选项。

`yield` 每次只能产生一个候选项。有多个候选时，可以多次使用 `yield` 。

Reference:
  https://github.com/hchunhui/librime-lua
--]]

local function datetime_translator(input, seg, env)
  local config = env.engine.schema.config
  local date = config:get_string(env.name_space .. '/date') or 'rq'
  local time = config:get_string(env.name_space .. '/time') or 'sj'
  local week = config:get_string(env.name_space .. '/week') or 'xq'
  local datetime = config:get_string(env.name_space .. '/datetime') or 'dt'
  local timestamp = config:get_string(env.name_space .. '/timestamp') or 'ts'

  -- 日期
  if (input == date) then
    local cand = Candidate('date', seg.start, seg._end, os.date('%Y-%m-%d'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('date', seg.start, seg._end, os.date('%Y/%m/%d'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('date', seg.start, seg._end, os.date('%Y.%m.%d'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('date', seg.start, seg._end, os.date('%Y%m%d'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('date', seg.start, seg._end, os.date('%Y年%m月%d日'), '')
    cand.quality = 100
    yield(cand)
  end

  -- 时间
  if (input == time) then
    local cand = Candidate('time', seg.start, seg._end, os.date('%H:%M'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('time', seg.start, seg._end, os.date('%H:%M:%S'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('time', seg.start, seg._end, os.date('%H%M%S'), '')
    cand.quality = 100
    yield(cand)
  end

  -- 星期
  if (input == week) then
    local weakTab = { '日', '一', '二', '三', '四', '五', '六' }
    local cand = Candidate('week', seg.start, seg._end, '周' .. weakTab[tonumber(os.date('%w') + 1)], '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('week', seg.start, seg._end, '星期' .. weakTab[tonumber(os.date('%w') + 1)], '')
    cand.quality = 100
    yield(cand)
  end

  -- ISO 8601/RFC 3339 的时间格式 （固定东八区）（示例 2022-01-07T20:42:51+08:00）
  if (input == datetime) then
    local cand = Candidate('datetime', seg.start, seg._end, os.date('%Y-%m-%dT%H:%M:%S+08:00'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('time', seg.start, seg._end, os.date('%Y%m%d%H%M%S'), '')
    cand.quality = 100
    yield(cand)
  end

  -- 时间戳（十位数，到秒，示例 1650861664）
  if (input == timestamp) then
    local cand = Candidate('datetime', seg.start, seg._end, os.time(), '')
    cand.quality = 100
    yield(cand)
  end
end

return datetime_translator
