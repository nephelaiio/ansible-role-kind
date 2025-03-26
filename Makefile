.PHONY: ${MAKECMDGOALS}

KIND_RELEASE := latest
KIND_IMAGE := $$(yq eval '.jobs.molecule.strategy.matrix.k8s[0]' .github/workflows/molecule.yml)
ROLE_NAME := $$(pwd | xargs basename)
MOLECULE_SCENARIO ?= default
MOLECULE_EPHEMERAL_DIR := "$$HOME/.cache/molecule/$(ROLE_NAME)/$(SCENARIO)"

test: install
	KIND_RELEASE=$(KIND_RELEASE) \
	KIND_IMAGE=$(KIND_IMAGE) \
	poetry run molecule $@ -s ${MOLECULE_SCENARIO}

install:
	@poetry install --no-root

lint: install
	poetry run yamllint .
	poetry run ansible-lint .
	poetry run molecule syntax

dependency create prepare converge idempotence side-effect verify destroy cleanup reset list:
	KIND_RELEASE=$(KIND_RELEASE) \
	KIND_IMAGE=$(KIND_IMAGE) \
	poetry run molecule $@ -s ${MOLECULE_SCENARIO}

purge:
	@echo cleaning ansible cache
	if [ -d $(HOME)/.cache/ansible-compat/ ]; then \
		find $(HOME)/.cache/ansible-compat/ -mindepth 2 -maxdepth 2 -type d -name "roles" | xargs -r rm -rf; \
	fi ;

clean: destroy reset purge
	@poetry env remove $$(which python) >/dev/null 2>&1 || exit 0

ifeq (helm,$(firstword $(MAKECMDGOALS)))
    HELM_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(subst $(space),,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))):;@:)
endif

helm:
	KUBECONFIG=$(MOLECULE_EPHEMERAL_DIR)/config $@ ${HELM_ARGS}

ifeq (kubectl,$(firstword $(MAKECMDGOALS)))
    KUBECTL_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(subst $(space),,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))):;@:)
endif

kubectl:
	@KUBECONFIG=$(MOLECULE_EPHEMERAL_DIR)/config $@ ${KUBECTL_ARGS}

publish:
	@echo publishing repository ${GITHUB_REPOSITORY}
	@echo GITHUB_ORGANIZATION=${GITHUB_ORG}
	@echo GITHUB_REPOSITORY=${GITHUB_REPO}
	@poetry run ansible-galaxy role import \
		--api-key ${GALAXY_API_KEY} ${GITHUB_ORG} ${GITHUB_REPO}
