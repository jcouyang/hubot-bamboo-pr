## Installation
```sh
npm install hubot-bamboo-pr --save
```

add hubot-bamboo-pr to external-script.json
```diff
[
"
  hubot-simpsons",
+ "hubot-bamboo-pr"
]
```

setup the github web hook with something like

http://your.hubot.com/trigger-bamboo?bamboo=http://your.bamboo.com&buildKey=planBuildKey&room=optional-slack-channel

![](https://www.evernote.com/shard/s23/sh/311a6aad-132c-447f-9fe6-23abaec16252/3f22258fb8b72fc1fd1a7c2ced0db94d/deep/0/Screen-Shot-2015-02-13-at-11.35.29-AM.png)
