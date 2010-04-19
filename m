From: <gregkh@suse.de>
Subject: patch ext4-retry-block-allocation-if-we-have-free-blocks-left.patch added to 2.6.27-stable tree
Date: Mon, 19 Apr 2010 10:26:59 -0700
Message-ID: <12716980192442@kroah.org>
References: <1268699165-17461-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com,
	dev@jaysonking.com, gregkh@suse.de, linux-ext4@vger.kernel.org,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab0DSRaA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 13:30:00 -0400
In-Reply-To: <1268699165-17461-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Retry block allocation if we have free blocks left

to the 2.6.27-stable tree.  Its filename is

    ext4-retry-block-allocation-if-we-have-free-blocks-left.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Mon Apr 19 10:22:08 2010
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Mon, 15 Mar 2010 20:26:00 -0400
Subject: ext4: Retry block allocation if we have free blocks left
To: stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Mingming Cao <cmm@us.ibm.com>, "Jayson R. King" <dev@jaysonking.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <1268699165-17461-7-git-send-email-tytso@mit.edu>


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit df22291ff0fde0d350cf15dac3e5cc33ac528875 upstream.

When we truncate files, the meta-data blocks released are not reused
untill we commit the truncate transaction.  That means delayed get_block
request will return ENOSPC even if we have free blocks left.  Force a
journal commit and retry block allocation if we get ENOSPC with free
blocks left.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jayson R. King <dev@jaysonking.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   81 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 24 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1661,6 +1661,7 @@ struct mpage_da_data {
 	struct writeback_control *wbc;
 	int io_done;
 	long pages_written;
+	int retval;
 };
 
 /*
@@ -1858,6 +1859,24 @@ static void ext4_da_block_invalidatepage
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
@@ -1872,7 +1891,7 @@ static int  mpage_da_map_blocks(struct m
 	int err = 0;
 	struct buffer_head new;
 	struct buffer_head *lbh = &mpd->lbh;
-	sector_t next = lbh->b_blocknr;
+	sector_t next;
 
 	/*
 	 * We consider only non-mapped and non-allocated blocks
@@ -1882,6 +1901,7 @@ static int  mpage_da_map_blocks(struct m
 	new.b_state = lbh->b_state;
 	new.b_blocknr = 0;
 	new.b_size = lbh->b_size;
+	next = lbh->b_blocknr;
 	/*
 	 * If we didn't accumulate anything
 	 * to write simply return
@@ -1898,6 +1918,13 @@ static int  mpage_da_map_blocks(struct m
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
@@ -1915,8 +1942,7 @@ static int  mpage_da_map_blocks(struct m
 		printk(KERN_EMERG "This should not happen.!! "
 					"Data will be lost\n");
 		if (err == -ENOSPC) {
-			printk(KERN_CRIT "Total free blocks count %lld\n",
-				ext4_count_free_blocks(mpd->inode->i_sb));
+			ext4_print_free_blocks(mpd->inode);
 		}
 		/* invlaidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
@@ -2141,39 +2167,36 @@ static int __mpage_da_writepage(struct p
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
 
@@ -2420,6 +2443,7 @@ static int ext4_da_writepages(struct add
 {
 	handle_t *handle = NULL;
 	loff_t range_start = 0;
+	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	long to_write, pages_skipped = 0;
@@ -2467,6 +2491,9 @@ static int ext4_da_writepages(struct add
 	range_start =  wbc->range_start;
 	pages_skipped = wbc->pages_skipped;
 
+	mpd.wbc = wbc;
+	mpd.inode = mapping->host;
+
 restart_loop:
 	to_write = wbc->nr_to_write;
 	while (!ret && to_write > 0) {
@@ -2502,11 +2529,17 @@ restart_loop:
 				goto out_writepages;
 			}
 		}
-
 		to_write -= wbc->nr_to_write;
-		ret = mpage_da_writepages(mapping, wbc,
-					  ext4_da_get_block_write);
+
+		mpd.get_block = ext4_da_get_block_write;
+		ret = mpage_da_writepages(mapping, wbc, &mpd);
+
 		ext4_journal_stop(handle);
+
+		if (mpd.retval == -ENOSPC)
+			jbd2_journal_force_commit_nested(sbi->s_journal);
+
+		/* reset the retry count */
 		if (ret == MPAGE_DA_EXTENT_TAIL) {
 			/*
 			 * got one extent now try with


Patches currently in stable-queue which might be from aneesh.kumar@linux.vnet.ibm.com are

queue-2.6.27/ext4-fix-file-fragmentation-during-large-file-write.patch
queue-2.6.27/ext4-retry-block-allocation-if-we-have-free-blocks-left.patch
queue-2.6.27/vfs-add-no_nrwrite_index_update-writeback-control-flag.patch
queue-2.6.27/ext4-retry-block-reservation.patch
queue-2.6.27/ext4-invalidate-pages-if-delalloc-block-allocation-fails.patch
queue-2.6.27/ext4-use-tag-dirty-lookup-during-mpage_da_submit_io.patch
queue-2.6.27/vfs-remove-the-range_cont-writeback-mode.patch
queue-2.6.27/ext4-make-sure-all-the-block-allocation-paths-reserve-blocks.patch
queue-2.6.27/ext4-implement-range_cyclic-in-ext4_da_writepages-instead-of-write_cache_pages.patch
queue-2.6.27/ext4-add-percpu-dirty-block-accounting.patch
