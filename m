From: zwu.kernel@gmail.com
Subject: [RFC v2 07/10] vfs: fork one kthread to update data temperature
Date: Sun, 23 Sep 2012 20:56:32 +0800
Message-ID: <1348404995-14372-8-git-send-email-zwu.kernel@gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, cmm@us.ibm.com, tytso@mit.edu,
	marco.stornelli@gmail.com, david@fromorbit.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Fork and run one kernel kthread to calculate
that temperature based on some metrics kept
in custom frequency data structs, and store
the info in the hash table.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |  467 +++++++++++++++++++++++++++++++++++++++++-
 fs/hot_tracking.h            |   78 +++++++
 include/linux/hot_tracking.h |    3 +
 3 files changed, 542 insertions(+), 6 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 5f96442..fd11695 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -17,6 +17,8 @@
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
 #include <linux/hash.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/types.h>
@@ -27,7 +29,12 @@ static struct kmem_cache *hot_inode_item_cache;
 static struct kmem_cache *hot_range_item_cache;
 static struct kmem_cache *hot_hash_node_cache;
 
+static struct task_struct *hot_track_temperature_update_kthread;
+
 static void hot_hash_node_init(void *_node);
+static int hot_hash_is_aging(struct hot_freq_data *freq_data);
+static void hot_hash_update_hash_table(struct hot_freq_data *freq_data,
+                        struct hot_info *root);
 
 /*
  * Initialize the inode tree. Should be called for each new inode
@@ -456,9 +463,13 @@ static struct hot_inode_item *hot_rb_update_inode_freq(struct inode *inode,
 		write_unlock(&hitree->lock);
 	}
 
-	spin_lock(&he->lock);
-	hot_rb_update_freq(&he->hot_freq_data, rw);
-	spin_unlock(&he->lock);
+	if (!hot_track_temperature_update_kthread
+		|| hot_track_temperature_update_kthread->pid != current->pid) {
+		spin_lock(&he->lock);
+		hot_rb_update_freq(&he->hot_freq_data, rw);
+		spin_unlock(&he->lock);
+		hot_hash_update_hash_table(&he->hot_freq_data, root);
+	}
 
 out:
 	return he;
@@ -505,9 +516,14 @@ static bool hot_rb_update_range_freq(struct hot_inode_item *he,
 			write_unlock(&hrtree->lock);
 		}
 
-		spin_lock(&hr->lock);
-		hot_rb_update_freq(&hr->hot_freq_data, rw);
-		spin_unlock(&hr->lock);
+		if (!hot_track_temperature_update_kthread
+			|| hot_track_temperature_update_kthread->pid != current->pid) {
+			spin_lock(&hr->lock);
+			hot_rb_update_freq(&hr->hot_freq_data, rw);
+			spin_unlock(&hr->lock);
+			hot_hash_update_hash_table(&hr->hot_freq_data, root);
+		}
+
 		hot_rb_free_hot_range_item(hr);
 	}
 
@@ -515,6 +531,58 @@ out:
 	return ret;
 }
 
+/* Walk the hot_inode_tree, locking as necessary */
+static struct hot_inode_item
+*hot_rb_find_next_hot_inode(struct hot_info *root,
+			u64 objectid)
+{
+	struct rb_node *node;
+	struct rb_node *prev;
+	struct hot_inode_item *entry;
+
+	read_lock(&root->hot_inode_tree.lock);
+
+	node = root->hot_inode_tree.map.rb_node;
+	prev = NULL;
+	while (node) {
+		prev = node;
+		entry = rb_entry(node, struct hot_inode_item, rb_node);
+
+		if (objectid < entry->i_ino)
+			node = node->rb_left;
+		else if (objectid > entry->i_ino)
+			node = node->rb_right;
+		else
+			break;
+	}
+
+	if (!node) {
+		while (prev) {
+			entry = rb_entry(prev, struct hot_inode_item, rb_node);
+			if (objectid <= entry->i_ino) {
+				node = prev;
+				break;
+			}
+			prev = rb_next(prev);
+		}
+	}
+
+	if (node) {
+		entry = rb_entry(node, struct hot_inode_item, rb_node);
+		/*
+		  * increase reference count to prevent pruning while
+		  * caller is using the hot_inode_item
+		  */
+		kref_get(&entry->refs);
+
+		read_unlock(&root->hot_inode_tree.lock);
+		return entry;
+	}
+
+	read_unlock(&root->hot_inode_tree.lock);
+	return NULL;
+}
+
 /* main function to update access frequency from read/writepage(s) hooks */
 void hot_rb_update_freqs(struct inode *inode, u64 start,
 			u64 len, int rw)
