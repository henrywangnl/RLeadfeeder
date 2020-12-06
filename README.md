
<!-- README.md is generated from README.Rmd. Please edit that file -->

# RLeadfeeder

<!-- badges: start -->

[![R-CMD-check](https://github.com/henrywangnl/RLeadfeeder/workflows/R-CMD-check/badge.svg)](https://github.com/henrywangnl/RLeadfeeder/actions)
<!-- badges: end -->

The goal of RLeadfeeder is to let you work with
[Leadfeeder](https://www.leadfeeder.com/) API.

## Installation

``` r
remotes::install_github("henrywangnl/RLeadfeeder")
```

## Authentication

Leadfeeder API expects an API token to be included in all requests sent
to the server.

You can generate your unique authentication token at [Leadfeeder API
settings](https://app.leadfeeder.com/l/settings/personal/api-tokens).

``` r
library(RLeadfeeder)

## Set your Leadfeeder API token
set_token(token = "YOUR_API_TOKEN")
#> Token saved!

## Check your Leadfeeder API token
get_token()
#> [1] "YOUR_API_TOKEN"
```

## Get accounts

Retrieve all accounts that you have access to.

``` r
get_accounts()
```

## Get feeds

Get all the feeds for an Account.

``` r
get_feeds(account_id = "12345")
```

## Get leads

Retrieve a list of leads in an Account on a specific time interval. The
total number of results is limited to the first 10000 leads.

``` r
get_leads(
  account_id = "12345", 
  start_date = "2020-11-01", 
  end_date = "2020-11-30"
)
```

## Get visits

Retrieve a list of Visits for all Leads from a specific time interval.

``` r
get_visits(
   account_id = "12345", 
   start_date = "2020-11-01", 
   end_date = "2020-11-30"
)
```
