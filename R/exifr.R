# http://code.flickr.net/2012/06/01/parsing-exif-client-side-using-javascript-2/
# http://www.media.mit.edu/pia/Research/deepview/exif.html

read_ifd_at <- function(IFD_start, all_bytes, endian, TIFF_offset) {

  tag_list = list()
  nb_dir_entries <- readBin(
    all_bytes[(IFD_start + 1):(IFD_start + 2)],
    "integer",
    size = 2,
    endian = endian
  )

  IFD_start = IFD_start + 3

  for (i in 1:nb_dir_entries) {

    tag_number <- readBin(
      all_bytes[(IFD_start):(IFD_start + 1 )],
      "integer",
      size = 2,
      endian = endian,
      signed = FALSE
    ) # tag number

    tag_type = readBin(
      all_bytes[(IFD_start + 2):(IFD_start + 3 )],
      "integer",
      size = 2,
      endian = endian
    )

    data_length <- readBin(
      all_bytes[(IFD_start + 4):(IFD_start + 7 )],
      "integer",
      size = 4,
      endian = endian
    )
    data_position <- readBin(
      all_bytes[(IFD_start + 8):(IFD_start + 11 )],
      "integer",
      size = 4,
      endian = endian
    )


    #     http://www.exiv2.org/Exif2-2.PDF p. 14
    #     Type
    #     The following types are used in Exif:
    #     1 = BYTE An 8-bit unsigned integer.,
    #     2 = ASCII An 8-bit byte containing one 7-bit ASCII code. The final byte is terminated with NULL.,
    #     3 = SHORT A 16-bit (2-byte) unsigned integer,
    #     4 = LONG A 32-bit (4-byte) unsigned integer,
    #     5 = RATIONAL Two LONGs. The first LONG is the numerator and the second LONG expresses the
    #     denominator.,
    #     7 = UNDEFINED An 8-bit byte that can take any value depending on the field definition,
    #     9 = SLONG A 32-bit (4-byte) signed integer (2's complement notation),
    #                                                 10 = SRATIONAL Two SLONGs. The first SLONG is the numerator and the second SLONG is the
    #                                                 denominator.


    #print(tag_number)
    tag_name <- tag_number_to_tag_name(tag_number)
    tag_value <- switch(tag_type,
                        {"Byte not implemented"},

                        {# 2 = ASCII
                          readBin(
                            all_bytes[(TIFF_offset + data_position + 1):
                                        (TIFF_offset + data_position + data_length)],
                            "char",
                            size = data_length
                          )

                        },
                        {# 3 = Int 16 bit
                          readBin(
                            all_bytes[(IFD_start + 8): # For entries less than 4 bytes, read data directly
                                        (IFD_start + 11)],
                            "integer",
                            endian = endian,
                            size = 2
                          )
                        },
                        {# 4 = Int 32 bit
                          readBin(
                            all_bytes[(IFD_start + 8): # For entries less than 4 bytes, read data directly
                                        (IFD_start + 11)],
                            "integer",
                            endian = endian,
                            size = 4
                          )
                        },
                        {# 5 = Rational

                          paste(
                            readBin(
                              all_bytes[(TIFF_offset + data_position + 1):
                                          (TIFF_offset + data_position + 4)],
                              "integer",
                              endian = endian,
                              size = 4
                            ),
                            readBin(
                              all_bytes[(TIFF_offset + data_position + 5):
                                          (TIFF_offset + data_position + 8)],
                              "integer",
                              endian = endian,
                              size = 4
                            ),
                            sep = "/"
                          )
                        }
    )

    IFD_start <- IFD_start + 12

    #print(paste(tag_type, tag_number,tag_value))

    if (tag_number == 34665) {
      #print("Into Sub IFD")
      #http://www.awaresystems.be/imaging/tiff/tifftags/subifds.html
      # Sub IFD offsets are relative to the TIFF header
      tag_list <- append(
        tag_list,
        read_ifd_at(tag_value + TIFF_offset, all_bytes, endian, TIFF_offset)
      )
    } else {
      tag_list[[tag_name]] <- tag_value
    }

  }

  return (tag_list)

}


find_raw_marker <- function(marker, all_bytes, start_offset=0) {

  reading_head <- start_offset + 1
  marker_length <- nchar(marker[1]) / 2 # Hope all markers have the same length
  repeat {
    slice <- readBin(
      all_bytes[reading_head:(reading_head + marker_length - 1)],
      "raw",
      n = marker_length
    )

    current_marker <- toupper(paste(slice,collapse = ""))
    if (current_marker %in% marker) {
      return(list(offset = reading_head - 1, marker = current_marker))
    } else {
      reading_head <- reading_head + 1
    }
  }
}

tag_number_to_tag_name <- function(tag_number){
  pairs = list()

  pairs[[ "41990" ]] <- "SceneCaptureType"
  pairs[[ "41986" ]] <- "ExposureMode"
  pairs[[ "41987" ]] <- "WhiteBalance"
  pairs[[ "33434" ]] <- "ExposureTime"
  pairs[[ "37378" ]] <- "ApertureValue"
  pairs[[ "37377" ]] <- "ShutterSpeedValue"
  pairs[[ "37386" ]] <- "FocalLength"

  pairs[[ "271" ]] <- "Make"
  pairs[[ "272" ]] <- "Model"

  t = as.character(tag_number)
  if (t %in% names(pairs)) {
    pairs[[as.character(tag_number)]]
  } else {
    warning(paste(tag_number, " tag number is not defined"))
    return (tag_number)
  }

}


read_exif_tags <- function(file_path) {
  con <- file(file_path, "rb")
  rm(file_path)
  all_bytes <- readBin(
    con, "raw",
    n = 128000, # All info should be in the first 128k (and probably 64k)
    size = 1
  )
  close(con);rm(con)


  # Find the APP1 marker
  res <- find_raw_marker("FFE1", all_bytes)
  APP1_offset <- res$offset

  # Read the length of the APP1 marker (APP1_offset + 1 + length of FFE1 marker)
  readBin(
    all_bytes[(APP1_offset + 1 + 2):(APP1_offset + 2 + 2)],
    "integer",
    size = 2,
    signed = FALSE,
    endian = "big" # Data size(2 Bytes) has "Motorola" byte alig
  )

  # which is Exif in ASCII
  res <- find_raw_marker("45786966", all_bytes, start_offset = APP1_offset + 2 + 2)
  Exif_offset <- res$offset

  # Read for little of big endian = THIS IS THE BEGINNING OF THE TIFF HEADER
  res <- find_raw_marker(c("4D4D","4949"), all_bytes, start_offset = Exif_offset)
  TIFF_offset <- res$offset
  if ( res$marker == "4D4D") {
    endian <- "big"
  } else {
    endian <- "little"
  }
  rm(res)

  # 002a or 2a00 depending on endianess
  readBin(all_bytes[(TIFF_offset + 3):(TIFF_offset + 4)],"raw",n = 2)

  IFD_offset <- readBin(
    all_bytes[(TIFF_offset + 5):(TIFF_offset + 5 + 3)],
    "integer",
    size = 4,
    endian = endian
  )

  read_ifd_at(TIFF_offset + IFD_offset, all_bytes, endian, TIFF_offset)

}