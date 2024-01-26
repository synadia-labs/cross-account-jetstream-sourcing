# cross-account-sourcing

Examples of how to source (or mirror) streams cross-accounts.
See the server configuration file for the export/import grants, and the stream config JSONs for examples of how to source streams from account A to account B.

The security imports and exports can be set in two different ways, depending on whether you want to control on a per (single) subject filter basis what messages are allowed for export/import or simply grant access to the whole stream with however many subject filters the sourcing streams want to use.

In these examples two streams are created on account A: 'foo' records messages on "foo.*" and 'bar' records messages on "bar.>".

For the stream 'foo', import/export settings only allow the export to streams with a filter of "foo.a" or "foo.b". Due to the way this 'per subject filter' export restriction mechanism works, you have to list in your export explicitly all the subject filters you want to allow exporting on. On the sourcing stream definition side you need to create exactly one source per subject filter being sourced (as opposed to a single source/mirror with multiple subject filters).

For the stream 'bar' the import/export settings allow for the export to sourcing/mirroring streams with any or multiple subject filter(s). The example stream definition in the `bar.json` file also shows examples of how you can transform the subjects as part of the sourcing from the other account. Note that two different $JS.API subjects filters are exported for stream 'bar' in to cover a sourcing/mirroring stream using only one subject filter for the source or multiple ones.

## Walkthrough

Start the nats-server:
```shell
nats-server -config config/server.conf&
```

Create stream 'foo' on account A listening on subjects "foo.*"
```shell
nats --user user-accountA --password s3cr3t stream add foo --subjects="foo.*" --defaults
```

Publish a message from account A on "foo.a"
```shell
nats --user user-accountA --password s3cr3t pub foo.a "hello from account A"
```

Publish a message from account A on "foo.b"
```shell
nats --user user-accountA --password s3cr3t pub foo.b "hello from account A on foo.b"
```

Create stream 'bar' on account A listening on subjects "bar.>"
```shell
nats --user user-accountA --password s3cr3t stream add bar --subjects="bar.>" --defaults
```

Publish a message from account A on "bar.a.b"
```shell
nats --user user-accountA --password s3cr3t pub bar.b.c "hello from account A on bar.b.c"
```

Create stream 'foo-b' on account B that sources accountA once with a filter on foo.b, which will source the messages from the start of the stream being sourced.

```shell
nats --user user-accountB --password s3cr3t stream add foo-b --config foo-b.json
```

Create stream 'foo-ab' on account B sourcing twice from accountA on account A: once with a filter of "foo.a" and a second time but with a filter of "foo.b"
```shell
nats --user user-accountB --password s3cr3t stream add foo-ab --config foo-ab.json
```

Check the messages got sourced to foo-a and foo-ab on account B
```shell
nats --user user-accountB --password s3cr3t stream view foo-b
```
```shell
nats --user user-accountB --password s3cr3t stream view foo-ab
```

Create stream 'bar' on account B sourcing once from account A using various subject filters and transforms
```shell
nats --user user-accountB --password s3cr3t stream add bar --config bar.json
```

And finally check that the messages on "bar.>" get properly sourced (and their subjects get transformed) into stream 'bar' 
```shell
nats --user user-accountB --password s3cr3t stream view bar
```