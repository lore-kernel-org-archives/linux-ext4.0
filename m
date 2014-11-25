From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: use the shash api correctly for crc32c
Date: Tue, 25 Nov 2014 13:32:59 -0800
Message-ID: <20141125213259.GM10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43889 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaKYVdG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2014 16:33:06 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since we're using the crypto shash API, let's use the full API to set
the seed and get the final checksum instead assuming the private data
structure layout in crc32c.ko to which we're not privy.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4.h       |    8 ++++++--
 include/linux/jbd2.h |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 67352ab..93e0efe 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1784,18 +1784,22 @@ static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 		struct shash_desc shash;
 		char ctx[4];
 	} desc;
+	u32 out_crc;
 	int err;
 
 	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));
 
 	desc.shash.tfm = sbi->s_chksum_driver;
 	desc.shash.flags = 0;
-	*(u32 *)desc.ctx = crc;
+	crc = cpu_to_le32(crc);
+	crypto_shash_setkey(desc.shash.tfm, (u8 *)&crc, sizeof(crc));
+	crypto_shash_init(&desc.shash);
 
 	err = crypto_shash_update(&desc.shash, address, length);
 	BUG_ON(err);
 
-	return *(u32 *)desc.ctx;
+	crypto_shash_final(&desc.shash, (u8 *)&out_crc);
+	return le32_to_cpu(~out_crc);
 }
 
 #ifdef __KERNEL__
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 704b9a5..8ce1196 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1374,6 +1374,7 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
 		struct shash_desc shash;
 		char ctx[JBD_MAX_CHECKSUM_SIZE];
 	} desc;
+	u32 out_crc;
 	int err;
 
 	BUG_ON(crypto_shash_descsize(journal->j_chksum_driver) >
@@ -1381,12 +1382,15 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
 
 	desc.shash.tfm = journal->j_chksum_driver;
 	desc.shash.flags = 0;
-	*(u32 *)desc.ctx = crc;
+	crc = cpu_to_le32(crc);
+	crypto_shash_setkey(desc.shash.tfm, (u8 *)&crc, sizeof(crc));
+	crypto_shash_init(&desc.shash);
 
 	err = crypto_shash_update(&desc.shash, address, length);
 	BUG_ON(err);
 
-	return *(u32 *)desc.ctx;
+	crypto_shash_final(&desc.shash, (u8 *)&out_crc);
+	return le32_to_cpu(~out_crc);
 }
 
 /* Return most recent uncommitted transaction */
