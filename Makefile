deploy: base_setup
	@echo "Deployment for CloudNative PG Cluster"
	@cd src && ./automate.sh
base_setup:
	@echo "Base Setup for CloudNative PG Deployment"
	@cd base && ./automate.sh