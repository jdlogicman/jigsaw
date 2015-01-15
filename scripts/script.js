var app = angular.module('main', ['ngTable'])
	.controller('DemoCtrl', function($scope, $filter, ngTableParams) {
			// $scope.results = jigsawresults;
			$scope.genomeFilter='Escherichia';
			$scope.tableParams = new ngTableParams({
				page: 1,            // show first page
				count: 10,          // count per page
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
		}
	);

