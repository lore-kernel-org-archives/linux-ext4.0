From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 Secure Delete 7/7v4] ext4/jbd2: Secure Delete: Secure delete journal blocks
Date: Fri,  7 Oct 2011 00:11:05 -0700
Message-ID: <1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47124 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758789Ab1JGHHT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Oct 2011 03:07:19 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 7 Oct 2011 03:07:18 -0400
In-Reply-To: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch modifies both ext4 and jbd2 such that the journal
blocks which may contain file data, are securely deleted
after the files data blocks are deleted.

Because old journal blocks may contain file data, we need
a way to find those blocks again when it comes time to secure
delete the file.  This patch adds a new list to the journal
structure to keep track of which vfs blocks the journal blocks
contain.

After a truncate or a punch hole operation has completed, a
new function ext4_secure_delete_jblks is called that flushes
the journal, and then searches the list for any journal blocks
that were used to journal the blocks that were just removed.
The found journal blocks are then secure deleted.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 0cba63b... fdf73b5... M	fs/ext4/ext4.h
:100644 100644 984fac2... 81df943... M	fs/ext4/extents.c
:100644 100644 bd1facd... 083c516... M	fs/ext4/inode.c
:100644 100644 eef6979... 2734e7b... M	fs/jbd2/commit.c
:100644 100644 f24df13... 6dd8af7... M	fs/jbd2/journal.c
:100644 100644 38f307b... 8b84b43... M	include/linux/jbd2.h
 fs/ext4/ext4.h       |    3 +
 fs/ext4/extents.c    |   12 +++++
 fs/ext4/inode.c      |  110 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/jbd2/commit.c     |    6 +++
 fs/jbd2/journal.c    |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h |   21 +++++++++
 6 files changed, 264 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0cba63b..fdf73b5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2230,6 +2230,9 @@ extern int ext4_secure_delete_lblks(struct inode *inode,
 			ext4_lblk_t first_block, unsigned long count);
 extern int ext4_secure_delete_pblks(struct inode *inode,
 			ext4_fsblk_t block, unsigned long count);
+extern int ext4_secure_delete_jblks(struct inode *inode,
+				ext4_lblk_t first_block, unsigned long count);
+
 
 /* move_extent.c */
 extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 984fac2..81df943 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4159,6 +4159,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	struct super_block *sb = inode->i_sb;
 	struct ext4_ext_cache cache_ex;
 	ext4_lblk_t first_block, last_block, num_blocks, iblock, max_blocks;
+	ext4_lblk_t first_secrm_blk, last_secrm_blk, secrm_blk_count;
 	struct address_space *mapping = inode->i_mapping;
 	struct ext4_map_blocks map;
 	handle_t *handle;
@@ -4317,6 +4318,17 @@ out:
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
+
+	if (!err && EXT4_I(inode)->i_flags & EXT4_SECRM_FL) {
+		first_secrm_blk = offset >> EXT4_BLOCK_SIZE_BITS(sb);
+		last_secrm_blk = (offset + length + sb->s_blocksize - 1) >>
+			EXT4_BLOCK_SIZE_BITS(sb);
+		secrm_blk_count = last_secrm_blk - first_secrm_blk;
+
+		err = ext4_secure_delete_jblks(inode,
+		   first_secrm_blk, secrm_blk_count);
+	}
+
 	return err;
 }
 int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bd1facd..083c516 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -909,6 +909,110 @@ int ext4_secure_delete_lblks(struct inode *inode, ext4_lblk_t first_block,
 	return err;
 }
 
