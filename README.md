
<!-- README.md is generated from README.Rmd. Please edit that file -->

# taxalight :zap: :zap:

<!-- badges: start -->

[![R build
status](https://github.com/cboettig/taxalight/workflows/R-CMD-check/badge.svg)](https://github.com/cboettig/taxalight/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/taxalight)](https://CRAN.R-project.org/package=taxalight)
<!-- badges: end -->

`taxalight` provides a lightweight, lightning fast query for resolving
taxonomic identifiers to taxonomic names, and vice versa, by using a
Lightning Memory Mapped Database backend.

## Installation

You can install the released version of taxalight from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("taxalight")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cboettig/taxalight")
```

## Quickstart

`taxalight` needs to first download and import the provider naming
databases. This can take a while, but needs to only be done once.

``` r
library(taxalight)
tl_create("itis")
#> Loading required namespace: vroom
```

Now we can look up species by names, IDs, or both at once:

``` r
tl("Homo sapiens")
#>       taxonID scientificName acceptedNameUsageID taxonomicStatus taxonRank
#> 1 ITIS:180092   Homo sapiens         ITIS:180092        accepted   species
#>    kingdom   phylum    class    order    family genus specificEpithet
#> 1 Animalia Chordata Mammalia Primates Hominidae  Homo         sapiens
#>   infraspecificEpithet vernacularName
#> 1                                 man
```

``` r
id <- c("ITIS:180092", "ITIS:179913", "Dendrocygna autumnalis")
tl(id)
#>       taxonID         scientificName acceptedNameUsageID taxonomicStatus
#> 1 ITIS:180092           Homo sapiens         ITIS:180092        accepted
#> 2 ITIS:179913               Mammalia         ITIS:179913        accepted
#> 3 ITIS:175044 Dendrocygna autumnalis         ITIS:175044        accepted
#>   taxonRank  kingdom   phylum    class        order    family       genus
#> 1   species Animalia Chordata Mammalia     Primates Hominidae        Homo
#> 2     class     <NA>     <NA>     <NA>         <NA>      <NA>        <NA>
#> 3   species Animalia Chordata     Aves Anseriformes  Anatidae Dendrocygna
#>   specificEpithet infraspecificEpithet               vernacularName
#> 1         sapiens                                               man
#> 2                                                           mammals
#> 3      autumnalis                      Black-bellied Whistling-Duck
```

For convenience, we can request just the name or id as a character
vector (paralleling functionality in `taxize`):

``` r
get_ids("Homo sapiens")
#> [1] "ITIS:180092"
```

``` r
get_names("ITIS:179913")
#> [1] "Mammalia"
```

## A provenance-backed data import

Under the hood, `taxalight` consumes a [DCAT2/PROV-O based
description](%22https://raw.githubusercontent.com/boettiger-lab/taxadb-cache/master/prov.json%22)
of the data provenance which generates the standard-format tables
imported by `taxalight` (and `taxadb`) from the original data published
by the naming providers. All data and scripts are identified by
content-based identifiers, which can be resolved by
<https://hash-archive.org> or the R package, `contentid`. This provides
several benefits over resolving data from a URL source:

1.  We have cryptographic certainty that we get the expected bytes every
    time
2.  We can automatically cache and reference a local copy. If the hash
    matches the requested identifier, then we don’t even need to check
    eTags or other indications that the version we have already is the
    right one.
3.  By registering multiple sources, the data can remain accessible even
    if one link rots away.

Input data and scripts for transforming the data into the desired format
are similarly archived and referenced by content identifiers in the
provenance trace.
