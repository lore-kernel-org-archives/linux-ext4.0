From: Vivek Haldar <haldar@google.com>
Subject: [PATCH] ext4: protect extent cache with r/w spinlock.
Date: Mon,  7 Nov 2011 15:13:08 -0800
Message-ID: <1320707588-14595-1-git-send-email-haldar@google.com>
Cc: Vivek Haldar <haldar@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The extent cache used to be protected by an exclusive spinlock. Using
a r/w lock instead will allow multiple concurrent readers. Also, use
percpu counters for cache hit/miss stats.

Tested: xfstests.

Signed-off-by: Vivek Haldar <haldar@google.com>
---
 fs/ext4/ext4.h    |   10 +++++++---
 fs/ext4/extents.c |   17 +++++++----------
 fs/ext4/super.c   |   18 ++++++++++++++++--
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 604c200..4732e55 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -882,6 +882,9 @@ struct ext4_inode_info {
 	ext4_io_end_t *cur_aio_dio;
 	atomic_t i_aiodio_unwritten; /* Nr. of inflight conversions pending */
 
+	/* r/w lock for extent cache */
+	rwlock_t extent_cache_lock;
+
 	spinlock_t i_block_reservation_lock;
 
 	/*
@@ -1183,9 +1186,10 @@ struct ext4_sb_info {
 	unsigned long s_ext_blocks;
 	unsigned long s_ext_extents;
 #endif
-	/* ext4 extent cache stats */
-	unsigned long extent_cache_hits;
-	unsigned long extent_cache_misses;
+
+	/* ext4 extent cache stats, per cpu */
+	struct percpu_counter extent_cache_hits;
+	struct percpu_counter extent_cache_misses;
 
 	/* for buddy allocator */
 	struct ext4_group_info ***s_group_info;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..9dd748f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1951,13 +1951,13 @@ ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
 {
 	struct ext4_ext_cache *cex;
 	BUG_ON(len == 0);
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+	write_lock(&EXT4_I(inode)->extent_cache_lock);
 	trace_ext4_ext_put_in_cache(inode, block, len, start);
 	cex = &EXT4_I(inode)->i_cached_extent;
 	cex->ec_block = block;
 	cex->ec_len = len;
 	cex->ec_start = start;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	write_unlock(&EXT4_I(inode)->extent_cache_lock);
 }
 
 /*
@@ -2031,10 +2031,7 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
 	struct ext4_sb_info *sbi;
 	int ret = 0;
 
-	/*
-	 * We borrow i_block_reservation_lock to protect i_cached_extent
-	 */
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+	read_lock(&EXT4_I(inode)->extent_cache_lock);
 	cex = &EXT4_I(inode)->i_cached_extent;
 	sbi = EXT4_SB(inode->i_sb);
 
@@ -2050,12 +2047,12 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
 		ret = 1;
 	}
 errout:
+	trace_ext4_ext_in_cache(inode, block, ret);
+	read_unlock(&EXT4_I(inode)->extent_cache_lock);
 	if (!ret)
-		sbi->extent_cache_misses++;
+		percpu_counter_inc(&sbi->extent_cache_misses);
 	else
-		sbi->extent_cache_hits++;
-	trace_ext4_ext_in_cache(inode, block, ret);
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		percpu_counter_inc(&sbi->extent_cache_hits);
 	return ret;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9953d80..739ca96 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -842,6 +842,8 @@ static void ext4_put_super(struct super_block *sb)
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
+	percpu_counter_destroy(&sbi->extent_cache_hits);
+	percpu_counter_destroy(&sbi->extent_cache_misses);
 	brelse(sbi->s_sbh);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < MAXQUOTAS; i++)
@@ -904,6 +906,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_da_metadata_calc_len = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
+	rwlock_init(&(ei->extent_cache_lock));
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
 #endif
@@ -2507,13 +2510,15 @@ static ssize_t lifetime_write_kbytes_show(struct ext4_attr *a,
 static ssize_t extent_cache_hits_show(struct ext4_attr *a,
 				      struct ext4_sb_info *sbi, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%lu\n", sbi->extent_cache_hits);
+	return snprintf(buf, PAGE_SIZE, "%lld\n",
+			percpu_counter_sum(&sbi->extent_cache_hits));
 }
 
 static ssize_t extent_cache_misses_show(struct ext4_attr *a,
 					struct ext4_sb_info *sbi, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%lu\n", sbi->extent_cache_misses);
+	return snprintf(buf, PAGE_SIZE, "%lld\n",
+			percpu_counter_sum(&sbi->extent_cache_misses));
 }
 
 static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
@@ -3589,6 +3594,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (!err) {
 		err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0);
 	}
+
+	/* Allocate cache hit/miss counters. */
+	if (!err)
+		err = percpu_counter_init(&sbi->extent_cache_hits, 0);
+	if (!err)
+		err = percpu_counter_init(&sbi->extent_cache_misses, 0);
+
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "insufficient memory");
 		goto failed_mount3;
@@ -3855,6 +3867,8 @@ failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
+	percpu_counter_destroy(&sbi->extent_cache_hits);
+	percpu_counter_destroy(&sbi->extent_cache_misses);
 	if (sbi->s_mmp_tsk)
 		kthread_stop(sbi->s_mmp_tsk);
 failed_mount2:
-- 
1.7.3.1
