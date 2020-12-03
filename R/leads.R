#' Get leads
#'
#' @param account_id your account id
#' @param start_date start date (yyyy-mm-dd)
#' @param end_date end date (yyyy-mm-dd)
#'
#' @return data frame of all leads
#' @export
#'
#' @examples
#' \dontrun{
#' get_leads(
#' account_id = "12345", start_date = "2020-11-01", end_date = "2020-11-30")
#' }
get_leads <- function(account_id = NULL, start_date = NULL, end_date = NULL) {
  if(is.null(account_id)) {
    stop("account_id is missing")
  }
  
  if(is.null(start_date)) {
    stop("start_date is missing")
  }
  
  if(is.null(end_date)) {
    stop("end_date is missing")
  }
  
  next_page <- ""
  results <- list(data = NULL, included = NULL)
  
  while(!is.null(next_page)) {
    if(next_page == "") {
      url <- httr::modify_url(
        base_url(),
        path = glue::glue("accounts/{account_id}/leads"),
        query = list(start_date = start_date,
                     end_date = end_date)
      )
    } else {
      url <- content$links$`next`
    }
    content <- call_api(url)
    next_page <- content$links$`next`
    results$data <- c(results$data, content$data)
    results$included <- c(results$included, content$included)
  }
  
  data_attr <- results$data %>% 
    purrr::map("attributes") %>% 
    purrr::map_df(purrr::flatten_dfr)
  
  data <- tibble::tibble(
    id = purrr::map_chr(results$data, "id"),
    data_attr,
    loc_id = purrr::map_chr(results$data, c("relationships", "location", "data", "id"))
  ) 
  
  loc_attr <- results$included %>% 
    purrr::map("attributes") %>% 
    purrr::map_df(purrr::flatten_dfr)
  
  location <- tibble::tibble(
    loc_id = purrr::map_chr(results$included, "id"),
    loc_attr
  )
  
  dplyr::left_join(data, location)
}
