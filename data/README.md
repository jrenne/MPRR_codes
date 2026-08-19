# Data files used by the companion book code

This directory contains only public, book-specific material. Reusable datasets
that belong to the `DTAM` package are documented and distributed through that
package. Licensed or otherwise restricted inputs are kept locally in the
Git-ignored `private_data/` directory and are not part of this repository.

## `ta-us-treasury-sifma.xlsx`

Source workbook for the Treasury issuance and outstanding-debt example in
Chapter 3. The code uses the `Issuance` and `Outstanding` sheets. The workbook
was downloaded from SIFMA Research's U.S. Treasury Securities Statistics page:

<https://www.sifma.org/research/statistics/us-fixed-income-securities-statistics>

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
The licensed source services are [LSEG Workspace](https://www.lseg.com/en/data-analytics/products/workspace/data-and-content)
and [Datastream](https://www.lseg.com/en/data-analytics/products/datastream-macroeconomic-analysis).

## `Treasury_HQM_TNC_20Y.xlsx`

Source and calculation workbook for the 20-year corporate credit-spread example in
Chapter 10. The spread is the annual average of the U.S. Treasury's monthly
average 20-year High Quality Market (HQM) corporate spot rate minus the matched
20-year Treasury Nominal Coupon-Issue (TNC) spot rate. Both components therefore
have the same maturity and yield-curve convention as the 20-year model bond.

The workbook retains the monthly observations, formula-derived annual averages,
source-file identifiers, source URLs, and a completeness check. The book uses
1986--2024.

Sources:

- [HQM corporate-bond yield curve](https://home.treasury.gov/data/treasury-coupon-issues-and-corporate-bond-yield-curve/corporate-bond-yield-curve)
- [TNC Treasury yield curve](https://home.treasury.gov/data/treasury-coupon-issues-and-corporate-bond-yield-curves/treasury-coupon-issues)

## `FederalReserve_HQM_CreditLossProxy.xlsx`

Source and calculation workbook for the credit-loss indicator used alongside
the 20-year spread in Chapter 10. It contains the Federal Reserve Board's
quarterly, seasonally adjusted, annualized net charge-off rate on business
loans at all commercial banks (`CORBLACBS`) from 1985 through 2024.

The workbook derives annual averages and normalizes their 1986--2024 time
profile so that the mean expected loss equals 3.54 basis points. This benchmark
is the equal-weight average of the 7--10-year expected losses reported by Amato
and Remolona (2003, Table 1) for AAA-, AA-, and A-rated U.S. corporate bonds.
With the chapter's 60% recovery rate, the calibrated expected loss is converted
to the physical default-intensity indicator used by the model. All derived
columns and validation checks are formula-driven.

Sources:

- [Federal Reserve charge-off and delinquency release](https://www.federalreserve.gov/releases/chargeoff/)
- [Federal Reserve series `CORBLACBS`](https://fred.stlouisfed.org/series/CORBLACBS)
- [Amato and Remolona (2003), "The credit spread puzzle"](https://www.bis.org/publ/qtrpdf/r_qt0312e.pdf)
