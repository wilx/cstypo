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
local KERN = node.id("kern")
local FONT_KERN = 0
local ITALIC_KERN = 3
local WHATSIT = node.id("whatsit")
local COLORSTACK = node.subtype("pdf_colorstack")

local CZECH_ID = cstypo_czech_language_id
--print('CZECH_ID value: ', CZECH_ID)

local enabled_hooks = {}

local function skip_formatting (n, direction)
  while n and ((n.id == KERN
                  and (n.subtype == FONT_KERN or n.subtype == ITALIC_KERN))
               or (n.id == WHATSIT and n.subtype == COLORSTACK)) do
    n = n[direction]
  end
  return n
end

local function protect_space (head, space)
  local p = node.new("penalty")
  p.penalty = 10000
  -- Put the penalty after any formatting nodes, directly before the glue.
  -- In particular, a kern followed by glue can itself be a breakpoint.
  node.insert_before(head, space, p)
end

local function is_word_boundary (n)
  return not n
    or n.id == GLUE
    or n.id == LOCAL_PAR
    or (n.id == HLIST and n.subtype == INDENT)
    or (n.id == GLYPH
          and unicode.utf8.match(unicode.utf8.char(n.char), "[%[%]()%{%}„‚]"))
end

local function prevent_single_letter (head)
  local current = head
  while current do
    -- glyph
    if (current.id == GLYPH
        -- and in Czech or unspecified (???)
          and (current.lang == nil
               or current.lang == CZECH_ID)) then
      -- only if we are at one letter word
      if unicode.utf8.match(unicode.utf8.char(current.char), "[zZsSuUkKoOvViI]") then
        local space = skip_formatting(current.next, "next")
        -- and left of it is a word boundary
        if (is_word_boundary(skip_formatting(current.prev, "prev"))
          -- and right of the one letter word is also a space
          and space and space.id == GLUE) then
          -- then avoid line break between the single letter word and the
          -- word following it
          protect_space(head, space)
        end
      end
    end
    current = current.next
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
  local current = head
  while current do
    -- glyph
    if (current.id == GLYPH
        -- and in Czech or unspecified (???)
          and (current.lang == nil
               or current.lang == CZECH_ID)) then
      -- only if we are at one letter word
      if unicode.utf8.match(unicode.utf8.char(current.char), "[aA]") then
        local space = skip_formatting(current.next, "next")
        -- and left of it is a word boundary
        if (is_word_boundary(skip_formatting(current.prev, "prev"))
          -- and right of the one letter word is also a space
          and space and space.id == GLUE) then
          -- then avoid line break between the single letter word and the
          -- word following it
          protect_space(head, space)
        end
      end
    end
    current = current.next
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
  local current = head
  while current do
    -- glyph
    if (current.id == GLYPH
        -- and in Czech or unspecified (???)
          and (current.lang == nil
               or current.lang == CZECH_ID)) then
      -- only if we are at percentage sign
      if unicode.utf8.match(unicode.utf8.char(current.char), "[%%‰°℃℉]") then
        local space = skip_formatting(current.prev, "prev")
        -- and left of it is a space
        if space and space.id == GLUE then
          -- and left of the space is a digit.
          local digit = skip_formatting(space.prev, "prev")
          if (digit and digit.id == GLYPH
                and unicode.utf8.match(unicode.utf8.char(digit.char), "[0-9]")) then
            protect_space(head, space)
          end
        end
      end
    end
    current = current.next
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
  local current = head
  while current do
    -- glyph
    if (current.id == GLYPH
        -- and in Czech or unspecified (???)
          and (current.lang == nil
               or current.lang == CZECH_ID)) then
      -- only if we are at paragraph symbol
      if unicode.utf8.match(unicode.utf8.char(current.char), "[§]") then
        local space = skip_formatting(current.next, "next")
        -- and right of it is a space
        if space and space.id == GLUE then
          local digit = skip_formatting(space.next, "next")
          if (digit and digit.id == GLYPH
                and unicode.utf8.match(unicode.utf8.char(digit.char), "[0-9]")) then
            -- Keep the paragraph symbol with its following number.
            protect_space(head, space)
          end
        end
      end
    end
    current = current.next
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
