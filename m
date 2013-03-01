From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: optimize ext4_es_shrink()
Date: Fri, 1 Mar 2013 00:00:29 -0500
Message-ID: <20130301050029.GB4452@thunk.org>
References: <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185625.GA224@x4>
 <20130227191923.GA1121@redhat.com>
 <20130227192907.GB14253@thunk.org>
 <20130227201217.GD14253@thunk.org>
 <20130301033005.GA7081@redhat.com>
 <20130301040039.GA4452@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50706 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab3CAFAf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Mar 2013 00:00:35 -0500
Content-Disposition: inline
In-Reply-To: <20130301040039.GA4452@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When the system is under memory pressure, ext4_es_srhink() will get
called very often.  So optimize returning the number of items in the
file system's extent status cache by keeping a per-filesystem count,
instead of calculating it each time by scanning all of the inodes in
the extent status cache.

Also rename the slab used for the extent status cache to be
"ext4_extent_status" so it's obviousl the slab in question is created
by ext4.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Zheng Liu <gnehzuil.liu@gmail.com>
---
 fs/ext4/ext4.h              |  1 +
 fs/ext4/extents_status.c    | 39 +++++++++++++--------------------------
 include/trace/events/ext4.h | 40 ++++++++++++----------------------------
 3 files changed, 26 insertions(+), 54 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6e16c18..96c1093 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1268,6 +1268,7 @@ struct ext4_sb_info {
 	atomic_t s_mb_preallocated;
 	atomic_t s_mb_discarded;
 	atomic_t s_lock_busy;
+	atomic_t s_extent_cache_cnt;
 
 	/* locality groups */
 	struct ext4_locality_group __percpu *s_locality_groups;
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index f768f4a..27fcdd2 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -147,11 +147,12 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      ext4_lblk_t end);
 static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
 				       int nr_to_scan);
-static int ext4_es_reclaim_extents_count(struct super_block *sb);
 
 int __init ext4_init_es(void)
 {
-	ext4_es_cachep = KMEM_CACHE(extent_status, SLAB_RECLAIM_ACCOUNT);
+	ext4_es_cachep = kmem_cache_create("ext4_extent_status",
+					   sizeof(struct extent_status),
+					   0, (SLAB_RECLAIM_ACCOUNT), NULL);
 	if (ext4_es_cachep == NULL)
 		return -ENOMEM;
 	return 0;
@@ -302,8 +303,10 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 	/*
 	 * We don't count delayed extent because we never try to reclaim them
 	 */
-	if (!ext4_es_is_delayed(es))
+	if (!ext4_es_is_delayed(es)) {
 		EXT4_I(inode)->i_es_lru_nr++;
+		atomic_inc(&EXT4_SB(inode->i_sb)->s_extent_cache_cnt);
+	}
 
 	return es;
 }
@@ -314,6 +317,7 @@ static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 	if (!ext4_es_is_delayed(es)) {
 		BUG_ON(EXT4_I(inode)->i_es_lru_nr == 0);
 		EXT4_I(inode)->i_es_lru_nr--;
+		atomic_dec(&EXT4_SB(inode->i_sb)->s_extent_cache_cnt);
 	}
 
 	kmem_cache_free(ext4_es_cachep, es);
@@ -674,10 +678,11 @@ static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
 	int nr_to_scan = sc->nr_to_scan;
 	int ret, nr_shrunk = 0;
 
-	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan);
+	ret = atomic_read(&sbi->s_extent_cache_cnt);
+	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan, ret);
 
 	if (!nr_to_scan)
-		return ext4_es_reclaim_extents_count(sbi->s_sb);
+		return ret;
 
 	INIT_LIST_HEAD(&scanned);
 
@@ -705,9 +710,10 @@ static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
 	}
 	list_splice_tail(&scanned, &sbi->s_es_lru);
 	spin_unlock(&sbi->s_es_lru_lock);
-	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk);
 
-	return ext4_es_reclaim_extents_count(sbi->s_sb);
+	ret = atomic_read(&sbi->s_extent_cache_cnt);
+	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
+	return ret;
 }
 
 void ext4_es_register_shrinker(struct super_block *sb)
@@ -751,25 +757,6 @@ void ext4_es_lru_del(struct inode *inode)
 	spin_unlock(&sbi->s_es_lru_lock);
 }
 
-static int ext4_es_reclaim_extents_count(struct super_block *sb)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_inode_info *ei;
-	struct list_head *cur;
-	int nr_cached = 0;
-
-	spin_lock(&sbi->s_es_lru_lock);
-	list_for_each(cur, &sbi->s_es_lru) {
-		ei = list_entry(cur, struct ext4_inode_info, i_es_lru);
-		read_lock(&ei->i_es_lock);
-		nr_cached += ei->i_es_lru_nr;
-		read_unlock(&ei->i_es_lock);
-	}
-	spin_unlock(&sbi->s_es_lru_lock);
-	trace_ext4_es_reclaim_extents_count(sb, nr_cached);
-	return nr_cached;
-}
-
 static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
 				       int nr_to_scan)
 {
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index c0457c0..4ee4710 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2255,64 +2255,48 @@ TRACE_EVENT(ext4_es_lookup_extent_exit,
 		  __entry->found ? __entry->status : 0)
 );
 
-TRACE_EVENT(ext4_es_reclaim_extents_count,
-	TP_PROTO(struct super_block *sb, int nr_cached),
-
-	TP_ARGS(sb, nr_cached),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	int,	nr_cached		)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= sb->s_dev;
-		__entry->nr_cached	= nr_cached;
-	),
-
-	TP_printk("dev %d,%d cached objects nr %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->nr_cached)
-);
-
 TRACE_EVENT(ext4_es_shrink_enter,
-	TP_PROTO(struct super_block *sb, int nr_to_scan),
+	TP_PROTO(struct super_block *sb, int nr_to_scan, int cache_cnt),
 
-	TP_ARGS(sb, nr_to_scan),
+	TP_ARGS(sb, nr_to_scan, cache_cnt),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	int,	nr_to_scan		)
+		__field(	int,	cache_cnt		)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
 		__entry->nr_to_scan	= nr_to_scan;
+		__entry->cache_cnt	= cache_cnt;
 	),
 
-	TP_printk("dev %d,%d nr to scan %d",
+	TP_printk("dev %d,%d nr_to_scan %d cache_cnt %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->nr_to_scan)
+		  __entry->nr_to_scan, __entry->cache_cnt)
 );
 
 TRACE_EVENT(ext4_es_shrink_exit,
-	TP_PROTO(struct super_block *sb, int shrunk_nr),
+	TP_PROTO(struct super_block *sb, int shrunk_nr, int cache_cnt),
 
-	TP_ARGS(sb, shrunk_nr),
+	TP_ARGS(sb, shrunk_nr, cache_cnt),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	int,	shrunk_nr		)
+		__field(	int,	cache_cnt		)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
 		__entry->shrunk_nr	= shrunk_nr;
+		__entry->cache_cnt	= cache_cnt;
 	),
 
-	TP_printk("dev %d,%d nr to scan %d",
+	TP_printk("dev %d,%d shrunk_nr %d cache_cnt %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->shrunk_nr)
+		  __entry->shrunk_nr, __entry->cache_cnt)
 );
 
 #endif /* _TRACE_EXT4_H */
-- 
1.7.12.rc0.22.gcdd159b