+/*
+ * ext4_secure_delete_jblks()
+ *
+ * Secure deletes the journal blocks that contain
+ * the specified logical blocks
+ *
+ * @inode: The files inode
+ * @first_block: Starting logical block
+ * @count: The number of blocks to secure delete
+ *         from the journal
+ *
+ * Returns 0 on sucess or negative on error
+ */
+int ext4_secure_delete_jblks(struct inode *inode,
+				ext4_lblk_t first_block, unsigned long count){
+
+	unsigned long long jbd2_pblk_start = 0;
+	unsigned long long jbd2_pblk_count = 0;
+	ext4_lblk_t last_block = 0;
+	struct list_head *tmp = NULL;
+	struct list_head *cur = NULL;
+	struct jbd2_blk_pair *b_pair = NULL;
+	int err = 0;
+	journal_t *journal = EXT4_JOURNAL(inode);
+
+	/* Do not allow last_block to wrap */
+	last_block = first_block + count;
+	if (last_block < first_block)
+		last_block = EXT_MAX_BLOCKS;
+
+	/*
+	 * Force the journal to finnish up any pending transactions
+	 * before we start secure deleteing journal blocks
+	 */
+	err = ext4_force_commit((inode)->i_sb);
+	if (err)
+		return err;
+
+	spin_lock(&journal->j_pair_lock);
+
+	/* Loop over the journals blocks looking for our logical blocks */
+	list_for_each_safe(cur, tmp, &journal->blk_pairs) {
+		b_pair = list_entry(cur, struct jbd2_blk_pair, list);
+		if ((b_pair->vfs_inode == inode) &&
+			(b_pair->vfs_lblk >= first_block) &&
+			(b_pair->vfs_lblk < last_block)) {
+
+			/*
+			 * It is likely that the journal blocks will be
+			 * consecutive, so lets try to secure delete them
+			 * in ranges
+			 */
+			if (jbd2_pblk_count == 0) {
+				/*
+				 * If there are no blocks in our range,
+				 * then this one will be the first
+				 */
+				jbd2_pblk_start = b_pair->jbd2_pblk;
+				jbd2_pblk_count = 1;
+			} else if ((b_pair->jbd2_pblk) ==
+				   (jbd2_pblk_start + jbd2_pblk_count)) {
+				/*
+				 * If this journal block is physically
+				 * consecutive, then just increase the range
+				 */
+				jbd2_pblk_count++;
+			} else if ((b_pair->jbd2_pblk) ==
+					(jbd2_pblk_start - 1) &&
+					jbd2_pblk_start > 0) {
+				/*
+				 * If this journal block is physically
+				 * consecutive (from the start of the
+				 * range), just increase the range from the
+				 * other end.
+				 */
+				jbd2_pblk_count++;
+				jbd2_pblk_start--;
+			} else {
+				/*
+				 * If the block was not consecutive, secure
+				 * delete the range, and restart the current
+				 * range
+				 */
+
+				err = ext4_secure_delete_pblks(journal->j_inode,
+					jbd2_pblk_start, jbd2_pblk_count);
+				if (err)
+					goto out;
+				jbd2_pblk_start = b_pair->jbd2_pblk;
+				jbd2_pblk_count = 1;
+			}
+		}
+	}
+
+	/* Secure delete any blocks still in our range */
+	if (jbd2_pblk_count > 0)
+		err = ext4_secure_delete_pblks(journal->j_inode,
+			jbd2_pblk_start, jbd2_pblk_count);
+
+out:
+	spin_unlock(&journal->j_pair_lock);
+	return err;
+}
+
 struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 			       ext4_lblk_t block, int create, int *err)
 {
@@ -3447,6 +3551,12 @@ void ext4_truncate(struct inode *inode)
 	else
 		ext4_ind_truncate(inode);
 
+	if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL) {
+		err = ext4_secure_delete_jblks(inode,
+			inode->i_size >> EXT4_BLOCK_SIZE_BITS(inode->i_sb),
+			EXT_MAX_BLOCKS);
+	}
+
 	trace_ext4_truncate_exit(inode);
 }
 
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index eef6979..2734e7b 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -593,6 +593,12 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 			jbd2_journal_abort(journal, flags);
 			continue;
 		}
