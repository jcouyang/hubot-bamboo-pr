url           = require('url')
querystring   = require('querystring')
eventTypesRaw = process.env['BAMBOO_EVENT_NOTIFIER_TYPES']
eventTypes    = []

if eventTypesRaw?
  eventTypes = eventTypesRaw.split(',')
else
  console.warn("github-repo-event-notifier is not setup to receive any events (BAMBOO_EVENT_NOTIFIER_TYPES is empty).")

module.exports = (robot) ->
  robot.router.post "/hubot/trigger-bamboo", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)
    bamboo_url = query.bamboo
    build_key = query.buildKey
    room = query.room
    res.end "" if !bamboo_url
    data = req.body
    eventType = req.headers["x-github-event"]
    console.log "Processing event type #{eventType}..."

    try
      if eventType in eventTypes
        if room
          robot.messageRoom room,"poke me to trigger build for pull request #{data.number} of #{data.pull_request.head.repo.name} #{bamboo_url}/ajax/runParametrisedManualBuild.action?planKey=#{build_key}&buildNumber=&customRevision=&key_pull_num=pull_num&variable_pull_num=#{data.number}&key_pull_sha=pull_sha&variable_pull_sha=#{data.pull_request.head.sha}&bamboo.successReturnMode=json&decorator=nothing&confirm=true"
        robot.http("#{bamboo_url}?bamboo.variable.pull_ref=#{data.pull_request.head.ref}&bamboo.variable.pull_sha=#{data.pull_request.head.sha}&bamboo.variable.pull_num=#{data.number}")
          .post()
      else
        console.log "Ignoring #{eventType} event as it's not allowed."
    catch error
      console.log "github repo event notifier error: #{error}. Request: #{req.body}"

    res.end ""
