#' Get all visits
#'
#' @param account_id your account id
#' @param start_date start date (yyyy-mm-dd)
#' @param end_date end date (yyyy-mm-dd)
#' @param lead_id lead id. NULL by default
#'
#' @return data frame of all visits for all the leads (by default) or for one specific lead (if lead_id is provided)
#' @export
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#'
#' get_visits(
#'    account_id = "12345",
#'    start_date = "2020-11-01",
#'    end_date = "2020-11-30"
#' )
#' }
get_visits <- function(account_id = NULL, start_date = NULL, 
                       end_date = NULL, lead_id = NULL) {
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
  results <- list()
  
  if(is.null(lead_id)) {
    path = glue::glue("accounts/{account_id}/visits")
  } else {
    path = glue::glue("accounts/{account_id}/leads/{lead_id}/visits")
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
    results <- c(results, content$data)
  }

  results %>%
    purrr::map(~ c(id = .$id, .$attributes)) %>%
    tibble::tibble(visit = .) %>%
    tidyr::unnest_wider(visit)
}
