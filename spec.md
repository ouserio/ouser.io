FORMAT: 1A

# OUser [working draft v0]

An open standard for distributed user account registration, session management, and access control.

# Group Initial

These API calls may be made at any time.

## Send [/v0/send]
### POST
+ Parameters
	+ email (string)
	+ type (optional, string)

+ Response 202 (application/json)
Message has been queued for delivery.
	+ Body

+ Response 400 (application/json)
Missing or incorrect parameter(s).
	+ Body

+ Response 404 (application/json)
Given `type` was not found.
	+ Body

+ Response 500 (application/json)
Internal Server Error
	+ Body

## Login [/v0/login]
### POST
+ Parameters
	+ email (string)
	+ password (string)

+ Response 200 (application/json)
	+ Body
			{
				"loginToken": "..."
			}

+ Response 400 (application/json)
Missing or incorrect parameter(s).
	+ Body

+ Response 401 (application/json)
Incorrect username or password.
	+ Body

+ Response 410 (application/json)
Invalid or expired token.
	+ Body

+ Response 500 (application/json)
Internal Server Error
	+ Body


# Group Token

These API calls may be made once a `token` has been acquired.

## Register [/v0/register]
### POST
+ Parameters
	+ token (string) ... Token as delivered via the `send` API.
	+ password (string) ... Password for this user.

+ Response 201 (application/json)
Created.
	+ Body

+ Response 400 (application/json)
Missing or incorrect parameter(s).
	+ Body

+ Response 409 (application/json)
Conflict; this email address is already registered.
	+ Body

+ Response 410 (application/json)
Token is invalid or expired.
	+ Body

+ Response 500 (application/json)
Internal Server Error
	+ Body

## Password Reset [/v0/reset_password]
### POST
+ Parameters
	+ token (string) ... Token as delivered via the `send` API.
	+ password (string) ... New password.

+ Response 204 (application/json)
Password changed.
	+ Body

+ Response 400 (application/json)
Missing or incorrect parameter(s).
	+ Body

+ Response 410 (application/json)
Token is invalid or expired.
	+ Body

+ Response 500 (application/json)
Internal Server Error
	+ Body


# Group Session

These API calls may be made once a `loginToken` has been acquired.

## Refresh [/v0/refresh]
### POST
+ Parameters
	+ loginToken (string) ... From `login` or `refresh` API.

+ Response 200 (application/json)
	+ Body
			{
				"loginToken": "..."
			}

+ Response 400 (application/json)
Missing or incorrect parameter(s).
	+ Body

+ Response 410 (application/json)
Session is invalid or expired.
	+ Body

+ Response 500 (application/json)
Internal Server Error
	+ Body

## Change Password [/v0/change_password]
### POST
+ Parameters
	+ loginToken (string) ... From `login` or `refresh` API.
	+ currentPassword (string)
	+ password (string)

+ Response 204 (application/json)
Password changed.
	+ Body

+ Response 400 (application/json)
Missing or incorrect parameter(s).
	+ Body

+ Response 403 (application/json)
`currentPassword` is incorrect.
	+ Body

+ Response 410 (application/json)
Session is invalid or expired.
	+ Body

+ Response 500 (application/json)
Internal Server Error
	+ Body

## Logout [/v0/logout]
### POST
+ Parameters
	+ loginToken (string) ... From `login` or `refresh` API.
	+ all = `false` (optional, boolean)
		Whether or not to logout only this session (`false`, the default) or all sessions for this user (`true`).

+ Response 204 (application/json)
Logged out.
	+ Body

+ Response 400 (application/json)
Missing or incorrect parameter(s).
	+ Body

+ Response 410 (application/json)
Session is invalid or expired.
	+ Body

+ Response 500 (application/json)
Internal Server Error
	+ Body
