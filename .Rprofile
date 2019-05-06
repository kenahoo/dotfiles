if (interactive()) {
   options(deparse.max.lines=5)
   options(max.print=4999)
}

local({
  options(repos=c(CRAN="https://cran.revolutionanalytics.com"))
})

## HTTPS support
if (!isTRUE(capabilities('libcurl')) && Sys.which('wget') != '')
    options(download.file.method = "wget")

Sys.setenv(TZ='UTC')

# Configure per-user package library, e.g. ~/R/library/3.2/ :
local({
  if (!grepl("/(mini)?conda", R.home(), perl=TRUE)) {
    majVer <- with(R.Version(), paste(major, sub("\\..+", "", minor), sep=".")) # e.g. "3.2"
    localLib <- path.expand(file.path('~/R/library', majVer))
    if (!file.exists(localLib))
       dir.create(localLib, recursive=TRUE)
    .libPaths(localLib)
    Sys.setenv(R_LIBS=localLib)  # See https://goo.gl/vhrpYj
  }
})


options(
  devtools.desc = list( Version = "0.1" ),
  devtools.desc.author = "Ken Williams <kenahoo@gmail.com> [aut, cre]",
  devtools.desc.suggests = 'testthat',
  devtools.desc.license = 'MIT'
)

# Useful for getting longer dput() output, etc.
# options('deparse.max.lines'=30)
