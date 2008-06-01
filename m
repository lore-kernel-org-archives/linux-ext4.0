From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC][PATCH 3/6] delalloc ENOSPC: reserve blocks
Date: Sun, 01 Jun 2008 16:35:55 -0700
Message-ID: <1212363355.4368.66.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:40670 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYFAXgC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2008 19:36:02 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m51Na1Qo027100
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:36:01 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m51Na1qR128954
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:36:01 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m51Na1XY004794
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:36:01 -0600
Received: from [9.67.174.55] (wecm-9-67-174-55.wecm.ibm.com [9.67.174.55])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m51Na0X7004774
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:36:00 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: delalloc ENOSPC handling core

From: Mingming cao <cmm@us.ibm.com>

Core part of delaloc ENOSPC (block reservation.) 
data/meta blocks are reserved on write_begin(), and per-inode reserved counters
are updated  after block allocation.
 
Signed-off-by: Mingming cao <cmm@us.ibm.com>

---
 fs/ext4/inode.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 3 deletions(-)

Index: linux-2.6.26-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/inode.c	2008-06-01 14:26:13.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/inode.c	2008-06-01 15:04:06.000000000 -0700
@@ -38,6 +38,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "ext4_extents.h"
 
 static void ext4_invalidatepage(struct page *page, unsigned long offset);
 
@@ -1410,6 +1411,61 @@ static int ext4_journalled_write_end(str
 	return ret ? ret : copied;
 }
 
+static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
+{
+       struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+       unsigned long md_needed, mdblocks, total = 0;
+
+       /*
+        * calculate the amount of metadata blocks to reserve
+	* in order to allocate nrblocks
+	* worse case is one extent per block
+	*/
+	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
+	mdblocks = ext4_ext_calc_metadata_amount(inode, total);
+	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
+
+	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
+	total = md_needed + nrblocks;
+
+	if (ext4_has_free_blocks(sbi, total) < total)
+		return -ENOSPC;
+
+	/* reduce fs free blocks counter */
+	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
+
+	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
+	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
+
+	return 0;       /* success */
+}
+
+static void ext4_da_release_space(struct inode *inode, int used, int to_free)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	int total, mdb, release;
+
+	/* calculate the number of metablocks still need to be reserved */
+	total = EXT4_I(inode)->i_reserved_data_blocks - used - to_free;
+	mdb = ext4_ext_calc_metadata_amount(inode, total);
+
+	/* figure out how many metablocks to release */
+	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
+	mdb = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
+
+	release = to_free + mdb;
+
+	/* update fs free blocks counter for truncate case */
+	percpu_counter_add(&sbi->s_freeblocks_counter, release);
+
+	/* update per-inode reservations */
+	BUG_ON(used + to_free > EXT4_I(inode)->i_reserved_data_blocks);
+	EXT4_I(inode)->i_reserved_data_blocks -= used + to_free;
+
+	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
+	EXT4_I(inode)->i_reserved_meta_blocks -= mdb;
+}
+
 /*
  * this is a special callback for ->write_begin() only
  * it's intention is to return mapped block or reserve space
@@ -1428,13 +1484,17 @@ static int ext4_da_get_block_prep(struct
 	 * the same as allocated blocks.
 	 */
 	ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0);
-	if (ret == 0) {
-		/* the block isn't allocated yet, let's reserve space */
-		/* XXX: call reservation here */
+	if ((ret == 0)&& !buffer_delay(bh_result)) {
+		/* the block isn't (pre)allocated yet, let's reserve space */
 		/*
 		 * XXX: __block_prepare_write() unmaps passed block,
 		 * is it OK?
 		 */
+		ret = ext4_da_reserve_space(inode, 1);
+		if (ret)
+			/* not enough space to reserve */
+			return ret;
+
 		map_bh(bh_result, inode->i_sb, 0);
 		set_buffer_new(bh_result);
 		set_buffer_delay(bh_result);
@@ -1463,6 +1523,9 @@ static int ext4_da_get_block_write(struc
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 
+		/* release reserved-but-unused meta blocks */
+		ext4_da_release_space(inode, ret, 0);
+
 		/*
 		 * Update on-disk size along with block allocation
 		 * we don't use 'extend_disksize' as size may change


