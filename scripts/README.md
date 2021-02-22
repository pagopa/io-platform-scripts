# io-platform-scripts

A useful group of scripts to maximize the management of several pagopa's repo together

## add-file-to-repo

### Prerequisites

- Having _hub_ command installed
- Setup _hub_ config file with _username_ and _Github Personal Access Token_ like this:

```bash
    echo "github.com:
          - user: <github username>
            oauth_token: <github token>" > ~/.config/hub
```

### Example

#### One project

```bash
add-file-to-repo.sh io-functions-app .devops/yarn-lock-upgrade.yml io/io-functions-test-deploy . test-branch "Test PR Title" "Test PR Description"
```

#### Multiple projects

```bash
echo "io-functions-test-deploy\nio-functions-template" | xargs -I{} ./scripts/add-file-to-repo.sh {}  .devops/yarn-lock-upgrade.yml io/io-functions-test-deploy . test-branch "Test PR Title" "Test PR Description" 
```

## 2) remove-file-from-repo

### Prerequisites

Same as ['add-file-to-repo'](#add-file-to-repo)

### Example

#### One project

```bash
remove-file-from-repo.sh io-functions-app  yarn-lock-upgrade.yml .devops test-branch "Test PR Title" "Test PR Description"
```

#### Multiple projects

```bash
echo "io-functions-test-deploy\io-functions-template" | xargs -I{} ./scripts/remove-file-from-repo {}  yarn-lock-upgrade.yml .devops test-branch "Test PR Title" "Test PR Description" 
```
