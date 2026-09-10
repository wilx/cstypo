--[[--
(c) 2016 Václav Haisman

This program can be redistributed and/or modified under the terms of the MIT
license. See LICENSE file.
--]]--

local GLYPH = node.id("glyph")
--print('GLYPH value: ', GLYPH)

local GLUE = node.id("glue")
--print('GLUE value: ', GLUE)

local LOCAL_PAR = node.id("local_par")
local HLIST = node.id("hlist")
local INDENT = 3 -- paragraph indentation hlist subtype

local CZECH_ID = cstypo_czech_language_id
--print('CZECH_ID value: ', CZECH_ID)

local enabled_hooks = {}

local function is_word_boundary (n)
  return not n
    or n.id == GLUE
    or n.id == LOCAL_PAR
    or (n.id == HLIST and n.subtype == INDENT)
    or (n.id == GLYPH
          and unicode.utf8.match(unicode.utf8.char(n.char), "[%[%]()%{%}„‚]"))
end

local function prevent_single_letter (head)
  while head do
    -- glyph
    if (head.id == GLYPH
        -- and in Czech or unspecified (???)
          and (head.lang == nil
               or head.lang == CZECH_ID)) then
      -- only if we are at one letter word
      if unicode.utf8.match(unicode.utf8.char(head.char), "[zZsSuUkKoOvViI]") then
        -- and left of it is a word boundary
        if (is_word_boundary(head.prev)
          -- and right of the one letter word is also a space
          and head.next and head.next.id == GLUE) then
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
  if enabled_hooks.cstyposingleletter then
    return
  end
  print('cstypo: Enabling single letter hook.')
  luatexbase.add_to_callback("pre_linebreak_filter", prevent_single_letter,
                             "cstyposingleletter")
  enabled_hooks.cstyposingleletter = true
end

function cstypo_single_letter_disable ()
  if not enabled_hooks.cstyposingleletter then
    return
  end
  print('cstypo: Disabling single letter hook.')
  luatexbase.remove_from_callback("pre_linebreak_filter", "cstyposingleletter")
  enabled_hooks.cstyposingleletter = false
end


local function prevent_a_letter (head)
  while head do
    -- glyph
    if (head.id == GLYPH
        -- and in Czech or unspecified (???)
          and (head.lang == nil
               or head.lang == CZECH_ID)) then
      -- only if we are at one letter word
      if unicode.utf8.match(unicode.utf8.char(head.char), "[aA]") then
        -- and left of it is a word boundary
        if (is_word_boundary(head.prev)
          -- and right of the one letter word is also a space
          and head.next and head.next.id == GLUE) then
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
  if enabled_hooks.cstypoaletter then
    return
  end
  print('cstypo: Enabling \'a\' letter hook.')
  luatexbase.add_to_callback("pre_linebreak_filter", prevent_a_letter,
                             "cstypoaletter")
  enabled_hooks.cstypoaletter = true
end

function cstypo_a_letter_disable ()
  if not enabled_hooks.cstypoaletter then
    return
  end
  print('cstypo: Disabling \'a\' letter hook.')
  luatexbase.remove_from_callback("pre_linebreak_filter", "cstypoaletter")
  enabled_hooks.cstypoaletter = false
end


local function prevent_percents (head)
  while head do
    -- glyph
    if (head.id == GLYPH
        -- and in Czech or unspecified (???)
          and (head.lang == nil
               or head.lang == CZECH_ID)) then
      -- only if we are at percentage sign
      if unicode.utf8.match(unicode.utf8.char(head.char), "[%%‰°℃℉]") then
        -- and left of it is a space
        if (head.prev and head.prev.id == GLUE
            -- and left of the space is a digit.
              and head.prev.prev and head.prev.prev.id == GLYPH
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
  if enabled_hooks.cstypopercents then
    return
  end
  print('cstypo: Enabling percents hook.')
  luatexbase.add_to_callback("pre_linebreak_filter", prevent_percents,
                             "cstypopercents")
  enabled_hooks.cstypopercents = true
end

function cstypo_percents_disable()
  if not enabled_hooks.cstypopercents then
    return
  end
  print('cstypo: Disabling percents hook.')
  luatexbase.remove_from_callback("pre_linebreak_filter", "cstypopercents")
  enabled_hooks.cstypopercents = false
end


local function prevent_paragraph (head)
  while head do
    -- glyph
    if (head.id == GLYPH
        -- and in Czech or unspecified (???)
          and (head.lang == nil
               or head.lang == CZECH_ID)) then
      -- only if we are at paragraph symbol
      if unicode.utf8.match(unicode.utf8.char(head.char), "[§]") then
        -- and right of it is a space
        if (head.next and head.next.id == GLUE
              and (head.next.next and head.next.next.id == GLYPH
                     and unicode.utf8.match(unicode.utf8.char(head.next.next.char),
                                            "[0-9]"))) then
          -- then avoid line break between the paragraph and the number
          -- following it
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

function cstypo_paragraph_enable()
  if enabled_hooks.cstypoparagraph then
    return
  end
  print('cstypo: Enabling paragraph hook.')
  luatexbase.add_to_callback("pre_linebreak_filter", prevent_paragraph,
                             "cstypoparagraph")
  enabled_hooks.cstypoparagraph = true
end

function cstypo_paragraph_disable()
  if not enabled_hooks.cstypoparagraph then
    return
  end
  print('cstypo: Disabling paragraph hook.')
  luatexbase.remove_from_callback("pre_linebreak_filter", "cstypoparagraph")
  enabled_hooks.cstypoparagraph = false
end
