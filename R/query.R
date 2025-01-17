#' Conduct a query and return the resulting documents
#'
#' @param index The index to query
#' @param queries An optional vector of queries to run (implicit OR)
#' @param fields An optional vector of fields to return
#' @param filters An optional list of filters, e.g. list(publisher='A', date=list(gte='2022-01-01'))
#' @param scroll Time to keep scrolling cursor alive
#' @param per_page Number of results per page
#' @param max_pages Stop after getting this many pages. Set to 0 to retrieve all.
#' @param credentials The credentials to use. If not given, uses last login information
#' @param merge_tags Character to merge tag fields with, default ';'. Set to NULL to prevent merging.
#' @export
query_documents <- function(
    index, queries=NULL, fields=c("date", "title"), filters=NULL,
    scroll="5m", per_page=1000, credentials=NULL, merge_tags=";",
    max_pages=1) {
  types = get_fields(index)
  convert = function(row) {
    for (tag_col in intersect(names(row), types$name[types$type == "tag"])) {
        row[tag_col] = paste(row[[tag_col]], collapse=merge_tags)
    }
    row
  }

  #TODO: convert dates into Date? <- could check field types. OTOH, maybe return table in more sensible format?
  body <- list(
    queries=queries, fields=fields, filters=filters,
    scroll=scroll, per_page=per_page)
  #TODO: I think there's a better way to create a result set from pages, right Kasper?
  results = list()
  while (T) {
    r = do_post(credentials, c("index", index, "query"), body=body, error_on_404=FALSE)
    if (is.null(r)) break
    new_results = r$results
    if (!is.null(merge_tags)) new_results = purrr::map(new_results, convert)
    new_results = dplyr::bind_rows(new_results)
    results <- append(results, list(new_results))
    message(paste0("Retrieved ", nrow(new_results), " results in ", length(results), " pages"))
    if (max_pages > 0 & length(results) >= max_pages) break
    body$scroll_id <- r$meta$scroll_id
  }
  d = dplyr::bind_rows(results)
  if ("_id" %in% colnames(d)) d <- dplyr::rename(d, .id="_id")
  for (date_col in intersect(colnames(d), types$name[types$type == "date"])) {

    d[[date_col]] = lubridate::as_datetime(d[[date_col]])
  }
  d
}

#' Conduct a query and return the resulting documents
#'
#' @param index The index to query
#' @param axes The aggregation axes, e.g. list(list(field="publisher", list(field="date", interval="year")))
#' @param queries An optional vector of queries to run (implicit OR)
#' @param filters An optional list of filters, e.g. list(publisher='A', date=list(gte='2022-01-01'))
#' @param credentials The credentials to use. If not given, uses last login information
#' @export
query_aggregate <- function(index, axes, queries=NULL, filters=NULL, credentials=NULL) {
  #TODO: convert dates into Date? <- could check field types. OTOH, maybe return table in more sensible format?
  body = list(axes=axes, queries=queries, filters=filters)
  r = do_post(credentials, c("index", index, "aggregate"), body=body)
  d = dplyr::bind_rows(r$data)
  if ("_query" %in% colnames(d)) d <- dplyr::rename(d, .query = "_query")
  d
}
#' Add or remove tags to/from documents by query or ID
#' @param index The index to query
#' @param field The tag field name
#' @param tag The tag to add or remove
#' @param action 'add' or 'remove' the tags
#' @param queries An optional vector of queries to run (implicit OR)
#' @param filters An optional list of filters, e.g. list(publisher='A', date=list(gte='2022-01-01'))
#' @param ids A vector of ids to add/remove tags from
#' @param credentials The credentials to use. If not given, uses last login information
#' @export
update_tags <- function(index, action, field, tag, ids=NULL, queries=NULL, filters=NULL, credentials=NULL) {
  body = list(field=field, action=action, tag=tag, ids=ids, queries=queries, filters=filters)
  do_post(credentials, c("index", index, "tags_update"), body=body)
}

