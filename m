From: Joe Perches <joe@perches.com>
Subject: [PATCH 7/9] ext4: Format neatening for easier grep
Date: Thu, 15 Mar 2012 17:07:35 -0700
Message-ID: <0166250eda6104d5a062dac44e7ed449369b2a5a.1331856300.git.joe@perches.com>
References: <cover.1331856299.git.joe@perches.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1331856299.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Split strings are difficult to grep so make it easier.

Coalesce strings.  Add spaces between words in newly coalesced formats.
Remove unnecessary terminating \n's from ext4_msg uses as ext4_msg
already adds it.  Add terminating \n's to ext4_debug uses.
Use %s, __func__ instead of embedded function names.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/ext4_jbd2.c   |    3 +-
 fs/ext4/extents.c     |   85 ++++++-------
 fs/ext4/file.c        |    3 +-
 fs/ext4/fsync.c       |    2 +-
 fs/ext4/inode.c       |   43 +++----
 fs/ext4/mballoc.c     |   93 +++++++-------
 fs/ext4/mmp.c         |   23 ++--
 fs/ext4/move_extent.c |   86 +++++--------
 fs/ext4/namei.c       |    4 +-
 fs/ext4/page-io.c     |   12 +--
 fs/ext4/resize.c      |   22 ++--
 fs/ext4/super.c       |  331 +++++++++++++++++++++++--------------------------
 12 files changed, 321 insertions(+), 386 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index aca1790..5365b66 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -43,8 +43,7 @@ int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
 	trace_ext4_forget(inode, is_metadata, blocknr);
 	BUFFER_TRACE(bh, "enter");
 
-	jbd_debug(4, "forgetting bh %p: is_metadata = %d, mode %o, "
-		  "data mode %x\n",
+	jbd_debug(4, "forgetting bh %p: is_metadata = %d, mode %o, data mode %x\n",
 		  bh, is_metadata, inode->i_mode,
 		  test_opt(inode->i_sb, DATA_FLAGS));
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c39a737..70b9419 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -760,9 +760,8 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 	len = EXT_LAST_INDEX(curp->p_hdr) - ix + 1;
 	BUG_ON(len < 0);
 	if (len > 0) {
-		ext_debug("insert new index %d: "
-				"move %d indices from 0x%p to 0x%p\n",
-				logical, len, ix, ix + 1);
+		ext_debug("insert new index %d: move %d indices from 0x%p to 0x%p\n",
+			  logical, len, ix, ix + 1);
 		memmove(ix + 1, ix, len * sizeof(struct ext4_extent_idx));
 	}
 
@@ -822,14 +821,12 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	}
 	if (path[depth].p_ext != EXT_MAX_EXTENT(path[depth].p_hdr)) {
 		border = path[depth].p_ext[1].ee_block;
-		ext_debug("leaf will be split."
-				" next leaf starts at %d\n",
-				  le32_to_cpu(border));
+		ext_debug("leaf will be split. next leaf starts at %d\n",
+			  le32_to_cpu(border));
 	} else {
 		border = newext->ee_block;
-		ext_debug("leaf will be added."
-				" next leaf starts at %d\n",
-				le32_to_cpu(border));
+		ext_debug("leaf will be added. next leaf starts at %d\n",
+			  le32_to_cpu(border));
 	}
 
 	/*
@@ -1771,34 +1768,31 @@ has_space:
 		if (le32_to_cpu(newext->ee_block)
 			   > le32_to_cpu(nearex->ee_block)) {
 			/* Insert after */
-			ext_debug("insert %u:%llu:[%d]%d before: "
-					"nearest %p\n",
-					le32_to_cpu(newext->ee_block),
-					ext4_ext_pblock(newext),
-					ext4_ext_is_uninitialized(newext),
-					ext4_ext_get_actual_len(newext),
-					nearex);
+			ext_debug("insert %u:%llu:[%d]%d before: nearest %p\n",
+				  le32_to_cpu(newext->ee_block),
+				  ext4_ext_pblock(newext),
+				  ext4_ext_is_uninitialized(newext),
+				  ext4_ext_get_actual_len(newext),
+				  nearex);
 			nearex++;
 		} else {
 			/* Insert before */
 			BUG_ON(newext->ee_block == nearex->ee_block);
-			ext_debug("insert %u:%llu:[%d]%d after: "
-					"nearest %p\n",
-					le32_to_cpu(newext->ee_block),
-					ext4_ext_pblock(newext),
-					ext4_ext_is_uninitialized(newext),
-					ext4_ext_get_actual_len(newext),
-					nearex);
+			ext_debug("insert %u:%llu:[%d]%d after: nearest %p\n",
+				  le32_to_cpu(newext->ee_block),
+				  ext4_ext_pblock(newext),
+				  ext4_ext_is_uninitialized(newext),
+				  ext4_ext_get_actual_len(newext),
+				  nearex);
 		}
 		len = EXT_LAST_EXTENT(eh) - nearex + 1;
 		if (len > 0) {
-			ext_debug("insert %u:%llu:[%d]%d: "
-					"move %d extents from 0x%p to 0x%p\n",
-					le32_to_cpu(newext->ee_block),
-					ext4_ext_pblock(newext),
-					ext4_ext_is_uninitialized(newext),
-					ext4_ext_get_actual_len(newext),
-					len, nearex, nearex + 1);
+			ext_debug("insert %u:%llu:[%d]%d: move %d extents from 0x%p to 0x%p\n",
+				  le32_to_cpu(newext->ee_block),
+				  ext4_ext_pblock(newext),
+				  ext4_ext_is_uninitialized(newext),
+				  ext4_ext_get_actual_len(newext),
+				  len, nearex, nearex + 1);
 			memmove(nearex + 1, nearex,
 				len * sizeof(struct ext4_extent));
 		}
