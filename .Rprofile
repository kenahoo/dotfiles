options(deparse.max.lines=5)
options(max.print=4999)

local({
    ## HTTPS requires R version 3.2 or better
    if (getRversion() >= '3.2') {
        cran <- "https://cran.revolutionanalytics.com"
    } else {
        cran <- "http://cran.revolutionanalytics.com"
    }
    options(repos=c(CRAN=cran))
})

Sys.setenv(TZ='UTC')

local({
    majVer <- with(R.Version(), paste(major, sub("\\..+", "", minor), sep=".")) # e.g. "3.2"
    .libPaths(Sys.glob(file.path('~/R/library', majVer)))
    Sys.setenv(R_LIBS=.libPaths()[1])  # See https://goo.gl/vhrpYj
})
