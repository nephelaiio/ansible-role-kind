##
# nephelaiio.k8s Ansible role
#
# @file
# @version 0.0.1

KIND_RELEASE := $$(yq eval '.jobs.molecule.strategy.matrix.include[0].release ' .github/workflows/molecule.yml)
K8S_RELEASE := $$(yq eval '.jobs.molecule.strategy.matrix.include[0].image' .github/workflows/molecule.yml)
SCENARIO ?= default
EPHEMERAL_DIR := "$$HOME/.cache/molecule/$(ROLE_NAME)/$(SCENARIO)"

.PHONY: clean molecule helm kubectl poetry

clean:
	find /home/teddyphreak/.cache/ansible-compat/ -type l -wholename "*roles/*" | xargs -r rm -f

molecule: poetry clean
	KIND_RELEASE=$(KIND_RELEASE) K8S_RELEASE=$(K8S_RELEASE) poetry run molecule $(filter-out $@,$(MAKECMDGOALS)) -s $(SCENARIO)

helm:
	KUBECONFIG=$(EPHEMERAL_DIR)/config helm $(filter-out $@,$(MAKECMDGOALS))

kubectl:
	@KUBECONFIG=$(EPHEMERAL_DIR)/config kubectl $(filter-out $@,$(MAKECMDGOALS))

poetry:
	@poetry install

# end
