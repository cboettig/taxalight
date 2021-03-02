
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
#> 
```

Now we can look up species by names, IDs, or a mix. Even vernacular
names can be recognized as key. Note that only exact matches are
supported though\! ITIS (`itis`) is the default provider, but GBIF, COL,
OTT, and NCBI are also available.

``` r
tl("Homo sapiens", provider = "itis")
#>        taxonID                  scientificName acceptedNameUsageID
#> 1  ITIS:944513                Homo aethiopicus         ITIS:180092
#> 2  ITIS:944514                 Homo americanus         ITIS:180092
#> 3  ITIS:944515                   Homo arabicus         ITIS:180092
#> 4  ITIS:944516              Homo australasicus         ITIS:180092
#> 5  ITIS:944517                      Homo cafer         ITIS:180092
#> 6  ITIS:944518                   Homo capensis         ITIS:180092
#> 7  ITIS:944519                 Homo columbicus         ITIS:180092
#> 8  ITIS:944520                   Homo drennani         ITIS:180092
#> 9  ITIS:944521                  Homo grimaldii         ITIS:180092
#> 10 ITIS:944522                Homo hottentotus         ITIS:180092
#> 11 ITIS:944523                Homo hyperboreus         ITIS:180092
#> 12 ITIS:944524                    Homo indicus         ITIS:180092
#> 13 ITIS:944525                  Homo japeticus         ITIS:180092
#> 14 ITIS:944526                  Homo melaninus         ITIS:180092
#> 15 ITIS:944527                 Homo monstrosus         ITIS:180092
#> 16 ITIS:944528                Homo neptunianus         ITIS:180092
#> 17 ITIS:944529                 Homo palestinus         ITIS:180092
#> 18 ITIS:944530                  Homo patagonus         ITIS:180092
#> 19 ITIS:944531                    Homo priscus         ITIS:180092
#> 20 ITIS:944532                  Homo scythicus         ITIS:180092
#> 21 ITIS:944533                    Homo sinicus         ITIS:180092
#> 22 ITIS:944534                   Homo spelaeus         ITIS:180092
#> 23 ITIS:944535                Homo troglodytes         ITIS:180092
#> 24 ITIS:944536                Homo wadjakensis         ITIS:180092
#> 25 ITIS:945628    Homo sapiens cro-magnonensis         ITIS:180092
#> 26 ITIS:945629      Homo sapiens grimaldiensis         ITIS:180092
#> 27 ITIS:945630 Homo fossilis proto-aethiopicus         ITIS:180092
#> 28 ITIS:945728  Homo fossilis protoaethiopicus         ITIS:180092
#> 29 ITIS:945730     Homo sapiens cromagnonensis         ITIS:180092
#> 30 ITIS:180092                    Homo sapiens         ITIS:180092
#>    taxonomicStatus  taxonRank  kingdom   phylum    class    order    family
#> 1          synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 2          synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 3          synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 4          synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 5          synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 6          synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 7          synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 8          synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 9          synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 10         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 11         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 12         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 13         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 14         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 15         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 16         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 17         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 18         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 19         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 20         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 21         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 22         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 23         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 24         synonym    species Animalia Chordata Mammalia Primates Hominidae
#> 25         synonym subspecies Animalia Chordata Mammalia Primates Hominidae
#> 26         synonym subspecies Animalia Chordata Mammalia Primates Hominidae
#> 27         synonym subspecies Animalia Chordata Mammalia Primates Hominidae
#> 28         synonym subspecies Animalia Chordata Mammalia Primates Hominidae
#> 29         synonym subspecies Animalia Chordata Mammalia Primates Hominidae
#> 30        accepted    species Animalia Chordata Mammalia Primates Hominidae
#>    genus specificEpithet infraspecificEpithet vernacularName
#> 1   Homo         sapiens                   NA            man
#> 2   Homo         sapiens                   NA            man
#> 3   Homo         sapiens                   NA            man
#> 4   Homo         sapiens                   NA            man
#> 5   Homo         sapiens                   NA            man
#> 6   Homo         sapiens                   NA            man
#> 7   Homo         sapiens                   NA            man
#> 8   Homo         sapiens                   NA            man
#> 9   Homo         sapiens                   NA            man
#> 10  Homo         sapiens                   NA            man
#> 11  Homo         sapiens                   NA            man
#> 12  Homo         sapiens                   NA            man
#> 13  Homo         sapiens                   NA            man
#> 14  Homo         sapiens                   NA            man
#> 15  Homo         sapiens                   NA            man
#> 16  Homo         sapiens                   NA            man
#> 17  Homo         sapiens                   NA            man
#> 18  Homo         sapiens                   NA            man
#> 19  Homo         sapiens                   NA            man
#> 20  Homo         sapiens                   NA            man
#> 21  Homo         sapiens                   NA            man
#> 22  Homo         sapiens                   NA            man
#> 23  Homo         sapiens                   NA            man
#> 24  Homo         sapiens                   NA            man
#> 25  Homo         sapiens                   NA            man
#> 26  Homo         sapiens                   NA            man
#> 27  Homo         sapiens                   NA            man
#> 28  Homo         sapiens                   NA            man
#> 29  Homo         sapiens                   NA            man
#> 30  Homo         sapiens                   NA            man
```

``` r
id <- c("ITIS:180092", "ITIS:179913", "Dendrocygna autumnalis", "Snow Goose",
        provider = "itis")
