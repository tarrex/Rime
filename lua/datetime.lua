--[[
datetime_translator: 将 `date`，`time` 等翻译为当前日期时间

translator 的功能是将分好段的输入串翻译为一系列候选项。

欲定义的 translator 包含三个输入参数：
  - input: 待翻译的字符串
  - seg: 包含 `start` 和 `_end` 两个属性，分别表示当前串在输入框中的起始和结束位置
  - env: 可选参数，表示 translator 所处的环境（本例没有体现）

translator 的输出是若干候选项。
与通常的函数使用 `return` 返回不同，translator 要求您使用 `yield` 产生候选项。

Candidate = (type: string, start: string, end: string, text: string, comment: string) => Candidate

`yield` 每次只能产生一个候选项。有多个候选时，可以多次使用 `yield` 。

Reference:
  https://github.com/hchunhui/librime-lua
--]]

local formats = {
  date = {
    '%Y-%m-%d',
    '%Y/%m/%d',
    '%Y.%m.%d',
    '%Y%m%d',
    '%Y年%m月%d日'
  },
  time = {
    '%H:%M',
    '%H:%M:%S',
    '%H%M%S'
  },
  datetime = {
    '%Y-%m-%dT%H:%M:%S+08:00',
    '%Y%m%d%H%M%S'
  },
  timestamp = {
    '%d'
  },
  week = {
    '周%s',
    '星期%s'
  }
}

local function datetime_translator(input, seg, env)
  local config = env.engine.schema.config
  local date = config:get_string(env.name_space .. '/date') or 'rq'
  local time = config:get_string(env.name_space .. '/time') or 'sj'
  local datetime = config:get_string(env.name_space .. '/datetime') or 'dt'
  local timestamp = config:get_string(env.name_space .. '/timestamp') or 'ts'
  local week = config:get_string(env.name_space .. '/week') or 'xq'

  local current_time = os.time()

  local yield_cand = function(type, text)
    local cand = Candidate(type, seg.start, seg._end, text, '')
    cand.quality = 100
    yield(cand)
  end

  if (input == date) then
    for _, fmt in ipairs(formats.date) do
      yield_cand('date', os.date(fmt, current_time))
    end
  end

  if (input == time) then
    for _, fmt in ipairs(formats.time) do
      yield_cand('time', os.date(fmt, current_time))
    end
  end

  if (input == datetime) then
    for _, fmt in ipairs(formats.datetime) do
      yield_cand('datetime', os.date(fmt, current_time))
    end
  end

  if (input == timestamp) then
    for _, fmt in ipairs(formats.timestamp) do
      yield_cand('timestamp', string.format(fmt, current_time))
    end
  end

  if (input == week) then
    local week_tab = { '日', '一', '二', '三', '四', '五', '六' }
    for _, fmt in ipairs(formats.week) do
      local text = week_tab[tonumber(os.date('%w', current_time) + 1)]
      yield_cand('week', string.format(fmt, text))
    end
  end
end

return datetime_translator
