library(ffscrapr)

SEASON <- 2024

my_leagues <- ffscrapr::sleeper_userleagues("rplain", SEASON)

league_id <- my_leagues %>%
  dplyr::filter(league_name == "The Hot Boyz") %>%
  dplyr::pull(league_id)

my_league <- ffscrapr::ff_connect(
  platform = "sleeper",
  season = SEASON,
  league_id = league_id
)

draft_board <- ff_draft(my_league)
#players_list <- draft_board |> select(-Round) |> pivot_longer(everything()) |> pull(value)

for(i in 1:nrow(draft_board)) {
  
  player_id <- draft_board[i, 'player_id']
  
  if(draft_board[i, 'pos'] == 'DEF') {
    url <- glue::glue('https://sleepercdn.com/images/team_logos/nfl/{stringr::str_to_lower(player_id)}.png') }
  else {
    url <- glue::glue("https://sleepercdn.com/content/nfl/players/{player_id}.jpg")
  }
  magick::image_read(url) |>
    magick::image_scale("50x50") |>
    magick::image_write(glue::glue('img/{player_id}.png'))
  
  magick::image_read(url) |>
    magick::image_scale("50x50") |>
    magick::image_convert(colorspace = 'gray') |>
    magick::image_write(glue::glue('img/{player_id}_bw.png'))
}
