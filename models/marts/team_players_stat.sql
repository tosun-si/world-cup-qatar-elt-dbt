{{config(
        materialized='table',
        partition_by={
          "field": "ingestionDate",
          "data_type": "timestamp",
          "granularity": "day"
        }
)}}

with team_players_stat_raw as (
    select * from {{ ref('team_players_stat_raw_cleaned') }}
)

SELECT
    nationality AS teamName,
    nationalTeamKitSponsor,
    fifaRanking,
    SUM(goalsScored) AS teamTotalGoals,
    current_timestamp() AS ingestionDate,

    STRUCT(
        playerName,
        appearances,
        savePercentage,
        cleanSheets
    ) AS goalKeeper,

    {{
        build_player_stats(
            'goalsScored',
            'appearances',
            'brandSponsorAndUsed',
            'club',
            'position',
            'playerDob',
            'playerName'
        )
    }}
    AS topScorers

    {{
        build_player_stats(
            'assistsProvided',
            'appearances',
            'brandSponsorAndUsed',
            'club',
            'position',
            'playerDob',
            'playerName'
        )
    }}
    AS bestPassers,

    {{
        build_player_stats(
            'dribblesPerNinety',
            'appearances',
            'brandSponsorAndUsed',
            'club',
            'position',
            'playerDob',
            'playerName'
        )
    }}
    AS bestDribblers,

    {{
        build_player_stats(
            'appearances',
            'appearances',
            'brandSponsorAndUsed',
            'club',
            'position',
            'playerDob',
            'playerName'
        )
    }}
    AS playersMostAppearances,

    {{
        build_player_stats(
            'totalDuelsWonPerNinety',
            'appearances',
            'brandSponsorAndUsed',
            'club',
            'position',
            'playerDob',
            'playerName'
        )
    }}
    AS playersMostDuelsWon,

    {{
        build_player_stats(
            'interceptionsPerNinety',
            'appearances',
            'brandSponsorAndUsed',
            'club',
            'position',
            'playerDob',
            'playerName'
        )
    }}
    AS playersMostInterception,

    {{
        build_player_stats(
            'tacklesPerNinety',
            'appearances',
            'brandSponsorAndUsed',
            'club',
            'position',
            'playerDob',
            'playerName'
        )
    }}
    AS playersMostSuccessfulTackles,

    {{
        build_player_stats(
            'tacklesPerNinety',
            'appearances',
            'brandSponsorAndUsed',
            'club',
            'position',
            'playerDob',
            'playerName'
        )
    }}
    AS playersMostSuccessfulTackles

from team_players_stat_raw
GROUP BY
    nationality