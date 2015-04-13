From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v2 03/20] ext4 crypto: add ext4 encryption Kconfig
Date: Sun, 12 Apr 2015 23:16:19 -0400
Message-ID: <1428894996-7852-4-git-send-email-tytso@mit.edu>
References: <1428894996-7852-1-git-send-email-tytso@mit.edu>
Cc: mhalcrow@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35600 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbbDMDQ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Apr 2015 23:16:58 -0400
In-Reply-To: <1428894996-7852-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change-Id: Ieedde8447d748d2ca1ffca546e58418fb9e9c885
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/Kconfig | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index efea5d5..18228c2 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -64,6 +64,23 @@ config EXT4_FS_SECURITY
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
 
+config EXT4_FS_ENCRYPTION
+	bool "Ext4 Encryption"
+	depends on EXT4_FS
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_ECB
+	select CRYPTO_XTS
+	select CRYPTO_CTS
+	select CRYPTO_SHA256
+	select KEYS
+	select ENCRYPTED_KEYS
+	help
+	  Enable encryption of ext4 files and directories.  This
+	  feature is similar to ecryptfs, but it is more memory
+	  efficient since it avoids caching the encrypted and
+	  decrypted pages in the page cache.
+
 config EXT4_DEBUG
 	bool "EXT4 debugging support"
 	depends on EXT4_FS
-- 
2.3.0