@@ -2754,8 +2748,8 @@ static int ext4_split_extent_at(handle_t *handle,
 	unsigned int ee_len, depth;
 	int err = 0;
 
-	ext_debug("ext4_split_extents_at: inode %lu, logical"
-		"block %llu\n", inode->i_ino, (unsigned long long)split);
+	ext_debug("ext4_split_extents_at: inode %lu, logicalblock %llu\n",
+		  inode->i_ino, (unsigned long long)split);
 
 	ext4_ext_show_leaf(inode, path);
 
@@ -2936,9 +2930,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	int err = 0;
 	int split_flag = 0;
 
-	ext_debug("ext4_ext_convert_to_initialized: inode %lu, logical"
-		"block %llu, max_blocks %u\n", inode->i_ino,
-		(unsigned long long)map->m_lblk, map->m_len);
+	ext_debug("%s: inode %lu, logicalblock %llu, max_blocks %u\n",
+		  __func__, inode->i_ino,
+		  (unsigned long long)map->m_lblk, map->m_len);
 
 	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
 		inode->i_sb->s_blocksize_bits;
@@ -3143,9 +3137,9 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	unsigned int ee_len;
 	int split_flag = 0, depth;
 
-	ext_debug("ext4_split_unwritten_extents: inode %lu, logical"
-		"block %llu, max_blocks %u\n", inode->i_ino,
-		(unsigned long long)map->m_lblk, map->m_len);
+	ext_debug("%s: inode %lu, logicalblock %llu, max_blocks %u\n",
+		  __func__, inode->i_ino,
+		  (unsigned long long)map->m_lblk, map->m_len);
 
 	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
 		inode->i_sb->s_blocksize_bits;
@@ -3178,10 +3172,10 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 
-	ext_debug("ext4_convert_unwritten_extents_endio: inode %lu, logical"
-		"block %llu, max_blocks %u\n", inode->i_ino,
-		(unsigned long long)le32_to_cpu(ex->ee_block),
-		ext4_ext_get_actual_len(ex));
+	ext_debug("%s: inode %lu, logicalblock %llu, max_blocks %u\n",
+		  __func__, inode->i_ino,
+		  (unsigned long long)le32_to_cpu(ex->ee_block),
+		  ext4_ext_get_actual_len(ex));
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
@@ -3458,10 +3452,9 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 	int err = 0;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
 
-	ext_debug("ext4_ext_handle_uninitialized_extents: inode %lu, logical "
-		  "block %llu, max_blocks %u, flags %x, allocated %u\n",
-		  inode->i_ino, (unsigned long long)map->m_lblk, map->m_len,
-		  flags, allocated);
+	ext_debug("%s: inode %lu, logical block %llu, max_blocks %u, flags %x, allocated %u\n",
+		  __func__, inode->i_ino, (unsigned long long)map->m_lblk,
+		  map->m_len, flags, allocated);
 	ext4_ext_show_leaf(inode, path);
 
 	trace_ext4_ext_handle_uninitialized_extents(inode, map, allocated,
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cb70f18..a979bcd 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -126,8 +126,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		/* Warn about this once per day */
 		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
 			ext4_msg(inode->i_sb, KERN_WARNING,
-				 "Unaligned AIO/DIO on inode %ld by %s; "
-				 "performance will be poor.",
+				 "Unaligned AIO/DIO on inode %ld by %s; performance will be poor",
 				 inode->i_ino, current->comm);
 		mutex_lock(ext4_aio_mutex(inode));
 		ext4_aiodio_wait(inode);
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index bb6c7d8..3f87aca 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -46,7 +46,7 @@ static void dump_completed_IO(struct inode * inode)
 		return;
 	}
 
-	ext4_debug("Dump inode %lu completed_io list \n", inode->i_ino);
+	ext4_debug("Dump inode %lu completed_io list\n", inode->i_ino);
 	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
 	list_for_each_entry(io, &EXT4_I(inode)->i_completed_io_list, list){
 		cur = &io->list;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a2a1ae4..2fbfee2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -273,8 +273,8 @@ void ext4_da_update_reserve_space(struct inode *inode,
 	spin_lock(&ei->i_block_reservation_lock);
 	trace_ext4_da_update_reserve_space(inode, used, quota_claim);
 	if (unlikely(used > ei->i_reserved_data_blocks)) {
-		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, used %d "
-			 "with only %d reserved data blocks\n",
+		ext4_msg(inode->i_sb, KERN_NOTICE,
+			 "%s: ino %lu, used %d with only %d reserved data blocks",
 			 __func__, inode->i_ino, used,
 			 ei->i_reserved_data_blocks);
 		WARN_ON(1);
@@ -472,9 +472,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	int retval;
 
 	map->m_flags = 0;
-	ext_debug("ext4_map_blocks(): inode %lu, flag %d, max_blocks %u,"
-		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
-		  (unsigned long) map->m_lblk);
+	ext_debug("%s: inode %lu, flag %d, max_blocks %u, logical block %lu\n",
+		  __func__, inode->i_ino, flags, map->m_len,
+		  (unsigned long)map->m_lblk);
 	/*
 	 * Try to see if we can get the block without requesting a new
 	 * file system block.
@@ -1165,9 +1165,9 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 		 * function is called from invalidate page, it's
 		 * harmless to return without any action.
 		 */
-		ext4_msg(inode->i_sb, KERN_NOTICE, "ext4_da_release_space: "
-			 "ino %lu, to_free %d with only %d reserved "
-			 "data blocks\n", inode->i_ino, to_free,
+		ext4_msg(inode->i_sb, KERN_NOTICE,
+			 "%s: ino %lu, to_free %d with only %d reserved data blocks",
+			 __func__, inode->i_ino, to_free,
 			 ei->i_reserved_data_blocks);
 		WARN_ON(1);
 		to_free = ei->i_reserved_data_blocks;
@@ -1532,13 +1532,12 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 		 */
 		if (!(EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED)) {
 			ext4_msg(sb, KERN_CRIT,
-				 "delayed block allocation failed for inode %lu "
-				 "at logical offset %llu with max blocks %zd "
-				 "with error %d", mpd->inode->i_ino,
+				 "delayed block allocation failed for inode %lu at logical offset %llu with max blocks %zd with error %d",
+				 mpd->inode->i_ino,
 				 (unsigned long long) next,
 				 mpd->b_size >> mpd->inode->i_blkbits, err);
 			ext4_msg(sb, KERN_CRIT,
-				"This should not happen!! Data will be lost\n");
+				"This should not happen!! Data will be lost");
 			if (err == -ENOSPC)
 				ext4_print_free_blocks(mpd->inode);
 		}
@@ -1689,9 +1688,9 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		invalid_block = ~0;
 
 	map->m_flags = 0;
-	ext_debug("ext4_da_map_blocks(): inode %lu, max_blocks %u,"
-		  "logical block %lu\n", inode->i_ino, map->m_len,
-		  (unsigned long) map->m_lblk);
+	ext_debug("%s: inode %lu, max_blocks %u, logical block %lu\n",
+		  __func__, inode->i_ino, map->m_len,
+		  (unsigned long)map->m_lblk);
 	/*
 	 * Try to see if we can get the block without requesting a new
 	 * file system block.
@@ -2274,9 +2273,9 @@ retry:
 		handle = ext4_journal_start(inode, needed_blocks);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
-			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
-			       "%ld pages, ino %lu; err %d", __func__,
-				wbc->nr_to_write, inode->i_ino, ret);
+			ext4_msg(inode->i_sb, KERN_CRIT,
+				 "%s: jbd2_start: %ld pages, ino %lu; err %d",
+				 __func__, wbc->nr_to_write, inode->i_ino, ret);
 			blk_finish_plug(&plug);
 			goto out_writepages;
 		}
@@ -2765,9 +2764,8 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 	if (!io_end || !size)
 		goto out;
 
-	ext_debug("ext4_end_io_dio(): io_end 0x%p "
-		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
- 		  iocb->private, io_end->inode->i_ino, iocb, offset,
+	ext_debug("%s: io_end 0x%p for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
+		  __func__, iocb->private, io_end->inode->i_ino, iocb, offset,
 		  size);
 
 	iocb->private = NULL;
@@ -4445,8 +4443,7 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 				if (mnt_count !=
 					le16_to_cpu(sbi->s_es->s_mnt_count)) {
 					ext4_warning(inode->i_sb,
-					"Unable to expand inode %lu. Delete"
-					" some EAs or run e2fsck.",
+					"Unable to expand inode %lu. Delete some EAs or run e2fsck.",
 					inode->i_ino);
 					mnt_count =
 					  le16_to_cpu(sbi->s_es->s_mnt_count);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cd4d7c6..70b22fb 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -499,9 +499,7 @@ static void mb_cmp_bitmaps(struct ext4_buddy *e4b, void *bitmap)
 		for (i = 0; i < e4b->bd_sb->s_blocksize; i++) {
 			if (b1[i] != b2[i]) {
 				ext4_msg(e4b->bd_sb, KERN_ERR,
-					 "corruption in group %u "
-					 "at byte %u(%u): %x in copy != %x "
-					 "on disk/prealloc",
+					 "corruption in group %u at byte %u(%u): %x in copy != %x on disk/prealloc",
 					 e4b->bd_group, i, i * 8, b1[i], b2[i]);
 				BUG();
 			}
@@ -2178,8 +2176,8 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 			EXT4_DESC_PER_BLOCK_BITS(sb);
 		meta_group_info = kmalloc(metalen, GFP_KERNEL);
 		if (meta_group_info == NULL) {
-			ext4_msg(sb, KERN_ERR, "can't allocate mem "
-				 "for a buddy group");
+			ext4_msg(sb, KERN_ERR,
+				 "can't allocate mem for a buddy group");
 			goto exit_meta_group_info;
 		}
 		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)] =
@@ -2541,26 +2539,25 @@ int ext4_mb_release(struct super_block *sb)
 		iput(sbi->s_buddy_cache);
 	if (sbi->s_mb_stats) {
 		ext4_msg(sb, KERN_INFO,
-		       "mballoc: %u blocks %u reqs (%u success)",
-				atomic_read(&sbi->s_bal_allocated),
-				atomic_read(&sbi->s_bal_reqs),
-				atomic_read(&sbi->s_bal_success));
+			 "mballoc: %u blocks %u reqs (%u success)",
+			 atomic_read(&sbi->s_bal_allocated),
+			 atomic_read(&sbi->s_bal_reqs),
+			 atomic_read(&sbi->s_bal_success));
 		ext4_msg(sb, KERN_INFO,
-		      "mballoc: %u extents scanned, %u goal hits, "
-				"%u 2^N hits, %u breaks, %u lost",
-				atomic_read(&sbi->s_bal_ex_scanned),
-				atomic_read(&sbi->s_bal_goals),
-				atomic_read(&sbi->s_bal_2orders),
-				atomic_read(&sbi->s_bal_breaks),
-				atomic_read(&sbi->s_mb_lost_chunks));
+			 "mballoc: %u extents scanned, %u goal hits, %u 2^N hits, %u breaks, %u lost",
+			 atomic_read(&sbi->s_bal_ex_scanned),
+			 atomic_read(&sbi->s_bal_goals),
+			 atomic_read(&sbi->s_bal_2orders),
+			 atomic_read(&sbi->s_bal_breaks),
+			 atomic_read(&sbi->s_mb_lost_chunks));
 		ext4_msg(sb, KERN_INFO,
-		       "mballoc: %lu generated and it took %Lu",
-				sbi->s_mb_buddies_generated,
-				sbi->s_mb_generation_time);
+			 "mballoc: %lu generated and it took %Lu",
+			 sbi->s_mb_buddies_generated,
+			 sbi->s_mb_generation_time);
 		ext4_msg(sb, KERN_INFO,
-		       "mballoc: %u preallocated, %u discarded",
-				atomic_read(&sbi->s_mb_preallocated),
-				atomic_read(&sbi->s_mb_discarded));
+			 "mballoc: %u preallocated, %u discarded",
+			 atomic_read(&sbi->s_mb_preallocated),
+			 atomic_read(&sbi->s_mb_discarded));
 	}
 
 	free_percpu(sbi->s_locality_groups);
@@ -3864,29 +3861,28 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 	    (EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED))
 		return;
 
-	ext4_msg(ac->ac_sb, KERN_ERR, "Can't allocate:"
-			" Allocation context details:");
+	ext4_msg(ac->ac_sb, KERN_ERR,
+		 "Can't allocate: Allocation context details:");
 	ext4_msg(ac->ac_sb, KERN_ERR, "status %d flags %d",
-			ac->ac_status, ac->ac_flags);
-	ext4_msg(ac->ac_sb, KERN_ERR, "orig %lu/%lu/%lu@%lu, "
-		 	"goal %lu/%lu/%lu@%lu, "
-			"best %lu/%lu/%lu@%lu cr %d",
-			(unsigned long)ac->ac_o_ex.fe_group,
-			(unsigned long)ac->ac_o_ex.fe_start,
-			(unsigned long)ac->ac_o_ex.fe_len,
-			(unsigned long)ac->ac_o_ex.fe_logical,
-			(unsigned long)ac->ac_g_ex.fe_group,
-			(unsigned long)ac->ac_g_ex.fe_start,
-			(unsigned long)ac->ac_g_ex.fe_len,
-			(unsigned long)ac->ac_g_ex.fe_logical,
-			(unsigned long)ac->ac_b_ex.fe_group,
-			(unsigned long)ac->ac_b_ex.fe_start,
-			(unsigned long)ac->ac_b_ex.fe_len,
-			(unsigned long)ac->ac_b_ex.fe_logical,
-			(int)ac->ac_criteria);
+		 ac->ac_status, ac->ac_flags);
+	ext4_msg(ac->ac_sb, KERN_ERR,
+		 "orig %lu/%lu/%lu@%lu, goal %lu/%lu/%lu@%lu, best %lu/%lu/%lu@%lu cr %d",
+		 (unsigned long)ac->ac_o_ex.fe_group,
+		 (unsigned long)ac->ac_o_ex.fe_start,
+		 (unsigned long)ac->ac_o_ex.fe_len,
+		 (unsigned long)ac->ac_o_ex.fe_logical,
+		 (unsigned long)ac->ac_g_ex.fe_group,
+		 (unsigned long)ac->ac_g_ex.fe_start,
+		 (unsigned long)ac->ac_g_ex.fe_len,
+		 (unsigned long)ac->ac_g_ex.fe_logical,
+		 (unsigned long)ac->ac_b_ex.fe_group,
+		 (unsigned long)ac->ac_b_ex.fe_start,
+		 (unsigned long)ac->ac_b_ex.fe_len,
+		 (unsigned long)ac->ac_b_ex.fe_logical,
+		 (int)ac->ac_criteria);
 	ext4_msg(ac->ac_sb, KERN_ERR, "%lu scanned, %d found",
 		 ac->ac_ex_scanned, ac->ac_found);
-	ext4_msg(ac->ac_sb, KERN_ERR, "groups: ");
+	ext4_msg(ac->ac_sb, KERN_ERR, "groups:");
 	ngroups = ext4_get_groups_count(sb);
 	for (i = 0; i < ngroups; i++) {
 		struct ext4_group_info *grp = ext4_get_group_info(sb, i);
@@ -4017,13 +4013,12 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	 * locality group. this is a policy, actually */
 	ext4_mb_group_or_file(ac);
 
-	mb_debug(1, "init ac: %u blocks @ %u, goal %u, flags %x, 2^%d, "
-			"left: %u/%u, right %u/%u to %swritable\n",
-			(unsigned) ar->len, (unsigned) ar->logical,
-			(unsigned) ar->goal, ac->ac_flags, ac->ac_2order,
-			(unsigned) ar->lleft, (unsigned) ar->pleft,
-			(unsigned) ar->lright, (unsigned) ar->pright,
-			atomic_read(&ar->inode->i_writecount) ? "" : "non-");
+	mb_debug(1, "init ac: %u blocks @ %u, goal %u, flags %x, 2^%d, left: %u/%u, right %u/%u to %swritable\n",
+		 (unsigned) ar->len, (unsigned) ar->logical,
+		 (unsigned) ar->goal, ac->ac_flags, ac->ac_2order,
+		 (unsigned) ar->lleft, (unsigned) ar->pleft,
+		 (unsigned) ar->lright, (unsigned) ar->pright,
+		 atomic_read(&ar->inode->i_writecount) ? "" : "non-");
 	return 0;
 
 }
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index ed6548d..1767b2a 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -73,8 +73,7 @@ void __dump_mmp_msg(struct super_block *sb, struct mmp_struct *mmp,
 {
 	__ext4_warning(sb, function, line, msg);
 	__ext4_warning(sb, function, line,
-		       "MMP failure info: last update time: %llu, last update "
-		       "node: %s, last update device: %s\n",
+		       "MMP failure info: last update time: %llu, last update node: %s, last update device: %s",
 		       (long long unsigned int) le64_to_cpu(mmp->mmp_time),
 		       mmp->mmp_nodename, mmp->mmp_bdevname);
 }
@@ -133,15 +132,13 @@ static int kmmpd(void *data)
 
 		if (!(le32_to_cpu(es->s_feature_incompat) &
 		    EXT4_FEATURE_INCOMPAT_MMP)) {
-			ext4_warning(sb, "kmmpd being stopped since MMP feature"
-				     " has been disabled.");
+			ext4_warning(sb, "kmmpd being stopped since MMP feature has been disabled");
 			EXT4_SB(sb)->s_mmp_tsk = NULL;
 			goto failed;
 		}
 
 		if (sb->s_flags & MS_RDONLY) {
-			ext4_warning(sb, "kmmpd being stopped since filesystem "
-				     "has been remounted as readonly.");
+			ext4_warning(sb, "kmmpd being stopped since filesystem has been remounted as readonly");
 			EXT4_SB(sb)->s_mmp_tsk = NULL;
 			goto failed;
 		}
@@ -274,11 +271,11 @@ int ext4_multi_mount_protect(struct super_block *sb,
 
 	/* Print MMP interval if more than 20 secs. */
 	if (wait_time > EXT4_MMP_MIN_CHECK_INTERVAL * 4)
-		ext4_warning(sb, "MMP interval %u higher than expected, please"
-			     " wait.\n", wait_time * 2);
+		ext4_warning(sb, "MMP interval %u higher than expected, please wait",
+			     wait_time * 2);
 
 	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
-		ext4_warning(sb, "MMP startup interrupted, failing mount\n");
+		ext4_warning(sb, "MMP startup interrupted, failing mount");
 		goto failed;
 	}
 
@@ -288,7 +285,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	mmp = (struct mmp_struct *)(bh->b_data);
 	if (seq != le32_to_cpu(mmp->mmp_seq)) {
 		dump_mmp_msg(sb, mmp,
-			     "Device is already active on another node.");
+			     "Device is already active on another node");
 		goto failed;
 	}
 
@@ -307,7 +304,7 @@ skip:
 	 * wait for MMP interval and check mmp_seq.
 	 */
 	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
-		ext4_warning(sb, "MMP startup interrupted, failing mount\n");
+		ext4_warning(sb, "MMP startup interrupted, failing mount");
 		goto failed;
 	}
 
@@ -317,7 +314,7 @@ skip:
 	mmp = (struct mmp_struct *)(bh->b_data);
 	if (seq != le32_to_cpu(mmp->mmp_seq)) {
 		dump_mmp_msg(sb, mmp,
-			     "Device is already active on another node.");
+			     "Device is already active on another node");
 		goto failed;
 	}
 
@@ -338,7 +335,7 @@ skip:
 	if (IS_ERR(EXT4_SB(sb)->s_mmp_tsk)) {
 		EXT4_SB(sb)->s_mmp_tsk = NULL;
 		kfree(mmpd_data);
-		ext4_warning(sb, "Unable to create kmmpd thread for %s.",
+		ext4_warning(sb, "Unable to create kmmpd thread for %s",
 			     sb->s_id);
 		goto failed;
 	}
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c5826c6..ce52881 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -952,8 +952,7 @@ mext_check_arguments(struct inode *orig_inode,
 	unsigned int blocksize = 1 << blkbits;
 
 	if (donor_inode->i_mode & (S_ISUID|S_ISGID)) {
-		ext4_debug("ext4 move extent: suid or sgid is set"
-			   " to donor file [ino:orig %lu, donor %lu]\n",
+		ext4_debug("ext4 move extent: suid or sgid is set to donor file [ino:orig %lu, donor %lu]\n",
 			   orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
@@ -963,28 +962,26 @@ mext_check_arguments(struct inode *orig_inode,
 
 	/* Ext4 move extent does not support swapfile */
 	if (IS_SWAPFILE(orig_inode) || IS_SWAPFILE(donor_inode)) {
-		ext4_debug("ext4 move extent: The argument files should "
-			"not be swapfile [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
+		ext4_debug("ext4 move extent: The argument files should not be swapfile [ino:orig %lu, donor %lu]\n",
+			   orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
 
 	/* Files should be in the same ext4 FS */
 	if (orig_inode->i_sb != donor_inode->i_sb) {
-		ext4_debug("ext4 move extent: The argument files "
-			"should be in same FS [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
+		ext4_debug("ext4 move extent: The argument files should be in same FS [ino:orig %lu, donor %lu]\n",
+			   orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
 
 	/* Ext4 move extent supports only extent based file */
 	if (!(ext4_test_inode_flag(orig_inode, EXT4_INODE_EXTENTS))) {
-		ext4_debug("ext4 move extent: orig file is not extents "
-			"based file [ino:orig %lu]\n", orig_inode->i_ino);
+		ext4_debug("ext4 move extent: orig file is not extents based file [ino:orig %lu]\n",
+			   orig_inode->i_ino);
 		return -EOPNOTSUPP;
 	} else if (!(ext4_test_inode_flag(donor_inode, EXT4_INODE_EXTENTS))) {
-		ext4_debug("ext4 move extent: donor file is not extents "
-			"based file [ino:donor %lu]\n", donor_inode->i_ino);
+		ext4_debug("ext4 move extent: donor file is not extents based file [ino:donor %lu]\n",
+			   donor_inode->i_ino);
 		return -EOPNOTSUPP;
 	}
 
@@ -995,9 +992,8 @@ mext_check_arguments(struct inode *orig_inode,
 
 	/* Start offset should be same */
 	if (orig_start != donor_start) {
-		ext4_debug("ext4 move extent: orig and donor's start "
-			"offset are not same [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
+		ext4_debug("ext4 move extent: orig and donor's start offset are not same [ino:orig %lu, donor %lu]\n",
+			   orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
 
@@ -1005,9 +1001,9 @@ mext_check_arguments(struct inode *orig_inode,
 	    (donor_start >= EXT_MAX_BLOCKS) ||
 	    (*len > EXT_MAX_BLOCKS) ||
 	    (orig_start + *len >= EXT_MAX_BLOCKS))  {
-		ext4_debug("ext4 move extent: Can't handle over [%u] blocks "
-			"[ino:orig %lu, donor %lu]\n", EXT_MAX_BLOCKS,
-			orig_inode->i_ino, donor_inode->i_ino);
+		ext4_debug("ext4 move extent: Can't handle over [%u] blocks [ino:orig %lu, donor %lu]\n",
+			   EXT_MAX_BLOCKS,
+			   orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
 
@@ -1015,51 +1011,40 @@ mext_check_arguments(struct inode *orig_inode,
 		donor_blocks = (donor_inode->i_size + blocksize - 1) >> blkbits;
 		/* TODO: eliminate this artificial restriction */
 		if (orig_start >= donor_blocks) {
-			ext4_debug("ext4 move extent: orig start offset "
-			"[%llu] should be less than donor file blocks "
-			"[%u] [ino:orig %lu, donor %lu]\n",
-			orig_start, donor_blocks,
-			orig_inode->i_ino, donor_inode->i_ino);
+			ext4_debug("ext4 move extent: orig start offset [%llu] should be less than donor file blocks [%u] [ino:orig %lu, donor %lu]\n",
+				   orig_start, donor_blocks,
+				   orig_inode->i_ino, donor_inode->i_ino);
 			return -EINVAL;
 		}
 
 		/* TODO: eliminate this artificial restriction */
 		if (orig_start + *len > donor_blocks) {
-			ext4_debug("ext4 move extent: End offset [%llu] should "
-				"be less than donor file blocks [%u]."
-				"So adjust length from %llu to %llu "
-				"[ino:orig %lu, donor %lu]\n",
-				orig_start + *len, donor_blocks,
-				*len, donor_blocks - orig_start,
-				orig_inode->i_ino, donor_inode->i_ino);
+			ext4_debug("ext4 move extent: End offset [%llu] should be less than donor file blocks [%u].So adjust length from %llu to %llu [ino:orig %lu, donor %lu]\n",
+				   orig_start + *len, donor_blocks,
+				   *len, donor_blocks - orig_start,
+				   orig_inode->i_ino, donor_inode->i_ino);
 			*len = donor_blocks - orig_start;
 		}
 	} else {
 		orig_blocks = (orig_inode->i_size + blocksize - 1) >> blkbits;
 		if (orig_start >= orig_blocks) {
-			ext4_debug("ext4 move extent: start offset [%llu] "
-				"should be less than original file blocks "
-				"[%u] [ino:orig %lu, donor %lu]\n",
-				 orig_start, orig_blocks,
-				orig_inode->i_ino, donor_inode->i_ino);
+			ext4_debug("ext4 move extent: start offset [%llu] should be less than original file blocks [%u] [ino:orig %lu, donor %lu]\n",
+				   orig_start, orig_blocks,
+				   orig_inode->i_ino, donor_inode->i_ino);
 			return -EINVAL;
 		}
 
 		if (orig_start + *len > orig_blocks) {
-			ext4_debug("ext4 move extent: Adjust length "
-				"from %llu to %llu. Because it should be "
-				"less than original file blocks "
-				"[ino:orig %lu, donor %lu]\n",
-				*len, orig_blocks - orig_start,
-				orig_inode->i_ino, donor_inode->i_ino);
+			ext4_debug("ext4 move extent: Adjust length from %llu to %llu. Because it should be less than original file blocks [ino:orig %lu, donor %lu]\n",
+				   *len, orig_blocks - orig_start,
+				   orig_inode->i_ino, donor_inode->i_ino);
 			*len = orig_blocks - orig_start;
 		}
 	}
 
 	if (!*len) {
-		ext4_debug("ext4 move extent: len should not be 0 "
-			"[ino:orig %lu, donor %lu]\n", orig_inode->i_ino,
-			donor_inode->i_ino);
+		ext4_debug("ext4 move extent: len should not be 0 [ino:orig %lu, donor %lu]\n",
+			   orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
 
@@ -1195,17 +1180,15 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 
 	/* orig and donor should be different file */
 	if (orig_inode->i_ino == donor_inode->i_ino) {
-		ext4_debug("ext4 move extent: The argument files should not "
-			"be same file [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
+		ext4_debug("ext4 move extent: The argument files should not be same file [ino:orig %lu, donor %lu]\n",
+			   orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
 
 	/* Regular file check */
 	if (!S_ISREG(orig_inode->i_mode) || !S_ISREG(donor_inode->i_mode)) {
-		ext4_debug("ext4 move extent: The argument files should be "
-			"regular file [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
+		ext4_debug("ext4 move extent: The argument files should be regular file [ino:orig %lu, donor %lu]\n",
+			   orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
 
@@ -1270,8 +1253,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 
 	/* No blocks within the specified range. */
 	if (le32_to_cpu(ext_cur->ee_block) > block_end) {
-		ext4_debug("ext4 move extent: The specified range of file "
-							"may be the hole\n");
+		ext4_debug("ext4 move extent: The specified range of file may be the hole\n");
 		ret1 = -EINVAL;
 		goto out;
 	}
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b10ee89..99f86a7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -474,8 +474,8 @@ fail2:
 fail:
 	if (*err == ERR_BAD_DX_DIR)
 		ext4_warning(dir->i_sb,
-			     "Corrupt dir inode %lu, running e2fsck is "
-			     "recommended.", dir->i_ino);
+			     "Corrupt dir inode %lu, running e2fsck is recommended.",
+			     dir->i_ino);
 	return NULL;
 }
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 09c9d4b..a5afbad 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -95,16 +95,13 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 	ssize_t size = io->size;
 	int ret = 0;
 
-	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
-		   "list->prev 0x%p\n",
-		   io, inode->i_ino, io->list.next, io->list.prev);
+	ext4_debug("%s: io 0x%p from inode %lu,list->next 0x%p,list->prev 0x%p\n",
+		   __func__, io, inode->i_ino, io->list.next, io->list.prev);
 
 	ret = ext4_convert_unwritten_extents(inode, offset, size);
 	if (ret < 0) {
 		ext4_msg(inode->i_sb, KERN_EMERG,
-			 "failed to convert unwritten extents to written "
-			 "extents -- potential data loss!  "
-			 "(inode %lu, offset %llu, size %zd, error %d)",
+			 "failed to convert unwritten extents to written extents -- potential data loss!  (inode %lu, offset %llu, size %zd, error %d)",
 			 inode->i_ino, offset, size, ret);
 	}
 
@@ -241,8 +238,7 @@ static void ext4_end_bio(struct bio *bio, int error)
 
 	if (error) {
 		io_end->flag |= EXT4_IO_END_ERROR;
-		ext4_warning(inode->i_sb, "I/O error writing to inode %lu "
-			     "(offset %llu size %ld starting block %llu)",
+		ext4_warning(inode->i_sb, "I/O error writing to inode %lu (offset %llu size %ld starting block %llu)",
 			     inode->i_ino,
 			     (unsigned long long) io_end->offset,
 			     (long) io_end->size,
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 83884e8..ed3a306 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -29,8 +29,7 @@ int ext4_resize_begin(struct super_block *sb)
 	 * with error, because it can destroy the filesystem easily.
 	 */
 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
-		ext4_warning(sb, "There are errors in the filesystem, "
-			     "so online resizing is not allowed\n");
+		ext4_warning(sb, "There are errors in the filesystem, so online resizing is not allowed");
 		return -EPERM;
 	}
 
@@ -104,13 +103,11 @@ static int verify_group_input(struct super_block *sb,
 		ext4_warning(sb, "Block bitmap same as inode bitmap (%llu)",
 			     (unsigned long long)input->block_bitmap);
 	else if (inside(input->block_bitmap, input->inode_table, itend))
-		ext4_warning(sb, "Block bitmap (%llu) in inode table "
-			     "(%llu-%llu)",
+		ext4_warning(sb, "Block bitmap (%llu) in inode table (%llu-%llu)",
 			     (unsigned long long)input->block_bitmap,
 			     (unsigned long long)input->inode_table, itend - 1);
 	else if (inside(input->inode_bitmap, input->inode_table, itend))
-		ext4_warning(sb, "Inode bitmap (%llu) in inode table "
-			     "(%llu-%llu)",
+		ext4_warning(sb, "Inode bitmap (%llu) in inode table (%llu-%llu)",
 			     (unsigned long long)input->inode_bitmap,
 			     (unsigned long long)input->inode_table, itend - 1);
 	else if (inside(input->block_bitmap, start, metaend))
@@ -123,8 +120,7 @@ static int verify_group_input(struct super_block *sb,
 			     start, metaend - 1);
 	else if (inside(input->inode_table, start, metaend) ||
 		 inside(itend - 1, start, metaend))
-		ext4_warning(sb, "Inode table (%llu-%llu) overlaps GDT table "
-			     "(%llu-%llu)",
+		ext4_warning(sb, "Inode table (%llu-%llu) overlaps GDT table (%llu-%llu)",
 			     (unsigned long long)input->inode_table,
 			     itend - 1, start, metaend - 1);
 	else
@@ -648,8 +644,7 @@ static int verify_reserved_gdb(struct super_block *sb,
 	while ((grp = ext4_list_backups(sb, &three, &five, &seven)) < end) {
 		if (le32_to_cpu(*p++) !=
 		    grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
-			ext4_warning(sb, "reserved GDT %llu"
-				     " missing grp %d (%llu)",
+			ext4_warning(sb, "reserved GDT %llu missing grp %d (%llu)",
 				     blk, grp,
 				     grp *
 				     (ext4_fsblk_t)EXT4_BLOCKS_PER_GROUP(sb) +
@@ -861,8 +856,7 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 	/* Get each reserved primary GDT block and verify it holds backups */
 	for (res = 0; res < reserved_gdb; res++, blk++) {
 		if (le32_to_cpu(*data) != blk) {
-			ext4_warning(sb, "reserved block %llu"
-				     " not at offset %ld",
+			ext4_warning(sb, "reserved block %llu not at offset %ld",
 				     blk,
 				     (long)(data - (__le32 *)dind->b_data));
 			err = -EINVAL;
@@ -1009,8 +1003,8 @@ static void update_backups(struct super_block *sb,
 	 */
 exit_err:
 	if (err) {
-		ext4_warning(sb, "can't update backup for group %u (err %d), "
-			     "forcing fsck on next reboot", group, err);
+		ext4_warning(sb, "can't update backup for group %u (err %d), forcing fsck on next reboot",
+			     group, err);
 		sbi->s_mount_state &= ~EXT4_VALID_FS;
 		sbi->s_es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
 		mark_buffer_dirty(sbi->s_sbh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ac77a95..cade67b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -738,8 +738,7 @@ void ext4_update_dynamic_rev(struct super_block *sb)
 		return;
 
 	ext4_warning(sb,
-		     "updating to rev %d because of new feature flag, "
-		     "running e2fsck is recommended",
+		     "updating to rev %d because of new feature flag, running e2fsck is recommended",
 		     EXT4_DYNAMIC_REV);
 
 	es->s_first_ino = cpu_to_le32(EXT4_GOOD_OLD_FIRST_INO);
@@ -1297,27 +1296,26 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
 	if (sb_any_quota_loaded(sb) &&
 		!sbi->s_qf_names[qtype]) {
 		ext4_msg(sb, KERN_ERR,
-			"Cannot change journaled "
-			"quota options when quota turned on");
+			 "Cannot change journaled quota options when quota turned on");
 		return 0;
 	}
 	qname = match_strdup(args);
 	if (!qname) {
 		ext4_msg(sb, KERN_ERR,
-			"Not enough memory for storing quotafile name");
+			 "Not enough memory for storing quotafile name");
 		return 0;
 	}
 	if (sbi->s_qf_names[qtype] &&
 		strcmp(sbi->s_qf_names[qtype], qname)) {
 		ext4_msg(sb, KERN_ERR,
-			"%s quota file already specified", QTYPE2NAME(qtype));
+			 "%s quota file already specified", QTYPE2NAME(qtype));
 		kfree(qname);
 		return 0;
 	}
 	sbi->s_qf_names[qtype] = qname;
 	if (strchr(sbi->s_qf_names[qtype], '/')) {
 		ext4_msg(sb, KERN_ERR,
-			"quotafile must be on filesystem root");
+			 "quotafile must be on filesystem root");
 		kfree(sbi->s_qf_names[qtype]);
 		sbi->s_qf_names[qtype] = NULL;
 		return 0;
@@ -1333,8 +1331,8 @@ static int clear_qf_name(struct super_block *sb, int qtype)
 
 	if (sb_any_quota_loaded(sb) &&
 		sbi->s_qf_names[qtype]) {
-		ext4_msg(sb, KERN_ERR, "Cannot change journaled quota options"
-			" when quota turned on");
+		ext4_msg(sb, KERN_ERR,
+			 "Cannot change journaled quota options when quota turned on");
 		return 0;
 	}
 	/*
@@ -1494,8 +1492,8 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		if (m->flags & MOPT_CLEAR_ERR)
 			clear_opt(sb, ERRORS_MASK);
 		if (token == Opt_noquota && sb_any_quota_loaded(sb)) {
-			ext4_msg(sb, KERN_ERR, "Cannot change quota "
-				 "options when quota turned on");
+			ext4_msg(sb, KERN_ERR,
+				 "Cannot change quota options when quota turned on");
 			return -1;
 		}
 
@@ -1516,8 +1514,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 				return -1;
 			if (arg && !is_power_of_2(arg)) {
 				ext4_msg(sb, KERN_ERR,
-					 "EXT4-fs: inode_readahead_blks"
-					 " must be a power of 2");
+					 "inode_readahead_blks must be a power of 2");
 				return -1;
 			}
 			sbi->s_inode_readahead_blks = arg;
@@ -1535,7 +1532,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 				else if (test_opt(sb, DATA_FLAGS) !=
 					 m->mount_opt) {
 					ext4_msg(sb, KERN_ERR,
-					 "Cannot change data mode on remount");
+						 "Cannot change data mode on remount");
 					return -1;
 				}
 			} else {
@@ -1558,9 +1555,8 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		} else if (m->flags & MOPT_QFMT) {
 			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != m->mount_opt) {
-				ext4_msg(sb, KERN_ERR, "Cannot "
-					 "change journaled quota options "
-					 "when quota turned on");
+				ext4_msg(sb, KERN_ERR,
+					 "Cannot change journaled quota options when quota turned on");
 				return -1;
 			}
 			sbi->s_jquota_fmt = m->mount_opt;
@@ -1583,8 +1579,8 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		}
 		return 1;
 	}
-	ext4_msg(sb, KERN_ERR, "Unrecognized mount option \"%s\" "
-		 "or missing value", opt);
+	ext4_msg(sb, KERN_ERR,
+		 "Unrecognized mount option \"%s\" or missing value", opt);
 	return -1;
 }
 
@@ -1623,21 +1619,20 @@ static int parse_options(char *options, struct super_block *sb,
 			clear_opt(sb, GRPQUOTA);
 
 		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
-			ext4_msg(sb, KERN_ERR, "old and new quota "
-					"format mixing");
+			ext4_msg(sb, KERN_ERR,
+				 "old and new quota format mixing");
 			return 0;
 		}
 
 		if (!sbi->s_jquota_fmt) {
-			ext4_msg(sb, KERN_ERR, "journaled quota format "
-					"not specified");
+			ext4_msg(sb, KERN_ERR,
+				 "journaled quota format not specified");
 			return 0;
 		}
 	} else {
 		if (sbi->s_jquota_fmt) {
-			ext4_msg(sb, KERN_ERR, "journaled quota format "
-					"specified with no journaling "
-					"enabled");
+			ext4_msg(sb, KERN_ERR,
+				 "journaled quota format specified with no journaling enabled");
 			return 0;
 		}
 	}
@@ -1806,31 +1801,28 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	int res = 0;
 
 	if (le32_to_cpu(es->s_rev_level) > EXT4_MAX_SUPP_REV) {
-		ext4_msg(sb, KERN_ERR, "revision level too high, "
-			 "forcing read-only mode");
+		ext4_msg(sb, KERN_ERR,
+			 "revision level too high, forcing read-only mode");
 		res = MS_RDONLY;
 	}
 	if (read_only)
 		goto done;
 	if (!(sbi->s_mount_state & EXT4_VALID_FS))
-		ext4_msg(sb, KERN_WARNING, "warning: mounting unchecked fs, "
-			 "running e2fsck is recommended");
+		ext4_msg(sb, KERN_WARNING,
+			 "warning: mounting unchecked fs, running e2fsck is recommended");
 	else if ((sbi->s_mount_state & EXT4_ERROR_FS))
 		ext4_msg(sb, KERN_WARNING,
-			 "warning: mounting fs with errors, "
-			 "running e2fsck is recommended");
+			 "warning: mounting fs with errors, running e2fsck is recommended");
 	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) > 0 &&
 		 le16_to_cpu(es->s_mnt_count) >=
 		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
 		ext4_msg(sb, KERN_WARNING,
-			 "warning: maximal mount count reached, "
-			 "running e2fsck is recommended");
+			 "warning: maximal mount count reached, running e2fsck is recommended");
 	else if (le32_to_cpu(es->s_checkinterval) &&
 		(le32_to_cpu(es->s_lastcheck) +
 			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
 		ext4_msg(sb, KERN_WARNING,
-			 "warning: checktime reached, "
-			 "running e2fsck is recommended");
+			 "warning: checktime reached, running e2fsck is recommended");
 	if (!sbi->s_journal)
 		es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
@@ -1954,7 +1946,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
 		flexbg_flag = 1;
 
-	ext4_debug("Checking group descriptors");
+	ext4_debug("Checking group descriptors\n");
 
 	for (i = 0; i < sbi->s_groups_count; i++) {
 		struct ext4_group_desc *gdp = ext4_get_group_desc(sb, i, NULL);
@@ -1971,32 +1963,33 @@ static int ext4_check_descriptors(struct super_block *sb,
 
 		block_bitmap = ext4_block_bitmap(sb, gdp);
 		if (block_bitmap < first_block || block_bitmap > last_block) {
-			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
-			       "Block bitmap for group %u not in group "
-			       "(block %llu)!", i, block_bitmap);
+			ext4_msg(sb, KERN_ERR,
+				 "%s: Block bitmap for group %u not in group (block %llu)!",
+				 __func__, i, block_bitmap);
 			return 0;
 		}
 		inode_bitmap = ext4_inode_bitmap(sb, gdp);
 		if (inode_bitmap < first_block || inode_bitmap > last_block) {
-			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
-			       "Inode bitmap for group %u not in group "
-			       "(block %llu)!", i, inode_bitmap);
+			ext4_msg(sb, KERN_ERR,
+				 "%s: Inode bitmap for group %u not in group (block %llu)!",
+				 __func__, i, inode_bitmap);
 			return 0;
 		}
 		inode_table = ext4_inode_table(sb, gdp);
 		if (inode_table < first_block ||
 		    inode_table + sbi->s_itb_per_group - 1 > last_block) {
-			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
-			       "Inode table for group %u not in group "
-			       "(block %llu)!", i, inode_table);
+			ext4_msg(sb, KERN_ERR,
+				 "%s: Inode table for group %u not in group (block %llu)!",
+				 __func__, i, inode_table);
 			return 0;
 		}
 		ext4_lock_group(sb, i);
 		if (!ext4_group_desc_csum_verify(sbi, i, gdp)) {
-			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
-				 "Checksum for group %u failed (%u!=%u)",
-				 i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
-				     gdp)), le16_to_cpu(gdp->bg_checksum));
+			ext4_msg(sb, KERN_ERR,
+				 "%s: Checksum for group %u failed (%u!=%u)",
+				 __func__, i,
+				 le16_to_cpu(ext4_group_desc_csum(sbi, i, gdp)),
+				 le16_to_cpu(gdp->bg_checksum));
 			if (!(sb->s_flags & MS_RDONLY)) {
 				ext4_unlock_group(sb, i);
 				return 0;
@@ -2046,22 +2039,21 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 	}
 
 	if (bdev_read_only(sb->s_bdev)) {
-		ext4_msg(sb, KERN_ERR, "write access "
-			"unavailable, skipping orphan cleanup");
+		ext4_msg(sb, KERN_ERR,
+			 "write access unavailable, skipping orphan cleanup");
 		return;
 	}
 
 	/* Check if feature set would not allow a r/w mount */
 	if (!ext4_feature_set_ok(sb, 0)) {
-		ext4_msg(sb, KERN_INFO, "Skipping orphan cleanup due to "
-			 "unknown ROCOMPAT features");
+		ext4_msg(sb, KERN_INFO,
+			 "Skipping orphan cleanup due to unknown ROCOMPAT features");
 		return;
 	}
 
 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
 		if (es->s_last_orphan)
-			jbd_debug(1, "Errors on filesystem, "
-				  "clearing orphan list.\n");
+			jbd_debug(1, "Errors on filesystem, clearing orphan list.\n");
 		es->s_last_orphan = 0;
 		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
 		return;
@@ -2080,8 +2072,8 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 			int ret = ext4_quota_on_mount(sb, i);
 			if (ret < 0)
 				ext4_msg(sb, KERN_ERR,
-					"Cannot turn on journaled "
-					"quota: error %d", ret);
+					"Cannot turn on journaled quota: error %d",
+					 ret);
 		}
 	}
 #endif
@@ -2099,16 +2091,16 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		dquot_initialize(inode);
 		if (inode->i_nlink) {
 			ext4_msg(sb, KERN_DEBUG,
-				"%s: truncating inode %lu to %lld bytes",
-				__func__, inode->i_ino, inode->i_size);
+				 "%s: truncating inode %lu to %lld bytes",
+				 __func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
 			ext4_truncate(inode);
 			nr_truncates++;
 		} else {
 			ext4_msg(sb, KERN_DEBUG,
-				"%s: deleting unreferenced inode %lu",
-				__func__, inode->i_ino);
+				 "%s: deleting unreferenced inode %lu",
+				 __func__, inode->i_ino);
 			jbd_debug(2, "deleting unreferenced inode %lu\n",
 				  inode->i_ino);
 			nr_orphans++;
@@ -2120,10 +2112,10 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 
 	if (nr_orphans)
 		ext4_msg(sb, KERN_INFO, "%d orphan inode%s deleted",
-		       PLURAL(nr_orphans));
+			 PLURAL(nr_orphans));
 	if (nr_truncates)
 		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
-		       PLURAL(nr_truncates));
+			 PLURAL(nr_truncates));
 #ifdef CONFIG_QUOTA
 	/* Turn quotas off */
 	for (i = 0; i < MAXQUOTAS; i++) {
@@ -2529,10 +2521,9 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 {
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT4_FEATURE_INCOMPAT_SUPP)) {
 		ext4_msg(sb, KERN_ERR,
-			"Couldn't mount because of "
-			"unsupported optional features (%x)",
-			(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) &
-			~EXT4_FEATURE_INCOMPAT_SUPP));
+			 "Couldn't mount because of unsupported optional features (%x)",
+			 (le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) &
+			  ~EXT4_FEATURE_INCOMPAT_SUPP));
 		return 0;
 	}
 
@@ -2541,10 +2532,10 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 
 	/* Check that feature set is OK for a read-write mount */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT4_FEATURE_RO_COMPAT_SUPP)) {
-		ext4_msg(sb, KERN_ERR, "couldn't mount RDWR because of "
-			 "unsupported optional features (%x)",
+		ext4_msg(sb, KERN_ERR,
+			 "couldn't mount RDWR because of unsupported optional features (%x)",
 			 (le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) &
-				~EXT4_FEATURE_RO_COMPAT_SUPP));
+			  ~EXT4_FEATURE_RO_COMPAT_SUPP));
 		return 0;
 	}
 	/*
@@ -2553,17 +2544,15 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 	 */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
 		if (sizeof(blkcnt_t) < sizeof(u64)) {
-			ext4_msg(sb, KERN_ERR, "Filesystem with huge files "
-				 "cannot be mounted RDWR without "
-				 "CONFIG_LBDAF");
+			ext4_msg(sb, KERN_ERR,
+				 "Filesystem with huge files cannot be mounted RDWR without CONFIG_LBDAF");
 			return 0;
 		}
 	}
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
 	    !EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 		ext4_msg(sb, KERN_ERR,
-			 "Can't support bigalloc feature without "
-			 "extents feature\n");
+			 "Can't support bigalloc feature without extents feature");
 		return 0;
 	}
 	return 1;
@@ -3105,13 +3094,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
 		pr_warn_once("Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!\n");
 		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+			ext4_msg(sb, KERN_ERR,
+				 "can't mount with both data=journal and delalloc");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DIOREAD_NOLOCK)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+			ext4_msg(sb, KERN_ERR,
+				 "can't mount with both data=journal and delalloc");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DELALLOC))
@@ -3121,8 +3110,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
 	if (test_opt(sb, DIOREAD_NOLOCK)) {
 		if (blocksize < PAGE_SIZE) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "dioread_nolock if block size != PAGE_SIZE");
+			ext4_msg(sb, KERN_ERR,
+				 "can't mount with dioread_nolock if block size != PAGE_SIZE");
 			goto failed_mount;
 		}
 	}
@@ -3135,27 +3124,26 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	     EXT4_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT4_HAS_INCOMPAT_FEATURE(sb, ~0U)))
 		ext4_msg(sb, KERN_WARNING,
-		       "feature flags set on rev 0 fs, "
-		       "running e2fsck is recommended");
+			 "feature flags set on rev 0 fs, running e2fsck is recommended");
 
 	if (IS_EXT2_SB(sb)) {
 		if (ext2_feature_set_ok(sb))
-			ext4_msg(sb, KERN_INFO, "mounting ext2 file system "
-				 "using the ext4 subsystem");
+			ext4_msg(sb, KERN_INFO,
+				 "mounting ext2 file system using the ext4 subsystem");
 		else {
-			ext4_msg(sb, KERN_ERR, "couldn't mount as ext2 due "
-				 "to feature incompatibilities");
+			ext4_msg(sb, KERN_ERR,
+				 "couldn't mount as ext2 due to feature incompatibilities");
 			goto failed_mount;
 		}
 	}
 
 	if (IS_EXT3_SB(sb)) {
 		if (ext3_feature_set_ok(sb))
-			ext4_msg(sb, KERN_INFO, "mounting ext3 file system "
-				 "using the ext4 subsystem");
+			ext4_msg(sb, KERN_INFO,
+				 "mounting ext3 file system using the ext4 subsystem");
 		else {
-			ext4_msg(sb, KERN_ERR, "couldn't mount as ext3 due "
-				 "to feature incompatibilities");
+			ext4_msg(sb, KERN_ERR,
+				 "couldn't mount as ext3 due to feature incompatibilities");
 			goto failed_mount;
 		}
 	}
@@ -3171,7 +3159,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
 	    blocksize > EXT4_MAX_BLOCK_SIZE) {
 		ext4_msg(sb, KERN_ERR,
-		       "Unsupported filesystem blocksize %d", blocksize);
+			 "Unsupported filesystem blocksize %d", blocksize);
 		goto failed_mount;
 	}
 
@@ -3179,7 +3167,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		/* Validate the filesystem blocksize */
 		if (!sb_set_blocksize(sb, blocksize)) {
 			ext4_msg(sb, KERN_ERR, "bad block size %d",
-					blocksize);
+				 blocksize);
 			goto failed_mount;
 		}
 
@@ -3189,14 +3177,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		bh = sb_bread(sb, logical_sb_block);
 		if (!bh) {
 			ext4_msg(sb, KERN_ERR,
-			       "Can't read superblock on 2nd try");
+				 "Can't read superblock on 2nd try");
 			goto failed_mount;
 		}
 		es = (struct ext4_super_block *)(((char *)bh->b_data) + offset);
 		sbi->s_es = es;
 		if (es->s_magic != cpu_to_le16(EXT4_SUPER_MAGIC)) {
 			ext4_msg(sb, KERN_ERR,
-			       "Magic mismatch, very weird!");
+				 "Magic mismatch, very weird!");
 			goto failed_mount;
 		}
 	}
@@ -3217,8 +3205,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		    (!is_power_of_2(sbi->s_inode_size)) ||
 		    (sbi->s_inode_size > blocksize)) {
 			ext4_msg(sb, KERN_ERR,
-			       "unsupported inode size: %d",
-			       sbi->s_inode_size);
+				 "unsupported inode size: %d",
+				 sbi->s_inode_size);
 			goto failed_mount;
 		}
 		if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE)
@@ -3231,8 +3219,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		    sbi->s_desc_size > EXT4_MAX_DESC_SIZE ||
 		    !is_power_of_2(sbi->s_desc_size)) {
 			ext4_msg(sb, KERN_ERR,
-			       "unsupported descriptor size %lu",
-			       sbi->s_desc_size);
+				 "unsupported descriptor size %lu",
+				 sbi->s_desc_size);
 			goto failed_mount;
 		}
 	} else
@@ -3277,8 +3265,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (has_bigalloc) {
 		if (clustersize < blocksize) {
 			ext4_msg(sb, KERN_ERR,
-				 "cluster size (%d) smaller than "
-				 "block size (%d)", clustersize, blocksize);
+				 "cluster size (%d) smaller than block size (%d)",
+				 clustersize, blocksize);
 			goto failed_mount;
 		}
 		sbi->s_cluster_bits = le32_to_cpu(es->s_log_cluster_size) -
@@ -3293,17 +3281,16 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 		if (sbi->s_blocks_per_group !=
 		    (sbi->s_clusters_per_group * (clustersize / blocksize))) {
-			ext4_msg(sb, KERN_ERR, "blocks per group (%lu) and "
-				 "clusters per group (%lu) inconsistent",
+			ext4_msg(sb, KERN_ERR,
+				 "blocks per group (%lu) and clusters per group (%lu) inconsistent",
 				 sbi->s_blocks_per_group,
 				 sbi->s_clusters_per_group);
 			goto failed_mount;
 		}
 	} else {
 		if (clustersize != blocksize) {
-			ext4_warning(sb, "fragment/cluster size (%d) != "
-				     "block size (%d)", clustersize,
-				     blocksize);
+			ext4_warning(sb, "fragment/cluster size (%d) != block size (%d)",
+				     clustersize, blocksize);
 			clustersize = blocksize;
 		}
 		if (sbi->s_blocks_per_group > blocksize * 8) {
@@ -3319,8 +3306,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (sbi->s_inodes_per_group > blocksize * 8) {
 		ext4_msg(sb, KERN_ERR,
-		       "#inodes per group too big: %lu",
-		       sbi->s_inodes_per_group);
+			 "#inodes per group too big: %lu",
+			 sbi->s_inodes_per_group);
 		goto failed_mount;
 	}
 
@@ -3331,8 +3318,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	err = generic_check_addressable(sb->s_blocksize_bits,
 					ext4_blocks_count(es));
 	if (err) {
-		ext4_msg(sb, KERN_ERR, "filesystem"
-			 " too large to mount safely on this system");
+		ext4_msg(sb, KERN_ERR,
+			 "filesystem too large to mount safely on this system");
 		if (sizeof(sector_t) < 8)
 			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
 		ret = err;
@@ -3345,8 +3332,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	/* check blocks count against device size */
 	blocks_count = sb->s_bdev->bd_inode->i_size >> sb->s_blocksize_bits;
 	if (blocks_count && ext4_blocks_count(es) > blocks_count) {
-		ext4_msg(sb, KERN_WARNING, "bad geometry: block count %llu "
-		       "exceeds size of device (%llu blocks)",
+		ext4_msg(sb, KERN_WARNING,
+			 "bad geometry: block count %llu exceeds size of device (%llu blocks)",
 		       ext4_blocks_count(es), blocks_count);
 		goto failed_mount;
 	}
@@ -3356,8 +3343,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * of the filesystem.
 	 */
 	if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
-		ext4_msg(sb, KERN_WARNING, "bad geometry: first data "
-			 "block %u is beyond end of filesystem (%llu)",
+		ext4_msg(sb, KERN_WARNING,
+			 "bad geometry: first data block %u is beyond end of filesystem (%llu)",
 			 le32_to_cpu(es->s_first_data_block),
 			 ext4_blocks_count(es));
 		goto failed_mount;
@@ -3367,12 +3354,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
 	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
 	if (blocks_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
-		ext4_msg(sb, KERN_WARNING, "groups count too large: %u "
-		       "(block count %llu, first data block %u, "
-		       "blocks per group %lu)", sbi->s_groups_count,
-		       ext4_blocks_count(es),
-		       le32_to_cpu(es->s_first_data_block),
-		       EXT4_BLOCKS_PER_GROUP(sb));
+		ext4_msg(sb, KERN_WARNING,
+			 "groups count too large: %u (block count %llu, first data block %u, blocks per group %lu)",
+			 sbi->s_groups_count,
+			 ext4_blocks_count(es),
+			 le32_to_cpu(es->s_first_data_block),
+			 EXT4_BLOCKS_PER_GROUP(sb));
 		goto failed_mount;
 	}
 	sbi->s_groups_count = blocks_count;
@@ -3402,7 +3389,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sbi->s_group_desc[i] = sb_bread(sb, block);
 		if (!sbi->s_group_desc[i]) {
 			ext4_msg(sb, KERN_ERR,
-			       "can't read group descriptor %d", i);
+				 "can't read group descriptor %d", i);
 			db_count = i;
 			goto failed_mount2;
 		}
@@ -3414,8 +3401,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
 		if (!ext4_fill_flex_info(sb)) {
 			ext4_msg(sb, KERN_ERR,
-			       "unable to initialize "
-			       "flex_bg meta info!");
+				 "unable to initialize flex_bg meta info!");
 			goto failed_mount2;
 		}
 
@@ -3489,8 +3475,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			goto failed_mount3;
 	} else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&
 	      EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
-		ext4_msg(sb, KERN_ERR, "required journal recovery "
-		       "suppressed and not mounted read-only");
+		ext4_msg(sb, KERN_ERR,
+			 "required journal recovery suppressed and not mounted read-only");
 		goto failed_mount_wq;
 	} else {
 		clear_opt(sb, DATA_FLAGS);
@@ -3540,8 +3526,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	case EXT4_MOUNT_WRITEBACK_DATA:
 		if (!jbd2_journal_check_available_features
 		    (sbi->s_journal, 0, 0, JBD2_FEATURE_INCOMPAT_REVOKE)) {
-			ext4_msg(sb, KERN_ERR, "Journal does not support "
-			       "requested data journaling mode");
+			ext4_msg(sb, KERN_ERR,
+				 "Journal does not support requested data journaling mode");
 			goto failed_mount_wq;
 		}
 	default:
@@ -3622,14 +3608,14 @@ no_journal:
 							sbi->s_inode_size) {
 		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
 						       EXT4_GOOD_OLD_INODE_SIZE;
-		ext4_msg(sb, KERN_INFO, "required extra inode space not"
-			 "available");
+		ext4_msg(sb, KERN_INFO,
+			 "required extra inode space not available");
 	}
 
 	err = ext4_setup_system_zone(sb);
 	if (err) {
-		ext4_msg(sb, KERN_ERR, "failed to initialize system "
-			 "zone (%d)", err);
+		ext4_msg(sb, KERN_ERR, "failed to initialize system zone (%d)",
+			 err);
 		goto failed_mount4a;
 	}
 
@@ -3669,8 +3655,8 @@ no_journal:
 	} else
 		descr = "out journal";
 
-	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
-		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
+	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. Opts: %s%s%s",
+		 descr, sbi->s_es->s_mount_opts,
 		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
 
 	if (es->s_error_count)
@@ -3827,7 +3813,7 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	hblock = bdev_logical_block_size(bdev);
 	if (blocksize < hblock) {
 		ext4_msg(sb, KERN_ERR,
-			"blocksize too small for journal device");
+			 "blocksize too small for journal device");
 		goto out_bdev;
 	}
 
