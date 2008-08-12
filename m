From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 5/6 ]Ext4 journal credits reservation fixes
Date: Tue, 12 Aug 2008 09:35:38 -0700
Message-ID: <1218558938.6766.55.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: tytso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53405 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYHLQgL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2008 12:36:11 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7CGaAIS030304
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:36:10 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7CGaA13239530
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:36:10 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7CGaA7O017792
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:36:10 -0400
In-Reply-To: <1218558190.6766.37.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4: journal credit fix the delalloc writepages

From: Mingming Cao <cmm@us.ibm.com>

Previous delalloc writepages implementation start a new transaction outside
a loop call of get_block() to do the block allocation. Due to lack of information 
of how many blocks to be allocated, the estimate of the journal credits is very
 Conservative and caused many issues.

With the reworked delayed allocation, a new transaction is created for
each get_block(), thus we don't need to guess how many credits for the multiple
chunk of allocation. Start every transaction with credits for insert a single 
extent is enough. But we still need to consider the journalled mode, where
it need to account for the number of data blocks.  So we guess max number of
data blocks for each allocation.  Due to the current VFS implementation
writepages() could only flush PAGEVEC of pages at a time, the max block
allocation is limited and calculated based on that, an the total number
of reserved delalloc datablocks, whichever is smaller.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

Index: linux-2.6.27-rc1/fs/ext4/inode.c
===================================================================
--- linux-2.6.27-rc1.orig/fs/ext4/inode.c	2008-08-12 08:15:59.000000000 -0700
+++ linux-2.6.27-rc1/fs/ext4/inode.c	2008-08-12 08:30:41.000000000 -0700
@@ -2210,17 +2210,28 @@ static int ext4_da_writepage(struct page
 }
 
 /*
- * For now just follow the DIO way to estimate the max credits
- * needed to write out EXT4_MAX_WRITEBACK_PAGES.
- * todo: need to calculate the max credits need for
- * extent based files, currently the DIO credits is based on
- * indirect-blocks mapping way.
- *
- * Probably should have a generic way to calculate credits
- * for DIO, writepages, and truncate
+ * This is called via ext4_da_writepages() to
+ * calulate the total number of credits to reserve to fit
+ * a single extent allocation into a single transaction,
+ * ext4_da_writpeages() will loop calling this before
+ * the block allocation.
+ *
+ * The page vector size limited the max number of pages could
+ * be writeout at a time. Based on this, the max blocks to pass to
+ * get_block is calculated
  */
-#define EXT4_MAX_WRITEBACK_PAGES      DIO_MAX_BLOCKS
-#define EXT4_MAX_WRITEBACK_CREDITS    25
+
+#define		EXT4_MAX_WRITEPAGES_SIZE	PAGEVEC_SIZE
+static int ext4_writepages_trans_blocks(struct inode *inode)
+{
+	int bpp = ext4_journal_blocks_per_page(inode);
+	int max_blocks = EXT4_MAX_WRITEPAGES_SIZE * bpp;
+
+	if (max_blocks > EXT4_I(inode)->i_reserved_data_blocks)
+		max_blocks =  EXT4_I(inode)->i_reserved_data_blocks;
+
+	return ext4_data_trans_blocks(inode, max_blocks);
+}
 
 static int ext4_da_writepages(struct address_space *mapping,
                                 struct writeback_control *wbc)
@@ -2262,7 +2273,7 @@ restart_loop:
 		 * by delalloc
 		 */
 		BUG_ON(ext4_should_journal_data(inode));
-		needed_blocks = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
+		needed_blocks = ext4_writepages_trans_blocks(inode);
 
 		/* start a new transaction*/
 		handle = ext4_journal_start(inode, needed_blocks);
@@ -4449,11 +4460,9 @@ static int ext4_writeblocks_trans_credit
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


