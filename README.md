# RT-Extension-FormValidator

An RT extension to perform customizable form validation

## Installation

Run the following commands:

```bash
perl Makefile.PL
make
make test # Optional. Runs the extension tests.
make install
```

## Configuration

This extension reads JSON configuration files from a directory configured in `$form_validator_rules_dir`.

It iterates every file in the directory (not recursively!) and tries to load the rules in them.

If the file contains only a single rule object, it will be appended to the loaded ruleset. If the file is an array of rules, all of them are appended to the ruleset.
