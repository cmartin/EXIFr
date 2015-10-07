library(LAI)
context("Basic EXIF extraction")

expect_that(
  read_exif_tags(system.file("extdata", "tiny.jpg", package = "EXIFr"))[["Make"]],
  equals("Canon")
)

expect_that(
  read_exif_tags(system.file("extdata", "tiny.jpg", package = "EXIFr"))[["ApertureValue"]],
  equals("43/8")
)