FORMAT: 1A

# OUser [working draft v1]
An open standard for distributed user account registration, session management, and access control.

# Group Initial

These API calls may be made at any time.

## Send [/send]
Send a `verification_code` to the given `identifier`.
### POST
+ Parameters
	+ identifier (string) ... e.g. `"user@example.com"` or `"8885551212"`
	+ identifier_type (string) ... e.g. `"email"` or `"sms"`
	+ message (optional, string) ... The type of message to send.

+ Response 202
Message has been queued for delivery.
	+ Body

+ Response 400
Missing or incorrect parameter(s).
	+ Body

+ Response 404
Given `message_type` was invalid.
	+ Body

+ Response 500
Internal Server Error
	+ Body

## Login [/login]
Login with `identifier` and `password`.
### POST
+ Parameters
	+ identifier (string) ... e.g. `"user@example.com"` or `"8885551212"`
	+ identifier_type (string) ... e.g. `"email"` or `"sms"`
	+ password (string)

+ Response 200
	+ Body
			{
				"session_token": "..."
			}

+ Response 400
Missing or incorrect parameter(s).
	+ Body

+ Response 401
Incorrect username or password.
	+ Body

+ Response 500
Internal Server Error
	+ Body


# Group Verification Code

These API calls may be made once a `verification_code` has been acquired.

## Register [/register]
Associate a password with the identifier used to send the given `verification_code`.
### POST
+ Parameters
	+ verification_code (string) ... Verification code, as delivered via the `send` API.
	+ password (string) ... Password for this user.

+ Response 201
Created.
	+ Body

+ Response 400
Missing or incorrect parameter(s).
	+ Body

+ Response 409
Conflict; this identifier is already registered.
	+ Body

+ Response 410
`verification_code` is invalid or expired.
	+ Body

+ Response 500
Internal Server Error
	+ Body

## Login [/login]
Login with `identifier` and `verification_code`.
### POST
+ Parameters
	+ identifier (string) ... e.g. `"user@example.com"` or `"8885551212"`
	+ identifier_type (string) ... e.g. `"email"` or `"sms"`
	+ verification_code (string)

+ Response 200
	+ Body
			{
				"session_token": "..."
			}

+ Response 400
Missing or incorrect parameter(s).
	+ Body

+ Response 401
Incorrect `identifier` or invalid/expired `verification_code`.
	+ Body

+ Response 500
Internal Server Error
	+ Body

## Reset Password [/reset_password]
Change password, without knowing current password.
### POST
+ Parameters
	+ verification_code (string) ... Verification code, as delivered via the `send` API.
	+ password (string) ... New password.

+ Response 204
Password changed.
	+ Body

+ Response 400
Missing or incorrect parameter(s).
	+ Body

+ Response 410
Token is invalid or expired.
	+ Body

+ Response 500
Internal Server Error
	+ Body


# Group Session Token

These API calls may be made once a `session_token` has been acquired.

## Refresh [/refresh]
Renew a `session_token`.
### POST
+ Parameters
	+ session_token (string) ... From `login` or `refresh` API.

+ Response 200
	+ Body
			{
				"session_token": "..."
			}

+ Response 400
Missing or incorrect parameter(s).
	+ Body

+ Response 410
Session is invalid or expired.
	+ Body

+ Response 500
Internal Server Error
	+ Body

## Change Password [/change_password]
Change password, given the current password.
### POST
+ Parameters
	+ session_token (string) ... From `login` or `refresh` API.
	+ current_password (string) ... Old password.
	+ password (string) ... New password.

+ Response 204
Password changed.
	+ Body

+ Response 400
Missing or incorrect parameter(s).
	+ Body

+ Response 403
`current_password` is incorrect.
	+ Body

+ Response 410
Session is invalid or expired.
	+ Body

+ Response 500
Internal Server Error
	+ Body

## Logout [/logout]
Invalidate the given `session_token`, or all `session_token`s for this user.
### POST
+ Parameters
	+ session_token (string) ... From `login` or `refresh` API.
	+ all = `false` (optional, boolean)
		Whether or not to logout only this session (`false`, the default) or all sessions for this user (`true`).

+ Response 204
Logged out.
	+ Body

+ Response 400
Missing or incorrect parameter(s).
	+ Body

+ Response 410
Session is invalid or expired.
	+ Body

+ Response 500
Internal Server Error
	+ Body

