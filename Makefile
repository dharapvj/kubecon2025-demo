.PHONY: demo-1 demo-1a demo-2-prep demo-2 demo-3-prep demo-3 demo-3-update-chart create-cluster cleanup

create-cluster:
	kind create cluster

demo-1:
	chainsaw test --report-format JUNIT-TEST --assert-timeout 1s --cleanup-timeout 10s demo-1 --namespace chainsaw

demo-1a:
	chainsaw test demo-1a

demo-2-prep:
	helm repo add clustersecret https://charts.clustersecret.com/
	helm install clustersecret clustersecret/cluster-secret --version 0.5.2 -n clustersecret --create-namespace

demo-2:
	chainsaw test demo-2

demo-3-prep:
	helm upgrade dummy --install -n default --version 0.1.0 ./demo-3/dummy

demo-3-check:
	kubectl get svc dummy -oyaml | yq '.spec.ports'

demo-3:
	chainsaw test demo-3

demo-3-update-chart:
	helm upgrade dummy --install -n default --version 0.1.1 ./demo-3/dummy-1.1

cleanup:
	kind delete cluster