# dashlack

dashing + slack = dashlack


## Getting Started

```
bundle install
SLACK_TOKEN=your_slack_token bundle exec dashing start -d
```

after, access to

```
http://127.0.0.1:3030/index?ids={slack user ids| delimiter ,}
```

e.g.
```
http://127.0.0.1:3030/index?ids=U029EC7BC,U0XMLK9U0
```