@@ -534,6 +602,65 @@ void hot_rb_update_freqs(struct inode *inode, u64 start,
 }
 
 /*
+ * take hot range that is now cold and remove from indexes and clean up
+ * any memory associted, involves removing hot range from rb tree, and
+ * heat hash lists, and freeing up all memory.
+ */
+static void hot_rb_remove_range_data(struct hot_inode_item *hot_inode,
+			struct hot_range_item *hr,
+			struct hot_info *root)
+{
+	/* remove range from rb tree */
+	hot_rb_remove_hot_range_item(&hot_inode->hot_range_tree, hr);
+
+	/* remove range from hash list */
+	spin_lock(&hr->heat_node->lock);
+	write_lock(&hr->heat_node->hlist->rwlock);
+	hlist_del(&hr->heat_node->hashnode);
+	write_unlock(&hr->heat_node->hlist->rwlock);
+	spin_unlock(&hr->heat_node->lock);
+
+	/*free up memory */
+	kfree(hr->heat_node);
+	hot_rb_free_hot_range_item(hr);
+}
+
+/* Update temperatures for each range item for aging purposes */
+static void hot_rb_update_range_data(struct hot_inode_item *hot_inode,
+					struct hot_info *root)
+{
+	struct hot_range_tree *inode_range_tree;
+	struct rb_node *node;
+	struct rb_node *old_node;
+	struct hot_range_item *current_range;
+	int range_is_aging;
+
+	inode_range_tree = &hot_inode->hot_range_tree;
+	write_lock(&inode_range_tree->lock);
+	node = rb_first(&inode_range_tree->map);
+	/* Walk the hot_range_tree for inode */
+	while (node) {
+		current_range = rb_entry(node, struct hot_range_item, rb_node);
+		hot_hash_update_hash_table(&current_range->hot_freq_data, root);
+		old_node = node;
+		node = rb_next(node);
+
+		spin_lock(&current_range->lock);
+		range_is_aging = hot_hash_is_aging(&current_range->hot_freq_data);
+		spin_unlock(&current_range->lock);
+
+		if (range_is_aging) {
+			if (atomic_read(
+			&current_range->heat_node->refs.refcount) <= 1)
+				hot_rb_remove_range_data(hot_inode,
+						current_range, root);
+		}
+	}
+
+	write_unlock(&inode_range_tree->lock);
+}
+
+/*
  * Initialize hash node.
  */
 static void hot_hash_node_init(void *_node)
@@ -575,6 +702,308 @@ static void hot_hash_table_init(struct hot_info *root)
 	}
 }
 
