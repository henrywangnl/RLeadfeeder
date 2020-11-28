base_url <- function() {
  "https://api.leadfeeder.com"
}

call_api <- function(url) {

  # Authorization: Token token=yourapitoken
  token <- paste("Token", glue::glue("token={get_token()}"))

  # user agent
  ua <- httr::user_agent("https://github.com/henrywangnl/RLeadfeeder")

  resp <- httr::GET(
    url = url,
    httr::add_headers(Authorization = token),
    ua
  )

  httr::stop_for_status(resp)

  httr::content(resp)
}
