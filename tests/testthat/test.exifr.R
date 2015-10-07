library(LAI)
context("Basic EXIF extraction")

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["Make"]],
  equals("Canon")
)

expect_that(
  read_exif_tags(system.file("extdata", "WSCT0151.JPG", package = "EXIFr"))[["Make"]],
  equals("Wingscapes")
)


context("tags from the sub-IFD section")

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["ExposureTime"]],
  equals("1/3200")
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["ApertureValue"]],
  equals("43/8")
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["FocalLength"]],
  equals("18/1")
)


expect_that(
  read_exif_tags(system.file("extdata", "WSCT0151.JPG", package = "EXIFr"))[["ApertureValue"]],
  equals("3/1")
)
