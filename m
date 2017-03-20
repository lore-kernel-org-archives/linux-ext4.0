From: Joe Richey <joerichey94@gmail.com>
Subject: [PATCH] misc: fixed error handling in e4crypt
Date: Mon, 20 Mar 2017 20:34:36 +0000
Message-ID: <1490042076-25845-1-git-send-email-joerichey94@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Michael Halcrow <mhalcrow@google.com>,
        Joe Richey <joerichey@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35351 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753279AbdCTWPp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Mar 2017 18:15:45 -0400
Received: by mail-pg0-f65.google.com with SMTP id g2so22108137pge.2
        for <linux-ext4@vger.kernel.org>; Mon, 20 Mar 2017 15:15:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Joe Richey <joerichey@google.com>

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
