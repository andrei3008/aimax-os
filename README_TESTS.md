Run the test suite against the running local services (API + UI should be running via docker compose).

Install dev deps:

```bash
python -m pip install -r requirements-dev.txt
```

Run tests:

```bash
pytest -q
```
