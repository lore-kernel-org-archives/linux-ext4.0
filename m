From: zwu.kernel@gmail.com
Subject: [RFC v4 03/15] vfs,hot_track: add the function for collecting I/O frequency
Date: Thu, 25 Oct 2012 23:08:55 +0800
Message-ID: <1351177747-19389-4-git-send-email-zwu.kernel@gmail.com>
References: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add some utils helpers to update access frequencies
for one file or its range.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |  191 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |    9 ++
 include/linux/hot_tracking.h |    2 +
 3 files changed, 202 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 5fef7e5..201598b 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -173,6 +173,149 @@ static void hot_inode_tree_exit(struct hot_info *root)
 	}
 }
 
+struct hot_inode_item
+*hot_inode_item_find(struct hot_info *root, u64 ino)
+{
+	struct hot_inode_item *he;
+	int ret;
+
+again:
+	spin_lock(&root->lock);
+	he = radix_tree_lookup(&root->hot_inode_tree, ino);
+	if (he) {
+		kref_get(&he->hot_inode.refs);
+		spin_unlock(&root->lock);
+		return he;
+	}
+	spin_unlock(&root->lock);
+
+	he = kmem_cache_zalloc(hot_inode_item_cachep,
+				GFP_KERNEL | GFP_NOFS);
+	if (!he)
+		return ERR_PTR(-ENOMEM);
+
+	hot_inode_item_init(he, ino, &root->hot_inode_tree);
+
+	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	if (ret) {
+		kmem_cache_free(hot_inode_item_cachep, he);
+		return ERR_PTR(ret);
+	}
+
+	spin_lock(&root->lock);
+	ret = radix_tree_insert(&root->hot_inode_tree, ino, he);
+	if (ret == -EEXIST) {
+		kmem_cache_free(hot_inode_item_cachep, he);
+		spin_unlock(&root->lock);
+		radix_tree_preload_end();
+		goto again;
+	}
+	spin_unlock(&root->lock);
+	radix_tree_preload_end();
+
+	kref_get(&he->hot_inode.refs);
+	return he;
+}
+
+static struct hot_range_item
+*hot_range_item_find(struct hot_inode_item *he,
+			u32 start)
+{
+	struct hot_range_item *hr;
+	int ret;
+
+again:
+	spin_lock(&he->lock);
+	hr = radix_tree_lookup(&he->hot_range_tree, start);
+	if (hr) {
+		kref_get(&hr->hot_range.refs);
+		spin_unlock(&he->lock);
+		return hr;
+	}
+	spin_unlock(&he->lock);
+
+	hr = kmem_cache_zalloc(hot_range_item_cachep,
+				GFP_KERNEL | GFP_NOFS);
+	if (!hr)
+		return ERR_PTR(-ENOMEM);
+
+	hot_range_item_init(hr, start, he);
+
+	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	if (ret) {
+		kmem_cache_free(hot_range_item_cachep, hr);
+		return ERR_PTR(ret);
+	}
+
+	spin_lock(&he->lock);
+	ret = radix_tree_insert(&he->hot_range_tree, start, hr);
+	if (ret == -EEXIST) {
+		kmem_cache_free(hot_range_item_cachep, hr);
+		spin_unlock(&he->lock);
+		radix_tree_preload_end();
+		goto again;
+	}
+	spin_unlock(&he->lock);
+	radix_tree_preload_end();
+
+	kref_get(&hr->hot_range.refs);
+	return hr;
+}
+
+/*
+ * This function does the actual work of updating the frequency numbers,
+ * whatever they turn out to be. FREQ_POWER determines how many atime
+ * deltas we keep track of (as a power of 2). So, setting it to anything above
+ * 16ish is probably overkill. Also, the higher the power, the more bits get
+ * right shifted out of the timestamp, reducing precision, so take note of that
+ * as well.
+ *
+ * The caller should have already locked freq_data's parent's spinlock.
+ *
+ * FREQ_POWER, defined immediately below, determines how heavily to weight
+ * the current frequency numbers against the newest access. For example, a value
+ * of 4 means that the new access information will be weighted 1/16th (ie 2^-4)
+ * as heavily as the existing frequency info. In essence, this is a kludged-
+ * together version of a weighted average, since we can't afford to keep all of
+ * the information that it would take to get a _real_ weighted average.
+ */
+static u64 hot_average_update(struct timespec old_atime,
+		struct timespec cur_time, u64 old_avg)
+{
+	struct timespec delta_ts;
+	u64 new_avg;
+	u64 new_delta;
+
+	delta_ts = timespec_sub(cur_time, old_atime);
+	new_delta = timespec_to_ns(&delta_ts) >> FREQ_POWER;
+
+	new_avg = (old_avg << FREQ_POWER) - old_avg + new_delta;
+	new_avg = new_avg >> FREQ_POWER;
+
+	return new_avg;
+}
+
+static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
+{
+	struct timespec cur_time = current_kernel_time();
+
+	if (write) {
+		freq_data->nr_writes += 1;
+		freq_data->avg_delta_writes = hot_average_update(
+				freq_data->last_write_time,
+				cur_time,
+				freq_data->avg_delta_writes);
+		freq_data->last_write_time = cur_time;
+	} else {
+		freq_data->nr_reads += 1;
+		freq_data->avg_delta_reads = hot_average_update(
+				freq_data->last_read_time,
+				cur_time,
+				freq_data->avg_delta_reads);
+		freq_data->last_read_time = cur_time;
+	}
+}
+
 /*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
@@ -199,6 +342,54 @@ err:
 }
 
 /*
+ * Main function to update access frequency from read/writepage(s) hooks
+ */
+inline void hot_update_freqs(struct inode *inode, u64 start,
+			u64 len, int rw)
+{
+	struct hot_info *root = inode->i_sb->s_hot_root;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+	u32 cur, end;
+
+	if (!root || (len == 0))
+		return;
+
+	he = hot_inode_item_find(root, inode->i_ino);
+	if (IS_ERR(he)) {
+		WARN_ON(1);
+		return;
+	}
+
+	spin_lock(&he->hot_inode.lock);
+	hot_freq_data_update(&he->hot_inode.hot_freq_data, rw);
+	spin_unlock(&he->hot_inode.lock);
+
+	/*
+	 * Align ranges on RANGE_SIZE boundary
+	 * to prevent proliferation of range structs
+	 */
+	end = (start + len + RANGE_SIZE - 1) >> RANGE_BITS;
+	for (cur = (start >> RANGE_BITS); cur < end; cur++) {
+		hr = hot_range_item_find(he, cur);
+		if (IS_ERR(hr)) {
+			WARN_ON(1);
+			hot_inode_item_put(he);
+			return;
+		}
+
+		spin_lock(&hr->hot_range.lock);
+		hot_freq_data_update(&hr->hot_range.hot_freq_data, rw);
+		spin_unlock(&hr->hot_range.lock);
+
+		hot_range_item_put(hr);
+	}
+
+	hot_inode_item_put(he);
+}
+EXPORT_SYMBOL_GPL(hot_update_freqs);
+
+/*
  * Initialize the data structures for hot data tracking.
  */
 int hot_track_init(struct super_block *sb)
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index febf699..3e5f5d0 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -19,5 +19,14 @@
 /* values for hot_freq_data flags */
 #define FREQ_DATA_TYPE_INODE (1 << 0)
 #define FREQ_DATA_TYPE_RANGE (1 << 1)
+/* size of sub-file ranges */
+#define RANGE_BITS 20
+#define RANGE_SIZE (1 << RANGE_BITS)
+
+#define FREQ_POWER 4
+
+struct hot_inode_item
+*hot_inode_item_find(struct hot_info *root, u64 ino);
+void hot_inode_item_put(struct hot_inode_item *he);
 
 #endif /* __HOT_TRACKING__ */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 592a6eb..de68f66 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -72,5 +72,7 @@ void __init hot_cache_init(void);
 int hot_track_init(struct super_block *sb);
 void hot_track_exit(struct super_block *sb);
 
+inline void hot_update_freqs(struct inode *inode, u64 start,
+				u64 len, int rw);
 
 #endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5

