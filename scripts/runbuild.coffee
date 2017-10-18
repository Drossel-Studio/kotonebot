# Description:
#   create new build on unity cloud build
#
# Commands:
#   hubot newbuild - 新しいビルド命令を送信します

Conversation = require('hubot-conversation');

class NewBuildCommand
    platform = ""
    cleanbuild = false

module.exports = (robot) ->
    conversation = new Conversation(robot)
    robot.respond /newbuild/, (res) ->
        dialog = conversation.startDialog res, 60000; # timeout = 1min
        dialog.timeout = (res) ->
            res.emote('タイムアウトだから中止するよ！')
        input_platform res, dialog

    p = new NewBuildCommand

    trim_input = (str) -> str.trim()

    input_platform = (res, dialog) ->
        res.send 'どのプラットフォームをビルドする？ [ 例) ios ]'
        dialog.addChoice /(.+)/, (res2) -> 
            p.platform = trim_input res2.match[1]
            input_clean res2, dialog # 次に実行する関数をaddChoice内で呼びます

    input_clean = (res, dialog) ->
        res.send 'クリーンビルドにする？（クリーンビルドにするとビルド時間が長くなるよ。何回ビルドしてもエラーになるときに使ってね） [ yes/no ]'
        dialog.addChoice /yes/, (res2) -> 
            p.cleanbuild = true
            confirmation res2, dialog
        dialog.addChoice /no/, (res2) -> 
            p.cleanbuild = false
            confirmation res2, dialog

    confirmation = (res, dialog) ->
        res.send 'これでビルドするよ！ [ yes/no ]'
        dialog.addChoice /yes/, (res2) ->
            show_result res2, dialog
        dialog.addChoice /no/, (res2) -> 
            res.send "りょーかい！ ビルドを中止するよ"

    show_result = (res, dialog) ->
        data = JSON.stringify({
          "clean": p.cleanbuild,
          "delay": 0
        })
        orgid = process.env.UNITY_ORGID
        projectid = process.env.UNITY_PROJECTID
        apikey = process.env.UNITY_CLOUDBUILD_APIKEY
        robot.http("https://build-api.cloud.unity3d.com/api/v1/orgs/#{orgid}/projects/#{projectid}/buildtargets/#{p.platform}/builds")
          .header('Content-Type', 'application/json')
          .header('Authorization', "Basic #{apikey}")
          .post(data) (err, response, body) ->
            if err
              res.send "ビルドの送信に失敗したよ... #{err}"
              return
            else
              res.send "ビルド命令の送信に成功したよ！"
