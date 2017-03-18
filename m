From: Joe Richey <joerichey@google.com>
Subject: [PATCH] misc: fixed error handling in e4crypt
Date: Sat, 18 Mar 2017 00:31:03 +0000
Message-ID: <1489797063-19169-1-git-send-email-joerichey@google.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="f403045cd336ac3199054af6cc10"
Cc: Theodore Ts'o <tytso@mit.edu>,
        Michael Halcrow <mhalcrow@google.com>,
        Joe Richey <joerichey@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:32867 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdCRA7B (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Mar 2017 20:59:01 -0400
Received: by mail-pg0-f50.google.com with SMTP id n190so50712286pga.0
        for <linux-ext4@vger.kernel.org>; Fri, 17 Mar 2017 17:59:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--f403045cd336ac3199054af6cc10

Due to some interesting behaviour in keyctl (as described in the
comments), we use KEYCTL_GET_KEYRING_ID to translate the special value
of KEY_SPEC_SESSION_KEYRING to a real keyring id. However, how we
currently do this is flawed in two ways.

First, if KEYCTL_GET_KEYRING_ID fails, we don't detect it as it returns
-1 and zero is used for an error value in get_keyring_id. Second, if the
user specifies "-k @s" the translation never runs and the undesireable
behavior occurs.

These are both fixed by doing the translation outside of get_keyring_id.

Signed-off-by: Joe Richey <joerichey@google.com>
---
 misc/e4crypt.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/misc/e4crypt.c b/misc/e4crypt.c
index 04faca3..fd2fc8f 100644
--- a/misc/e4crypt.c
+++ b/misc/e4crypt.c
@@ -507,24 +507,12 @@ static int get_keyring_id(const char *keyring)
 
 	/*
 	 * If no keyring is specified, by default use either the user
-	 * session key ring or the session keyring.  Fetching the
+	 * session keyring or the session keyring.  Fetching the
 	 * session keyring will return the user session keyring if no
 	 * session keyring has been set.
-	 *
-	 * We need to do this instead of simply adding the key to
-	 * KEY_SPEC_SESSION_KEYRING since trying to add a key to a
-	 * session keyring that does not yet exist will cause the
-	 * kernel to create a session keyring --- which wil then get
-	 * garbage collected as soon as e4crypt exits.
-	 *
-	 * The fact that the keyctl system call and the add_key system
-	 * call treats KEY_SPEC_SESSION_KEYRING differently when a
-	 * session keyring does not exist is very unfortunate and
-	 * confusing, but so it goes...
 	 */
 	if (keyring == NULL)
-		return keyctl(KEYCTL_GET_KEYRING_ID,
-			      KEY_SPEC_SESSION_KEYRING, 0);
+		return KEY_SPEC_SESSION_KEYRING;
 	for (x = 0; x < (sizeof(keyrings) / sizeof(keyrings[0])); ++x) {
 		if (strcmp(keyring, keyrings[x].name) == 0) {
 			return keyrings[x].code;
@@ -585,6 +573,24 @@ static void insert_key_into_keyring(const char *keyring, struct salt *salt)
 	key.mode = EXT4_ENCRYPTION_MODE_AES_256_XTS;
 	memcpy(key.raw, salt->key, EXT4_MAX_KEY_SIZE);
 	key.size = EXT4_MAX_KEY_SIZE;
+
+	/*
+	 * We need to do this instead of simply adding the key to
+	 * KEY_SPEC_SESSION_KEYRING since trying to add a key to a
+	 * session keyring that does not yet exist will cause the
+	 * kernel to create a session keyring --- which wil then get
+	 * garbage collected as soon as e4crypt exits.
+	 *
+	 * The fact that the keyctl system call and the add_key system
+	 * call treats KEY_SPEC_SESSION_KEYRING differently when a
+	 * session keyring does not exist is very unfortunate and
+	 * confusing, but so it goes...
+	 */
+	if (keyring_id == KEY_SPEC_SESSION_KEYRING) {
+		keyring_id = keyctl(KEYCTL_GET_KEYRING_ID, keyring_id, 0);
+		if (keyring_id < 0)
+			printf("Could not get session keyring.\n");
+	}
 	rc = add_key(EXT2FS_KEY_TYPE_LOGON, key_ref_full, (void *)&key,
 		     sizeof(key), keyring_id);
 	if (rc == -1) {
-- 
2.7.4


--f403045cd336ac3199054af6cc10
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIS7QYJKoZIhvcNAQcCoIIS3jCCEtoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghBTMIIEXDCCA0SgAwIBAgIOSBtqDm4P/739RPqw/wcwDQYJKoZIhvcNAQELBQAwZDELMAkGA1UE
BhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExOjA4BgNVBAMTMUdsb2JhbFNpZ24gUGVy
c29uYWxTaWduIFBhcnRuZXJzIENBIC0gU0hBMjU2IC0gRzIwHhcNMTYwNjE1MDAwMDAwWhcNMjEw
NjE1MDAwMDAwWjBMMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEiMCAG
A1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBALR23lKtjlZW/17kthzYcMHHKFgywfc4vLIjfq42NmMWbXkNUabIgS8KX4PnIFsTlD6F
GO2fqnsTygvYPFBSMX4OCFtJXoikP2CQlEvO7WooyE94tqmqD+w0YtyP2IB5j4KvOIeNv1Gbnnes
BIUWLFxs1ERvYDhmk+OrvW7Vd8ZfpRJj71Rb+QQsUpkyTySaqALXnyztTDp1L5d1bABJN/bJbEU3
Hf5FLrANmognIu+Npty6GrA6p3yKELzTsilOFmYNWg7L838NS2JbFOndl+ce89gM36CW7vyhszi6
6LqqzJL8MsmkP53GGhf11YMP9EkmawYouMDP/PwQYhIiUO0CAwEAAaOCASIwggEeMA4GA1UdDwEB
/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIB
ADAdBgNVHQ4EFgQUyzgSsMeZwHiSjLMhleb0JmLA4D8wHwYDVR0jBBgwFoAUJiSSix/TRK+xsBtt
r+500ox4AAMwSwYDVR0fBEQwQjBAoD6gPIY6aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9ncy9n
c3BlcnNvbmFsc2lnbnB0bnJzc2hhMmcyLmNybDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIG
CCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG
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
QAYIKwYBBQUHMAKGNGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzaHZzbWlt
ZWNhMS5jcnQwHQYDVR0OBBYEFIzdacNPR4CxZxcfYVOn0kurxuOYMB8GA1UdIwQYMBaAFMs4ErDH
mcB4koyzIZXm9CZiwOA/MEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMDsGA1UdHwQ0MDIwMKAuoCyGKmh0
dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NodnNtaW1lY2ExLmNybDAOBgNVHQ8BAf8EBAMCBaAw
HQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMA0GCSqGSIb3DQEBCwUAA4IBAQAESPQix4jl
tO0Y5E5w9HIuLMT775Dc8T4ddEq1WlwZwiC3+wUvycRlBmLTD/9Kl9VkZEymqwP3OkzHsmWyAcmU
JXvwDIgWqmHjrGhxO6/GWC1Z/+LD9aY1iCEjzSBxUpkyAdON+QcdabM8rQjGaeIISC3DA7luQACW
xcTkDKtxV+KG54Nh6lBI52Xee/vUkgWP8zF7AskYoh7WXIlT++pUvLsLXyzQ+2/q7uo6WvqqAEBi
nBKGKtVwFRuIWJqdfix5Cw0tPOmyIvgphEL/HnVQNilaYDSly0p9fNPYjP5YAPB+3hHschaYY4TC
eU9cXFsl1/C1pCe51dT7ZblpgjqZMYICXjCCAloCAQEwXDBMMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEiMCAGA1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMQIM
PV9GeTJlm18T4QwsMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCBpbfgrgUgxcA7c
rV8WntrLM77FuBDRfD9MxsZZjV2uhjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0xNzAzMTgwMDU4NTlaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAEoQi+xUmsT124qW9PkqVjSgiivyOfaBX
hBgPV/LOv8Et+dbO/eKdgAzSbePi4sSBzIIe64iSXHxragcXy+0iySVOFBgmTi1CKuK32cMrejNN
gcQR8Cj3UbJAoDzNRXKFD2zZWUdZUleKOLHQosH5gv2bGUlDnRm2nHf6nFnN3nj7Z2bRuq4rsJ9v
cqvEV3tCpe0N4pvlXRaZD/jjy5wI9zEm7PQM7vDoEWMH+Gd+i23Y7rRLTw34BT5XWw3RlLwBF/7Q
mG5be/jvzdJxi1nqVQVFUnga5dUyvX6xzvWBK3Eigl/zVsYJsSlaPuq9JGLv2FSU9nzhBVeKf2w+
J0Iiwg==
--f403045cd336ac3199054af6cc10--
