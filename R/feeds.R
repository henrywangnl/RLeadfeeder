#' Get custom feeds list for an account
#'
#' @param account_id your account id
#'
#' @return data frame of custom feeds
#' @export
#'
#' @examples
#' \dontrun{
#' get_feeds()
#' }
get_feeds <- function(account_id = NULL) {
  
  if(is.null(account_id)) {
    stop("account_id is missing")
  }
  
  url <- httr::modify_url(
    base_url(),
    path = glue::glue("accounts/{account_id}/custom-feeds")
  )
  
  content <- call_api(url)
  
  tibble::tibble(
    id = purrr::map_chr(content$data, "id"),
    type = purrr::map_chr(content$data, "type"),
    name = purrr::map_chr(content$data, c("attributes", "name")),
  )
}
