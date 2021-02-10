# see https://github.com/kubernetes/kops/blob/master/docs/cli/kops_create_cluster.md
# see https://github.com/kubernetes/kops/blob/master/docs/terraform.md

export KOPS_FEATURE_FLAGS=AlphaAllowGCE # to unlock the GCE features
export CLUSTER_NAME="example.k8s.local"
export ZONES=$(gcloud config get-value compute/zone)
export KOPS_STATE_STORE="gs://example-kops-state/"
export PROJECT=$(gcloud config get-value project)

kops create cluster \
--name ${CLUSTER_NAME} \
--zones ${ZONES} \
--state ${KOPS_STATE_STORE} \
--project=$PROJECT \
--node-count=3 \
--cloud gce
