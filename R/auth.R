# from https://github.com/lockedata/hubspot/blob/master/R/hubspot_key.R # nolint

#' Get your Leadfeeder API token
#'
#' @return The Leadfeeder API token
#' @export
#'
#' @examples
#' get_token()
get_token <- function() {
  token <- try(keyring::key_get("rleadfeeder"), silent = TRUE)

  if (methods::is(token, "try-error")) {
    stop("Could not find Leadfeeder API token.
         Please run set_token() to set your token first.")
  }

  return(token)
}

#' Set your Leadfeeder API token
#'
#' @param token API token, generated on Leadfeeder dashboard
#'
#' @export
#'
#' @examples
#' \dontrun{
#' set_token(token = "yourtoken")
#' }
set_token <- function(token = NULL) {
  if (is.null(token)) {
    keyring::key_set("rleadfeeder")
  } else {
    keyring::key_set_with_value(
      password = token,
      service = "rleadfeeder"
    )
  }

  message("Token saved!")
}
