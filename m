From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Fri, 14 Jun 2013 22:09:40 +0800
Message-ID: <20130614140940.GA20401@gmail.com>
References: <51B7B128.60909@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>
To: Dave Hansen <dave.hansen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51B7B128.60909@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 11, 2013 at 04:22:16PM -0700, Dave Hansen wrote:
> I've got a test case which I intended to use to stress the VM a bit.  It
> fills memory up with page cache a couple of times.  It essentially runs
> 30 or so cp's in parallel.
> 
> 98% of my CPU is system time, and 96% of _that_ is being spent on the
> spinlock in ext4_es_lru_add().  I think the LRU list head and its lock
> end up being *REALLY* hot cachelines and are *the* bottleneck on this
> test.  Note that this is _before_ we go in to reclaim and actually start
> calling in to the shrinker.  There is zero memory pressure in this test.
> 
> I'm not sure the benefits of having a proper in-order LRU during reclaim
> outweigh such a drastic downside for the common case.

Hi Dave,

I paste a patch that tries to fix this problem that you reported.  I do
the following test in my sand box, and it seeems that this patch could
fix the problem.  This patch is not very mature.  But I hope to be sure
that my direction is right.  So I really appreciate if you could confirm
that this patch can fix the problem in your test case.

I try to reproduce the test as you described.  I creaete a ext4 file
system that is a loopback device in a x86_64 server with 16 CPUs, 24G
memory.  Then I create 160 64G sparse files, and copy them to /dev/null.
I use 'perf record/report' to observe the overhead, and the results are
as below:

unpatched kernel
----------------
65.32%               cp  [kernel.kallsyms]            [k] _raw_spin_lock                                                                                                       
                         |
                         --- _raw_spin_lock
                            |          
                            |--99.30%-- ext4_es_lru_add
                            |          ext4_es_lookup_extent
                            |          ext4_map_blocks
                            |          _ext4_get_block
                            |          ext4_get_block
                            |          do_mpage_readpage

The result shows that ext4_es_lru_add() burns about 65% CPU time.

patched kernel
--------------
2.26%               cp  [kernel.kallsyms]          [k] _raw_spin_lock                                                                                                         
                         |
                         --- _raw_spin_lock
                            |          
                            |--96.36%-- rmqueue_bulk.clone.0
                            |          get_page_from_freelist
                            |          |          
                            |          |--60.13%-- __alloc_pages_nodemask

After applied the patch, ext4_es_lru_add() is never a bottleneck.

I am not sure whether I have reproduced your test.  So that would be
great if you can confirm that this patch can fix the problem.  The patch
bases against the master branch of ext4 tree.

Any comment or suggestion is welcome.

Thanks,
                                                - Zheng


Subject: [PATCH] ext4: improve extent cache shrink mechanism to avoid to burn CPU time

From: Zheng Liu <wenqing.lz@taobao.com>

Now we maintain an proper in-order LRU list in ext4 to reclaim entries
from extent status tree when we are under heavy memory pressure.  For
keeping this order, a spin lock is used to protect this list.  But this
lock burns a lot of CPU time.

This commit tries to fix this problem.  Now a new member called
i_touch_when is added into ext4_inode_info to record the last access
time for an inode.  Meanwhile we never need to keep a proper in-order
LRU list.  So this can avoid to burns some CPU time.  When we try to
reclaim some entries from extent status tree, we use list_sort() to get
a proper in-order list.  Then we traverse this list to discard some
entries.

In this commit, we break the loop if s_extent_cache_cnt == 0 because
that means that all extents in extent status tree have been reclaimed.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ext4.h           |    1 +
 fs/ext4/extents_status.c |   43 ++++++++++++++++++++++++++++++++++---------
 fs/ext4/inode.c          |    4 ++++
 fs/ext4/super.c          |    1 +
 4 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 019db3c..1c31f27 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -874,6 +874,7 @@ struct ext4_inode_info {
 	rwlock_t i_es_lock;
 	struct list_head i_es_lru;
 	unsigned int i_es_lru_nr;	/* protected by i_es_lock */
+	unsigned long i_touch_when;	/* jiffies of last accessing */
 
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index e6941e6..0b867b8 100644
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
+	LIST_HEAD(scanned);
 	int nr_to_scan = sc->nr_to_scan;
 	int ret, nr_shrunk = 0;
 
@@ -893,10 +909,16 @@ static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
 	if (!nr_to_scan)
 		return ret;
 
-	INIT_LIST_HEAD(&scanned);
-
 	spin_lock(&sbi->s_es_lru_lock);
+	list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
 	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
+		/*
+		 * If we have already reclaimed all extents from extent
+		 * status tree, just stop the loop immediately.
+		 */
+		if (percpu_counter_read_positive(&sbi->s_extent_cache_cnt) == 0)
+			break;
+
 		list_move_tail(cur, &scanned);
 
 		ei = list_entry(cur, struct ext4_inode_info, i_es_lru);
@@ -947,11 +969,14 @@ void ext4_es_lru_add(struct inode *inode)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
+	ei->i_touch_when = jiffies;
+
+	if (!list_empty(&ei->i_es_lru))
+		return;
+
 	spin_lock(&sbi->s_es_lru_lock);
 	if (list_empty(&ei->i_es_lru))
-		list_add_tail(&ei->i_es_lru, &sbi->s_es_lru);
-	else
-		list_move_tail(&ei->i_es_lru, &sbi->s_es_lru);
+		list_add(&ei->i_es_lru, &sbi->s_es_lru);
 	spin_unlock(&sbi->s_es_lru_lock);
 }
 
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
index a9c1438..b365695 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -849,6 +849,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	rwlock_init(&ei->i_es_lock);
 	INIT_LIST_HEAD(&ei->i_es_lru);
 	ei->i_es_lru_nr = 0;
+	ei->i_touch_when = 0;
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
-- 
1.7.9.7
