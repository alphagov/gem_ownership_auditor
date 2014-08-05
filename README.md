# Gem ownership auditor

Anyone who is a gem 'owner' on [rubygems.org](https://rubygems.org) can
publish a new version of a gem.

When an employee leaves GDS, we are careful to make sure that their access our
production services and infrastructure is revoked.

As part of this process, we should ensure that they no longer have access to
publish gems which we actively use and manage. Although it's unlikely that
anyone would actually do anything malicious in practice, this seems like a
sensible and reasonable precaution.

Unfortunately there's not an easy way to manage this through the rubygems.org
user interface. The `gem` command line tool can list the owners of a
particular gem, and also manipulate gem owners, but doesn't have a way to
interrogate the rubygems API in other ways.

The `gem_ownership_auditor` tool attempts to solve this, by doing the
following:

* gets a list of gems owned by the 'govuk' user (https://rubygems.org/profiles/govuk)
* for each of those gems, lists the owners

it prints out a summary showing the owners and a list of the gems that they
own.

You can then revoke ownership of a gem for users who should not have access
using:

```
gem owner --remove email@example.com gemname
```

## Installation/usage

We use bundler to manage dependencies, so after cloning, do:

```
$ bundle install
$ bundle exec ./gem_ownership_auditor.rb
```
