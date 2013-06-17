From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Mon, 17 Jun 2013 18:10:33 +0800
Message-ID: <20130617101033.GA17828@gmail.com>
References: <51B7B128.60909@intel.com>
 <20130614140940.GA20401@gmail.com>
 <20130614140215.GA1017@thunk.org>
 <20130614170028.GA21544@gmail.com>
 <20130614180054.GB1017@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@intel.com>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jan kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130614180054.GB1017@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 14, 2013 at 02:00:54PM -0400, Theodore Ts'o wrote:
> On Sat, Jun 15, 2013 at 01:00:28AM +0800, Zheng Liu wrote:
> > > I have a suggestion for how to address this: Keep a timestamp of when
> > > the list last has been sorted in struct ext4_super_info.  When
> > > iterating over the list, looking for a candidate inode, if inode's
> > > i_touch_when is greater than the last time sorted, skip the inode.  If
> > > there are no inodes left in the list, or more than some threshold
> > > inodes have been skipped, only then resort the list (and update the
> > > timestamp in the ext4_super_info structure).
> > > 
> > 
> > Thanks for your suggestion.  I fully agree with you.  What I concern is
> > how to define this threshold.  A fixed value is very simple but too
> > inflexible.  If this value is too big, this lru list could never be
> > sorted.
> 
> In my proposal, if the list is never sorted before, we would
> definitely sort the list the first time there is a request to shrink
> the number of extent caches.  So the list would always be sorted at
> least once.
> 
> If an inode gets accessed after the time when the list has been
> sorted, then the last_touch time will be greater than the last_sorted
> time, right?  And our goal is to use the least recently used inode, so
> as long as we know they have been used more recently than the time the
> list was sorted, and there are still inodes on the list where the
> last_touch time is older than the last_sort time, we don't have a
> problem.  So we will evict all of the non-delalloc extent cache items
> from that inode, and remove it from the list.
> 
> The original reason for having the threshold at all is so that if we
> skip a huge number of inodes on the list, this would take a long time.
> But thinking about this some more, we don't even need a threshold.
> What we do instead is if the the last_touch time is newer than the
> last_sort time, we just move the inode to the end of the list.  That
> means the end of the list will be unsorted, but that's OK, because the
> oldest inodes are still at the beginning of the list.  Once the head
> of the list is newer than the last_sorted time, then we know we need
> to resort the entire list.
> 
> Does that make sense to you?

Hi Ted and Dave,

Sorry for the late.  It makes sense to me.  Here is the second version
of patch.  Could you please review it?

Dave, that would be great if you could do your testing again to confirm
this patch is useful.

Any feedback is welcome.

Thanks,
                                                - Zheng


Subject: [PATCH v2] ext4: improve extent cache shrink mechanism to avoid to burn CPU time

From: Zheng Liu <wenqing.lz@taobao.com>

Now we maintain an proper in-order LRU list in ext4 to reclaim entries
from extent status tree when we are under heavy memory pressure.  For
keeping this order, a spin lock is used to protect this list.  But this
lock burns a lot of CPU time.  We can use the following steps to trigger
it.

  % cd /dev/shm
  % dd if=/dev/zero of=ext4-img bs=1M count=2k
  % mkfs.ext4 ext4-img
  % mount -t ext4 -o loop ext4-img /mnt
  % cd /mnt
  % for ((i=0;i<160;i++)); do truncate -s 64g $i; done
  % for ((i=0;i<160;i++)); do cp $i /dev/null &; done
  % perf record -a -g
  % perf report

This commit tries to fix this problem.  Now a new member called
i_touch_when is added into ext4_inode_info to record the last access
time for an inode.  Meanwhile we never need to keep a proper in-order
LRU list.  So this can avoid to burns some CPU time.  When we try to
reclaim some entries from extent status tree, we use list_sort() to get
a proper in-order list.  Then we traverse this list to discard some
entries.  In ext4_sb_info, we use s_es_last_sorted to record the last
time of sorting this list.  When we traverse the list, we skip the inode
that is newer than this time, and move this inode to the tail of LRU
list.  When the head of the list is newer than s_es_last_sorted, we will
sort the LRU list again.

In this commit, we break the loop if s_extent_cache_cnt == 0 because
that means that all extents in extent status tree have been reclaimed.

