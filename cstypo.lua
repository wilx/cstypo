local GLYPH = node.id("glyph")
--print('GLYPH value: ', GLYPH)

local GLUE = node.id("glue")
--print('GLUE value: ', GLUE)


local function prevent_single_letter (head)
  --print('prevent_single_letter hook is executing', head)
  while head do
    -- glyph
    --print('inside prevent_single_letter loop, head.id: ', head.id)
    if head.id == GLYPH then
      -- only if we are at one letter word
      if unicode.utf8.match(unicode.utf8.char(head.char), "[zZsSuUkKoOvViI]") then
        -- and left of it is either a space
        if ((head.prev.id == GLUE
             -- or one of '{[('
               or (head.prev.id == GLYPH
                     and unicode.utf8.match(unicode.utf8.char(head.prev.char),
                                            "[%[%]()%{%}]")))
          -- and right of the one letter word is also a space
          and head.next.id == GLUE) then
          -- then avoid line break between the single letter word and the
          -- word following it
          local p = node.new("penalty")
          p.penalty = 10000
          node.insert_after(head, head, p)
          --print('inserting penalty at ', head)
        end
      end
    end
    head = head.next
  end
  return true
end

function cstypo_single_letter_enable ()
  print('cstypo: Enabling single letter hook.')
  luatexbase.add_to_callback("pre_linebreak_filter", prevent_single_letter,
                             "cstyposingleletter")
end

function cstypo_single_letter_disable ()
  print('cstypo: Disabling single letter hook.')
  luatexbase.remove_from_callback("pre_linebreak_filter", "cstyposingleletter")
end


local function prevent_a_letter (head)
  while head do
    -- glyph
    if head.id == GLYPH then
      -- only if we are at one letter word
      if unicode.utf8.match(unicode.utf8.char(head.char), "[aA]") then
        -- and previous is space
        if ((head.prev.id == GLUE
             -- or previous is one of '{[('
               or (head.prev.id == GLYPH
                     and unicode.utf8.match(unicode.utf8.char(head.prev.char),
                                            "[%[%]()%{%}]")))
          -- and right of the one letter word is also a space
          and head.next.id == GLUE) then
          -- then avoid line break between the single letter word and the
          -- word following it
          local p = node.new("penalty")
          p.penalty = 10000
          node.insert_after(head, head, p)
        end
      end
    end
    head = head.next
  end
  return true
end

function cstypo_a_letter_enable ()
  print('cstypo: Enabling \'a\' letter hook.')
  luatexbase.add_to_callback("pre_linebreak_filter", prevent_a_letter,
                             "cstypoaletter")
end

function cstypo_a_letter_disable ()
  print('cstypo: Disabling \'a\' letter hook.')
  luatexbase.remove_from_callback("pre_linebreak_filter", "cstypoaletter")
end


local function prevent_percents (head)
  while head do
    -- glyph
    if head.id == GLYPH then
      -- only if we are at percentage sign
      if unicode.utf8.match(unicode.utf8.char(head.char), "%%") then
        -- and left of it is a space
        if (head.prev.id == GLUE
            -- and left of the space is a digit.
              and head.prev.prev.id == GLYPH
              and unicode.utf8.match(unicode.utf8.char(head.prev.prev.char),
                                     "[0-9]")) then
          local p = node.new("penalty")
          p.penalty = 10000
          node.insert_after(head.prev.prev, head.prev.prev, p)
        end
      end
    end
    head = head.next
  end
  return true
end

function cstypo_percents_enable()
  print('cstypo: Enabling percents hook.')
  luatexbase.add_to_callback("pre_linebreak_filter", prevent_percents,
                             "cstypopercents")
end

function cstypo_percents_disable()
  print('cstypo: Disabling percents hook.')
  luatexbase.remove_from_callback("pre_linebreak_filter", "cstypopercents")
end
