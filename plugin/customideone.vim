" Vim global plugin that provides access to the ideone.org pastebin.
" Requires +python support.
"
" Add this to your ~/.vim/plugin/ directory. Then you can use
"
" :IPaste
"     to send the current buffer to ideone.org and open your pasted code
"     in your webbrowser.
"
" :IRun
"     to send the current buffer to ideone.org, execute it on their server,
"     and open both the pasted source and the program output in your browser.
"
" The correct filetype is automatically detected from the 'filetype' variable.
"
" Version:      1.3
" Last Change:  05 aug 2008
" Maintainer:   Nicolas Weber <nicolasweber at gmx.de>


if has('python')
  command! IPaste python ideonePaste()
  command! IRun python ideoneRun()
  command! IRunW python ideoneRunWo()
else
  command! IPaste echo 'Only avaliable with +python support.'
  command! IRun echo 'Only avaliable with +python support.'
  command! IRunW echo 'Only avaliable with +python support.'
endif

if has('python')
python << EOF
def ideoneLang(vimLang):
  filetypeMap = {
    'c':'C',
    'cpp':'44',
    'd':'D',
    'haskell':'Haskell',
    'lua':'Lua',
    'ocaml':'Ocaml',
    'php':'PHP',
    'perl':'Perl',
    'python':'Python',
    'ruby':'Ruby',
    'scheme':'Scheme',
    'tcl':'Tcl'
  }
  return filetypeMap.get(vimLang, 'Plain Text')

def ideoneGet(run):
  import urllib
  import vim
  import os

  os.environ['BROWSER'] = 'firefox'
  url = 'http://ideone.com/ideone/Index/submit/'
  data = {
    'file':'\n'.join(vim.current.buffer),
    'lang':ideoneLang(vim.eval('&filetype')),
    'submit':'Submit'
  }
  if run:
    data['run'] = 1

  response = urllib.urlopen(url, urllib.urlencode(data))
  return response.geturl()

def ideonePaste():
  url = ideoneGet(run=False)
  import vim
  vim.command("call setreg('+', '%s')" % url)
  vim.command("call setreg('*', '%s')" % url)
  import webbrowser
  webbrowser.open(url)

def ideoneRun():
  url = ideoneGet(run=True)
  import vim
  vim.command("call setreg('+', '%s')" % url)
  vim.command("call setreg('*', '%s')" % url)
  import webbrowser
  webbrowser.open(url)

def ideoneRunWo():
  url = ideoneGet(run=True)
  import vim
  vim.command("call setreg('+', '%s')" % url)
  vim.command("call setreg('*', '%s')" % url)
  #import webbrowser
  #webbrowser.open(url)

EOF
endif
