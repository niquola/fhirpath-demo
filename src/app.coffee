require('file?name=/index.html!jade-env-html!./index.jade')

require('ng-cache?!jade-env-html!./404.jade')
require('ng-cache?!jade-env-html!./_index.jade')
require('./app.less')
require('angular-ui-codemirror')

app = angular.module('app', [
  'ngCookies'
  'ngRoute'
  'ngAnimate'
  'ui.codemirror'
])

app.run ($rootScope, $window) ->
  console.log('run')

app.config ($routeProvider) ->
  rp = $routeProvider
  rp.when '/',
    name: 'index'
    templateUrl: '_index.jade'
    controller: 'IndexCtrl'
    reloadOnSearch: false
  rp.otherwise templateUrl: '404.jade'


app.controller 'IndexCtrl', ($scope) ->
  $scope.path = 'Patient.name.given'
  $scope.resource = '{"resourceType": "Patient", "name": [{"given": ["John"]}]}'
  $scope.update = ()->
    $scope.result = $scope.path

  console.log('here')
  codemirrorExtraKeys = window.CodeMirror.normalizeKeyMap
    "Ctrl-Space": () ->
      $scope.$apply('doMapping()')

    Tab: (cm) ->
      cm.replaceSelection("  ")

  $scope.codemirrorConfig =
    lineWrapping: false
    lineNumbers: true
    mode: 'javascript'
    extraKeys: codemirrorExtraKeys,
    viewportMargin: Infinity
