From: Petros Koutoupis <petros@petroskoutoupis.com>
Subject: [PATCH] ext4.h: Fixed alignment and minor code cleanup.
Date: Wed, 20 Dec 2017 14:09:18 -0600
Message-ID: <1513800558.15997.3.camel@petroskoutoupis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:52734 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754388AbdLTUO3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Dec 2017 15:14:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Minor code cleanup: Fixed alignment and a reduction of lines in header file.

Signed-off-by: Petros Koutoupis <petros@petroskoutoupis.com>


diff -uNpr linux-4.15-rc4.orig/fs/ext4/ext4.h linux-4.15-rc4/fs/ext4/ext4.h
--- linux-4.15-rc4.orig/fs/ext4/ext4.h	2017-12-18 08:35:04.000000000 -0600
+++ linux-4.15-rc4/fs/ext4/ext4.h	2017-12-18 08:37:02.000000000 -0600
@@ -611,10 +611,10 @@ enum {
 /*
  * Flags used by ext4_free_blocks
  */
-#define EXT4_FREE_BLOCKS_METADATA	0x0001
-#define EXT4_FREE_BLOCKS_FORGET		0x0002
-#define EXT4_FREE_BLOCKS_VALIDATED	0x0004
-#define EXT4_FREE_BLOCKS_NO_QUOT_UPDATE	0x0008
+#define EXT4_FREE_BLOCKS_METADATA		0x0001
+#define EXT4_FREE_BLOCKS_FORGET			0x0002
+#define EXT4_FREE_BLOCKS_VALIDATED		0x0004
+#define EXT4_FREE_BLOCKS_NO_QUOT_UPDATE		0x0008
 #define EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER	0x0010
 #define EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER	0x0020
 
@@ -1986,10 +1986,10 @@ static inline __le16 ext4_rec_len_to_dis
 
 /* Legal values for the dx_root hash_version field: */
 
-#define DX_HASH_LEGACY		0
-#define DX_HASH_HALF_MD4	1
-#define DX_HASH_TEA		2
-#define DX_HASH_LEGACY_UNSIGNED	3
+#define DX_HASH_LEGACY			0
+#define DX_HASH_HALF_MD4		1
+#define DX_HASH_TEA			2
+#define DX_HASH_LEGACY_UNSIGNED		3
 #define DX_HASH_HALF_MD4_UNSIGNED	4
 #define DX_HASH_TEA_UNSIGNED		5
 
@@ -2000,7 +2000,6 @@ static inline u32 ext4_chksum(struct ext
 		struct shash_desc shash;
 		char ctx[4];
 	} desc;
-	int err;
 
 	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));
 
@@ -2008,8 +2007,7 @@ static inline u32 ext4_chksum(struct ext
 	desc.shash.flags = 0;
 	*(u32 *)desc.ctx = crc;
 
-	err = crypto_shash_update(&desc.shash, address, length);
-	BUG_ON(err);
+	BUG_ON(crypto_shash_update(&desc.shash, address, length));
 
 	return *(u32 *)desc.ctx;
 }
