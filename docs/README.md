# Technical documentation

This is the canonical technical reference. Executable Python/SQL remains authoritative; profiling and notes retain discovery history.

| Document | Scope |
|---|---|
| [Architecture](architecture.md) | Implemented components and boundaries |
| [Pipeline](pipeline.md) / [runbook](runbook.md) | Execution, transactions, reruns, setup, verification |
| [Data model](data_model.md) / [dictionary](data_dictionary.md) | Grains, keys, relationships, columns, row counts |
| [Validation](validation.md) / [constraints](constraints.md) / [quality](data_quality.md) / [transformations](transformations.md) | Checks, enforcement, exceptions, cleaning |
| [Views](views.md) / [indexes](indexes.md) | Serving contracts and performance structures |
| [Functions](functions.md) / [procedures](procedures.md) | Reusable logic and deployment state |
| [Analytics](analytics.md) / [metrics](metrics.md) | Query progression, formulas, caveats |
| [Power BI](powerbi.md) | Current state and proposed model |
| [Assumptions](assumptions.md) / [limitations](limitations.md) | Interpretation and boundaries |

Audit basis: repository files, raw CSV profiling, and read-only inspection of the configured local PostgreSQL instance on 2026-08-21. “Live-verified” is point-in-time evidence, not an automated test guarantee.
