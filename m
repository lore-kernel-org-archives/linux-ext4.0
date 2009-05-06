From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ext4/jbd2: remove stray markers
Date: Wed, 6 May 2009 12:44:36 +0200
Message-ID: <20090506104436.GA24047@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: rostedt@goodmis.org, mingo@elte.hu, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:48565 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbZEFKoz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2009 06:44:55 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4/jbd2 has a couple of stray markers without any users introduced
in commit ba80b1019aa722b24506db1ee755e0bb2f513022 (which has a very
useless changelog, btw).  Remove them in preparation of removing the
markers in favour of the TRACE_EVENT macro (and also because we don't
keep dead code around).

Ted, I think you have some TRAVE_EVENT patches for ext4 pending, but is
it okay to queue up this removal in the tracing tree?  That way we can
remove the markers leftovers there completely as soon as the 2.6.31
merge window opens.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-tip/fs/ext4/fsync.c
===================================================================
--- linux-2.6-tip.orig/fs/ext4/fsync.c	2009-05-06 10:39:46.000000000 +0000
+++ linux-2.6-tip/fs/ext4/fsync.c	2009-05-06 10:39:54.000000000 +0000
@@ -52,10 +52,6 @@
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
-	trace_mark(ext4_sync_file, "dev %s datasync %d ino %ld parent %ld",
-		   inode->i_sb->s_id, datasync, inode->i_ino,
-		   dentry->d_parent->d_inode->i_ino);
-
 	/*
 	 * data=writeback:
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
Index: linux-2.6-tip/fs/ext4/ialloc.c
===================================================================
--- linux-2.6-tip.orig/fs/ext4/ialloc.c	2009-05-06 10:39:46.000000000 +0000
+++ linux-2.6-tip/fs/ext4/ialloc.c	2009-05-06 10:40:02.000000000 +0000
@@ -209,11 +209,6 @@
 
 	ino = inode->i_ino;
 	ext4_debug("freeing inode %lu\n", ino);
-	trace_mark(ext4_free_inode,
-		   "dev %s ino %lu mode %d uid %lu gid %lu bocks %llu",
-		   sb->s_id, inode->i_ino, inode->i_mode,
-		   (unsigned long) inode->i_uid, (unsigned long) inode->i_gid,
-		   (unsigned long long) inode->i_blocks);
 
 	/*
 	 * Note: we must free any quota before locking the superblock,
@@ -817,8 +812,6 @@
 		return ERR_PTR(-EPERM);
 
 	sb = dir->i_sb;
-	trace_mark(ext4_request_inode, "dev %s dir %lu mode %d", sb->s_id,
-		   dir->i_ino, mode);
 	inode = new_inode(sb);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -1050,8 +1043,6 @@
 	}
 
 	ext4_debug("allocating inode %lu\n", inode->i_ino);
-	trace_mark(ext4_allocate_inode, "dev %s ino %lu dir %lu mode %d",
-		   sb->s_id, inode->i_ino, dir->i_ino, mode);
 	goto really_out;
 fail:
 	ext4_std_error(sb, err);
Index: linux-2.6-tip/fs/ext4/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/ext4/inode.c	2009-05-06 10:39:46.000000000 +0000
+++ linux-2.6-tip/fs/ext4/inode.c	2009-05-06 10:40:30.000000000 +0000
@@ -1433,10 +1433,6 @@
  	pgoff_t index;
 	unsigned from, to;
 
-	trace_mark(ext4_write_begin,
-		   "dev %s ino %lu pos %llu len %u flags %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, flags);
  	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
@@ -1512,10 +1508,6 @@
 	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 
-	trace_mark(ext4_ordered_write_end,
-		   "dev %s ino %lu pos %llu len %u copied %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, copied);
 	ret = ext4_jbd2_file_inode(handle, inode);
 
 	if (ret == 0) {
@@ -1554,10 +1546,6 @@
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
-	trace_mark(ext4_writeback_write_end,
-		   "dev %s ino %lu pos %llu len %u copied %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, copied);
 	new_i_size = pos + copied;
 	if (new_i_size > EXT4_I(inode)->i_disksize) {
 		ext4_update_i_disksize(inode, new_i_size);
@@ -1593,10 +1581,6 @@
 	unsigned from, to;
 	loff_t new_i_size;
 
-	trace_mark(ext4_journalled_write_end,
-		   "dev %s ino %lu pos %llu len %u copied %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, copied);
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
@@ -2372,9 +2356,6 @@
 	struct buffer_head *page_bufs;
 	struct inode *inode = page->mapping->host;
 
-	trace_mark(ext4_da_writepage,
-		   "dev %s ino %lu page_index %lu",
-		   inode->i_sb->s_id, inode->i_ino, page->index);
 	size = i_size_read(inode);
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -2486,20 +2467,6 @@
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
-	trace_mark(ext4_da_writepages,
-		   "dev %s ino %lu nr_t_write %ld "
-		   "pages_skipped %ld range_start %llu "
-		   "range_end %llu nonblocking %d "
-		   "for_kupdate %d for_reclaim %d "
-		   "for_writepages %d range_cyclic %d",
-		   inode->i_sb->s_id, inode->i_ino,
-		   wbc->nr_to_write, wbc->pages_skipped,
-		   (unsigned long long) wbc->range_start,
-		   (unsigned long long) wbc->range_end,
-		   wbc->nonblocking, wbc->for_kupdate,
-		   wbc->for_reclaim, wbc->for_writepages,
-		   wbc->range_cyclic);
-
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
 	 * a transaction for special inodes like journal inode on last iput()
@@ -2664,14 +2631,6 @@
 	if (!no_nrwrite_index_update)
 		wbc->no_nrwrite_index_update = 0;
 	wbc->nr_to_write -= nr_to_writebump;
-	trace_mark(ext4_da_writepage_result,
-		   "dev %s ino %lu ret %d pages_written %d "
-		   "pages_skipped %ld congestion %d "
-		   "more_io %d no_nrwrite_index_update %d",
-		   inode->i_sb->s_id, inode->i_ino, ret,
-		   pages_written, wbc->pages_skipped,
-		   wbc->encountered_congestion, wbc->more_io,
-		   wbc->no_nrwrite_index_update);
 	return ret;
 }
 
@@ -2724,10 +2683,6 @@
 	}
 	*fsdata = (void *)0;
 
-	trace_mark(ext4_da_write_begin,
-		   "dev %s ino %lu pos %llu len %u flags %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, flags);
 retry:
 	/*
 	 * With delayed allocation, we don't log the i_disksize update
@@ -2820,10 +2775,6 @@
 		}
 	}
 
-	trace_mark(ext4_da_write_end,
-		   "dev %s ino %lu pos %llu len %u copied %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, copied);
 	start = pos & (PAGE_CACHE_SIZE - 1);
 	end = start + copied - 1;
 
@@ -3076,9 +3027,6 @@
 	loff_t size = i_size_read(inode);
 	loff_t len;
 
-	trace_mark(ext4_normal_writepage,
-		   "dev %s ino %lu page_index %lu",
-		   inode->i_sb->s_id, inode->i_ino, page->index);
 	J_ASSERT(PageLocked(page));
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -3164,9 +3112,6 @@
 	loff_t size = i_size_read(inode);
 	loff_t len;
 
-	trace_mark(ext4_journalled_writepage,
-		   "dev %s ino %lu page_index %lu",
-		   inode->i_sb->s_id, inode->i_ino, page->index);
 	J_ASSERT(PageLocked(page));
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
Index: linux-2.6-tip/fs/ext4/mballoc.c
===================================================================
--- linux-2.6-tip.orig/fs/ext4/mballoc.c	2009-05-06 10:39:46.000000000 +0000
+++ linux-2.6-tip/fs/ext4/mballoc.c	2009-05-06 10:41:01.000000000 +0000
@@ -2882,9 +2882,6 @@
 		discard_block = (ext4_fsblk_t) entry->group * EXT4_BLOCKS_PER_GROUP(sb)
 			+ entry->start_blk
 			+ le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
-		trace_mark(ext4_discard_blocks, "dev %s blk %llu count %u",
-			   sb->s_id, (unsigned long long) discard_block,
-			   entry->count);
 		sb_issue_discard(sb, discard_block, entry->count);
 
 		kmem_cache_free(ext4_free_ext_cachep, entry);
@@ -3658,10 +3655,6 @@
 
 	mb_debug("new inode pa %p: %llu/%u for %u\n", pa,
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
-	trace_mark(ext4_mb_new_inode_pa,
-		   "dev %s ino %lu pstart %llu len %u lstart %u",
-		   sb->s_id, ac->ac_inode->i_ino,
-		   pa->pa_pstart, pa->pa_len, pa->pa_lstart);
 
 	ext4_mb_use_inode_pa(ac, pa);
 	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
@@ -3721,8 +3714,6 @@
 
 	mb_debug("new group pa %p: %llu/%u for %u\n", pa,
 		 pa->pa_pstart, pa->pa_len, pa->pa_lstart);
-	trace_mark(ext4_mb_new_group_pa, "dev %s pstart %llu len %u lstart %u",
-		   sb->s_id, pa->pa_pstart, pa->pa_len, pa->pa_lstart);
 
 	ext4_mb_use_group_pa(ac, pa);
 	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
@@ -3812,10 +3803,6 @@
 			ext4_mb_store_history(ac);
 		}
 
-		trace_mark(ext4_mb_release_inode_pa,
-			   "dev %s ino %lu block %llu count %u",
-			   sb->s_id, pa->pa_inode->i_ino, grp_blk_start + bit,
-			   next - bit);
 		mb_free_blocks(pa->pa_inode, e4b, bit, next - bit);
 		bit = next + 1;
 	}
@@ -3849,8 +3836,6 @@
 	if (ac)
 		ac->ac_op = EXT4_MB_HISTORY_DISCARD;
 
-	trace_mark(ext4_mb_release_group_pa, "dev %s pstart %llu len %d",
-		   sb->s_id, pa->pa_pstart, pa->pa_len);
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
@@ -4016,8 +4001,6 @@
 	}
 
 	mb_debug("discard preallocation for inode %lu\n", inode->i_ino);
-	trace_mark(ext4_discard_preallocations, "dev %s ino %lu", sb->s_id,
-		   inode->i_ino);
 
 	INIT_LIST_HEAD(&list);
 
@@ -4473,8 +4456,6 @@
 	int ret;
 	int freed = 0;
 
-	trace_mark(ext4_mb_discard_preallocations, "dev %s needed %d",
-		   sb->s_id, needed);
 	for (i = 0; i < EXT4_SB(sb)->s_groups_count && needed > 0; i++) {
 		ret = ext4_mb_discard_group_preallocations(sb, i, needed);
 		freed += ret;
@@ -4503,18 +4484,6 @@
 	sb = ar->inode->i_sb;
 	sbi = EXT4_SB(sb);
 
-	trace_mark(ext4_request_blocks, "dev %s flags %u len %u ino %lu "
-		   "lblk %llu goal %llu lleft %llu lright %llu "
-		   "pleft %llu pright %llu ",
-		   sb->s_id, ar->flags, ar->len,
-		   ar->inode ? ar->inode->i_ino : 0,
-		   (unsigned long long) ar->logical,
-		   (unsigned long long) ar->goal,
-		   (unsigned long long) ar->lleft,
-		   (unsigned long long) ar->lright,
-		   (unsigned long long) ar->pleft,
-		   (unsigned long long) ar->pright);
-
 	/*
 	 * For delayed allocation, we could skip the ENOSPC and
 	 * EDQUOT check, as blocks and quotas have been already
@@ -4622,19 +4591,6 @@
 						reserv_blks);
 	}
 
-	trace_mark(ext4_allocate_blocks,
-		   "dev %s block %llu flags %u len %u ino %lu "
-		   "logical %llu goal %llu lleft %llu lright %llu "
-		   "pleft %llu pright %llu ",
-		   sb->s_id, (unsigned long long) block,
-		   ar->flags, ar->len, ar->inode ? ar->inode->i_ino : 0,
-		   (unsigned long long) ar->logical,
-		   (unsigned long long) ar->goal,
-		   (unsigned long long) ar->lleft,
-		   (unsigned long long) ar->lright,
-		   (unsigned long long) ar->pleft,
-		   (unsigned long long) ar->pright);
-
 	return block;
 }
 
@@ -4768,10 +4724,6 @@
 	}
 
 	ext4_debug("freeing block %lu\n", block);
-	trace_mark(ext4_free_blocks,
-		   "dev %s block %llu count %lu metadata %d ino %lu",
-		   sb->s_id, (unsigned long long) block, count, metadata,
-		   inode ? inode->i_ino : 0);
 
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 	if (ac) {
Index: linux-2.6-tip/fs/ext4/super.c
===================================================================
--- linux-2.6-tip.orig/fs/ext4/super.c	2009-05-06 10:39:46.000000000 +0000
+++ linux-2.6-tip/fs/ext4/super.c	2009-05-06 10:41:07.000000000 +0000
@@ -3287,7 +3287,6 @@
 	int ret = 0;
 	tid_t target;
 
-	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
 	sb->s_dirt = 0;
 	if (EXT4_SB(sb)->s_journal) {
 		if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal,
Index: linux-2.6-tip/fs/jbd2/checkpoint.c
===================================================================
--- linux-2.6-tip.orig/fs/jbd2/checkpoint.c	2009-05-06 10:39:46.000000000 +0000
+++ linux-2.6-tip/fs/jbd2/checkpoint.c	2009-05-06 10:41:25.000000000 +0000
@@ -358,8 +358,6 @@
 	 * journal straight away.
 	 */
 	result = jbd2_cleanup_journal_tail(journal);
