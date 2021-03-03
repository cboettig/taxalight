# taxalight 0.1.3

* patch for Solaris

# taxalight 0.1.2

* Added a `NEWS.md` file to track changes to the package.
* stricter matching criteria for get_ids():
  - if unique acceptedNameUsageID is found, go with that.
  - if multiples, drop subspecies, test for uniqueness
  - if one name is acceptedName, go with that.
  - otherwise, return NA

