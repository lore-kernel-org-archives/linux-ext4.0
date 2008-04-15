From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Tue, 15 Apr 2008 16:33:17 -0700
Message-ID: <1208302397.3636.49.camel@localhost.localdomain>
References: <20080415161430.GC28699@duck.suse.cz>
	 <1208282932.3636.9.camel@localhost.localdomain>
	 <1208302106.3636.47.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33237 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbYDOXdU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2008 19:33:20 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3FNXJEW032554
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 19:33:19 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3FNXJtn282706
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 19:33:19 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3FNXJ2H025465
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 19:33:19 -0400
In-Reply-To: <1208302106.3636.47.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-04-15 at 16:28 -0700, Mingming Cao wrote:
> On Tue, 2008-04-15 at 11:08 -0700, Mingming Cao wrote:
> > On Tue, 2008-04-15 at 18:14 +0200, Jan Kara wrote:
> > >   Hi,
> > > 
> > >   I've ported my patch inversing locking ordering of page_lock and
> > > transaction start to ext4 (on top of ext4 patch queue). Everything except
> > > delayed allocation is converted (the patch is below for interested
> > > readers). The question is how to proceed with delayed allocation. Its
> > > current implementation in VFS is designed to work well with the old
> > > ordering (page lock first, then start a transaction). We could bend it to
> > > work with the new locking ordering but I really see no point since ext4 is
> > > the only user. 
> > 
> > I think the plan is port the changes to ext2/3/JFS and support delayed
> > allocation on those filesystems. 
> > 
> > > Also XFS has AFAIK ordering first start transaction, then
> > > lock pages so if we should ever merge delayed alloc implementations the new
> > > ordering would make it easier.
> > >   So what do people think here? Do you agree with reimplementing current
> > > mpage_da_... functions?
> > 
> > It worth a try, but I could not see how to bend delayed allocation to
> > work the new ordering:( With delayed allocation Ext4 gets into
> > writepage() directly with page locked, but we need to start transaction
> > to do block allocation...:(
> 
> Looked again it seems possible to reservse the order with delayed
> allocation. with ext3_da_writepgaes() we could start the journal before
> calling mpage_da_writepages()(which will lock the pages), instead of
> start the journal inside ext4_da_get_block_write(). So that we could get
> the locking order right. Just need to taking care of the estimated
> credits right.
> 
> How about this? (untested, just throw out for comment)

Seems sent out an old version, this version compiles

---
 fs/ext4/inode.c |   53 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 13 deletions(-)

Index: linux-2.6.25-rc9/fs/ext4/inode.c
===================================================================
--- linux-2.6.25-rc9.orig/fs/ext4/inode.c	2008-04-15 15:40:33.000000000 -0700
+++ linux-2.6.25-rc9/fs/ext4/inode.c	2008-04-15 16:32:10.000000000 -0700
@@ -1437,18 +1437,12 @@ static int ext4_da_get_block_prep(struct
 static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
-	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 	loff_t disksize = EXT4_I(inode)->i_disksize;
 	handle_t *handle = NULL;
 
-	if (create) {
-		handle = ext4_journal_start(inode, needed_blocks);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			goto out;
-		}
-	}
+	handle = ext4_journal_current_handle();
 
 	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
 				   bh_result, create, 0);
@@ -1483,17 +1477,51 @@ static int ext4_da_get_block_write(struc
 		ret = 0;
 	}
 
-out:
-	if (handle && !IS_ERR(handle))
-		ext4_journal_stop(handle);
-
 	return ret;
 }
 
+/*
+ * For now just follow the DIO way to estimate the max credits
+ * needed to write out EXT4_MAX_BUF_BLOCKS pages.
+ * todo: need to calculate the max credits need for
+ * extent based files, currently the DIO credits is based on
+ * indirect-blocks mapping way.
+ *
+ * Probably should have a generic way to calculate credits
+ * for DIO, writepages, and truncate
+ */
+#define EXT4_MAX_BUF_BLOCKS	DIO_MAX_BLOCKS
+#define EXT4_MAX_BUF_CREDITS	DIO_CREDITS
+
 static int ext4_da_writepages(struct address_space *mapping,
 				struct writeback_control *wbc)
 {
-	return mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
+	struct inode *inode = mapping->host;
+	handle_t *handle = NULL;
+	int needed_blocks;
+	int ret;
+
+	/*
+	 * Estimate the worse case needed credits to write out
+	 * EXT4_MAX_BUF_BLOCKS pages
+	 */
+	needed_blocks = EXT4_MAX_BUF_CREDITS;
+
+	/* start the transaction with credits*/
+	handle = ext4_journal_start(inode, needed_blocks);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		return ret;
+	}
+
+	/* set the max pages could be write-out at a time */
+	wbc->range_end = wbc->range_start +
+			EXT4_MAX_BUF_BLOCKS << PAGE_CACHE_SHIFT - 1;
+
+	ret = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
+	ext4_journal_stop(handle);
+
+	return ret;
 }
 
 static int ext4_da_write_begin(struct file *file, struct address_space *mapping,




