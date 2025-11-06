-- latex_passthrough.lua
-- A Pandoc Lua filter to treat fenced code blocks with the class 'latex'
-- as raw LaTeX blocks. This is useful when the primary output format is
-- LaTeX/PDF, but we want to ignore these blocks for other formats like HTML.

function Fenced(el)
  -- Check if the element is a fenced code block and has the 'latex' class
  if el.classes:includes('latex') then
    -- Check if the output format is 'latex'
    if FORMAT:match 'latex' then
      -- If so, return a RawBlock of type 'tex' with the content of the code block.
      -- This effectively tells Pandoc to treat the content as raw LaTeX.
      return pandoc.RawBlock('tex', el.text)
    else
      -- If the format is not LaTeX (e.g., HTML, docx), return an empty list
      -- to remove the block completely from the output.
      return {}
    end
  end
  -- If the block does not have the 'latex' class, return nil to leave it unchanged.
  return nil
end
