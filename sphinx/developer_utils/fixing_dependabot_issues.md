## Dependabot Issues

Dependabot will identify the problematic library, and give the minimal version of the library that is need to resolve the security vulnerability.

Dependabot will describe the security vulnerability that has been found in the dependency.  It provide the urgentcy of the vulnerability, like 'critical', 'high', and 'moderate'.  Critical vulnerabilities need to be resolved as soon as possible, usually by the next Specify release.

## Upgrading Dependencies

### Upgrading a front-end javascript/typescript library with npm

Use the `npm ls` to check out the versions and dependency chains of a library.  Here's an example
```bash
npm ls loader-utils
specify7-frontend@1.0.0 /Users/username/git/specify7/specifyweb/frontend/js_src
├─┬ babel-loader@8.2.5
│ └── loader-utils@2.0.2
├── loader-utils@3.2.1
└─┬ worker-loader@3.0.8
  └── loader-utils@2.0.0
```

After editing the package.json, run `npm i` to update the package-lock.json file.

Upgrade the dependencies as needed to prevent older versions of libraries with security vulnerabilities.

Usually, it is best to upgrade the library to the minimum version of the library that is compliant with the vulnerability fix.  This minimize the risk of the upgrade making breaking changes to the code.

For indirect dependencies that need upgraded, an override of the version might be needed to be made in the package.json file.

After verifying that all unit tests have passed, do some general testing to ensure there are no breaking changes.  Try searching the codebase to see where the library is used in order to focus testing on use cases that are more likely to be affected.

### Upgrading a back-end python library

Similar to the process of upgrading a front-end dependency.  Upgrade the problematic library in the `requirements.txt` file.

Once the requirements have been changed, run `docker compose up --build` to rebuild the project.  Make sure that the project builds without any errors and that all unit tests have passed.  Then, general testing can be done to ensure no breaking changes have been made.

Most upgrades can be straight forward, but complications can arise when one upgrade necessitates other library upgrades.
