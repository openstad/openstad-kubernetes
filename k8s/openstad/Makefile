chart-name=openstad
namespace=openstad

debug: clean
	@echo "Creating a dry-run log..."
	@mkdir -p debug
	@helm install $(chart-name) . --dry-run --debug > debug/dry-run-debug-log.txt
	@echo "Dry-run log created successfully!"

install-dependencies:
	helm dependency update

install: install-dependencies
	helm install $(chart-name) . -n $(namespace) --create-namespace

upgrade: 
	helm upgrade $(chart-name) . -n $(namespace)

test:
	helm install openstad .
	helm uninstall openstad

get-values:
	clear

	@echo ""
	@echo "==========================="
	@echo "=      Custom values      ="
	@echo "==========================="
	@echo ""

	@helm inspect values .

uninstall:
	helm uninstall $(chart-name) -n $(namespace) --keep-history

clean:
	rm -rf ./debug
