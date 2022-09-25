##
# nephelaiio.k8s Ansible role
#
# @file
# @version 0.0.1

KIND_RELEASE := $$(yq eval '.jobs.molecule.strategy.matrix.release| sort | reverse | .[0]' .github/workflows/main.yml)
KIND_IMAGE := $$(yq eval '.jobs.molecule.strategy.matrix.image | sort | reverse | .[0]' .github/workflows/main.yml)

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