Meanwhile in this commit, ext4_es_{un}register_shrinker()'s prototype is
changed to save a local variable in these functions.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
changelog:
v2:
	* avoid to sort the LRU list
	* change ext4_es_{un}register_shrinker()'s prototype to save a local
	  variable

 fs/ext4/ext4.h           |    2 ++
 fs/ext4/extents_status.c |   77 ++++++++++++++++++++++++++++++++++------------
 fs/ext4/extents_status.h |    5 +--
 fs/ext4/inode.c          |    4 +++
 fs/ext4/super.c          |    7 +++--
 5 files changed, 70 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 019db3c..f30ff8c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -874,6 +874,7 @@ struct ext4_inode_info {
 	rwlock_t i_es_lock;
 	struct list_head i_es_lru;
 	unsigned int i_es_lru_nr;	/* protected by i_es_lock */
+	unsigned long i_touch_when;	/* jiffies of last accessing */
 
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
@@ -1302,6 +1303,7 @@ struct ext4_sb_info {
 	/* Reclaim extents from extent status tree */
 	struct shrinker s_es_shrinker;
 	struct list_head s_es_lru;
+	unsigned long s_es_last_sorted;
 	struct percpu_counter s_extent_cache_cnt;
 	spinlock_t s_es_lru_lock ____cacheline_aligned_in_smp;
 };
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index e6941e6..80dcc59 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -10,6 +10,7 @@
  * Ext4 extents status tree core functions.
  */
 #include <linux/rbtree.h>
+#include <linux/list_sort.h>
 #include "ext4.h"
 #include "extents_status.h"
 #include "ext4_extents.h"
@@ -291,7 +292,6 @@ out:
 
 	read_unlock(&EXT4_I(inode)->i_es_lock);
 
-	ext4_es_lru_add(inode);
 	trace_ext4_es_find_delayed_extent_range_exit(inode, es);
 }
 
@@ -672,7 +672,6 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 error:
 	write_unlock(&EXT4_I(inode)->i_es_lock);
 
-	ext4_es_lru_add(inode);
 	ext4_es_print_tree(inode);
 
 	return err;
@@ -734,7 +733,6 @@ out:
 
 	read_unlock(&EXT4_I(inode)->i_es_lock);
 
-	ext4_es_lru_add(inode);
 	trace_ext4_es_lookup_extent_exit(inode, es, found);
 	return found;
 }
@@ -878,12 +876,30 @@ int ext4_es_zeroout(struct inode *inode, struct ext4_extent *ex)
 				     EXTENT_STATUS_WRITTEN);
 }
 
+static int ext4_inode_touch_time_cmp(void *priv, struct list_head *a,
+				     struct list_head *b)
+{
+	struct ext4_inode_info *eia, *eib;
+	unsigned long diff;
+
+	eia = list_entry(a, struct ext4_inode_info, i_es_lru);
+	eib = list_entry(b, struct ext4_inode_info, i_es_lru);
+
+	diff = eia->i_touch_when - eib->i_touch_when;
+	if (diff < 0)
+		return -1;
+	if (diff > 0)
+		return 1;
+	return 0;
+}
+
 static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct ext4_sb_info *sbi = container_of(shrink,
 					struct ext4_sb_info, s_es_shrinker);
 	struct ext4_inode_info *ei;
-	struct list_head *cur, *tmp, scanned;
+	struct list_head *cur, *tmp;
+	LIST_HEAD(skiped);
 	int nr_to_scan = sc->nr_to_scan;
 	int ret, nr_shrunk = 0;
 
@@ -893,23 +909,41 @@ static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
 	if (!nr_to_scan)
 		return ret;
 
-	INIT_LIST_HEAD(&scanned);
-
 	spin_lock(&sbi->s_es_lru_lock);
+
+	/*
+	 * If the inode that is at the head of LRU list is newer than
+	 * last_sorted time, that means that we need to sort this list.
+	 */
+	ei = list_first_entry(&sbi->s_es_lru, struct ext4_inode_info, i_es_lru);
+	if (sbi->s_es_last_sorted < ei->i_touch_when) {
+		list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
+		sbi->s_es_last_sorted = jiffies;
+	}
+
 	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
-		list_move_tail(cur, &scanned);
+		/*
+		 * If we have already reclaimed all extents from extent
+		 * status tree, just stop the loop immediately.
+		 */
+		if (percpu_counter_read_positive(&sbi->s_extent_cache_cnt) == 0)
+			break;
 
 		ei = list_entry(cur, struct ext4_inode_info, i_es_lru);
 
-		read_lock(&ei->i_es_lock);
-		if (ei->i_es_lru_nr == 0) {
-			read_unlock(&ei->i_es_lock);
+		/* Skip the inode that is newer than the last_sorted time */
+		if (sbi->s_es_last_sorted < ei->i_touch_when) {
+			list_move_tail(cur, &skiped);
 			continue;
 		}
-		read_unlock(&ei->i_es_lock);
+
+		if (ei->i_es_lru_nr == 0)
+			continue;
 
 		write_lock(&ei->i_es_lock);
 		ret = __es_try_to_reclaim_extents(ei, nr_to_scan);
+		if (ei->i_es_lru_nr == 0)
+			list_del_init(&ei->i_es_lru);
 		write_unlock(&ei->i_es_lock);
 
 		nr_shrunk += ret;
@@ -917,7 +951,9 @@ static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
 		if (nr_to_scan == 0)
 			break;
 	}