tl(id)
#>        taxonID         scientificName acceptedNameUsageID taxonomicStatus
#> 1  ITIS:180092           Homo sapiens         ITIS:180092        accepted
#> 4  ITIS:179913               Mammalia         ITIS:179913        accepted
#> 7  ITIS:175044 Dendrocygna autumnalis         ITIS:175044        accepted
#> 13 ITIS:175029     Anser caerulescens         ITIS:175038         synonym
#> 14 ITIS:175030      Anser hyperboreus         ITIS:175038         synonym
#> 15 ITIS:175038      Chen caerulescens         ITIS:175038        accepted
#>    taxonRank  kingdom   phylum    class        order    family       genus
#> 1    species Animalia Chordata Mammalia     Primates Hominidae        Homo
#> 4      class     <NA>     <NA>     <NA>         <NA>      <NA>        <NA>
#> 7    species Animalia Chordata     Aves Anseriformes  Anatidae Dendrocygna
#> 13   species Animalia Chordata     Aves Anseriformes  Anatidae        Chen
#> 14   species Animalia Chordata     Aves Anseriformes  Anatidae        Chen
#> 15   species Animalia Chordata     Aves Anseriformes  Anatidae        Chen
#>    specificEpithet infraspecificEpithet               vernacularName
#> 1          sapiens                   NA                          man
#> 4                                    NA                      mammals
#> 7       autumnalis                   NA Black-bellied Whistling-Duck
#> 13    caerulescens                   NA                   Snow Goose
#> 14    caerulescens                   NA                   Snow Goose
#> 15    caerulescens                   NA                   Snow Goose
```

For convenience, we can request just the name or id as a character
vector (paralleling functionality in `taxize`). If the name is
recognized as an accepted name, the corresponding ID for the provider is
returned.

``` r
get_ids("Homo sapiens")
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
#> Importing /home/cboettig/.local/share/R/contentid/sha256/ef/6a/ef6ae3b337be65c661d5e2d847613ebc955bb9d91d2d98d03cf8c53029cecc2a in 100000 line chunks:
#>  ...Done! (in 13.0536 secs)
```

``` r
bench::bench_time(
  df_tb <- taxadb::filter_name(sp, "itis")
)
#> process    real 
#>   3.91s   3.93s
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
#>  29.3ms  44.4ms
df_tl
#>        taxonID            scientificName acceptedNameUsageID taxonomicStatus
#> 1  ITIS:175044    Dendrocygna autumnalis         ITIS:175044        accepted
#> 7  ITIS:175047 Dendrocygna bicolor helva         ITIS:175046         synonym
#> 8  ITIS:175046       Dendrocygna bicolor         ITIS:175046        accepted
#> 16 ITIS:175018         Philacte canagica         ITIS:175042         synonym
#> 17 ITIS:175031           Anser canagicus         ITIS:175042         synonym
#> 18 ITIS:175042             Chen canagica         ITIS:175042        accepted
#> 28 ITIS:175029        Anser caerulescens         ITIS:175038         synonym
#> 29 ITIS:175030         Anser hyperboreus         ITIS:175038         synonym
#> 30 ITIS:175038         Chen caerulescens         ITIS:175038        accepted
#>     taxonRank  kingdom   phylum class        order   family       genus
#> 1     species Animalia Chordata  Aves Anseriformes Anatidae Dendrocygna
#> 7  subspecies Animalia Chordata  Aves Anseriformes Anatidae Dendrocygna
#> 8     species Animalia Chordata  Aves Anseriformes Anatidae Dendrocygna
#> 16    species Animalia Chordata  Aves Anseriformes Anatidae        Chen
#> 17    species Animalia Chordata  Aves Anseriformes Anatidae        Chen
#> 18    species Animalia Chordata  Aves Anseriformes Anatidae        Chen
#> 28    species Animalia Chordata  Aves Anseriformes Anatidae        Chen
#> 29    species Animalia Chordata  Aves Anseriformes Anatidae        Chen
#> 30    species Animalia Chordata  Aves Anseriformes Anatidae        Chen
#>    specificEpithet infraspecificEpithet               vernacularName
#> 1       autumnalis                   NA Black-bellied Whistling-Duck
#> 7          bicolor                   NA       Fulvous Whistling-Duck
#> 8          bicolor                   NA       Fulvous Whistling-Duck
#> 16        canagica                   NA                Emperor Goose
#> 17        canagica                   NA                Emperor Goose
#> 18        canagica                   NA                Emperor Goose
#> 28    caerulescens                   NA                   Snow Goose
#> 29    caerulescens                   NA                   Snow Goose
#> 30    caerulescens                   NA                   Snow Goose
```

``` r
bench::bench_time(
  id_tb <- taxadb::get_ids(sp, "itis")
)
#> process    real 
#>   2.19s   2.21s
id_tb
#> [1] "ITIS:175044" "ITIS:175046" "ITIS:175042" "ITIS:175038"
```

``` r
bench::bench_time(
  id_tl <- taxalight::get_ids(sp, "itis")
)
#> process    real 
#>  25.6ms    38ms
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

