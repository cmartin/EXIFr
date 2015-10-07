library(LAI)
context("Basic EXIF extraction")

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["Make"]],
  equals("Canon")
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["ApertureValue"]],
  equals("43/8")
)

expect_that(
  read_exif_tags(system.file("extdata", "WSCT0151.JPG", package = "EXIFr"))[["Make"]],
  equals("Wingscapes")
)

expect_that(
  read_exif_tags(system.file("extdata", "WSCT0151.JPG", package = "EXIFr"))[["ApertureValue"]],
  equals("3/1")
)
