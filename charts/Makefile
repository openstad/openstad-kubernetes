get-subcharts: package
	mkdir -p ./openstad-chart/charts
	mv ./subcharts/*.tgz ./openstad-chart/charts

package:
	$(MAKE) -C subcharts package-all

clean:
	rm -rf ./chart-repo
	rm -rf ./subcharts/*.tgz
