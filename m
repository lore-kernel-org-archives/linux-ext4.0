From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: fix sparse warnings with new shash api usage
Date: Wed, 26 Nov 2014 15:51:09 -0800
Message-ID: <20141126235109.GO10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22596 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKZXvP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2014 18:51:15 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use __le32, not u32 so that sparse is happy.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4.h       |    6 +++---
 include/linux/jbd2.h |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 93e0efe..da83f20 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1784,15 +1784,15 @@ static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 		struct shash_desc shash;
 		char ctx[4];
 	} desc;
-	u32 out_crc;
+	__le32 out_crc;
 	int err;
 
 	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));
 
 	desc.shash.tfm = sbi->s_chksum_driver;
 	desc.shash.flags = 0;
-	crc = cpu_to_le32(crc);
-	crypto_shash_setkey(desc.shash.tfm, (u8 *)&crc, sizeof(crc));
+	out_crc = cpu_to_le32(crc);
+	crypto_shash_setkey(desc.shash.tfm, (u8 *)&out_crc, sizeof(out_crc));
 	crypto_shash_init(&desc.shash);
 
 	err = crypto_shash_update(&desc.shash, address, length);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 8ce1196..ae365ca 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1374,7 +1374,7 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
 		struct shash_desc shash;
 		char ctx[JBD_MAX_CHECKSUM_SIZE];
 	} desc;
-	u32 out_crc;
+	__le32 out_crc;
 	int err;
 
 	BUG_ON(crypto_shash_descsize(journal->j_chksum_driver) >
@@ -1382,8 +1382,8 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
 
 	desc.shash.tfm = journal->j_chksum_driver;
 	desc.shash.flags = 0;
-	crc = cpu_to_le32(crc);
-	crypto_shash_setkey(desc.shash.tfm, (u8 *)&crc, sizeof(crc));
+	out_crc = cpu_to_le32(crc);
+	crypto_shash_setkey(desc.shash.tfm, (u8 *)&out_crc, sizeof(out_crc));
 	crypto_shash_init(&desc.shash);
 
 	err = crypto_shash_update(&desc.shash, address, length);
