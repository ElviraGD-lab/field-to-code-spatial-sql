# Data passport

Small files that the lessons load are stored in this folder. Larger datasets are not stored here: they will be published as an open **data package** on Zenodo, with a DOI. This file says, for every dataset the book uses, where it comes from, under which licence, when it was prepared and how to get it again.

The working coordinate system of the book is **ETRS89 / UTM zone 30N (EPSG:25830)**.

Status of each entry: **checked** (source, licence and file verified) or **to check** (to be verified before the first lesson that uses it).

| Dataset | Source | Licence and attribution | Downloaded | Chapters | Status |
|---|---|---|---|---|---|
| Towers, spans and lines of the 400 kV corridor at the Pajares pass (33 towers, 34 spans, 5 line sections) | Pajares project: OpenStreetMap topology, positions checked on PNOA orthophoto and LiDAR | contains information from OpenStreetMap, © OpenStreetMap contributors, available under the Open Database Licence (ODbL 1.0); heights and slopes derived from PNOA LiDAR and MDT02 «PNOA cedido por © Instituto Geográfico Nacional» (CC BY 4.0) | 2026-10-17 | 2– | checked |

## Files in this folder

### `towers.csv` — towers of the 400 kV lines (lesson 2.2)

33 rows, one per tower; comma-separated, first row = column names; UTF-8.

| Column | Type | Meaning |
|---|---|---|
| `label` | text | tower label, e.g. N01; unique |
| `lines` | text | line(s) the tower belongs to (N, A, B, C, S); junction towers list several, e.g. `N,A,B,C` |
| `x`, `y` | numeric | ETRS89 / UTM zone 30N (EPSG:25830), metres |
| `ground_z_m` | numeric | ground elevation at the tower base from MDT02, m |
| `height_m` | numeric | tower height from the PNOA LiDAR normalised surface model, m |
| `slope_deg` | numeric | terrain slope at the tower, degrees |
| `anchor_candidate` | boolean | `true` if the tower may be an anchor (dead-end) tower, e.g. at a bend of the line |

Prepared from the Pajares project file `powerline_reference_east400_towers.csv` (2026-10-17): 8 of its 28 columns, renamed. Licence of this file: **ODbL 1.0** (it contains information from OpenStreetMap). Attribution: © OpenStreetMap contributors; «PNOA cedido por © Instituto Geográfico Nacional».
