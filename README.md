
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
Lightning Memory Mapped Database backend. Compared to `taxadb`, it has
few dependencies, fewer functions, and faster performance.

If you just need to resolve scientific names to identifiers and vice
versa, `taxalight` is a fast and simple option. `taxalight` currently
supports names from Integrated Taxonomic Information System (ITIS),
National Center for Biotechnology Information (NCBI), Global
Biodiversity Information Facility (GBIF), Catalogue of Life (COL), and
Open Tree Taxonomy (OTT). Like `taxadb`, `taxalight` uses annual stable
version snapshots from these providers and presents the naming data in
the simple and consistent tabular format of the Darwin Core Standard.

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
#> 
```

Now we can look up species by names, IDs, or a mix. Even vernacular
names can be recognized as key. Note that only exact matches are
supported though! ITIS (`itis`) is the default provider, but GBIF, COL,
OTT, and NCBI are also available.

``` r
tl("Homo sapiens", provider = "itis")
#> # A tibble: 30 x 14
#>    taxonID   scientificName  acceptedNameUsag… taxonomicStatus taxonRank kingdom
#>    <chr>     <chr>           <chr>             <chr>           <chr>     <chr>  
#>  1 ITIS:944… Homo aethiopic… ITIS:180092       synonym         species   Animal…
#>  2 ITIS:944… Homo americanus ITIS:180092       synonym         species   Animal…
#>  3 ITIS:944… Homo arabicus   ITIS:180092       synonym         species   Animal…
#>  4 ITIS:944… Homo australas… ITIS:180092       synonym         species   Animal…
#>  5 ITIS:944… Homo cafer      ITIS:180092       synonym         species   Animal…
#>  6 ITIS:944… Homo capensis   ITIS:180092       synonym         species   Animal…
#>  7 ITIS:944… Homo columbicus ITIS:180092       synonym         species   Animal…
#>  8 ITIS:944… Homo drennani   ITIS:180092       synonym         species   Animal…
#>  9 ITIS:944… Homo grimaldii  ITIS:180092       synonym         species   Animal…
#> 10 ITIS:944… Homo hottentot… ITIS:180092       synonym         species   Animal…
#> # … with 20 more rows, and 8 more variables: phylum <chr>, class <chr>,
#> #   order <chr>, family <chr>, genus <chr>, specificEpithet <chr>,
#> #   infraspecificEpithet <lgl>, vernacularName <chr>
```

``` r
id <- c("ITIS:180092", "ITIS:179913", "Dendrocygna autumnalis", "Snow Goose",
        provider = "itis")
tl(id)
#> # A tibble: 6 x 14
#>   taxonID   scientificName    acceptedNameUsa… taxonomicStatus taxonRank kingdom
#>   <chr>     <chr>             <chr>            <chr>           <chr>     <chr>  
#> 1 ITIS:180… Homo sapiens      ITIS:180092      accepted        species   Animal…
#> 2 ITIS:179… Mammalia          ITIS:179913      accepted        class     <NA>   
#> 3 ITIS:175… Dendrocygna autu… ITIS:175044      accepted        species   Animal…
#> 4 ITIS:175… Anser caerulesce… ITIS:175038      synonym         species   Animal…
#> 5 ITIS:175… Anser hyperboreus ITIS:175038      synonym         species   Animal…
#> 6 ITIS:175… Chen caerulescens ITIS:175038      accepted        species   Animal…
#> # … with 8 more variables: phylum <chr>, class <chr>, order <chr>,
#> #   family <chr>, genus <chr>, specificEpithet <chr>,
#> #   infraspecificEpithet <lgl>, vernacularName <chr>
```

For convenience, we can request just the name or id as a character
vector (paralleling functionality in `taxize`). If the name is
recognized as an accepted name, the corresponding ID for the provider is
returned.

``` r
get_ids("Homo sapiens")
#>  Homo sapiens 
#> "ITIS:180092"
```

``` r
get_names("ITIS:179913")
#> [1] "Mammalia"
```

## Benchmarks

``` r
library(bench)
```

``` r
sp <- c("Dendrocygna autumnalis", "Dendrocygna bicolor",
        "Chen canagica",          "Chen caerulescens"     )
