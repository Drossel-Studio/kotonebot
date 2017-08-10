# Description:
#   get a latest build link on unity cloud build
#

module.exports = (robot) ->
    robot.respond /latest/, (msg) ->
        orgid = process.env.UNITY_ORGID
        projectid = process.env.UNITY_PROJECTID
        apikey = process.env.UNITY_CLOUDBUILD_APIKEY

        for platform in ["ios", "android"]
          buildtargetid = platform
          request = robot.http("https://build-api.cloud.unity3d.com/api/v1/orgs/#{orgid}/projects/#{projectid}/buildtargets/#{buildtargetid}/builds")
                      .header('Content-Type', 'application/json')
                      .header('Authorization', "Basic #{apikey}")
                      .query(buildStatus: "success")
                      .query(per_page: 1)
                      .get()
          request (err, res, body) ->
              if err
                msg.send "エラーが発生したよ... #{err}"
                return
              else
                data = JSON.parse(body)[0]
                number = data["build"]
                msg.send "<https://developer.cloud.unity3d.com/build/orgs/#{orgid}/projects/#{projectid}/buildtargets/#{buildtargetid}/builds/#{number}/download/|#{buildtargetid}>"
