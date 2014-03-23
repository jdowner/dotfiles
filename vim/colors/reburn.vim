" Vim color file
" Maintainer:   Jani Nurminen <slinky@iki.fi>
" Last Change:  $Id: zenburn.vim,v 2.13 2009/10/24 10:16:01 slinky Exp $
" URL:          http://slinky.imukuppi.org/zenburnpage/
" License:      GPL
"
" Nothing too fancy, just some alien fruit salad to keep you in the zone.
" This syntax file was designed to be used with dark environments and 
" low light situations. Of course, if it works during a daybright office, go
" ahead :)
"
" Owes heavily to other Vim color files! With special mentions
" to "BlackDust", "Camo" and "Desert".
"
" To install, copy to ~/.vim/colors directory.
"
" Alternatively, you can use Vimball installation:
"     vim zenburn.vba
"     :so %
"     :q
"
" For details, see :help vimball
"
" After installation, use it with :colorscheme zenburn.
" See also :help syntax
"
" Credits:
"  - Jani Nurminen - original Zenburn
"  - Steve Hall & Cream posse - higher-contrast Visual selection
"  - Kurt Maier - 256 color console coloring, low and high contrast toggle,
"                 bug fixing
"  - Charlie - spotted too bright StatusLine in non-high contrast mode
"  - Pablo Castellazzi - CursorLine fix for 256 color mode
"  - Tim Smith - force dark background
"  - John Gabriele - spotted bad Ignore-group handling
"  - Zac Thompson - spotted invisible NonText in low contrast mode
"  - Christophe-Marie Duquesne - suggested making a Vimball
"
" CONFIGURABLE PARAMETERS:
"
" You can use the default (don't set any parameters), or you can
" set some parameters to tweak the Zenburn colours.
"
" To use them, put them into your .vimrc file before loading the color scheme,
" example:
"    let g:zenburn_high_Contrast=1
"    colors zenburn
"
" * You can now set a darker background for bright environments. To activate, use:
"   contrast Zenburn, use:
"
"      let g:zenburn_high_Contrast = 1
"
" * For example, Vim help files uses the Ignore-group for the pipes in tags 
"   like "|somelink.txt|". By default, the pipes are not visible, as they
"   map to Ignore group. If you wish to enable coloring of the Ignore group,
"   set the following parameter to 1. Warning, it might make some syntax files
"   look strange.
"
"      let g:zenburn_color_also_Ignore = 1
"
" * To get more contrast to the Visual selection, use
"
"      let g:zenburn_alternate_Visual = 1
"
" * To use alternate colouring for Error message, use
"
"      let g:zenburn_alternate_Error = 1
"
" * The new default for Include is a duller orange. To use the original
"   colouring for Include, use
"
"      let g:zenburn_alternate_Include = 1
"
" * Work-around to a Vim bug, it seems to misinterpret ctermfg and 234 and 237
"   as light values, and sets background to light for some people. If you have
"   this problem, use:
"
"      let g:zenburn_force_dark_Background = 1
"
" NOTE:
"
" * To turn the parameter(s) back to defaults, use UNLET:
"
"      unlet g:zenburn_alternate_Include
"
"   Setting to 0 won't work!
"
" That's it, enjoy!
"
" TODO
"   - Visual alternate color is broken? Try GVim >= 7.0.66 if you have trouble
"   - IME colouring (CursorIM)

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="reburn"

if &t_Co > 255
"    hi Boolean         ctermfg=181
"    hi Character       ctermfg=181   cterm=bold
"    hi Conditional     ctermfg=223   cterm=bold
"    hi Cursor          ctermfg=233   ctermbg=109     cterm=bold
"    hi Debug           ctermfg=181   cterm=bold
"    hi Define          ctermfg=223   cterm=bold
"    hi Delimiter       ctermfg=245
"    hi Exception       ctermfg=249   cterm=bold
"    hi Float           ctermfg=251
"    hi Function        ctermfg=174
"    hi Keyword         ctermfg=221   cterm=bold    
"    hi Label           ctermfg=187
"    hi Macro           ctermfg=223   cterm=bold    
"    hi Number          ctermfg=116
"    hi Operator        ctermfg=117
"    hi PreCondit       ctermfg=35
"    hi Repeat          ctermfg=223   cterm=bold
"    hi SpecialComment  ctermfg=108   cterm=bold
"    hi StorageClass    ctermfg=183
"    hi Structure       ctermfg=229   cterm=bold
"    hi Tag             ctermfg=181   cterm=bold
"    hi Typedef         ctermfg=253   cterm=bold
"    hi VisualNOS       ctermfg=236   ctermbg=210     cterm=bold
"    hi CursorLine      ctermbg=236   cterm=none
    " pmenu
"    hi PMenu      ctermfg=248  ctermbg=0
"    hi PMenuSel   ctermfg=223 ctermbg=235



    hi Constant         ctermfg=131
    hi Comment          ctermfg=108
    hi DiffAdd         ctermfg=66    ctermbg=237     cterm=bold
    hi DiffChange      ctermbg=236
    hi DiffDelete      ctermfg=236   ctermbg=238
    hi DiffText        ctermfg=217   ctermbg=237     cterm=bold
    hi Directory       ctermfg=188   cterm=bold
    hi ErrorMsg        ctermfg=115   ctermbg=236     cterm=bold
    hi FoldColumn      ctermfg=109   ctermbg=238
    hi Folded          ctermfg=109   ctermbg=238
    hi Identifier      ctermfg=174
    hi IncSearch       ctermbg=228   ctermfg=238
    hi LineNr          ctermfg=248   ctermbg=235
    hi ModeMsg         ctermfg=223   cterm=none
    hi MoreMsg         ctermfg=15    cterm=bold
    hi PreProc         ctermfg=35
    hi Question        ctermfg=15    cterm=bold
    hi Search          ctermfg=230   ctermbg=240
    hi SpecialChar     ctermfg=181   cterm=bold
    hi Special         ctermfg=181
    hi SpecialKey      ctermfg=151
    hi Statement       ctermfg=38
    hi StatusLine      ctermfg=236   ctermbg=186
    hi StatusLineNC    ctermfg=235   ctermbg=108
    hi String          ctermfg=179
    hi Title           ctermfg=7     ctermbg=234     cterm=bold
    hi Todo            ctermfg=108   ctermbg=234     cterm=bold
    hi Type            ctermfg=176
    hi Underlined      ctermfg=188   ctermbg=234     cterm=bold
    hi VertSplit       ctermfg=236   ctermbg=65

    hi WarningMsg      ctermfg=15    ctermbg=236     cterm=bold
    hi WildMenu        ctermbg=236   ctermfg=194     cterm=bold


    hi SpellLocal       ctermfg=14  ctermbg=237
    hi SpellBad         ctermfg=1   ctermbg=247
    hi SpellCap         ctermfg=19  ctermbg=250
    hi SpellRare        ctermfg=13  ctermbg=250

    hi Normal           ctermfg=188 ctermbg=235
    hi NonText          ctermfg=238
        
endif
