From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 03/22] ext4 crypto: add ext4 encryption Kconfig
Date: Thu,  2 Apr 2015 18:10:40 -0400
Message-ID: <1428012659-12709-4-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47972 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbbDBWMd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:12:33 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change-Id: Ieedde8447d748d2ca1ffca546e58418fb9e9c885
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/Kconfig | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index efea5d5..33de739 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -64,6 +64,26 @@ config EXT4_FS_SECURITY
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
 
+config EXT4_FS_ENCRYPTION
+	bool "Ext4 Encryption"
+	depends on EXT4_FS
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_CTR
+	select CRYPTO_ECB
+	select CRYPTO_XTS
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	select CRYPTO_HMAC
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

