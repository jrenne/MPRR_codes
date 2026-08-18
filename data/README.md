# Data files used by the companion book code

This directory contains only public, book-specific material. Reusable datasets
that belong to the `DTAM` package are documented and distributed through that
package. Licensed or otherwise restricted inputs are kept locally in the
Git-ignored `private_data/` directory and are not part of this repository.

## `ta-us-treasury-sifma.xlsx`

Source workbook for the Treasury issuance and outstanding-debt example in
Chapter 3. The code uses the `Issuance` and `Outstanding` sheets. The workbook
was downloaded from SIFMA Research's U.S. Treasury Securities Statistics page:

<https://www.sifma.org/research/statistics/us-treasury-securities-statistics>

The workbook identifies the underlying sources for the series used in the book
as the U.S. Department of the Treasury and the Bureau of the Fiscal Service.
Users should cite SIFMA and the underlying source and check SIFMA's current
website terms before redistributing the workbook or using it commercially.

## `Futures_extraction_template.xlsx`

A blank workbook supplied to help readers reconstruct the natural-gas futures
panel used in Chapter 8 if they have authorized access to the relevant data
provider. It contains dates, contract headers, and metadata, but no licensed
settlement-price observations.

The populated futures data are not distributed. They remain in the local
`private_data/` directory and are used only to regenerate the book figures.
The same rule applies to the Moody's/S&P credit data used in Chapter 10.
