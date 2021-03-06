'use strict'

angular.module('facegroupApp')
  .controller 'GroupCtrl', ['$location', '$scope', 'Facebook', ($location, $scope, Facebook) ->

    angular.element('body').addClass('feed')

    Facebook.getLoginStatus (response) ->
      if response.status == 'connected'
        $scope.fetchGoups()
      else
        $location.path('/')

    $scope.fetchGoups = ->
      Facebook.api '/me/groups?fields=icon,email,name,id&icon_size=16', (response) ->
        $scope.$apply ->
          $scope.groups = response.data

    $scope.showFeed = (group) ->
      Facebook.api "/#{group.id}?fields=feed.fields(message,from,comments.limit(200).fields(from,message),full_picture,picture)&limit=100", (response) ->

        $scope.$apply ->
          $scope.groupFeed =
            id: response.id
            name: group.name
            feed: response.feed.data
            totalMessages: response.feed.data.length
  ]

