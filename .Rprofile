if (interactive()) {
   options(deparse.max.lines=5)
   options(max.print=4999)
}

local({
    ## HTTPS requires R version 3.2 or better
    if (getRversion() >= '3.2') {
        cran <- "https://cran.revolutionanalytics.com"
    } else {
        cran <- "http://cran.revolutionanalytics.com"
    }
    options(repos=c(CRAN=cran))
})

## HTTPS support
if (!isTRUE(capabilities('libcurl')) && Sys.which('wget') != '')
    options(download.file.method = "wget")

Sys.setenv(TZ='UTC')

local({
    majVer <- with(R.Version(), paste(major, sub("\\..+", "", minor), sep=".")) # e.g. "3.2"
    rLib <- path.expand(file.path('~/R/library', majVer))
    if (!file.exists(rLib)) dir.create(rLib, recursive=TRUE)
    .libPaths(rLib)
    Sys.setenv(R_LIBS=rLib)  # See https://goo.gl/vhrpYj
})


options(
  devtools.desc = list( Version = "0.1" ),
  devtools.desc.author = "Ken Williams <kenahoo@gmail.com> [aut, cre]",
  devtools.desc.suggests = 'testthat',
  devtools.desc.license = 'MIT'
)
