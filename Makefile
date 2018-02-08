.PHONY: docker-scf-base
docker-scf-base:
	docker build --rm --tag kameshsampath/ow-scf-base -f Dockerfile .

.PHONY: docker-scf-fn
docker-scf-fn:
	docker build --rm --tag kameshsampath/ow-scf-fn-runner -f Dockerfile.fn .

.PHONY: docker-scf-app
docker-scf-app:
	docker build --rm --tag kameshsampath/ow-scf-app-runner -f Dockerfile.app .

docker-clean: 
	-docker rmi kameshsampath/ow-scf-base; \
	 docker rmi kameshsampath/ow-scf-fn-runner; \
	 docker rmi kameshsampath/ow-scf-app-runner