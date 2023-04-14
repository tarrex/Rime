-- local _KeySequence = KeySequence

-- KeySequence = function(str)
--   local ks = _KeySequence()
--   if type(str) == 'string' then
--     ks:parse(str)
--   end
--   return ks
-- end

-- Processer
select_character_processor = require('select_character')

-- Translators
datetime_translator = require('datetime')
unicode_translator = require('unicode')
number_translator = require('number')

-- Filters
long_word_filter = require('long_word')
