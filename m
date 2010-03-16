From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.27.y 06/11] ext4: Retry block allocation if we have free blocks left
Date: Mon, 15 Mar 2010 20:26:00 -0400
Message-ID: <1268699165-17461-7-git-send-email-tytso@mit.edu>
References: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Cc: "Jayson R. King" <dev@jaysonking.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38655 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937230Ab0CPA0M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Mar 2010 20:26:12 -0400
In-Reply-To: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
---
 fs/ext4/inode.c |   81 ++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 57 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e82b895..71901ae 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1661,6 +1661,7 @@ struct mpage_da_data {
 	struct writeback_control *wbc;
 	int io_done;
 	long pages_written;
+	int retval;
 };
 
 /*
@@ -1858,6 +1859,24 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
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
@@ -1872,7 +1891,7 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 	int err = 0;
 	struct buffer_head new;
 	struct buffer_head *lbh = &mpd->lbh;
-	sector_t next = lbh->b_blocknr;
+	sector_t next;
 
 	/*
 	 * We consider only non-mapped and non-allocated blocks
@@ -1882,6 +1901,7 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 	new.b_state = lbh->b_state;
 	new.b_blocknr = 0;
 	new.b_size = lbh->b_size;
+	next = lbh->b_blocknr;
 	/*
 	 * If we didn't accumulate anything
 	 * to write simply return
@@ -1898,6 +1918,13 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
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
@@ -1915,8 +1942,7 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 		printk(KERN_EMERG "This should not happen.!! "
 					"Data will be lost\n");
 		if (err == -ENOSPC) {
-			printk(KERN_CRIT "Total free blocks count %lld\n",
-				ext4_count_free_blocks(mpd->inode->i_sb));
+			ext4_print_free_blocks(mpd->inode);
 		}
 		/* invlaidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
@@ -2141,39 +2167,36 @@ static int __mpage_da_writepage(struct page *page,
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
 
@@ -2420,6 +2443,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 {
 	handle_t *handle = NULL;
 	loff_t range_start = 0;
+	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	long to_write, pages_skipped = 0;
@@ -2467,6 +2491,9 @@ static int ext4_da_writepages(struct address_space *mapping,
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
