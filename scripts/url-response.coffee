# Description:
#   特定の発言に応じて必要なURLを教えてくれます
#

module.exports = (robot) ->
  robot.hear /楽曲一覧/i, (msg) ->
    msg.send "https://docs.google.com/spreadsheets/d/1H7cdM8P7sgN3gFY1z3xZAiu59izBQiWPKje1kzVFEBc/edit?usp=sharing"
