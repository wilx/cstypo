local test = {}
local GLYPH = node.id('glyph')
local GLUE = node.id('glue')
local HLIST = node.id('hlist')
local PENALTY = node.id('penalty')
local active = false

local function text_of(head)
  local result = {}
  for n in node.traverse(head) do
    if n.id == GLYPH then
      result[#result + 1] = unicode.utf8.char(n.char)
    elseif n.id == GLUE and n.subtype == 13 then
      result[#result + 1] = ' '
    elseif n.id == HLIST then
      result[#result + 1] = text_of(n.head)
    end
  end
  return table.concat(result)
end

function test.begin(label, expected_penalties, expected_lines)
  -- Reattach after the hooks currently enabled, including after re-enabling.
  if active then
    luatexbase.remove_from_callback('pre_linebreak_filter', 'cstypo.test.nodes')
    luatexbase.remove_from_callback('post_linebreak_filter', 'cstypo.test.lines')
  end
  active = true
  luatexbase.add_to_callback('pre_linebreak_filter', function(head)
    local penalties = 0
    for n in node.traverse(head) do
      if n.id == PENALTY and n.penalty == 10000
          and n.next and n.next.id == GLUE and n.next.subtype ~= 15 then
        penalties = penalties + 1
      end
    end
    assert(penalties == expected_penalties, label .. ': expected '
      .. expected_penalties .. ' protected spaces, got ' .. penalties)
    return true
  end, 'cstypo.test.nodes')
  luatexbase.add_to_callback('post_linebreak_filter', function(head)
    local lines = {}
    for n in node.traverse(head) do
      if n.id == HLIST then
        lines[#lines + 1] = text_of(n.head)
      end
    end
    local actual = table.concat(lines, '|')
    assert(expected_lines == '' or actual == expected_lines,
      label .. ': expected lines [' .. expected_lines .. '], got [' .. actual .. ']')
    texio.write_nl('term and log', 'PASS ' .. label .. ': ' .. actual)
    return true
  end, 'cstypo.test.lines')
end

return test
