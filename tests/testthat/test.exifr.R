library(LAI)

context("Supported tags listing")
expect_true("ApertureValue" %in% supported_tags())
expect_false("ShutterSpeedValue" %in% supported_tags())

context("Basic EXIF extraction")

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["Make"]],
  equals("Canon")
)

expect_that(
  read_exif_tags(system.file("extdata", "WSCT0151.JPG", package = "EXIFr"))[["Make"]],
  equals("Wingscapes")
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["DateTime"]],
  equals("2013:07:09 10:23:47")
)

context("Tags from the sub-IFD section")

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
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["ISOSpeedRatings"]],
  equals(800)
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["PixelYDimension"]],
  equals(67)
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["PixelXDimension"]],
  equals(100)
)

expect_that(
  read_exif_tags(system.file("extdata", "WSCT0151.JPG", package = "EXIFr"))[["ApertureValue"]],
  equals("3/1")
)
