# repository-importer

Script to get all archival records for a repository and build an importable JSON file.

## Version

It is recommended that source and target instances of ArchivesSpace use the same version.

Currently tested version: v2.4.1.

## Export usage:

```bash
./export.sh <source backend URL> <source repo id> <username> <password>
```

## Import usage:

```bash
./import.sh <target backend URL> <target repo id> <username> <password> <file to import>
```

---