@@ -3835,8 +3821,8 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	offset = EXT4_MIN_BLOCK_SIZE % blocksize;
 	set_blocksize(bdev, blocksize);
 	if (!(bh = __bread(bdev, sb_block, blocksize))) {
-		ext4_msg(sb, KERN_ERR, "couldn't read superblock of "
-		       "external journal");
+		ext4_msg(sb, KERN_ERR,
+			 "couldn't read superblock of external journal");
 		goto out_bdev;
 	}
 
@@ -3844,8 +3830,7 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	if ((le16_to_cpu(es->s_magic) != EXT4_SUPER_MAGIC) ||
 	    !(le32_to_cpu(es->s_feature_incompat) &
 	      EXT4_FEATURE_INCOMPAT_JOURNAL_DEV)) {
-		ext4_msg(sb, KERN_ERR, "external journal has "
-					"bad superblock");
+		ext4_msg(sb, KERN_ERR, "external journal has bad superblock");
 		brelse(bh);
 		goto out_bdev;
 	}
@@ -3874,9 +3859,9 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 		goto out_journal;
 	}
 	if (be32_to_cpu(journal->j_superblock->s_nr_users) != 1) {
-		ext4_msg(sb, KERN_ERR, "External journal has more than one "
-					"user (unsupported) - %d",
-			be32_to_cpu(journal->j_superblock->s_nr_users));
+		ext4_msg(sb, KERN_ERR,
+			 "External journal has more than one user (unsupported) - %d",
+			 be32_to_cpu(journal->j_superblock->s_nr_users));
 		goto out_journal;
 	}
 	EXT4_SB(sb)->journal_bdev = bdev;
