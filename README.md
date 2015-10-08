# EXIFr, a minimalist EXIF reader for R

This package natively reads EXIF tags from digital images. It does not rely on any external libraries or binary executables.

To keep things as simple as possible for the beginning, only the following tags are currently available :

* ExposureTime
* ApertureValue
* FocalLength
* ISOSpeedRatings
* PixelYDimension
* PixelXDimension
* DateTime
* Make
* Model

All values are returned as provided in the image file, so for example ExposureTime is "1/3200" and not 0.0003125


## To install : 
```{r}
library(devtools)
devtools::install_github("cmartin/EXIFr")
```

## To try the code with one of the example images : 
```{r}
library(EXIFr)

# To list all tags : 
read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))

# To view the value of a specific tag
read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["ApertureValue"]]

```

## If you need help with the EXIF format
The following resources were particularly useful :

* http://www.exiv2.org/Exif2-2.PDF
* http://code.flickr.net/2012/06/01/parsing-exif-client-side-using-javascript-2/
* http://www.media.mit.edu/pia/Research/deepview/exif.html

## Problems : 
Please report any bugs to the [GitHub issue tracker](https://github.com/cmartin/EXIFr/issues) and write any questions to <charles.martin1@uqtr.ca>

## If this code is useful to you, please cite as : 
Charles A. Martin (2015). EXIFr: Natively read EXIF tags from R. R package version 0.0.0.9000.
