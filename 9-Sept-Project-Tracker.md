# Project Tracker - CI/CD for E-commerce (9 Sept 2025)

## Phase 1 – Foundation Setup & Docker Hub Integration
- Status: In Progress
- Owner: DevOps (you)

### Completed
- Backend image rebuild succeeds locally with Alpine + bash
- Validation: bash present, Node version ok, migrate/seed scripts executable

### Next
- Add GitHub secrets for Docker Hub and push from CI
- Build & push backend and frontend images with latest + SHA tags

### Checkpoints
- [x] Local Docker build pass
- [ ] GitHub workflow run completes
- [ ] Images visible at docker.io/routeclouds/{routeclouds-backend,routeclouds-frontend}

## Phase 2 – Automated CI/CD Pipeline
- Status: Planned
- CI: Build/push images; basic smoke validations
- CD: Prepare placeholders for EKS deploy (to be added)

## Risks / Blockers
- Docker Hub token not yet configured in GitHub
- TypeScript build inside Docker may be skipped if tsc missing; ensure dist/ present

## Rollback Plan (Images)
- Re-tag last known good SHA as latest
- Or pull previous latest and redeploy

## Notes
- Docker Hub org: routeclouds (email: routesclouds@gmail.com)
- Secrets expected in GitHub: DOCKERHUB_USERNAME, DOCKERHUB_TOKEN

