# issue-cleanup

Check github issues for secure details that shouldn't be there. Prints out links to issues that need editing. If you see no links, you're clear.

Checks for:

* `auth_token=` in issue descriptions
* ... and that's it for now

## Usage 

    ruby ./cleanup.rb {user_or_org} {github_oauth_token}
    
## License

MIT. See LICENSE.md