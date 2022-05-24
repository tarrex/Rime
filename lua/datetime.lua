-- Reference: https://github.com/hchunhui/librime-lua
local function translator(input, seg)
  -- 日期
  if (input == 'rq') then
    local cand = Candidate('date', seg.start, seg._end, os.date('%Y-%m-%d'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('date', seg.start, seg._end, os.date('%Y/%m/%d'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('date', seg.start, seg._end, os.date('%Y.%m.%d'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('date', seg.start, seg._end, os.date('%Y年%m月%d日'), '')
    cand.quality = 100
    yield(cand)
  end

  -- 时间
  if (input == 'sj') then
    local cand = Candidate('time', seg.start, seg._end, os.date('%H:%M'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('time', seg.start, seg._end, os.date('%H:%M:%S'), '')
    cand.quality = 100
    yield(cand)
  end

  -- 星期
  if (input == 'xq') then
    local weakTab = { '日', '一', '二', '三', '四', '五', '六' }
    local cand = Candidate('week', seg.start, seg._end, '周' .. weakTab[tonumber(os.date('%w') + 1)], '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('week', seg.start, seg._end, '星期' .. weakTab[tonumber(os.date('%w') + 1)], '')
    cand.quality = 100
    yield(cand)
  end

  -- ISO 8601/RFC 3339 的时间格式 （固定东八区）（示例 2022-01-07T20:42:51+08:00）
  if (input == 'dt') then
    local cand = Candidate('datetime', seg.start, seg._end, os.date('%Y-%m-%dT%H:%M:%S+08:00'), '')
    cand.quality = 100
    yield(cand)
    local cand = Candidate('time', seg.start, seg._end, os.date('%Y%m%d%H%M%S'), '')
    cand.quality = 100
    yield(cand)
  end

  -- 时间戳（十位数，到秒，示例 1650861664）
  if (input == 'ts') then
    local cand = Candidate('datetime', seg.start, seg._end, os.time(), '')
    cand.quality = 100
    yield(cand)
  end
end

return translator
