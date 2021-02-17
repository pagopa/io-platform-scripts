# io-platform-scripts

A useful group of scripts to maximize the management of several pagopa's repo together

## Prerequisites

- Updating the list of repository we want to update under _io-functions-list.txt_
- Having _hub_ command installed
- Setup _hub_ config file with _username_ and _Github Personal Access Token_ like this:

```bash
    echo "github.com:
          - user: <github username>
            oauth_token: <github token>" > ~/.config/hub
```

## Scripts

### copy-file-from-template-to-all-functions

Script used to copy one or more files from _io-functions-template_ to all the repos contained into _io-funtctions-list.txt_ and make a PR each

### remove-file-from-all-repo

Script used to remove one or more files from all the repos contained into _io-functions-list.txt_ and make a PR each

### update-all-package-names-with-org

One-time only script to update the package name with "@pagopa/" prefix for all repos contained into _io-functions-list.txt_ and make a PR each