+static void hot_hash_node_free(struct hlist_head *head)
+{
+	struct hlist_node *pos = NULL, *pos2 = NULL;
+	struct hot_hash_node *heatnode = NULL;
+
+	hlist_for_each_safe(pos, pos2, head) {
+			heatnode = hlist_entry(pos,
+					struct hot_hash_node,
+					hashnode);
+			hlist_del(pos);
+			kfree(heatnode);
+	}
+
+}
+
+static void hot_hash_table_free(struct hot_info *root)
+{
+	int i;
+
+	/* Free node/range heat hash lists */
+	for (i = 0; i < HEAT_HASH_SIZE; i++) {
+		hot_hash_node_free(&root->heat_inode_hl[i].hashhead);
+		hot_hash_node_free(&root->heat_range_hl[i].hashhead);
+	}
+}
+
+static u64 hot_hash_shift(u64 counter, u32 bits, bool shift_dir)
+{
+	if (shift_dir)
+		return counter << bits;
+	else
+		return counter >> bits;
+}
+
+/*
+ * hot_hash_calc_temperature() is responsible for distilling the six heat
+ * criteria, which are described in detail in hot_hash.h) down into a single
+ * temperature value for the data, which is an integer between 0
+ * and HEAT_MAX_VALUE.
+ *
+ * To accomplish this, the raw values from the hot_freq_data structure
+ * are shifted various ways in order to make the temperature calculation more
+ * or less sensitive to each value.
+ *
+ * Once this calibration has happened, we do some additional normalization and
+ * make sure that everything fits nicely in a u32. From there, we take a very
+ * rudimentary kind of "average" of each of the values, where the *_COEFF_POWER
+ * values act as weights for the average.
+ *
+ * Finally, we use the HEAT_HASH_BITS value, which determines the size of the
+ * heat hash list, to normalize the temperature to the proper granularity.
+ */
+int hot_hash_calc_temperature(struct hot_freq_data *freq_data)
+{
+	u64 result = 0;
+
+	struct timespec ckt = current_kernel_time();
+	u64 cur_time = timespec_to_ns(&ckt);
+
+	u32 nrr_heat = (u32)hot_hash_shift((u64)freq_data->nr_reads,
+					NRR_MULTIPLIER_POWER, true);
+	u32 nrw_heat = (u32)hot_hash_shift((u64)freq_data->nr_writes,
+					NRW_MULTIPLIER_POWER, true);
+
+	u64 ltr_heat =
+	hot_hash_shift((cur_time - timespec_to_ns(&freq_data->last_read_time)),
+			LTR_DIVIDER_POWER, false);
+	u64 ltw_heat =
+	hot_hash_shift((cur_time - timespec_to_ns(&freq_data->last_write_time)),
+			LTW_DIVIDER_POWER, false);
+
+	u64 avr_heat =
+		hot_hash_shift((((u64) -1) - freq_data->avg_delta_reads),
+			AVR_DIVIDER_POWER, false);
+	u64 avw_heat =
+		hot_hash_shift((((u64) -1) - freq_data->avg_delta_writes),
+			AVW_DIVIDER_POWER, false);
+
+	/* ltr_heat is now guaranteed to be u32 safe */
+	if (ltr_heat >= hot_hash_shift((u64) 1, 32, true))
+		ltr_heat = 0;
+	else
+		ltr_heat = hot_hash_shift((u64) 1, 32, true) - ltr_heat;
+
+	/* ltw_heat is now guaranteed to be u32 safe */
+	if (ltw_heat >= hot_hash_shift((u64) 1, 32, true))
+		ltw_heat = 0;
+	else
+		ltw_heat = hot_hash_shift((u64) 1, 32, true) - ltw_heat;
+
+	/* avr_heat is now guaranteed to be u32 safe */
+	if (avr_heat >= hot_hash_shift((u64) 1, 32, true))
+		avr_heat = (u32) -1;
+
+	/* avw_heat is now guaranteed to be u32 safe */
+	if (avw_heat >= hot_hash_shift((u64) 1, 32, true))
+		avw_heat = (u32) -1;
+
+	nrr_heat = (u32)hot_hash_shift((u64)nrr_heat,
+				(3 - NRR_COEFF_POWER), false);
+	nrw_heat = (u32)hot_hash_shift((u64)nrw_heat,
+				(3 - NRW_COEFF_POWER), false);
+	ltr_heat = hot_hash_shift(ltr_heat, (3 - LTR_COEFF_POWER), false);
+	ltw_heat = hot_hash_shift(ltw_heat, (3 - LTW_COEFF_POWER), false);
+	avr_heat = hot_hash_shift(avr_heat, (3 - AVR_COEFF_POWER), false);
+	avw_heat = hot_hash_shift(avw_heat, (3 - AVW_COEFF_POWER), false);
+
+	result = nrr_heat + nrw_heat + (u32) ltr_heat +
+			(u32) ltw_heat + (u32) avr_heat + (u32) avw_heat;
+
+	return result >> (32 - HEAT_HASH_BITS);
+}
+
+static int hot_hash_is_aging(struct hot_freq_data *freq_data)
+{
+	int ret = 0;
+	struct timespec ckt = current_kernel_time();
+
+	u64 cur_time = timespec_to_ns(&ckt);
+	u64 last_read_ns =
+		(cur_time - timespec_to_ns(&freq_data->last_read_time));
+	u64 last_write_ns =
+		(cur_time - timespec_to_ns(&freq_data->last_write_time));
+	u64 kick_ns = TIME_TO_KICK * (u64)1000000000;
+
+	if ((last_read_ns > kick_ns) && (last_write_ns > kick_ns))
+		ret = 1;
+
+	return ret;
+}
+
+/*
+ * Calc a new temperature and, if necessary, move the heat_node corresponding
+ * to this inode or range to the proper hashlist with the new temperature
+ */
+static void hot_hash_update_hash_table(struct hot_freq_data *freq_data,
+			struct hot_info *root)
+{
+	int temperature = 0;
+	int moved = 0;
+	struct hot_hash_head *buckets, *current_bucket = NULL;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+
+	if (freq_data->flags & FREQ_DATA_TYPE_INODE) {
+		he = hot_freq_data_get_he(freq_data);
+		buckets = root->heat_inode_hl;
+
+		spin_lock(&he->lock);
+		temperature = hot_hash_calc_temperature(freq_data);
+		freq_data->last_temperature = temperature;
+		spin_unlock(&he->lock);
+
+		if (he == NULL)
+			return;
+
+		spin_lock(&he->heat_node->lock);
+		if (he->heat_node->hlist == NULL) {
+			current_bucket = buckets + temperature;
+			moved = 1;
+		} else {
+			write_lock(&he->heat_node->hlist->rwlock);
+			current_bucket = he->heat_node->hlist;
+			if (current_bucket->temperature != temperature) {
+				hlist_del(&he->heat_node->hashnode);
+				current_bucket = buckets + temperature;
+				moved = 1;
+			}
+			write_unlock(&he->heat_node->hlist->rwlock);
+		}
+
+		if (moved) {
+			write_lock(&current_bucket->rwlock);
+			hlist_add_head(&he->heat_node->hashnode,
+					&current_bucket->hashhead);
+			he->heat_node->hlist = current_bucket;
+			write_unlock(&current_bucket->rwlock);
+		}
+		spin_unlock(&he->heat_node->lock);
+	} else if (freq_data->flags & FREQ_DATA_TYPE_RANGE) {
+		hr = hot_freq_data_get_hr(freq_data);
+		buckets = root->heat_range_hl;
+
+		spin_lock(&hr->lock);
+		temperature = hot_hash_calc_temperature(freq_data);
+		freq_data->last_temperature = temperature;
+		spin_unlock(&hr->lock);
+
+		if (hr == NULL)
+			return;
+
+		spin_lock(&hr->heat_node->lock);
+		if (hr->heat_node->hlist == NULL) {
+			current_bucket = buckets + temperature;
+			moved = 1;
+		} else {
+			write_lock(&hr->heat_node->hlist->rwlock);
+			current_bucket = hr->heat_node->hlist;
+			if (current_bucket->temperature != temperature) {
+				hlist_del(&hr->heat_node->hashnode);
+				current_bucket = buckets + temperature;
+				moved = 1;
+			}
+			write_unlock(&hr->heat_node->hlist->rwlock);
+		}
+
+		if (moved) {
+			write_lock(&current_bucket->rwlock);
+			hlist_add_head(&hr->heat_node->hashnode,
+					&current_bucket->hashhead);
+			hr->heat_node->hlist = current_bucket;
+			write_unlock(&current_bucket->rwlock);
+		}
+		spin_unlock(&hr->heat_node->lock);
+	}
+}
+
+/*
+ * Update temperatures for each hot inode item and
+ * hot range item for aging purposes
+ */
+static void hot_hash_temperature_update_iterator(struct hot_info *root)
+{
+	struct hot_inode_item *current_hot_inode;
+	struct hot_inode_tree *hot_inode_tree;
+	unsigned long inode_num;
+
+	hot_inode_tree = &root->hot_inode_tree;
+
+	/* walk the inode tree */
+	current_hot_inode = hot_rb_find_next_hot_inode(root, 0);
+	while (current_hot_inode) {
+		hot_hash_update_hash_table(
+			&current_hot_inode->hot_freq_data, root);
+		hot_rb_update_range_data(current_hot_inode, root);
+		inode_num = current_hot_inode->i_ino;
+		hot_rb_free_hot_inode_item(current_hot_inode);
+		current_hot_inode = hot_rb_find_next_hot_inode(root,
+							inode_num + 1);
+	}
+}
+
+/* Determine if there is hot data tracking to be enabled */
+static bool hot_hash_global_hot_track(void)
+{
+	struct super_block *sb;
+	bool ret = false;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (hlist_unhashed(&sb->s_instances))
+			continue;
+		if (sb->s_hotinfo.mount_opt & HOT_MOUNT_HOT_TRACK)
+			ret = true;
+	}
+	spin_unlock(&sb_lock);
+
+	return ret;
+}
+
+/*
+ * kthread iterates each hot_inode_item and hot_range_item
+ * and update temperatures to be shifted in heat hash table
+ * for purposes of relocation and such hot file detection
+ */
+static int hot_hash_temperature_update_kthread(void *arg)
+{
+	struct super_block *sb;
+	struct hot_info *root;
+	unsigned long delay;
+
+	do {
+		spin_lock(&sb_lock);
+		list_for_each_entry(sb, &super_blocks, s_list) {
+			if (hlist_unhashed(&sb->s_instances))
+				continue;
+			delay = HZ * HEAT_UPDATE_DELAY;
+			root = &sb->s_hotinfo;
+			if (mutex_trylock(
+				&root->hot_data_update_kthread_mutex)) {
+				hot_hash_temperature_update_iterator(root);
+				mutex_unlock(
+					&root->hot_data_update_kthread_mutex);
+			}
+			if (unlikely(freezing(current))) {
+				__refrigerator(true);
+			} else {
+				set_current_state(TASK_INTERRUPTIBLE);
+				if (!kthread_should_stop()) {
+					spin_unlock(&sb_lock);
+					schedule_timeout(delay);
+					spin_lock(&sb_lock);
+				}
+				__set_current_state(TASK_RUNNING);
+			}
+		}
+		spin_unlock(&sb_lock);
+	} while (!kthread_should_stop() || !hot_hash_global_hot_track());
+
+	return 0;
+}
+
 /*
  * Regular mount options parser for -hottrack option.
  * return false if no -hottrack is specified;
@@ -625,6 +1054,30 @@ void __init hot_track_cache_init(void)
 }
 
 /*
+ * Fork and initialize kthread for each new mount point that
+ * periodically goes through hot inodes and hot ranges and ages them
+ * based on frequency of access
+ */
+static void hot_track_fork_temperature_update_kthread(void)
+{
+	if (hot_track_temperature_update_kthread)
+		return;
+
+	hot_track_temperature_update_kthread =
+		kthread_run(hot_hash_temperature_update_kthread, NULL,
+					"hot_temperature_update_kthread");
+	if (IS_ERR(hot_track_temperature_update_kthread))
+		kthread_stop(hot_track_temperature_update_kthread);
+}
+
+/* Stop the kthread to do temperature updates for all filesystems */
+static void hot_track_stop_temperature_update_kthread(void)
+{
+	if (hot_track_temperature_update_kthread)
+		kthread_stop(hot_track_temperature_update_kthread);
+}
+
+/*
  * Initialize the data structures for hot data tracking.
  */
 void hot_track_init(struct super_block *sb, const char *name)
