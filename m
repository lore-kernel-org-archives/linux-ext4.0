From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/6] ext4: Move LRU list handling into extent status code
Date: Fri, 14 Nov 2014 11:45:53 +0100
Message-ID: <1415961957-21621-3-git-send-email-jack@suse.cz>
References: <1415961957-21621-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935099AbaKNKqD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Nov 2014 05:46:03 -0500
In-Reply-To: <1415961957-21621-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently callers adding extents to extent status tree were responsible
for adding the inode to LRU list. This is error prone and puts LRU list
handling in unnecessarily many places.

Just add inode to LRU automatically when the first non-delay extent is
added to the tree and remove inode from LRU when the last non-delay
extent is removed.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c        |  2 --
 fs/ext4/extents_status.c | 10 ++++++----
 fs/ext4/extents_status.h |  2 --
 fs/ext4/inode.c          |  2 --
 fs/ext4/ioctl.c          |  2 --
 fs/ext4/super.c          |  1 -
 6 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0a97e039d0a0..923327719507 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4622,7 +4622,6 @@ out2:
 
 	trace_ext4_ext_map_blocks_exit(inode, flags, map,
 				       err ? err : allocated);
-	ext4_es_lru_add(inode);
 	return err ? err : allocated;
 }
 
@@ -5181,7 +5180,6 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		error = ext4_fill_fiemap_extents(inode, start_blk,
 						 len_blks, fieinfo);
 	}
-	ext4_es_lru_add(inode);
 	return error;
 }
 
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 94e7855ae71b..339a9e1678e6 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -314,7 +314,8 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 	 * We don't count delayed extent because we never try to reclaim them
 	 */
 	if (!ext4_es_is_delayed(es)) {
-		EXT4_I(inode)->i_es_lru_nr++;
+		if (!EXT4_I(inode)->i_es_lru_nr++)
+			ext4_es_lru_add(inode);
 		percpu_counter_inc(&EXT4_SB(inode->i_sb)->
 					s_es_stats.es_stats_lru_cnt);
 	}
@@ -333,7 +334,8 @@ static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 	/* Decrease the lru counter when this es is not delayed */
 	if (!ext4_es_is_delayed(es)) {
 		BUG_ON(EXT4_I(inode)->i_es_lru_nr == 0);
-		EXT4_I(inode)->i_es_lru_nr--;
+		if (!--EXT4_I(inode)->i_es_lru_nr)
+			ext4_es_lru_del(inode);
 		percpu_counter_dec(&EXT4_SB(inode->i_sb)->
 					s_es_stats.es_stats_lru_cnt);
 	}
@@ -1225,7 +1227,7 @@ void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
 	unregister_shrinker(&sbi->s_es_shrinker);
 }
 
-void ext4_es_lru_add(struct inode *inode)
+static void ext4_es_lru_add(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -1241,7 +1243,7 @@ void ext4_es_lru_add(struct inode *inode)
 	spin_unlock(&sbi->s_es_lru_lock);
 }
 
-void ext4_es_lru_del(struct inode *inode)
+static void ext4_es_lru_del(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index efd5f970b501..9b5e7616b116 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -151,7 +151,5 @@ static inline void ext4_es_store_pblock_status(struct extent_status *es,
 
 extern int ext4_es_register_shrinker(struct ext4_sb_info *sbi);
 extern void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi);
-extern void ext4_es_lru_add(struct inode *inode);
-extern void ext4_es_lru_del(struct inode *inode);
 
 #endif /* _EXT4_EXTENTS_STATUS_H */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 69601d288119..e9e580152720 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -491,7 +491,6 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
-		ext4_es_lru_add(inode);
 		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
 			map->m_pblk = ext4_es_pblock(&es) +
 					map->m_lblk - es.es_lblk;
@@ -1393,7 +1392,6 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, iblock, &es)) {
-		ext4_es_lru_add(inode);
 		if (ext4_es_is_hole(&es)) {
 			retval = 0;
 			down_read(&EXT4_I(inode)->i_data_sem);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bfda18a15592..f58a0d106726 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -78,8 +78,6 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
 	memswap(&ei1->i_disksize, &ei2->i_disksize, sizeof(ei1->i_disksize));
 	ext4_es_remove_extent(inode1, 0, EXT_MAX_BLOCKS);
 	ext4_es_remove_extent(inode2, 0, EXT_MAX_BLOCKS);
-	ext4_es_lru_del(inode1);
-	ext4_es_lru_del(inode2);
 
 	isize = i_size_read(inode1);
 	i_size_write(inode1, i_size_read(inode2));
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1eda6ab0ef9d..9f052d49553e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -972,7 +972,6 @@ void ext4_clear_inode(struct inode *inode)
 	dquot_drop(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-	ext4_es_lru_del(inode);
 	if (EXT4_I(inode)->jinode) {
 		jbd2_journal_release_jbd_inode(EXT4_JOURNAL(inode),
 					       EXT4_I(inode)->jinode);
-- 
1.8.1.4

