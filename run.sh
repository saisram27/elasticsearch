helm upgrade --wait --timeout=600 --install \
  --values ./master.yaml elasticsearch elastic/elasticsearch

helm upgrade --wait --timeout=600 --install \
  --values ./data.yaml elasticsearch elastic/elasticsearch

helm upgrade --wait --timeout=600 --install \
  --values ./client.yaml elasticsearch elastic/elasticsearch