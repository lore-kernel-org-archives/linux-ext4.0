From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 5/6  V2]Ext4 journal credits  fixes for delalloc writepages
Date: Fri, 15 Aug 2008 17:40:58 -0700
Message-ID: <1218847258.8183.50.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
	 <1218558938.6766.55.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: tytso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:40652 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYHPAlC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 20:41:02 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7G0f1tr001664
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 20:41:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7G0f0Fe131000
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 18:41:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7G0f0wp008256
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 18:41:00 -0600
In-Reply-To: <1218558938.6766.55.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4: journal credit fix the delalloc writepages

From: Mingming Cao <cmm@us.ibm.com>

Previous delalloc writepages implementation start a new transaction outside
a loop call of get_block() to do the block allocation. Due to lack of
information of how many blocks to be allocated, the estimate of the journal
credits is very conservtive and caused many issues.

With the rewored delayed allocation, a new transaction is created for
each get_block(), thus we don't need to guess how many credits for the multiple
chunk of allocation. Start every transaction with credits for insert a
single exent is enough. But we still need to consider the journalled mode,
where it need to account for the number of data blocks.  So we guess
max number of data blocks for each allocation.  Due to the current VFS
implementation writepages() could only flush PAGEVEC lengh of pages at a
time, the max block allocation is limited and calculated based on
that, and the total number of reserved delalloc datablocks, whichever
is smaller.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

Index: linux-2.6.27-rc3/fs/ext4/inode.c
===================================================================
--- linux-2.6.27-rc3.orig/fs/ext4/inode.c	2008-08-15 14:51:22.000000000 -0700
+++ linux-2.6.27-rc3/fs/ext4/inode.c	2008-08-15 17:18:09.000000000 -0700
@@ -1850,8 +1850,11 @@ static void mpage_add_bh_to_extent(struc
 {
 	struct buffer_head *lbh = &mpd->lbh;
 	sector_t next;
+	int nrblocks = lbh->b_size >> mpd->inode->i_blkbits;
 
-	next = lbh->b_blocknr + (lbh->b_size >> mpd->inode->i_blkbits);
+	/* check if thereserved journal credits might overflow */
+	if (nrblocks >EXT4_MAX_TRANS_DATA)
+		goto flush_it;
 
 	/*
 	 * First block in the extent
@@ -1863,6 +1866,7 @@ static void mpage_add_bh_to_extent(struc
 		return;
 	}
 
+	next = lbh->b_blocknr + nrblocks;
 	/*
 	 * Can we merge the block to our big extent?
 	 */
@@ -1871,6 +1875,7 @@ static void mpage_add_bh_to_extent(struc
 		return;
 	}
 
+flush_it:
 	/*
 	 * We couldn't merge the block to our extent, so we
 	 * need to flush current  extent and start new one
@@ -2231,17 +2236,26 @@ static int ext4_da_writepage(struct page
 }
 
 /*
- * For now just follow the DIO way to estimate the max credits
- * needed to write out EXT4_MAX_WRITEBACK_PAGES.
- * todo: need to calculate the max credits need for
- * extent based files, currently the DIO credits is based on
- * indirect-blocks mapping way.
+ * This is called via ext4_da_writepages() to
+ * calulate the total number of credits to reserve to fit
+ * a single extent allocation into a single transaction,
+ * ext4_da_writpeages() will loop calling this before
+ * the block allocation.
  *
- * Probably should have a generic way to calculate credits
- * for DIO, writepages, and truncate
+ * The page vector size limited the max number of pages could
+ * be writeout at a time. Based on this, the max blocks to pass to
+ * get_block is calculated
  */
-#define EXT4_MAX_WRITEBACK_PAGES      DIO_MAX_BLOCKS
-#define EXT4_MAX_WRITEBACK_CREDITS    25
+
+static int ext4_writepages_trans_blocks(struct inode *inode)
+{
+	int max_blocks = EXT4_MAX_TRANS_DATA;
+
+	if (max_blocks > EXT4_I(inode)->i_reserved_data_blocks)
+		max_blocks =  EXT4_I(inode)->i_reserved_data_blocks;
+
+	return ext4_chunk_trans_blocks(inode, max_blocks);
+}
 
 static int ext4_da_writepages(struct address_space *mapping,
                                 struct writeback_control *wbc)
@@ -2283,7 +2297,7 @@ restart_loop:
 		 * by delalloc
 		 */
 		BUG_ON(ext4_should_journal_data(inode));
-		needed_blocks = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
+		needed_blocks = ext4_writepages_trans_blocks(inode);
 
 		/* start a new transaction*/
 		handle = ext4_journal_start(inode, needed_blocks);
@@ -4462,11 +4476,9 @@ int ext4_meta_trans_blocks(struct inode*
  * the modification of a single pages into a single transaction,
  * which may include multile chunk of block allocations.
  *
- * This could be called via ext4_write_begin() or later
- * ext4_da_writepages() in delalyed allocation case.
+ * This could be called via ext4_write_begin()
  *
- * In both case it's possible that we could allocating multiple
- * chunks of blocks. We need to consider the worse case, when
+ * We need to consider the worse case, when
  * one new block per extent.
  */
 int ext4_writepage_trans_blocks(struct inode *inode)