+
+		err = jbd2_record_pair(journal, jh2bh(jh), jh2bh(new_jh));
+		if (err) {
+			jbd2_journal_abort(journal, flags);
+			continue;
+		}
 		set_bit(BH_JWrite, &jh2bh(new_jh)->b_state);
 		wbuf[bufs++] = jh2bh(new_jh);
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index f24df13..6dd8af7 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -248,6 +248,100 @@ static void journal_kill_thread(journal_t *journal)
 	}
 	write_unlock(&journal->j_state_lock);
 }
+/*
+ * jbd2_record_pair()
+ * Updates the journals list of block pairs to contain an new pair of journal
+ * to vfs blocks.  This list is an in memory record of the journals blocks to
+ * help facilitate finding out what vfs blocks the journal blocks contain.
+ * Secure delete uses this list to clear out stale journal blocks that may
+ * still contain file data that needs to be secure deleted. This list is updated
+ * when a vfs data block is written to the journal or when a descriptor block
+ * is written to the journal.
+ *
+ * journal: The journal to update
+ * vfs_bh:  The vfs buffer_head that the jbd2_bh is journaling.  This
+ *          may be NULL if jbd2_bh does not represent a vfs block.
+ * jbd2_bh: The jbd2 buffer_head that has just been allocated for some
+ *          use in the journal. jbd2_bh may not be NULL.
+ *
+ * Returns 0 on sucess or negative on failure
+ */
+int jbd2_record_pair(journal_t *journal,
+		struct buffer_head *vfs_bh,
+		struct buffer_head *jbd2_bh){
+
+	struct page *page;
+	struct buffer_head *bh;
+	struct buffer_head *head;
+	pgoff_t index;
+	struct jbd2_blk_pair *b_pair = NULL;
+	struct list_head *cur;
+	unsigned long long vfs_lblk = 0;
+	unsigned long long vfs_pblk = 0;
+	struct inode *vfs_inode = NULL;
+
+	/* If we have the vfs bh, figure out the logical block offset */
+	if (vfs_bh) {
+		page = vfs_bh->b_page;
+		vfs_inode = page->mapping->host;
+		vfs_pblk = vfs_bh->b_blocknr;
+		index = page->index;
+
+		/* Find the block offset of the page */
+		vfs_lblk = index <<
+			(PAGE_CACHE_SHIFT - vfs_inode->i_sb->s_blocksize_bits);
+
+		/* Then add in the block offset of the bh in the page */
+		bh = page_buffers(page);
+		head = bh;
+		do {
+			if (bh == vfs_bh)
+				break;
+			bh = bh->b_this_page;
+			vfs_lblk++;
+		} while (bh != head);
+	}
+
+	spin_lock(&journal->j_pair_lock);
+	/*
+	 * Add the pair to the list.  If there is already a pair
+	 * for this journal block, just update it with the new vfs
+	 * block info
+	 */
+	list_for_each(cur, &journal->blk_pairs) {
+		b_pair = list_entry(cur, struct jbd2_blk_pair, list);
+		if (b_pair->jbd2_pblk == jbd2_bh->b_blocknr) {
+			b_pair->vfs_inode = vfs_inode;
+			b_pair->vfs_pblk = vfs_pblk;
+			b_pair->vfs_lblk = vfs_lblk;
+			b_pair->jbd2_pblk = jbd2_bh->b_blocknr;
+
+			break;
+		} else
+			b_pair = NULL;
+	}
+
+	/*
+	 * If the journal block was not found in the list,
+	 * add a new pair to the list
+	 */
+	if (!b_pair) {
+		b_pair = kzalloc(sizeof(struct jbd2_blk_pair), GFP_NOFS);
+		if (!b_pair) {
+			spin_unlock(&journal->j_pair_lock);
+			return -ENOMEM;
+		}
+		b_pair->jbd2_pblk = jbd2_bh->b_blocknr;
+		b_pair->vfs_inode = vfs_inode;
+		b_pair->vfs_pblk = vfs_pblk;
+		b_pair->vfs_lblk = vfs_lblk;
+
+		list_add(&b_pair->list, &journal->blk_pairs);
+	}
+
+	spin_unlock(&journal->j_pair_lock);
+	return 0;
+}
 
 /*
  * jbd2_journal_write_metadata_buffer: write a metadata buffer to the journal.
@@ -739,7 +833,13 @@ struct journal_head *jbd2_journal_get_descriptor_buffer(journal_t *journal)
 	lock_buffer(bh);
 	memset(bh->b_data, 0, journal->j_blocksize);
 	set_buffer_uptodate(bh);
+	err = jbd2_record_pair(journal, NULL, bh);
+
 	unlock_buffer(bh);
+
+	if (err)
+		return NULL;
+
 	BUFFER_TRACE(bh, "return this buffer");
 	return jbd2_journal_add_journal_head(bh);
 }
@@ -895,9 +995,11 @@ static journal_t * journal_init_common (void)
 	init_waitqueue_head(&journal->j_wait_commit);
 	init_waitqueue_head(&journal->j_wait_updates);
 	mutex_init(&journal->j_barrier);
+	INIT_LIST_HEAD(&journal->blk_pairs);
 	mutex_init(&journal->j_checkpoint_mutex);
 	spin_lock_init(&journal->j_revoke_lock);
 	spin_lock_init(&journal->j_list_lock);
+	spin_lock_init(&journal->j_pair_lock);
 	rwlock_init(&journal->j_state_lock);
 
 	journal->j_commit_interval = (HZ * JBD2_DEFAULT_MAX_COMMIT_AGE);
@@ -1361,6 +1463,8 @@ recovery_error:
 int jbd2_journal_destroy(journal_t *journal)
 {
 	int err = 0;
+	struct list_head *cur;
+	struct jbd2_blk_pair *b_pair;
 
 	/* Wait for the commit thread to wake up and die. */
 	journal_kill_thread(journal);
