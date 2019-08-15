if (interactive()) {
   options(deparse.max.lines=5)
   options(max.print=4999)
}

options(
  repos=c(CRAN="https://cran.revolutionanalytics.com"),
  devtools.desc = list( Version = "0.1" ),
  devtools.desc.author = "Ken Williams <kenahoo@gmail.com> [aut, cre]",
  devtools.desc.suggests = 'testthat',
  devtools.desc.license = 'MIT'
)

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


# Useful for getting longer dput() output, etc.
# options('deparse.max.lines'=30)