@@ -632,11 +1085,13 @@ void hot_track_init(struct super_block *sb, const char *name)
 	sb->s_hotinfo.mount_opt |= HOT_MOUNT_HOT_TRACK;
 	hot_rb_inode_tree_init(&sb->s_hotinfo.hot_inode_tree);
 	hot_hash_table_init(&sb->s_hotinfo);
+	hot_track_fork_temperature_update_kthread();
 }
 
 void hot_track_exit(struct super_block *sb)
 {
 	sb->s_hotinfo.mount_opt &= ~HOT_MOUNT_HOT_TRACK;
+	hot_track_stop_temperature_update_kthread();
 	hot_hash_table_free(&sb->s_hotinfo);
 	hot_rb_inode_tree_free(&sb->s_hotinfo);
 }
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 3a8d398..1b6c694 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -27,6 +27,76 @@
 
 #define FREQ_POWER 4
 
+/*
+ * time to quit keeping track of
+ * tracking data (seconds)
+ */
+#define TIME_TO_KICK 400
+
+/* set how often to update temperatures (seconds) */
+#define HEAT_UPDATE_DELAY 400
+
+/*
+ * The following comments explain what exactly comprises a unit of heat.
+ *
+ * Each of six values of heat are calculated and combined in order to form an
+ * overall temperature for the data:
+ *
+ * NRR - number of reads since mount
+ * NRW - number of writes since mount
+ * LTR - time elapsed since last read (ns)
+ * LTW - time elapsed since last write (ns)
+ * AVR - average delta between recent reads (ns)
+ * AVW - average delta between recent writes (ns)
+ *
+ * These values are divided (right-shifted) according to the *_DIVIDER_POWER
+ * values defined below to bring the numbers into a reasonable range. You can
+ * modify these values to fit your needs. However, each heat unit is a u32 and
+ * thus maxes out at 2^32 - 1. Therefore, you must choose your dividers quite
+ * carefully or else they could max out or be stuck at zero quite easily.
+ *
+ * (E.g., if you chose AVR_DIVIDER_POWER = 0, nothing less than 4s of atime
+ * delta would bring the temperature above zero, ever.)
+ *
+ * Finally, each value is added to the overall temperature between 0 and 8
+ * times, depending on its *_COEFF_POWER value. Note that the coefficients are
+ * also actually implemented with shifts, so take care to treat these values
+ * as powers of 2. (I.e., 0 means we'll add it to the temp once; 1 = 2x, etc.)
+ */
+
+/* NRR/NRW heat unit = 2^X accesses */
+#define NRR_MULTIPLIER_POWER 20
+#define NRR_COEFF_POWER 0
+#define NRW_MULTIPLIER_POWER 20
+#define NRW_COEFF_POWER 0
+
+/* LTR/LTW heat unit = 2^X ns of age */
+#define LTR_DIVIDER_POWER 30
+#define LTR_COEFF_POWER 1
+#define LTW_DIVIDER_POWER 30
+#define LTW_COEFF_POWER 1
+
+/*
+ * AVR/AVW cold unit = 2^X ns of average delta
+ * AVR/AVW heat unit = HEAT_MAX_VALUE - cold unit
+ *
+ * E.g., data with an average delta between 0 and 2^X ns
+ * will have a cold value of 0, which means a heat value
+ * equal to HEAT_MAX_VALUE.
+ */
+#define AVR_DIVIDER_POWER 40
+#define AVR_COEFF_POWER 0
+#define AVW_DIVIDER_POWER 40
+#define AVW_COEFF_POWER 0
+
+/* macros to wrap container_of()'s for hot data structs */
+#define hot_freq_data_get_he(x) \
+        ((struct hot_inode_item *) container_of(x, \
+        struct hot_inode_item, hot_freq_data))
+#define hot_freq_data_get_hr(x) \
+        ((struct hot_range_item *) container_of(x, \
+        struct hot_range_item, hot_freq_data))
+
 struct hot_info;
 struct inode;
 
@@ -37,6 +107,14 @@ void hot_rb_free_hot_inode_item(struct hot_inode_item *he);
 void hot_rb_update_freqs(struct inode *inode, u64 start, u64 len,
 			int rw);
 
+/*
+ * Returns a value from 0 to HEAT_MAX_VALUE
+ * indicating the temperature of the
+ * file (and consequently its bucket number
+ * in hash list) (see hot_hash.c)
+ */
+int hot_hash_calc_temperature(struct hot_freq_data *freq_data);
+
 bool hot_track_parse_options(char *options);
 void __init hot_track_cache_init(void);
 void hot_track_init(struct super_block *sb, const char *name);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index bc41f94..1ec90a6 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -141,6 +141,9 @@ struct hot_info {
 
 	/* hash map of range temperature */
 	struct hot_hash_head heat_range_hl[HEAT_HASH_SIZE];
+
+	/* protects hot data items while being iterated and updated */
+	struct mutex hot_data_update_kthread_mutex;
 };
 
 extern void hot_rb_update_freqs(struct inode *inode,
-- 
1.7.6.5
