lualatex --interaction=batchmode --shell-escape --draftmode sample
biber sample
bib2gls sample
lualatex --interaction=batchmode --shell-escape --draftmode sample
lualatex --interaction=batchmode --shell-escape sample