-	list_splice_tail(&scanned, &sbi->s_es_lru);
+
+	/* Move the newer inodes into the tail of the LRU list. */
+	list_splice_tail(&skiped, &sbi->s_es_lru);
 	spin_unlock(&sbi->s_es_lru_lock);
 
 	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
@@ -925,21 +961,19 @@ static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
 	return ret;
 }
 
-void ext4_es_register_shrinker(struct super_block *sb)
+void ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 {
-	struct ext4_sb_info *sbi;
-
-	sbi = EXT4_SB(sb);
 	INIT_LIST_HEAD(&sbi->s_es_lru);
 	spin_lock_init(&sbi->s_es_lru_lock);
+	sbi->s_es_last_sorted = 0;
 	sbi->s_es_shrinker.shrink = ext4_es_shrink;
 	sbi->s_es_shrinker.seeks = DEFAULT_SEEKS;
 	register_shrinker(&sbi->s_es_shrinker);
 }
 
-void ext4_es_unregister_shrinker(struct super_block *sb)
+void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
 {
-	unregister_shrinker(&EXT4_SB(sb)->s_es_shrinker);
+	unregister_shrinker(&sbi->s_es_shrinker);
 }
 
 void ext4_es_lru_add(struct inode *inode)
@@ -947,11 +981,14 @@ void ext4_es_lru_add(struct inode *inode)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
+	ei->i_touch_when = jiffies;
+
+	if (!list_empty(&ei->i_es_lru))
+		return;
+
 	spin_lock(&sbi->s_es_lru_lock);
 	if (list_empty(&ei->i_es_lru))
 		list_add_tail(&ei->i_es_lru, &sbi->s_es_lru);
-	else
-		list_move_tail(&ei->i_es_lru, &sbi->s_es_lru);
 	spin_unlock(&sbi->s_es_lru_lock);
 }
 
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index f740eb03..e936730 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -39,6 +39,7 @@
 				 EXTENT_STATUS_DELAYED | \
 				 EXTENT_STATUS_HOLE)
 
+struct ext4_sb_info;
 struct ext4_extent;
 
 struct extent_status {
@@ -119,8 +120,8 @@ static inline void ext4_es_store_status(struct extent_status *es,
 	es->es_pblk = block;
 }
 
-extern void ext4_es_register_shrinker(struct super_block *sb);
-extern void ext4_es_unregister_shrinker(struct super_block *sb);
+extern void ext4_es_register_shrinker(struct ext4_sb_info *sbi);
+extern void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi);
 extern void ext4_es_lru_add(struct inode *inode);
 extern void ext4_es_lru_del(struct inode *inode);
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 38f03dc..1477406 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -571,6 +571,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
 		  (unsigned long) map->m_lblk);
 
+	ext4_es_lru_add(inode);
+
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
 		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
@@ -1888,6 +1890,8 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		  "logical block %lu\n", inode->i_ino, map->m_len,
 		  (unsigned long) map->m_lblk);
 
+	ext4_es_lru_add(inode);
+
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, iblock, &es)) {
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a9c1438..a7054e7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -760,7 +760,7 @@ static void ext4_put_super(struct super_block *sb)
 			ext4_abort(sb, "Couldn't clean up the journal");
 	}
 
-	ext4_es_unregister_shrinker(sb);
+	ext4_es_unregister_shrinker(sbi);
 	del_timer(&sbi->s_err_report);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
@@ -849,6 +849,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	rwlock_init(&ei->i_es_lock);
 	INIT_LIST_HEAD(&ei->i_es_lru);
 	ei->i_es_lru_nr = 0;
+	ei->i_touch_when = 0;
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
@@ -3766,7 +3767,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_err_report.data = (unsigned long) sb;
 
 	/* Register extent status tree shrinker */
-	ext4_es_register_shrinker(sb);
+	ext4_es_register_shrinker(sbi);
 
 	err = percpu_counter_init(&sbi->s_freeclusters_counter,
 			ext4_count_free_clusters(sb));
@@ -4084,7 +4085,7 @@ failed_mount_wq:
 		sbi->s_journal = NULL;
 	}
 failed_mount3:
-	ext4_es_unregister_shrinker(sb);
+	ext4_es_unregister_shrinker(sbi);
 	del_timer(&sbi->s_err_report);
 	if (sbi->s_flex_groups)
 		ext4_kvfree(sbi->s_flex_groups);
-- 
1.7.9.7
