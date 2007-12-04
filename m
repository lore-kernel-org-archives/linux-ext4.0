From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3] ext4: different maxbytes functions for bitmap & extent
 files
Date: Tue, 04 Dec 2007 09:58:11 -0600
Message-ID: <47557913.3090208@redhat.com>
References: <47557870.9060405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbXLDP6O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2007 10:58:14 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lB4FwD5e017302
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 10:58:13 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB4FwCOF024576
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 10:58:12 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB4FwBIR026907
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 10:58:12 -0500
In-Reply-To: <47557870.9060405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

use 2 different maxbytes functions for bitmapped & extent-based
files.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc3/fs/ext4/super.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ext4/super.c
+++ linux-2.6.24-rc3/fs/ext4/super.c
@@ -1656,17 +1656,57 @@ static void ext4_orphan_cleanup (struct 
 }
 
 /*
- * Maximal file size.  There is a direct, and {,double-,triple-}indirect
+ * Maximal extent format file size.
+ * Resulting logical blkno at s_maxbytes must fit in our on-disk
+ * extent format containers, within a sector_t, and within i_blocks
+ * in the vfs.  ext4 inode has 48 bits of i_block in fsblock units,
+ * so that won't be a limiting factor.
+ *
+ * Note, this does *not* consider any metadata overhead for vfs i_blocks.
+ */
+static loff_t ext4_max_size(int blkbits)
+{
+	loff_t res;
+	loff_t upper_limit = MAX_LFS_FILESIZE;
+
+	/* small i_blocks in vfs inode? */
+	if (sizeof(blkcnt_t) < sizeof(u64)) {
+		/*
+		 * CONFIG_LSF is not enabled implies the inode
+		 * i_block represent total blocks in 512 bytes
+		 * 32 == size of vfs inode i_blocks * 8
+		 */
+		upper_limit = (1LL << 32) - 1;
+
+		/* total blocks in file system block size */
+		upper_limit >>= (blkbits - 9);
+		upper_limit <<= blkbits;
+	}
+
+	/* 32-bit extent-start container, ee_block */
+	res = 1LL << 32;
+	res <<= blkbits;
+	res -= 1;
+
+	/* Sanity check against vm- & vfs- imposed limits */
+	if (res > upper_limit)
+		res = upper_limit;
+
+	return res;
+}
+
+/*
+ * Maximal bitmap file size.  There is a direct, and {,double-,triple-}indirect
  * block limit, and also a limit of (248 - 1) 512-byte sectors in i_blocks.
  * We need to be 1 filesystem block less than the 248 sector limit.
  */
-static loff_t ext4_max_size(int bits)
+static loff_t ext4_max_bitmap_size(int bits)
 {
 	loff_t res = EXT4_NDIR_BLOCKS;
 	int meta_blocks;
 	loff_t upper_limit;
 	/* This is calculated to be the largest file size for a
-	 * dense, file such that the total number of
+	 * dense, bitmapped file such that the total number of
 	 * sectors in the file, including data and all indirect blocks,
 	 * does not exceed 248 -1
 	 * __u32 i_blocks_lo and _u16 i_blocks_high representing the