@@ -1405,6 +1509,14 @@ int jbd2_journal_destroy(journal_t *journal)
 		iput(journal->j_inode);
 	if (journal->j_revoke)
 		jbd2_journal_destroy_revoke(journal);
+
+	spin_lock(&journal->j_pair_lock);
+	list_for_each_prev(cur, &journal->blk_pairs) {
+		b_pair = list_entry(cur, struct jbd2_blk_pair, list);
+		kfree(b_pair);
+	}
+	spin_unlock(&journal->j_pair_lock);
+
 	kfree(journal->j_wbuf);
 	kfree(journal);
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 38f307b..8b84b43 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -698,6 +698,19 @@ jbd2_time_diff(unsigned long start, unsigned long end)
 
 #define JBD2_NR_BATCH	64
 
+
+/*
+ * List for keeping track of which vfs
+ * block a journal block contians.
+ */
+struct jbd2_blk_pair {
+	struct inode *vfs_inode;
+	unsigned long long vfs_pblk;
+	unsigned long long vfs_lblk;
+	unsigned long long jbd2_pblk;
+	struct list_head list;
+};
+
 /**
  * struct journal_s - The journal_s type is the concrete type associated with
  *     journal_t.
@@ -1002,6 +1015,9 @@ struct journal_s
 	 * superblock pointer here
 	 */
 	void *j_private;
+
+	spinlock_t              j_pair_lock;
+	struct list_head blk_pairs;
 };
 
 /*
@@ -1080,6 +1096,11 @@ jbd2_journal_write_metadata_buffer(transaction_t	  *transaction,
 			      struct journal_head **jh_out,
 			      unsigned long long   blocknr);
 
+extern int jbd2_record_pair(journal_t *journal,
+		struct buffer_head *vfs_bh,
+		struct buffer_head *jbd2_bh);
+
+
 /* Transaction locking */
 extern void		__wait_on_journal (journal_t *);
 
-- 
1.7.1

