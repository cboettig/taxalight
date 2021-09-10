# taxalight 0.1.5

* `get_ids` example in docs now uses "itis_test" data, not full ITIS

# taxalight 0.1.4

* CRAN reports `thor` fails to access LMDB database on Mac's M1 (arm-based)
  architectures.  For now, skip testing on CRAN until issue is resolved in `thor`.

# taxalight 0.1.3

* patch for Solaris

# taxalight 0.1.2

* Added a `NEWS.md` file to track changes to the package.
* stricter matching criteria for get_ids():
  - if unique acceptedNameUsageID is found, go with that.
  - if multiples, drop subspecies, test for uniqueness
  - if one name is acceptedName, go with that.
  - otherwise, return NA

