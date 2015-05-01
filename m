From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: ext4 crypto: Do not select from EXT4_FS_ENCRYPTION
Date: Fri, 1 May 2015 08:18:55 +0800
Message-ID: <20150501001855.GA31516@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Halcrow <mhalcrow@google.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55937 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbbEAATD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Apr 2015 20:19:03 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a tristate EXT4_ENCRYPTION to do the selections
for EXT4_FS_ENCRYPTION because selecting from a bool causes all
the selected options to be built-in, even if EXT4 itself is a
module.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 18228c2..024f228 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -64,8 +64,8 @@ config EXT4_FS_SECURITY
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
 
-config EXT4_FS_ENCRYPTION
-	bool "Ext4 Encryption"
+config EXT4_ENCRYPTION
+	tristate "Ext4 Encryption"
 	depends on EXT4_FS
 	select CRYPTO_AES
 	select CRYPTO_CBC
@@ -81,6 +81,11 @@ config EXT4_FS_ENCRYPTION
 	  efficient since it avoids caching the encrypted and
 	  decrypted pages in the page cache.
 
+config EXT4_FS_ENCRYPTION
+	bool
+	default y
+	depends on EXT4_ENCRYPTION
+
 config EXT4_DEBUG
 	bool "EXT4 debugging support"
 	depends on EXT4_FS
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
