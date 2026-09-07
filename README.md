
## Module organization

Import `Tagged` to use the core API, including the protocols and operations formerly supplied by separate modules. It re-exports `Carrier`. Dependency exports live in `Sources/Tagged/exports.swift`.

Import `Tagged_Standard_Library_Integration` for standard-library integration APIs.

`Tagged Test Support` lives in `Tests/Support`. Foundation integration can be added as `Tagged Foundation Integration` when needed.
