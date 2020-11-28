#' Get accounts
#'
#' @return data frame of accounts the user has access to
#' @export
#'
#' @examples
#' get_accounts()
get_accounts <- function() {
 url <- httr::modify_url(
   base_url(),
   path = "accounts"
 )
 
 content <- call_api(url)
 
 tibble::tibble(
   id = purrr::map_chr(content$data, "id"),
   type = purrr::map_chr(content$data, "type"),
   name = purrr::map_chr(content$data, c("attributes", "name")),
   timezone = purrr::map_chr(content$data, c("attributes", "timezone")),
   subscription = purrr::map_chr(content$data, c("attributes", "subscription"))
 )
}