@@ -3904,8 +3889,8 @@ static int ext4_load_journal(struct super_block *sb,
 
 	if (journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
-		ext4_msg(sb, KERN_INFO, "external journal device major/minor "
-			"numbers have changed");
+		ext4_msg(sb, KERN_INFO,
+			 "external journal device major/minor numbers have changed");
 		journal_dev = new_decode_dev(journal_devnum);
 	} else
 		journal_dev = new_decode_dev(le32_to_cpu(es->s_journal_dev));
@@ -3919,21 +3904,21 @@ static int ext4_load_journal(struct super_block *sb,
 	 */
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
 		if (sb->s_flags & MS_RDONLY) {
-			ext4_msg(sb, KERN_INFO, "INFO: recovery "
-					"required on readonly filesystem");
+			ext4_msg(sb, KERN_INFO,
+				 "INFO: recovery required on readonly filesystem");
 			if (really_read_only) {
-				ext4_msg(sb, KERN_ERR, "write access "
-					"unavailable, cannot proceed");
+				ext4_msg(sb, KERN_ERR,
+					 "write access unavailable, cannot proceed");
 				return -EROFS;
 			}
-			ext4_msg(sb, KERN_INFO, "write access will "
-			       "be enabled during recovery");
+			ext4_msg(sb, KERN_INFO,
+				 "write access will be enabled during recovery");
 		}
 	}
 
 	if (journal_inum && journal_dev) {
-		ext4_msg(sb, KERN_ERR, "filesystem has both journal "
-		       "and inode journals!");
+		ext4_msg(sb, KERN_ERR,
+			 "filesystem has both journal and inode journals!");
 		return -EINVAL;
 	}
 
@@ -3999,8 +3984,8 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 		 * be remapped.  Nothing we can do but to retry the
 		 * write and hope for the best.
 		 */
-		ext4_msg(sb, KERN_ERR, "previous I/O error to "
-		       "superblock detected");
+		ext4_msg(sb, KERN_ERR,
+			 "previous I/O error to superblock detected");
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
@@ -4040,8 +4025,8 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 
 		error = buffer_write_io_error(sbh);
 		if (error) {
-			ext4_msg(sb, KERN_ERR, "I/O error while writing "
-			       "superblock");
+			ext4_msg(sb, KERN_ERR,
+				 "I/O error while writing superblock");
 			clear_buffer_write_io_error(sbh);
 			set_buffer_uptodate(sbh);
 		}
@@ -4103,9 +4088,9 @@ static void ext4_clear_journal_err(struct super_block *sb,
 		char nbuf[16];
 
 		errstr = ext4_decode_error(sb, j_errno, nbuf);
-		ext4_warning(sb, "Filesystem error recorded "
-			     "from previous mount: %s", errstr);
-		ext4_warning(sb, "Marking fs in need of filesystem check.");
+		ext4_warning(sb, "Filesystem error recorded from previous mount: %s",
+			     errstr);
+		ext4_warning(sb, "Marking fs in need of filesystem check");
 
 		EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
@@ -4328,9 +4313,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 
 				if (!ext4_group_desc_csum_verify(sbi, g, gdp)) {
 					ext4_msg(sb, KERN_ERR,
-	       "ext4_remount: Checksum for group %u failed (%u!=%u)",
-		g, le16_to_cpu(ext4_group_desc_csum(sbi, g, gdp)),
-					       le16_to_cpu(gdp->bg_checksum));
+						 "%s: Checksum for group %u failed (%u!=%u)",
+						 __func__, g,
+						 le16_to_cpu(ext4_group_desc_csum(sbi, g, gdp)),
+						 le16_to_cpu(gdp->bg_checksum));
 					err = -EINVAL;
 					goto restore_opts;
 				}
@@ -4342,10 +4328,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			 * require a full umount/remount for now.
 			 */
 			if (es->s_last_orphan) {
-				ext4_msg(sb, KERN_WARNING, "Couldn't "
-				       "remount RDWR because of unprocessed "
-				       "orphan inode list.  Please "
-				       "umount/remount instead");
+				ext4_msg(sb, KERN_WARNING,
+					 "Couldn't remount RDWR because of unprocessed orphan inode list.  Please umount/remount instead.");
 				err = -EINVAL;
 				goto restore_opts;
 			}
@@ -4632,8 +4616,7 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 		/* Quotafile not in fs root? */
 		if (path->dentry->d_parent != sb->s_root)
 			ext4_msg(sb, KERN_WARNING,
-				"Quota file not on filesystem root. "
-				"Journaled quota will not work");
+				"Quota file not on filesystem root. Journaled quota will not work.");
 	}
 
 	/*
@@ -4735,9 +4718,9 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	handle_t *handle = journal_current_handle();
 
 	if (EXT4_SB(sb)->s_journal && !handle) {
-		ext4_msg(sb, KERN_WARNING, "Quota write (off=%llu, len=%llu)"
-			" cancelled because transaction is not started",
-			(unsigned long long)off, (unsigned long long)len);
+		ext4_msg(sb, KERN_WARNING,
+			 "Quota write (off=%llu, len=%llu) cancelled because transaction is not started",
+			 (unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
 	/*
@@ -4745,9 +4728,9 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	 * then it is impossible to cross a block boundary.
 	 */
 	if (sb->s_blocksize - offset < len) {
-		ext4_msg(sb, KERN_WARNING, "Quota write (off=%llu, len=%llu)"
-			" cancelled because not block aligned",
-			(unsigned long long)off, (unsigned long long)len);
+		ext4_msg(sb, KERN_WARNING,
+			 "Quota write (off=%llu, len=%llu) cancelled because not block aligned",
+			 (unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
 
-- 
1.7.8.111.gad25c.dirty
