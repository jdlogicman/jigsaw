var app = angular.module('main', ['ngTable'])
	.controller('DemoCtrl', function($scope, $filter, ngTableParams) {
			$scope.results = jigsawresults;
			$scope.tableParams = new ngTableParams({
				page: 1,            // show first page
				count: 10,          // count per page
				sorting: {
				    name: 'asc'     // initial sorting
				}
			    },{
				total: $scope.results.length, // length of $scope.results
				getData: function($defer, params) {
				    // use build-in angular filter
				    var orderedData = params.sorting() ?
							$filter('orderBy')($scope.results, params.orderBy()) :
							$scope.results;

				    $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()));
				}
			    });
		}
	);

