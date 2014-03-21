module Instagram
  class Client

    # Methods for the Users API.
    #
    # @see http://instagram.com/developer/endpoints/users/
    module Users
    
    # Returns a list of users whom a given user follows
      #
      # @overload user_follows(id=nil, options={})
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash]
      #   @example Returns a list of users the authenticated user follows
      #     Instagram.user_follows
      # @overload user_follows(id=nil, options={})
      #   @param user [Integer] An Instagram user ID.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (nil) Breaks the results into pages. Provide values as returned in the response objects's next_cursor attribute to page forward in the list.
      #   @option options [Integer] :count (nil) Limits the number of results returned per page.
      #   @return [Hashie::Mash]
      #   @example Return a list of users @mikeyk follows
      #     Instagram.user_follows(4) # @mikeyk user ID being 4
      # @see TODO:docs url
      # @format :json
      # @authenticated false unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @rate_limited true
      def user_follows(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        id = args.first || "self"
        response = get("users/#{id}/follows", options)
        response
      end
    end

    # Returns a list of users whom a given user is followed by
    #
    # @overload user_followed_by(id=nil, options={})
    #   @param options [Hash] A customizable set of options.
    #   @return [Hashie::Mash]
    #   @example Returns a list of users the authenticated user is followed by
    #     Instagram.user_followed_by
    # @overload user_followed_by(id=nil, options={})
    #   @param user [Integer] An Instagram user ID.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (nil) Breaks the results into pages. Provide values as returned in the response objects's next_cursor attribute to page forward in the list.
    #   @option options [Integer] :count (nil) Limits the number of results returned per page.
    #   @return [Hashie::Mash]
    #   @example Return a list of users @mikeyk is followed by
    #     Instagram.user_followed_by(4) # @mikeyk user ID being 4
    # @see TODO:docs url
    # @format :json
    # @authenticated false unless requesting it from a protected user
    #
    #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
    # @rate_limited true
    def user_followed_by(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      id = args.first || "self"
      response = get("users/#{id}/followed-by", options)
      response
    end

      # Retrieve a single user's information.
      #
      # @param user [String, Integer] The user ID or username.
      # @return [Hashie::Mash] The user's data.
      # @see http://instagram.com/developer/endpoints/users/#get_users
      # @example Get user by ID
      #   client.user(16500486)
      # @example Get user by username
      #   client.user('caseyscarborough')
      # @example Get authentication user
      #   client.user
      def user(user=nil)
        case user
        when Integer
          get "/users/#{user}", auth_params
        when String
          results = search(user)
          get "/users/#{results.data[0].id}", auth_params
        when nil
          get '/users/self', auth_params
        end
      end

      # Search for a user by username.
      #
      # @param query [String] The username to search for.
      # @return [Hashie::Mash] The search results.
      # @see http://instagram.com/developer/endpoints/users/#get_users_search
      # @example Search for a user
      #   client.search('caseyscarborough')
      def search(query=nil)
        get "/users/search", auth_params.merge(:q => query)
      end

      # Get the authenticated user's feed.
      #
      # @return [Hashie::Mash] The user's feed.
      # @see http://instagram.com/developer/endpoints/users/#get_users_feed
      # @example
      #   client.feed
      def feed
        get '/users/self/feed', auth_params
      end

      # Get the most recent media published by a user.
      #
      # Returns the recent media for the user for the ID passed in as a parameter.
      # If no ID is specified, then returns the authenticated user's recent media.
      #
      # @param id [Integer] The user's ID.
      # @return [Hashie::Mash] The user's recent media.
      # @see http://instagram.com/developer/endpoints/users/#get_users_media_recent
      def recent(id=nil)
        id = "self" unless id
        get "/users/#{id}/media/recent", auth_params
      end

      # See the authenticated user's list of media they've liked.
      #
      # @return [Hashie::Mash] List of media.
      # @see http://instagram.com/developer/endpoints/users/#get_users_feed_liked
      def liked
        get '/users/self/media/liked', auth_params
      end

    end

  end
end