-	trace_mark(jbd2_checkpoint, "dev %s need_checkpoint %d",
-		   journal->j_devname, result);
 	jbd_debug(1, "cleanup_journal_tail returned %d\n", result);
 	if (result <= 0)
 		return result;
Index: linux-2.6-tip/fs/jbd2/commit.c
===================================================================
--- linux-2.6-tip.orig/fs/jbd2/commit.c	2009-05-06 10:39:46.000000000 +0000
+++ linux-2.6-tip/fs/jbd2/commit.c	2009-05-06 10:41:30.000000000 +0000
@@ -394,8 +394,6 @@
 	commit_transaction = journal->j_running_transaction;
 	J_ASSERT(commit_transaction->t_state == T_RUNNING);
 
-	trace_mark(jbd2_start_commit, "dev %s transaction %d",
-		   journal->j_devname, commit_transaction->t_tid);
 	jbd_debug(1, "JBD: starting commit of transaction %d\n",
 			commit_transaction->t_tid);
 
@@ -1053,9 +1051,6 @@
 	if (journal->j_commit_callback)
 		journal->j_commit_callback(journal, commit_transaction);
 
-	trace_mark(jbd2_end_commit, "dev %s transaction %d head %d",
-		   journal->j_devname, commit_transaction->t_tid,
-		   journal->j_tail_sequence);
 	jbd_debug(1, "JBD: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
 	if (to_free)
