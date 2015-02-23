var app = angular.module('main', ['ngTable'])
	.filter('unique', function() {
	    return function(input, key) {
	    };
	})
	.controller('DemoCtrl', function($scope, $filter, ngTableParams) {
			var u = {}, a = [];
			for(var i = 0, l = jigsawresults.length; i < l; ++i){
				if(!u.hasOwnProperty(jigsawresults[i].SUMMARYReferenceGenome)) {
				    a.push(jigsawresults[i].SUMMARYReferenceGenome);
				    u[jigsawresults[i].SUMMARYReferenceGenome] = 1;
				}
			    }
			$scope.genomes = a;
			for (var index=0; index < a.length; index++) {
				if (a[index].indexOf('Esch') == 0) {
					$scope.genomeFilter = a[index];
					break;
				}
			}
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

