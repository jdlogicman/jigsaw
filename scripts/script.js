var app = angular.module('main', ['ngTable'])
	.filter('unique', function() {
	    return function(input, key) {
	    };
	})
	.controller('DemoCtrl', function($scope, $filter, ngTableParams) {
			// get unique list of genomes
			var u = {}, a = [];
			for(var i = 0, l = jigsawresults.length; i < l; ++i){
				if(!u.hasOwnProperty(jigsawresults[i].SUMMARYReferenceGenome)) {
				    a.push(jigsawresults[i].SUMMARYReferenceGenome);
				    u[jigsawresults[i].SUMMARYReferenceGenome] = 1;
				}
			    }
			$scope.genomes = a;
			// apply genome filter
			for (var index=0; index < a.length; index++) {
				if (a[index].indexOf('Esch') == 0) {
					$scope.genomeFilter = a[index];
					break;
				}
			}
			$scope.columns = [
				{ title: 'Analysis ID', field:'ANALYSIS_ID', visible: true },
				{ title: 'Sample ID', field:'SAMPLE_ID', visible: true },
				{ title: 'genome %', field:'QUASTbrokenGenomefraction', visible: true },
				{ title: '#contigs', field:'QUASTbrokencontigs', visible: true },
				{ title: '#misassemblies', field:'QUASTbrokenmisassemblies', visible: true },
				{ title: 'Largest Alignment', field:'QUASTLargestalignment', visible: true },
				{ title: 'Median Insert Size', field:'FIREBRANDinsert_size_median', visible: true },
				{ title: 'Insert StdDev', field:'FIREBRANDinsert_size_stdev', visible: true },
				{ title: 'Mean Read Len', field:'FIREBRANDmean_read_length', visible: true },
				{ title: 'NGA50', field:'QUASTbrokenNGA50', visible: true },
			    ];
			 var u = {};
			for (var x in $scope.columns) {
				u[$scope.columns[x].field] = 1;
			}
			console.log(u);
			if (jigsawresults.length > 0) {
				for (var propertyName in jigsawresults[0]) {
					if (!u.hasOwnProperty(propertyName)) {
						u[propertyName] = 1;
						$scope.columns.push({ title: propertyName, field:propertyName, visible: false});
					}
				}
			}
			

			$scope.genomes = a;
			$scope.showColumnChooser = false;
			$scope.tableParams = new ngTableParams({
				page: 1,            // show first page
				count: 100,          // count per page
				sorting: {
				    ANALYSIS_ID: 'desc'     // initial sorting
				}
			    },{
				total: jigsawresults.length, // length of $scope.results
				getData: function($defer, params) {
				    // use build-in angular filter
				    var orderedData = params.sorting() ?
							$filter('orderBy')(jigsawresults, params.orderBy()) :
							jigsawresults;

				    $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()));
				}
			    });
		});

