chart-name=openstad-frontend

debug: clean
	@echo "Creating a dry-run log..."
	@mkdir -p debug
	@helm install $(chart-name) . --dry-run --debug > debug/dry-run-debug-log.txt
	@echo "Dry-run log created successfuly!"

clean:
	rm -rf ./debug
