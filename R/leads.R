#' Get leads
#'
#' @param account_id your account id
#' @param start_date start date (yyyy-mm-dd)
#' @param end_date end date (yyyy-mm-dd)
#' @param feed_id custom feed id. NULL by default. 
#'
#' @return data frame of all leads for all the feeds (if feed_id is NULL) or for one specific feed (if feed_id is provided)
#' @export
#'
#' @examples
#' \dontrun{
#'
#' get_leads(
#'    account_id = "12345",
#'    start_date = "2020-11-01",
#'    end_date = "2020-11-30"
#' )
#' }
get_leads <- function(account_id = NULL, start_date = NULL, 
                      end_date = NULL, feed_id = NULL) {
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
  
  if(is.null(feed_id)) {
    path = glue::glue("accounts/{account_id}/leads")
  } else {
    path = glue::glue("accounts/{account_id}/custom-feeds/{feed_id}/leads")
  }

  while(!is.null(next_page)) {
    if(next_page == "") {
      url <- httr::modify_url(
        base_url(),
        path = path,
        query = list(start_date = start_date,
                     end_date = end_date,
                     `page[size]` = 100)
      )
    } else {
      url <- content$links$`next`
    }
    content <- call_api(url)
    next_page <- content$links$`next`
    results$data <- c(results$data, content$data)
    results$included <- c(results$included, content$included)
  }

  data <- results$data %>%
    purrr::map(
      ~ c(id = .$id, .$attributes, loc_id = .$relationships$location$data$id)
    ) %>% 
    tibble::tibble(lead = .) %>% 
    tidyr::unnest_wider(lead)
  
  location <- results$included %>%
    purrr::map(
      ~ c(loc_id = .$id, .$attributes)
    ) %>% 
    tibble::tibble(location = .) %>% 
    tidyr::unnest_wider(location)
  
  suppressMessages(dplyr::left_join(data, location)) %>%
    dplyr::distinct()
}
