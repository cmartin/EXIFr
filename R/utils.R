#' Converts a rational number from to string to its numeric representation
#'
#' @param x A string containing the number to convert.
#' @return The numerical value of x.
#' @examples
#' rational_to_numeric("1/3200")
#' @export
#' @seealso \code{\link{read_exif_tags}}
rational_to_numeric <- function(x) {
  p = strsplit(x,"/")
  as.numeric(unlist(p)[1]) / as.numeric(unlist(p)[2])
}