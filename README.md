# cross-account-sourcing

Demonstrate cross-account export/import grants to SOURCE streams across account boundary.

Steps:

Start the nats-server:
```
nats-server -config config/server.conf&
```

create stream 'testA' on account A listening on subjects "foo.*"
```
nats --user user-testA --password s3cr3t stream add testA --subjects="foo.*" --defaults
```

create stream 'foo-ab' on account B sourcing twice from testA on account A: once with a filter of "foo.a" and a second time but with a filter of "foo.b", an API prefix of "$JS.testA.API" (if creating from a nats prompt just type 'testA') and a delivery prefix of "testB.S"
```
nats --user user-testB --password s3cr3t stream add foo-ab --config foo-ab.json
```


publish a message from account A on "foo.a"
```
nats --user user-testA --password s3cr3t pub foo.a "hello from account A"
```

check the message got sourced to foo-ab on account B
```
nats --user user-testB --password s3cr3t stream view foo-ab
```

Publish a new message on foo.a (from account A)
```
nats --user user-testA --password s3cr3t pub foo.a "hello again from account A on foo.a"
```

Publish a new message on foo.b (from account A)
```
nats --user user-testA --password s3cr3t pub foo.b "hello again from account A on foo.b"
```

Create stream 'foo-b' on account B that sources testA once with a filter on foo.b, which will source the messages from the start of the stream being sourced.

```
nats --user user-testB --password s3cr3t stream add foo-b --config foo-b.json
```

and check that those message make it both to foo-ab, and only one makes it to foo-b
```
nats --user user-testB --password s3cr3t stream view foo-ab
```

```
nats --user user-testB --password s3cr3t stream view foo-b
```