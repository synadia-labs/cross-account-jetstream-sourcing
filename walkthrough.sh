nats-server -config config/server.conf&
nats --user user-accountA --password s3cr3t stream add foo --subjects="foo.*" --defaults
nats --user user-accountA --password s3cr3t pub foo.a "hello from account A"
nats --user user-accountA --password s3cr3t pub foo.b "hello from account A on foo.b"
nats --user user-accountA --password s3cr3t stream add bar --subjects="bar.>" --defaults
nats --user user-accountA --password s3cr3t pub bar.b.c "hello from account A on bar.b.c"
nats --user user-accountB --password s3cr3t stream add foo-b --config foo-b.json
nats --user user-accountB --password s3cr3t stream add foo-ab --config foo-ab.json
nats --user user-accountB --password s3cr3t stream view foo-b
nats --user user-accountB --password s3cr3t stream view foo-ab
nats --user user-accountB --password s3cr3t stream add bar --config bar.json
nats --user user-accountB --password s3cr3t stream view bar
