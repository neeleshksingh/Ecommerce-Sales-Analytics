# Limitations and productionization

## Current limitations

- Full destructive rebuild only; no incremental/high-water-mark processing.
- Full-pipeline bootstrap order is defective: it connects to/resets `DB_NAME` before attempting create-if-absent setup.
- No scheduler, orchestration service, CI/CD, unit/integration tests, retries, lineage, or monitoring.
- Credentials and full URL are printed; secrets are interpolated without URL encoding.
- pandas loads entire CSVs and inserts through `to_sql`; the million-row geolocation load is a likely bottleneck versus PostgreSQL COPY/chunking.
- AUTOCOMMIT leaves earlier stages committed after later failure.
- Validation is observational and incomplete.
- Functions/procedures are not deployed by the pipeline; live database state has drifted from repository definitions.
- Standard views are recomputed and mixed-grain; there are no materialized views or semantic contracts.
- Power BI, processed file output, and versioned business results are absent.
- Source data ends in 2018; `CURRENT_DATE` recency is unsuitable for stable historical segmentation.

## Performance considerations

Implemented optimization includes PK indexes plus explicit FK, lookup, and composite indexes. Potential costs remain: full DataFrame loads, repeated multi-table aggregation, window sorts, standard-view recomputation, and a correlated product/category maximum query that exceeded an 8-second audit timeout. Several composite indexes overlap leading columns of simpler indexes; actual benefit/overhead requires `EXPLAIN (ANALYZE, BUFFERS)` evidence.

## Productionization sequence

1. Remove secret logging; validate/encode configuration and use least-privilege roles.
2. Separate environment/database provisioning from a non-destructive load; introduce staging and atomic publish/swap.
3. Add explicit types, COPY/chunking, manifests, checksums, row reconciliation, and assertion failures.
4. Add migrations and deploy all views/functions/procedures consistently.
5. Fix query defects and add automated semantic/regression tests.
6. Add orchestration, observability, lineage, backup/recovery, and CI/CD.
7. Define and version the Power BI semantic model and refresh SLA.
