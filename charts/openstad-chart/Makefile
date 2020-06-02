chart-name=openstad-chart

debug: clean install-dependencies
	@echo "Creating a dry-run log..."
	@mkdir -p debug
	@helm install $(chart-name) . --dry-run --debug > debug/dry-run-debug-log.txt
	@echo "Dry-run log created successfuly!"

install-dependencies:
	helm dependency update

install: install-dependencies
	helm install $(chart-name) .

upgrade: 
	helm upgrade $(chart-name) .

get-values:
	clear

	@echo ""
	@echo "==========================="
	@echo "=      Custom values      ="
	@echo "==========================="
	@echo ""

	@helm inspect values .

uninstall:
	helm uninstall $(chart-name) --keep-history

clean:
	rm -rf ./debug
