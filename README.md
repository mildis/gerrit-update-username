# Gerrit scripts to update username
## usage
```
$ git clone All-Users.git
$ cd All-Users
$ git fetch origin refs/meta/external-ids:refs/origins/meta/external-ids
$ git checkout FETCH_HEAD
#
# scripts should be outside the repo
#
# to update username based on a LDAP attribute
$ ../update-ldap-username-attribute.sh sAMAccountName employeeID
#
# OR
#
# to update a username knowing the old and the new one
$ ../update-username.sh larry lana
```

`update-ldap-username-attribute.sh` calls `update-username.sh` so don't do it twice.

At the end of the process, review the changes then commit and push
```
$ git commit -m 'update users for new org'
$ git push origin HEAD:refs/meta/external-ids
```

If gerrit accepted your changes, flush the caches and tou are done
```
$ ssh -p 29418 gerrit.example.com gerrit flush-caches --all
```