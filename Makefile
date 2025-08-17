run-api:
	cd api && uvicorn app:app --reload --port 8000

run-cli:
	cd cli && python3 ai.py chat "Hello from AiMax"

run-ui:
	cd ui/aimax-ui && pnpm dev

build-ui:
	cd ui/aimax-ui && pnpm build
