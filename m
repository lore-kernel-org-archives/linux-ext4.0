From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 11/11] ext4: Retry block allocation if we have free blocks left
Date: Wed, 27 Aug 2008 20:58:36 +0530
Message-ID: <1219850916-8986-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:60864 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755590AbYH0P3T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 11:29:19 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7RFTGvA005867
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:16 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7RFTGU91642736
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:16 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7RFTGQ0022100
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:16 +0530
In-Reply-To: <1219850916-8986-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we truncate files, the meta-data blocks released
are not reused untill we commit the truncate transaction.
That means delayed get_block request will return ENOSPC
even if we have free blocks left. Force a journal commit
and retry block allocation if we get ENOSPC with free
blocks left.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   81 ++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 57 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 24381bb..bbe7fac 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1634,6 +1634,7 @@ static void ext4_da_page_release_reservation(struct page *page,
 	struct writeback_control *wbc;
 	int io_done;
 	long pages_written;
+	int retval;
 };
 
 /*
@@ -1820,6 +1821,24 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
 	return;
 }
 
+static void ext4_print_free_blocks(struct inode *inode)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	printk(KERN_EMERG "Total free blocks count %lld\n",
+			ext4_count_free_blocks(inode->i_sb));
+	printk(KERN_EMERG "Free/Dirty block details\n");
+	printk(KERN_EMERG "free_blocks=%lld\n",
+			percpu_counter_sum(&sbi->s_freeblocks_counter));
+	printk(KERN_EMERG "dirty_blocks=%lld\n",
+			percpu_counter_sum(&sbi->s_dirtyblocks_counter));
+	printk(KERN_EMERG "Block reservation details\n");
+	printk(KERN_EMERG "i_reserved_data_blocks=%lu\n",
+			EXT4_I(inode)->i_reserved_data_blocks);
+	printk(KERN_EMERG "i_reserved_meta_blocks=%lu\n",
+			EXT4_I(inode)->i_reserved_meta_blocks);
+	return;
+}
+
 /*
  * mpage_da_map_blocks - go through given space
  *
@@ -1834,7 +1853,7 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 	int err = 0;
 	struct buffer_head new;
 	struct buffer_head *lbh = &mpd->lbh;
-	sector_t next = lbh->b_blocknr;
+	sector_t next;
 
 	/*
 	 * We consider only non-mapped and non-allocated blocks
@@ -1844,6 +1863,7 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 	new.b_state = lbh->b_state;
 	new.b_blocknr = 0;
 	new.b_size = lbh->b_size;
+	next = lbh->b_blocknr;
 	/*
 	 * If we didn't accumulate anything
 	 * to write simply return
@@ -1860,6 +1880,13 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 		 */
 		if (err == -EAGAIN)
 			return 0;
+
+		if (err == -ENOSPC &&
+				ext4_count_free_blocks(mpd->inode->i_sb)) {
+			mpd->retval = err;
+			return 0;
+		}
+
 		/*
 		 * get block failure will cause us
 		 * to loop in writepages. Because
@@ -1877,8 +1904,7 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 		printk(KERN_EMERG "This should not happen.!! "
 					"Data will be lost\n");
 		if (err == -ENOSPC) {
-			printk(KERN_CRIT "Total free blocks count %lld\n",
-				ext4_count_free_blocks(mpd->inode->i_sb));
+			ext4_print_free_blocks(mpd->inode);
 		}
 		/* invlaidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
@@ -2085,39 +2111,36 @@ static int __mpage_da_writepage(struct page *page,
  */
 static int mpage_da_writepages(struct address_space *mapping,
 			       struct writeback_control *wbc,
-			       get_block_t get_block)
+			       struct mpage_da_data *mpd)
 {
-	struct mpage_da_data mpd;
 	long to_write;
 	int ret;
 
-	if (!get_block)
+	if (!mpd->get_block)
 		return generic_writepages(mapping, wbc);
 
-	mpd.wbc = wbc;
-	mpd.inode = mapping->host;
-	mpd.lbh.b_size = 0;
-	mpd.lbh.b_state = 0;
-	mpd.lbh.b_blocknr = 0;
-	mpd.first_page = 0;
-	mpd.next_page = 0;
-	mpd.get_block = get_block;
-	mpd.io_done = 0;
-	mpd.pages_written = 0;
+	mpd->lbh.b_size = 0;
+	mpd->lbh.b_state = 0;
+	mpd->lbh.b_blocknr = 0;
+	mpd->first_page = 0;
+	mpd->next_page = 0;
+	mpd->io_done = 0;
+	mpd->pages_written = 0;
+	mpd->retval = 0;
 
 	to_write = wbc->nr_to_write;
 
-	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, &mpd);
+	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
 
 	/*
 	 * Handle last extent of pages
 	 */
-	if (!mpd.io_done && mpd.next_page != mpd.first_page) {
-		if (mpage_da_map_blocks(&mpd) == 0)
-			mpage_da_submit_io(&mpd);
+	if (!mpd->io_done && mpd->next_page != mpd->first_page) {
+		if (mpage_da_map_blocks(mpd) == 0)
+			mpage_da_submit_io(mpd);
 	}
 
-	wbc->nr_to_write = to_write - mpd.pages_written;
+	wbc->nr_to_write = to_write - mpd->pages_written;
 	return ret;
 }
 
@@ -2356,6 +2379,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 {
 	handle_t *handle = NULL;
 	loff_t range_start = 0;
+	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	long to_write, pages_skipped = 0;
@@ -2389,6 +2413,9 @@ static int ext4_da_writepages(struct address_space *mapping,
 	range_start =  wbc->range_start;
 	pages_skipped = wbc->pages_skipped;
 
+	mpd.wbc = wbc;
+	mpd.inode = mapping->host;
+
 restart_loop:
 	to_write = wbc->nr_to_write;
 	while (!ret && to_write > 0) {
@@ -2412,11 +2439,17 @@ static int ext4_da_writepages(struct address_space *mapping,
 			dump_stack();
 			goto out_writepages;
 		}
