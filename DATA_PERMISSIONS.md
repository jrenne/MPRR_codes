# Rights and data notice

The MIT Licence in this repository applies only to original source code. It
does not relicense manuscript text, book excerpts, rendered figures, datasets,
provider templates, or third-party material.

## Public book-specific files

- `data/Treasury_HQM_TNC_20Y.xlsx` contains source and calculation material
  based on U.S. Treasury data. Source links and transformations are documented
  in `data/README.md`.
- `data/FederalReserve_HQM_CreditLossProxy.xlsx` contains source and
  calculation material based on Federal Reserve Board data. Source links and
  transformations are documented in `data/README.md`.
- `data/Futures_extraction_template.xlsx` is a blank reconstruction template.
  It contains no licensed settlement-price observations.

Each third-party source remains subject to its own terms. Inclusion of source
information in this repository does not place that material under the MIT
Licence or grant permissions belonging to the original provider.

## Restricted inputs

Restricted inputs used to generate some figures are kept locally in the
Git-ignored `private_data/` directory and are not distributed. These include:

- the SIFMA Treasury-statistics workbook used for the issuance and
  outstanding-debt example; and
- natural-gas futures observations obtained through licensed LSEG Workspace
  and Datastream access.

On 20 August 2026, an LSEG account manager confirmed in writing that the
natural-gas futures chart identified in the request may appear in the book and
on its public companion website, provided that the chart displays a clear and
visible source. The chart therefore carries the wording "Source: LSEG
Datastream via LSEG Workspace." This confirmation does not authorize
redistribution of the underlying observations, which remain private and are
not included in this repository or in DTAM.

Readers should obtain these inputs from their original provider under terms
applicable to their own access. Source pages are linked at the relevant point
in the Bookdown and in `data/README.md`.

## DTAM datasets

Reusable datasets supplied by the companion DTAM package are governed by the
source-specific notices distributed with that package:

<https://github.com/jrenne/DTAM>
