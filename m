From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 40/41] EXT4: instrumentation with tracepoints
Date: Thu, 05 Mar 2009 17:48:08 -0500
Message-ID: <20090305225520.692384747@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.o
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.polymtl.ca ([132.207.4.11]:45541 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758456AbZCEXia (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Mar 2009 18:38:30 -0500
Content-Disposition: inline; filename=ext4-move-from-markers-to-tracepoints.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Took the instrumentation from "ext4: Add markers for better debuggability" and
moved it to tracepoints.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Stephen C. Tweedie <sct@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ext4 Developers List <linux-ext4@vger.kernel.org>
---
 fs/ext4/fsync.c      |    8 +--
 fs/ext4/ialloc.c     |   17 +++---
 fs/ext4/inode.c      |   79 +++++++++----------------------
 fs/ext4/mballoc.c    |   71 +++++++++-------------------
 fs/ext4/mballoc.h    |    2 
 fs/ext4/super.c      |    6 +-
 include/trace/ext4.h |  129 +++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 194 insertions(+), 118 deletions(-)

Index: linux-2.6-lttng/fs/ext4/fsync.c
===================================================================
--- linux-2.6-lttng.orig/fs/ext4/fsync.c	2009-03-05 15:21:54.000000000 -0500
+++ linux-2.6-lttng/fs/ext4/fsync.c	2009-03-05 15:49:28.000000000 -0500
@@ -28,10 +28,12 @@
 #include <linux/writeback.h>
 #include <linux/jbd2.h>
 #include <linux/blkdev.h>
-#include <linux/marker.h>
+#include <trace/ext4.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
+DEFINE_TRACE(ext4_sync_file);
+
 /*
  * akpm: A new design for ext4_sync_file().
  *
@@ -52,9 +54,7 @@ int ext4_sync_file(struct file *file, st
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
-	trace_mark(ext4_sync_file, "dev %s datasync %d ino %ld parent %ld",
-		   inode->i_sb->s_id, datasync, inode->i_ino,
-		   dentry->d_parent->d_inode->i_ino);
+	trace_ext4_sync_file(file, dentry, datasync);
 
 	/*
 	 * data=writeback:
Index: linux-2.6-lttng/fs/ext4/ialloc.c
===================================================================
--- linux-2.6-lttng.orig/fs/ext4/ialloc.c	2009-03-05 15:21:54.000000000 -0500
+++ linux-2.6-lttng/fs/ext4/ialloc.c	2009-03-05 15:49:28.000000000 -0500
@@ -22,6 +22,7 @@
 #include <linux/random.h>
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
+#include <trace/ext4.h>
 #include <asm/byteorder.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
@@ -29,6 +30,10 @@
 #include "acl.h"
 #include "group.h"
 
+DEFINE_TRACE(ext4_free_inode);
+DEFINE_TRACE(ext4_request_inode);
+DEFINE_TRACE(ext4_allocate_inode);
+
 /*
  * ialloc.c contains the inodes allocation and deallocation routines
  */
@@ -210,11 +215,7 @@ void ext4_free_inode(handle_t *handle, s
 
 	ino = inode->i_ino;
 	ext4_debug("freeing inode %lu\n", ino);
-	trace_mark(ext4_free_inode,
-		   "dev %s ino %lu mode %d uid %lu gid %lu bocks %llu",
-		   sb->s_id, inode->i_ino, inode->i_mode,
-		   (unsigned long) inode->i_uid, (unsigned long) inode->i_gid,
-		   (unsigned long long) inode->i_blocks);
+	trace_ext4_free_inode(inode);
 
 	/*
 	 * Note: we must free any quota before locking the superblock,
@@ -703,8 +704,7 @@ struct inode *ext4_new_inode(handle_t *h
 		return ERR_PTR(-EPERM);
 
 	sb = dir->i_sb;
-	trace_mark(ext4_request_inode, "dev %s dir %lu mode %d", sb->s_id,
-		   dir->i_ino, mode);
+	trace_ext4_request_inode(dir, mode);
 	inode = new_inode(sb);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -939,8 +939,7 @@ got:
 	}
 
 	ext4_debug("allocating inode %lu\n", inode->i_ino);
-	trace_mark(ext4_allocate_inode, "dev %s ino %lu dir %lu mode %d",
-		   sb->s_id, inode->i_ino, dir->i_ino, mode);
+	trace_ext4_allocate_inode(inode, dir, mode);
 	goto really_out;
 fail:
 	ext4_std_error(sb, err);
Index: linux-2.6-lttng/fs/ext4/inode.c
===================================================================
--- linux-2.6-lttng.orig/fs/ext4/inode.c	2009-03-05 15:21:54.000000000 -0500
+++ linux-2.6-lttng/fs/ext4/inode.c	2009-03-05 15:49:28.000000000 -0500
@@ -37,11 +37,24 @@
 #include <linux/namei.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <trace/ext4.h>
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
 #include "ext4_extents.h"
 
+DEFINE_TRACE(ext4_write_begin);
+DEFINE_TRACE(ext4_ordered_write_end);
+DEFINE_TRACE(ext4_writeback_write_end);
+DEFINE_TRACE(ext4_journalled_write_end);
+DEFINE_TRACE(ext4_da_writepage);
+DEFINE_TRACE(ext4_da_writepages);
+DEFINE_TRACE(ext4_da_writepages_result);
+DEFINE_TRACE(ext4_da_write_begin);
+DEFINE_TRACE(ext4_da_write_end);
+DEFINE_TRACE(ext4_normal_writepage);
+DEFINE_TRACE(ext4_journalled_writepage);
+
 #define MPAGE_DA_EXTENT_TAIL 0x01
 
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
@@ -1353,10 +1366,7 @@ static int ext4_write_begin(struct file 
  	pgoff_t index;
 	unsigned from, to;
 
-	trace_mark(ext4_write_begin,
-		   "dev %s ino %lu pos %llu len %u flags %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, flags);
+	trace_ext4_write_begin(inode, pos, len, flags);
  	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
@@ -1432,10 +1442,7 @@ static int ext4_ordered_write_end(struct
 	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 
-	trace_mark(ext4_ordered_write_end,
-		   "dev %s ino %lu pos %llu len %u copied %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, copied);
+	trace_ext4_ordered_write_end(inode, pos, len, copied);
 	ret = ext4_jbd2_file_inode(handle, inode);
 
 	if (ret == 0) {
@@ -1474,10 +1481,7 @@ static int ext4_writeback_write_end(stru
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
-	trace_mark(ext4_writeback_write_end,
-		   "dev %s ino %lu pos %llu len %u copied %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, copied);
+	trace_ext4_writeback_write_end(inode, pos, len, copied);
 	new_i_size = pos + copied;
 	if (new_i_size > EXT4_I(inode)->i_disksize) {
 		ext4_update_i_disksize(inode, new_i_size);
@@ -1513,10 +1517,7 @@ static int ext4_journalled_write_end(str
 	unsigned from, to;
 	loff_t new_i_size;
 
-	trace_mark(ext4_journalled_write_end,
-		   "dev %s ino %lu pos %llu len %u copied %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, copied);
+	trace_ext4_journalled_write_end(inode, pos, len, copied);
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
@@ -2333,9 +2334,7 @@ static int ext4_da_writepage(struct page
 	struct buffer_head *page_bufs;
 	struct inode *inode = page->mapping->host;
 
-	trace_mark(ext4_da_writepage,
-		   "dev %s ino %lu page_index %lu",
-		   inode->i_sb->s_id, inode->i_ino, page->index);
+	trace_ext4_da_writepage(inode, page);
 	size = i_size_read(inode);
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -2447,19 +2446,7 @@ static int ext4_da_writepages(struct add
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
+	trace_ext4_da_writepages(inode, wbc);
 
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
@@ -2595,14 +2582,7 @@ out_writepages:
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
+	trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
 	return ret;
 }
 
@@ -2654,11 +2634,7 @@ static int ext4_da_write_begin(struct fi
 					len, flags, pagep, fsdata);
 	}
 	*fsdata = (void *)0;
-
-	trace_mark(ext4_da_write_begin,
-		   "dev %s ino %lu pos %llu len %u flags %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, flags);
+	trace_ext4_da_write_begin(inode, pos, len, flags);
 retry:
 	/*
 	 * With delayed allocation, we don't log the i_disksize update
@@ -2751,10 +2727,7 @@ static int ext4_da_write_end(struct file
 		}
 	}
 
-	trace_mark(ext4_da_write_end,
-		   "dev %s ino %lu pos %llu len %u copied %u",
-		   inode->i_sb->s_id, inode->i_ino,
-		   (unsigned long long) pos, len, copied);
+	trace_ext4_da_write_end(inode, pos, len, copied);
 	start = pos & (PAGE_CACHE_SIZE - 1);
 	end = start + copied - 1;
 
@@ -2965,9 +2938,7 @@ static int ext4_normal_writepage(struct 
 	loff_t size = i_size_read(inode);
 	loff_t len;
 
-	trace_mark(ext4_normal_writepage,
-		   "dev %s ino %lu page_index %lu",
-		   inode->i_sb->s_id, inode->i_ino, page->index);
+	trace_ext4_normal_writepage(inode, page);
 	J_ASSERT(PageLocked(page));
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -3053,9 +3024,7 @@ static int ext4_journalled_writepage(str
 	loff_t size = i_size_read(inode);
 	loff_t len;
 
-	trace_mark(ext4_journalled_writepage,
-		   "dev %s ino %lu page_index %lu",
-		   inode->i_sb->s_id, inode->i_ino, page->index);
+	trace_ext4_journalled_writepage(inode, page);
 	J_ASSERT(PageLocked(page));
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
Index: linux-2.6-lttng/fs/ext4/mballoc.c
===================================================================
--- linux-2.6-lttng.orig/fs/ext4/mballoc.c	2009-03-05 15:21:54.000000000 -0500
+++ linux-2.6-lttng/fs/ext4/mballoc.c	2009-03-05 15:49:28.000000000 -0500
@@ -343,6 +343,17 @@ static void release_blocks_on_commit(jou
 
 
 
+DEFINE_TRACE(ext4_discard_blocks);
+DEFINE_TRACE(ext4_mb_new_inode_pa);
+DEFINE_TRACE(ext4_mb_new_group_pa);
+DEFINE_TRACE(ext4_mb_release_inode_pa);
+DEFINE_TRACE(ext4_mb_release_group_pa);
+DEFINE_TRACE(ext4_discard_preallocations);
+DEFINE_TRACE(ext4_mb_discard_preallocations);
+DEFINE_TRACE(ext4_request_blocks);
+DEFINE_TRACE(ext4_allocate_blocks);
+DEFINE_TRACE(ext4_free_blocks);
+
 static inline void *mb_correct_addr_and_bit(int *bit, void *addr)
 {
 #if BITS_PER_LONG == 64
@@ -2878,9 +2889,8 @@ static void release_blocks_on_commit(jou
 		discard_block = (ext4_fsblk_t) entry->group * EXT4_BLOCKS_PER_GROUP(sb)
 			+ entry->start_blk
 			+ le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
-		trace_mark(ext4_discard_blocks, "dev %s blk %llu count %u",
-			   sb->s_id, (unsigned long long) discard_block,
-			   entry->count);
+		trace_ext4_discard_blocks(sb, (unsigned long long)discard_block,
+					  entry);
 		sb_issue_discard(sb, discard_block, entry->count);
 
 		kmem_cache_free(ext4_free_ext_cachep, entry);
@@ -3700,10 +3710,7 @@ ext4_mb_new_inode_pa(struct ext4_allocat
 
 	mb_debug("new inode pa %p: %llu/%u for %u\n", pa,
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
-	trace_mark(ext4_mb_new_inode_pa,
-		   "dev %s ino %lu pstart %llu len %u lstart %u",
-		   sb->s_id, ac->ac_inode->i_ino,
-		   pa->pa_pstart, pa->pa_len, pa->pa_lstart);
+	trace_ext4_mb_new_inode_pa(ac, pa);
 
 	ext4_mb_use_inode_pa(ac, pa);
 	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
@@ -3762,9 +3769,8 @@ ext4_mb_new_group_pa(struct ext4_allocat
 	pa->pa_linear = 1;
 
 	mb_debug("new group pa %p: %llu/%u for %u\n", pa,
-		 pa->pa_pstart, pa->pa_len, pa->pa_lstart);
-	trace_mark(ext4_mb_new_group_pa, "dev %s pstart %llu len %u lstart %u",
-		   sb->s_id, pa->pa_pstart, pa->pa_len, pa->pa_lstart);
+			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
+	trace_ext4_mb_new_group_pa(ac, pa);
 
 	ext4_mb_use_group_pa(ac, pa);
 	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
@@ -3854,10 +3860,8 @@ ext4_mb_release_inode_pa(struct ext4_bud
 			ext4_mb_store_history(ac);
 		}
 
-		trace_mark(ext4_mb_release_inode_pa,
-			   "dev %s ino %lu block %llu count %u",
-			   sb->s_id, pa->pa_inode->i_ino, grp_blk_start + bit,
-			   next - bit);
+		trace_ext4_mb_release_inode_pa(ac, pa, grp_blk_start + bit,
+					       next - bit);
 		mb_free_blocks(pa->pa_inode, e4b, bit, next - bit);
 		bit = next + 1;
 	}
@@ -3891,8 +3895,7 @@ ext4_mb_release_group_pa(struct ext4_bud
 	if (ac)
 		ac->ac_op = EXT4_MB_HISTORY_DISCARD;
 
-	trace_mark(ext4_mb_release_group_pa, "dev %s pstart %llu len %d",
-		   sb->s_id, pa->pa_pstart, pa->pa_len);
+	trace_ext4_mb_release_group_pa(ac, pa);
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
@@ -4058,8 +4061,7 @@ void ext4_discard_preallocations(struct 
 	}
 
 	mb_debug("discard preallocation for inode %lu\n", inode->i_ino);
-	trace_mark(ext4_discard_preallocations, "dev %s ino %lu", sb->s_id,
-		   inode->i_ino);
+	trace_ext4_discard_preallocations(inode);
 
 	INIT_LIST_HEAD(&list);
 
@@ -4515,8 +4517,7 @@ static int ext4_mb_discard_preallocation
 	int ret;
 	int freed = 0;
 
-	trace_mark(ext4_mb_discard_preallocations, "dev %s needed %d",
-		   sb->s_id, needed);
+	trace_ext4_mb_discard_preallocations(sb, needed);
 	for (i = 0; i < EXT4_SB(sb)->s_groups_count && needed > 0; i++) {
 		ret = ext4_mb_discard_group_preallocations(sb, i, needed);
 		freed += ret;
@@ -4545,17 +4546,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
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
+	trace_ext4_request_blocks(ar);
 
 	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag) {
 		/*
@@ -4659,18 +4650,7 @@ out3:
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
+	trace_ext4_allocate_blocks(ar, (unsigned long long)block);
 
 	return block;
 }
@@ -4805,10 +4785,7 @@ void ext4_mb_free_blocks(handle_t *handl
 	}
 
 	ext4_debug("freeing block %lu\n", block);
-	trace_mark(ext4_free_blocks,
-		   "dev %s block %llu count %lu metadata %d ino %lu",
-		   sb->s_id, (unsigned long long) block, count, metadata,
-		   inode ? inode->i_ino : 0);
+	trace_ext4_free_blocks(inode, block, count, metadata);
 
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 	if (ac) {
Index: linux-2.6-lttng/fs/ext4/mballoc.h
===================================================================
--- linux-2.6-lttng.orig/fs/ext4/mballoc.h	2009-03-05 15:21:54.000000000 -0500
+++ linux-2.6-lttng/fs/ext4/mballoc.h	2009-03-05 15:49:28.000000000 -0500
@@ -19,8 +19,8 @@
 #include <linux/seq_file.h>
 #include <linux/version.h>
 #include <linux/blkdev.h>
-#include <linux/marker.h>
 #include <linux/mutex.h>
+#include <trace/ext4.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
 #include "group.h"
Index: linux-2.6-lttng/fs/ext4/super.c
===================================================================
--- linux-2.6-lttng.orig/fs/ext4/super.c	2009-03-05 15:21:54.000000000 -0500
+++ linux-2.6-lttng/fs/ext4/super.c	2009-03-05 15:49:28.000000000 -0500
@@ -35,9 +35,9 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
-#include <linux/marker.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
+#include <trace/ext4.h>
 #include <asm/uaccess.h>
 
 #include "ext4.h"
@@ -47,6 +47,8 @@
 #include "namei.h"
 #include "group.h"
 
+DEFINE_TRACE(ext4_sync_fs);
+
 struct proc_dir_entry *ext4_proc_root;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
@@ -3048,7 +3050,7 @@ static int ext4_sync_fs(struct super_blo
 	int ret = 0;
 	tid_t target;
 
-	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
+	trace_ext4_sync_fs(sb, wait);
 	sb->s_dirt = 0;
 	if (EXT4_SB(sb)->s_journal) {
 		if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal,
Index: linux-2.6-lttng/include/trace/ext4.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/trace/ext4.h	2009-03-05 15:49:28.000000000 -0500
@@ -0,0 +1,129 @@
+#ifndef _TRACE_EXT4_H
+#define _TRACE_EXT4_H
+
+#include <linux/tracepoint.h>
+
+struct ext4_free_data;
+struct ext4_prealloc_space;
+struct ext4_allocation_context;
+struct ext4_allocation_request;
+
+DECLARE_TRACE(ext4_free_inode,
+	TPPROTO(struct inode *inode),
+		TPARGS(inode));
+
+DECLARE_TRACE(ext4_request_inode,
+	TPPROTO(struct inode *dir, int mode),
+		TPARGS(dir, mode));
+
+DECLARE_TRACE(ext4_allocate_inode,
+	TPPROTO(struct inode *inode, struct inode *dir, int mode),
+		TPARGS(inode, dir, mode));
+
+DECLARE_TRACE(ext4_write_begin,
+	TPPROTO(struct inode *inode, loff_t pos, unsigned int len,
+			unsigned int flags),
+		TPARGS(inode, pos, len, flags));
+
+DECLARE_TRACE(ext4_ordered_write_end,
+	TPPROTO(struct inode *inode, loff_t pos, unsigned int len,
+			unsigned int copied),
+		TPARGS(inode, pos, len, copied));
+
+DECLARE_TRACE(ext4_writeback_write_end,
+	TPPROTO(struct inode *inode, loff_t pos, unsigned int len,
+			unsigned int copied),
+		TPARGS(inode, pos, len, copied));
+
+DECLARE_TRACE(ext4_journalled_write_end,
+	TPPROTO(struct inode *inode, loff_t pos, unsigned int len,
+			unsigned int copied),
+		TPARGS(inode, pos, len, copied));
+
+DECLARE_TRACE(ext4_da_writepage,
+	TPPROTO(struct inode *inode, struct page *page),
+		TPARGS(inode, page));
+
+DECLARE_TRACE(ext4_da_writepages,
+	TPPROTO(struct inode *inode, struct writeback_control *wbc),
+		TPARGS(inode, wbc));
+
+DECLARE_TRACE(ext4_da_writepages_result,
+	TPPROTO(struct inode *inode, struct writeback_control *wbc,
+			int ret, int pages_written),
+		TPARGS(inode, wbc, ret, pages_written));
+
+DECLARE_TRACE(ext4_da_write_begin,
+	TPPROTO(struct inode *inode, loff_t pos, unsigned int len,
+			unsigned int flags),
+		TPARGS(inode, pos, len, flags));
+
+DECLARE_TRACE(ext4_da_write_end,
+	TPPROTO(struct inode *inode, loff_t pos, unsigned int len,
+			unsigned int copied),
+		TPARGS(inode, pos, len, copied));
+
+DECLARE_TRACE(ext4_normal_writepage,
+	TPPROTO(struct inode *inode, struct page *page),
+		TPARGS(inode, page));
+
+DECLARE_TRACE(ext4_journalled_writepage,
+	TPPROTO(struct inode *inode, struct page *page),
+		TPARGS(inode, page));
+
+DECLARE_TRACE(ext4_discard_blocks,
+	TPPROTO(struct super_block *sb, unsigned long long blk,
+			struct ext4_free_data *entry),
+		TPARGS(sb, blk, entry));
+
+DECLARE_TRACE(ext4_mb_new_inode_pa,
+	TPPROTO(struct ext4_allocation_context *ac,
+			struct ext4_prealloc_space *pa),
+		TPARGS(ac, pa));
+
+DECLARE_TRACE(ext4_mb_new_group_pa,
+	TPPROTO(struct ext4_allocation_context *ac,
+			struct ext4_prealloc_space *pa),
+		TPARGS(ac, pa));
+
+DECLARE_TRACE(ext4_mb_release_inode_pa,
+	TPPROTO(struct ext4_allocation_context *ac,
+			struct ext4_prealloc_space *pa,
+			unsigned long long block, unsigned int count),
+		TPARGS(ac, pa, block, count));
+
+DECLARE_TRACE(ext4_mb_release_group_pa,
+	TPPROTO(struct ext4_allocation_context *ac,
+			struct ext4_prealloc_space *pa),
+		TPARGS(ac, pa));
+
+DECLARE_TRACE(ext4_discard_preallocations,
+	TPPROTO(struct inode *inode),
+		TPARGS(inode));
+
+DECLARE_TRACE(ext4_mb_discard_preallocations,
+	TPPROTO(struct super_block *sb, int needed),
+		TPARGS(sb, needed));
+
+DECLARE_TRACE(ext4_request_blocks,
+	TPPROTO(struct ext4_allocation_request *ar),
+		TPARGS(ar));
+
+DECLARE_TRACE(ext4_allocate_blocks,
+	TPPROTO(struct ext4_allocation_request *ar, unsigned long long block),
+		TPARGS(ar, block));
+
+DECLARE_TRACE(ext4_free_blocks,
+	TPPROTO(struct inode *inode, unsigned long block, unsigned long count,
+			int metadata),
+		TPARGS(inode, block, count, metadata));
+
+DECLARE_TRACE(ext4_sync_file,
+	TPPROTO(struct file *file, struct dentry *dentry, int datasync),
+		TPARGS(file, dentry, datasync));
+
+DECLARE_TRACE(ext4_sync_fs,
+	TPPROTO(struct super_block *sb, int wait),
+		TPARGS(sb, wait));
+
+#endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
