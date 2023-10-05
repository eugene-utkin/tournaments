module TournamentsHelper
  def humanize_match_result(match)
    if match.result == 'team_a_won'
      "#{match.team_a.name} won."
    elsif match.result == 'team_b_won'
      "#{match.team_b.name} won."
    elsif match.result == 'not_played_yet'
      "not played yet."
    else
      "#{match.result}."
    end
  end
end