``` r
tl_provenance()
#>                                                                                id
#> 4  hash://sha256/1ee9c0158dfe19f613583b0c7b17ac36fe6a30e5177392996b37a9ba71f9fa2c
#> 5  hash://sha256/25090de609b2d01bd27280bc6ff5f67db47757cca5db0306c9718e6343233ff6
#> 7  hash://sha256/2c5e65f240a23e2fc32240dd3144cdf2d1d0c9dcb5568c467cc3f94772abcb72
#> 8  hash://sha256/2fba4f4abbbeb3a748bdc1047b59d88ebd8dddbf3cf0f3a5fcbd48c8877fed54
#> 9  hash://sha256/30516362af0a394a7a78677ae129a95101cb852bda20ad872ae042ced43c463c
#> 10 hash://sha256/3399516b5281ca295e64540c1198e244a9b71e9fa914be23be069ca601121b37
#> 12 hash://sha256/3e478c6eec1fb7a1b131529f847a50d8e48a8bf7b08a1b8f11f6d0cbaac1c882
#> 15 hash://sha256/598c626c6087369d0ed3c49b3c1092435a02df247038989ed12071a1c17a0549
#> 19 hash://sha256/85455c919650c46864c4dd04be43c8b1b08994ace82c4805871dfe20b5ab5cd3
#> 20 hash://sha256/8ce38e4d537a1ce50f8f9b32577df29012eaf0c84eccb28c6e9eafbe0e00d190
#> 22 hash://sha256/9912ae9f4db075d73b0d23c4bc299078c16aca87cf72baabca3ec5b4ae6ab590
#> 23 hash://sha256/9b9f18d604fa9a245feb39bbc0e9529fdcc488e9f113132c65c9eca90ce93f51
#> 24 hash://sha256/9bc29db0ce5e2695727fc5f894ef0681b766ccc9c813071cdd1bc8b4921ec110
#> 25 hash://sha256/ae83e52e3492fb806da9b7d5c360da7cf822d0843bdd7f976b996decc1ae9571
#> 26 hash://sha256/ae9948252e798b9879144b84b521f88de3677cf0308b92283e75385a9c487ea3
#> 27 hash://sha256/afbe371055cd7c42c73ac7bb07bd265300683d4a7ae038fe7e473778a5d0dfcc
#> 28 hash://sha256/b2dc25d2999093649656662c8141af84e6a2355ee0eceb4413251319ca7d76bc
#> 29 hash://sha256/b31ed646287eb2c73eaebd3fed8fd7b24b1df7eb6e5c6eb6dcf2d3a93d43536d
#> 30 hash://sha256/b42ce79bbebc3224a5e7a288333947b0f2d685fa84347e455a8ee7c03c7a14e0
#> 31 hash://sha256/b6884a113d8aafda1b3c89e32172218c63504d65d35442bb718d8a1a62704c77
#> 32 hash://sha256/b73e81c37d3c5b624d183192fdbfdcaeaeef396dd0e13d3533ff2d21eb02190e
#> 33 hash://sha256/bc63094c83d8dfa4bffa2c9d0487ff1a95952ad7e8a6eb252fb93e4f1e590fcb
#> 36 hash://sha256/cd1cf5f20154aaa171c8ecfa53e4486a340d540ca8bda0e8cd899cbc9275f628
#> 40 hash://sha256/d91b51013b669a31fd268743cf2db866b0f3e7a7f1af78e60271fa5f137bd21e
#> 41 hash://sha256/d9ba565ef177af1eb4471d6bc82f2b270cc92bc779ce711f05bda2923d4e5518
#> 42 hash://sha256/e3fa608785c5cd9dbb50d0cd4ed07486639b2c57a71246dd8a6fb22bf8c10425
#> 43 hash://sha256/e4f2a2e78c33febd546cc20e60f95595476f39db86f7662aeb314bc7695686a7
#> 46 hash://sha256/ef6ae3b337be65c661d5e2d847613ebc955bb9d91d2d98d03cf8c53029cecc2a
#> 47 hash://sha256/fa9c8d2a3030d6a43878110d459868d7b36e2e2bc8a9a59850ca33d36cc19899
#>                  title wasGeneratedAtTime compressFormat version      series
#> 4   common_gbif.tsv.gz         2020-09-14           gzip    2020 common_gbif
#> 5      dwc_slb.tsv.bz2         2019-12-01            bz2    2019     dwc_slb
#> 7      dwc_col.tsv.bz2         2019-12-01            bz2    2019     dwc_col
#> 8       dwc_wd.tsv.bz2         2019-12-01            bz2    2019      dwc_wd
#> 9  common_iucn.tsv.bz2         2019-12-01            bz2    2019 common_iucn
#> 10     dwc_ott.tsv.bz2         2019-12-01            bz2    2019     dwc_ott
#> 12     dwc_ncbi.tsv.gz         2020-09-14           gzip    2020    dwc_ncbi
#> 15    dwc_ncbi.tsv.bz2         2019-12-01            bz2    2019    dwc_ncbi
#> 19      dwc_col.tsv.gz         2020-09-14           gzip    2020     dwc_col
#> 20  common_slb.tsv.bz2         2019-12-01            bz2    2019  common_slb
#> 22      dwc_ott.tsv.gz         2020-09-14           gzip    2020     dwc_ott
#> 23    dwc_gbif.tsv.bz2         2019-12-01            bz2    2019    dwc_gbif
#> 24    dwc_itis.tsv.bz2         2019-12-01            bz2    2019    dwc_itis
#> 25  common_itis.tsv.gz         2020-09-15           gzip    2020 common_itis
#> 26   common_col.tsv.gz         2020-09-14           gzip    2020  common_col
#> 27     dwc_tpl.tsv.bz2         2019-12-01            bz2    2019     dwc_tpl
#> 28 common_gbif.tsv.bz2         2019-12-01            bz2    2019 common_gbif
#> 29     dwc_ncbi.tsv.gz         2020-09-25           gzip    2020    dwc_ncbi
#> 30 common_ncbi.tsv.bz2         2019-12-01            bz2    2019 common_ncbi
#> 31  common_ncbi.tsv.gz         2020-09-25           gzip    2020 common_ncbi
#> 32   common_fb.tsv.bz2         2019-12-01            bz2    2019   common_fb
#> 33 common_itis.tsv.bz2         2019-12-01            bz2    2019 common_itis
#> 36     dwc_ncbi.tsv.gz         2020-09-14           gzip    2020    dwc_ncbi
#> 40    dwc_iucn.tsv.bz2         2019-12-01            bz2    2019    dwc_iucn
#> 41      dwc_fb.tsv.bz2         2019-12-01            bz2    2019      dwc_fb
#> 42  common_col.tsv.bz2         2019-12-01            bz2    2019  common_col
#> 43  common_ncbi.tsv.gz         2020-09-14           gzip    2020 common_ncbi
#> 46     dwc_itis.tsv.gz         2020-09-15           gzip    2020    dwc_itis
#> 47     dwc_gbif.tsv.gz         2020-09-14           gzip    2020    dwc_gbif
#>                 key
#> 4  2020_common_gbif
#> 5      2019_dwc_slb
#> 7      2019_dwc_col
#> 8       2019_dwc_wd
#> 9  2019_common_iucn
#> 10     2019_dwc_ott
#> 12    2020_dwc_ncbi
#> 15    2019_dwc_ncbi
#> 19     2020_dwc_col
#> 20  2019_common_slb
#> 22     2020_dwc_ott
#> 23    2019_dwc_gbif
#> 24    2019_dwc_itis
#> 25 2020_common_itis
#> 26  2020_common_col
#> 27     2019_dwc_tpl
#> 28 2019_common_gbif
#> 29    2020_dwc_ncbi
#> 30 2019_common_ncbi
#> 31 2020_common_ncbi
#> 32   2019_common_fb
#> 33 2019_common_itis
#> 36    2020_dwc_ncbi
#> 40    2019_dwc_iucn
#> 41      2019_dwc_fb
#> 42  2019_common_col
#> 43 2020_common_ncbi
#> 46    2020_dwc_itis
#> 47    2020_dwc_gbif
```