```

``` r
taxadb::td_create("itis", schema="dwc")
#> Registered S3 methods overwritten by 'readr':
#>   method           from 
#>   format.col_spec  vroom
#>   print.col_spec   vroom
#>   print.collector  vroom
#>   print.date_names vroom
#>   print.locale     vroom
#>   str.col_spec     vroom
#> Warning in overwrite_db(con, tablename): overwriting 2020_dwc_itis
#> Importing /home/cboettig/.local/share/R/contentid/data/ef/6a/ef6ae3b337be65c661d5e2d847613ebc955bb9d91d2d98d03cf8c53029cecc2a in 100000 line chunks:
#>  ...Done! (in 14.38502 secs)
```

``` r
bench::bench_time(
  df_tb <- taxadb::filter_name(sp, "itis")
)
#> process    real 
#>   2.81s   2.84s
df_tb
#> # A tibble: 4 x 17
#>    sort taxonID   scientificName     taxonRank acceptedNameUsag… taxonomicStatus
#>   <int> <chr>     <chr>              <chr>     <chr>             <chr>          
#> 1     1 ITIS:175… Dendrocygna autum… species   ITIS:175044       accepted       
#> 2     2 ITIS:175… Dendrocygna bicol… species   ITIS:175046       accepted       
#> 3     3 ITIS:175… Chen canagica      species   ITIS:175042       accepted       
#> 4     4 ITIS:175… Chen caerulescens  species   ITIS:175038       accepted       
#> # … with 11 more variables: update_date <chr>, kingdom <chr>, phylum <chr>,
#> #   class <chr>, order <chr>, family <chr>, genus <chr>, specificEpithet <chr>,
#> #   infraspecificEpithet <chr>, vernacularName <chr>, input <chr>
```

``` r
bench::bench_time(
  df_tl <- taxalight::tl(sp, "itis")
)
#> process    real 
#>  29.8ms  44.8ms
df_tl
#> # A tibble: 9 x 14
#>   taxonID  scientificName    acceptedNameUsag… taxonomicStatus taxonRank kingdom
#>   <chr>    <chr>             <chr>             <chr>           <chr>     <chr>  
#> 1 ITIS:17… Dendrocygna autu… ITIS:175044       accepted        species   Animal…
#> 2 ITIS:17… Dendrocygna bico… ITIS:175046       synonym         subspeci… Animal…
#> 3 ITIS:17… Dendrocygna bico… ITIS:175046       accepted        species   Animal…
#> 4 ITIS:17… Philacte canagica ITIS:175042       synonym         species   Animal…
#> 5 ITIS:17… Anser canagicus   ITIS:175042       synonym         species   Animal…
#> 6 ITIS:17… Chen canagica     ITIS:175042       accepted        species   Animal…
#> 7 ITIS:17… Anser caerulesce… ITIS:175038       synonym         species   Animal…
#> 8 ITIS:17… Anser hyperboreus ITIS:175038       synonym         species   Animal…
#> 9 ITIS:17… Chen caerulescens ITIS:175038       accepted        species   Animal…
#> # … with 8 more variables: phylum <chr>, class <chr>, order <chr>,
#> #   family <chr>, genus <chr>, specificEpithet <chr>,
#> #   infraspecificEpithet <lgl>, vernacularName <chr>
```

``` r
bench::bench_time(
  id_tb <- taxadb::get_ids(sp, "itis")
)
#> process    real 
#>   2.42s   2.54s
id_tb
#> Dendrocygna autumnalis    Dendrocygna bicolor          Chen canagica 
#>          "ITIS:175044"          "ITIS:175046"          "ITIS:175042" 
#>      Chen caerulescens 
#>          "ITIS:175038"
```

``` r
bench::bench_time(
  id_tl <- taxalight::get_ids(sp, "itis")
)
#> process    real 
#>  31.7ms    45ms
id_tl
#> Dendrocygna autumnalis    Dendrocygna bicolor          Chen canagica 
#>          "ITIS:175044"          "ITIS:175046"          "ITIS:175042" 
#>      Chen caerulescens 
#>          "ITIS:175038"
```

## A provenance-backed data import

Under the hood, `taxalight` consumes a [DCAT2/PROV-O based
description](https://raw.githubusercontent.com/boettiger-lab/taxadb-cache/master/prov.json)
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
