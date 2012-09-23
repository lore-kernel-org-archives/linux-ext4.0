From: zwu.kernel@gmail.com
Subject: [RFC v2 02/10] vfs: add support for updating access frequency
Date: Sun, 23 Sep 2012 20:56:27 +0800
Message-ID: <1348404995-14372-3-git-send-email-zwu.kernel@gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, cmm@us.ibm.com, tytso@mit.edu,
	marco.stornelli@gmail.com, david@fromorbit.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43603 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab2IWM5K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Sep 2012 08:57:10 -0400
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Sun, 23 Sep 2012 08:57:09 -0400
In-Reply-To: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add some utils helpers to update access frequencies
for one file or its range.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |  359 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |   15 +++
 2 files changed, 374 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 173054b..52ed926 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -106,6 +106,365 @@ inode_err:
 }
 
 /*
+ * Drops the reference out on hot_inode_item by one and free the structure
+ * if the reference count hits zero
+ */
+void hot_rb_free_hot_inode_item(struct hot_inode_item *he)
+{
+	if (!he)
+		return;
+
+	if (atomic_dec_and_test(&he->refs.refcount)) {
+		WARN_ON(he->in_tree);
+		kmem_cache_free(hot_inode_item_cache, he);
+	}
+}
+
+/*
+ * Drops the reference out on hot_range_item by one and free the structure
+ * if the reference count hits zero
+ */
+static void hot_rb_free_hot_range_item(struct hot_range_item *hr)
+{
+	if (!hr)
+		return;
+
+	if (atomic_dec_and_test(&hr->refs.refcount)) {
+		WARN_ON(hr->in_tree);
+		kmem_cache_free(hot_range_item_cache, hr);
+	}
+}
+
+static struct rb_node *hot_rb_insert_hot_inode_item(struct rb_root *root,
+						unsigned long inode_num,
+						struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hot_inode_item *entry;
+
+	/* walk tree to find insertion point */
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_inode_item, rb_node);
+
+		if (inode_num < entry->i_ino)
+			p = &(*p)->rb_left;
+		else if (inode_num > entry->i_ino)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	entry = rb_entry(node, struct hot_inode_item, rb_node);
+	entry->in_tree = 1;
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+
+	return NULL;
+}
+
+static u64 hot_rb_range_end(struct hot_range_item *hr)
+{
+	if (hr->start + hr->len < hr->start)
+		return (u64)-1;
+
+	return hr->start + hr->len - 1;
+}
+
+static struct rb_node *hot_rb_insert_hot_range_item(struct rb_root *root,
+						u64 start,
+						struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hot_range_item *entry;
+
+	/* ensure start is on a range boundary */
+	start = start & RANGE_SIZE_MASK;
+	/* walk tree to find insertion point */
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_range_item, rb_node);
+
+		if (start < entry->start)
+			p = &(*p)->rb_left;
+		else if (start >= hot_rb_range_end(entry))
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	entry = rb_entry(node, struct hot_range_item, rb_node);
+	entry->in_tree = 1;
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+
+	return NULL;
+}
+
+/*
+ * Add a hot_inode_item to a hot_inode_tree. If the tree already contains
+ * an item with the index given, return -EEXIST
+ */
+static int hot_rb_add_hot_inode_item(struct hot_inode_tree *tree,
+				struct hot_inode_item *he)
+{
+	int ret = 0;
+	struct rb_node *rb;
+
+	rb = hot_rb_insert_hot_inode_item(
+			&tree->map, he->i_ino, &he->rb_node);
+	if (rb) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	kref_get(&he->refs);
+
+out:
+	return ret;
+}
+
+/*
+ * Add a hot_range_item to a hot_range_tree. If the tree already contains
+ * an item with the index given, return -EEXIST
+ *
+ * Also optionally aggresively merge ranges (currently disabled)
+ */
+static int hot_rb_add_hot_range_item(struct hot_range_tree *tree,
+			struct hot_range_item *hr)
+{
+	int ret = 0;
+	struct rb_node *rb;
+
+	rb = hot_rb_insert_hot_range_item(
+				&tree->map, hr->start, &hr->rb_node);
+	if (rb) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	kref_get(&hr->refs);
+
+out:
+	return ret;
+}
+
+/*
+ * Lookup a hot_inode_item in the hot_inode_tree with the given index
+ * (inode_num)
+ */
+struct hot_inode_item
+*hot_rb_lookup_hot_inode_item(struct hot_inode_tree *tree,
+				unsigned long inode_num)
+{
+	struct rb_node **p = &(tree->map.rb_node);
+	struct rb_node *parent = NULL;
+	struct hot_inode_item *entry;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_inode_item, rb_node);
+
+		if (inode_num < entry->i_ino)
+			p = &(*p)->rb_left;
+		else if (inode_num > entry->i_ino)
+			p = &(*p)->rb_right;
+		else {
+			kref_get(&entry->refs);
+			return entry;
+		}
+	}
+
+	return NULL;
+}
+
+/*
+ * Lookup a hot_range_item in a hot_range_tree with the given index
+ * (start, offset)
+ */
+static struct hot_range_item
+*hot_rb_lookup_hot_range_item(struct hot_range_tree *tree,
+				u64 start)
+{
+	struct rb_node **p = &(tree->map.rb_node);
+	struct rb_node *parent = NULL;
+	struct hot_range_item *entry;
+
+	/* ensure start is on a range boundary */
+	start = start & RANGE_SIZE_MASK;
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_range_item, rb_node);
+
+		if (start < entry->start)
+			p = &(*p)->rb_left;
+		else if (start > hot_rb_range_end(entry))
+			p = &(*p)->rb_right;
+		else {
+			kref_get(&entry->refs);
+			return entry;
+		}
+	}
+
+	return NULL;
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
+static void hot_rb_update_freq(struct hot_freq_data *freq_data, int rw)
+{
+	struct timespec old_atime;
+	struct timespec current_time;
+	struct timespec delta_ts;
+	u64 new_avg;
+	u64 new_delta;
+
+	if (unlikely(rw)) {
+		old_atime = freq_data->last_write_time;
+		freq_data->nr_writes += 1;
+		new_avg = freq_data->avg_delta_writes;
+	} else {
+		old_atime = freq_data->last_read_time;
+		freq_data->nr_reads += 1;
+		new_avg = freq_data->avg_delta_reads;
+	}
+
+	current_time = current_kernel_time();
+	delta_ts = timespec_sub(current_time, old_atime);
+	new_delta = timespec_to_ns(&delta_ts) >> FREQ_POWER;
+
+	new_avg = (new_avg << FREQ_POWER) - new_avg + new_delta;
+	new_avg = new_avg >> FREQ_POWER;
+
+	if (unlikely(rw)) {
+		freq_data->last_write_time = current_time;
+		freq_data->avg_delta_writes = new_avg;
+	} else {
+		freq_data->last_read_time = current_time;
+		freq_data->avg_delta_reads = new_avg;
+	}
+}
+
+/* Update inode frequency struct */
+static struct hot_inode_item *hot_rb_update_inode_freq(struct inode *inode,
+							int rw)
+{
+	struct hot_info *root = &(inode->i_sb->s_hotinfo);
+	struct hot_inode_tree *hitree = &(root->hot_inode_tree);
+	struct hot_inode_item *he;
+
+	read_lock(&hitree->lock);
+	he = hot_rb_lookup_hot_inode_item(hitree, inode->i_ino);
+	read_unlock(&hitree->lock);
+
+	if (!he) {
+		he = kmem_cache_alloc(hot_inode_item_cache,
+					GFP_KERNEL | GFP_NOFS);
+		if (!he)
+			goto out;
+
+		write_lock(&hitree->lock);
+		hot_rb_inode_item_init(he);
+		he->i_ino = inode->i_ino;
+		hot_rb_add_hot_inode_item(hitree, he);
+		write_unlock(&hitree->lock);
+	}
+
+	spin_lock(&he->lock);
+	hot_rb_update_freq(&he->hot_freq_data, rw);
+	spin_unlock(&he->lock);
+
+out:
+	return he;
+}
+
+/* Update range frequency struct */
+static bool hot_rb_update_range_freq(struct hot_inode_item *he,
+				u64 off, u64 len, int rw,
+				struct hot_info *root)
+{
+	struct hot_range_tree *hrtree = &(he->hot_range_tree);
+	struct hot_range_item *hr = NULL;
+	u64 start_off = off & RANGE_SIZE_MASK;
+	u64 end_off = (off + len - 1) & RANGE_SIZE_MASK;
+	u64 cur;
+	int ret = true;
+
+	if (len == 0)
+		return false;
+
+	/*
+	 * Align ranges on RANGE_SIZE boundary to prevent proliferation
+	 * of range structs
+	 */
+	for (cur = start_off; cur <= end_off; cur += RANGE_SIZE) {
+		read_lock(&hrtree->lock);
+		hr = hot_rb_lookup_hot_range_item(hrtree, cur);
+		read_unlock(&hrtree->lock);
+
+		if (!hr) {
+			hr = kmem_cache_alloc(hot_range_item_cache,
+						GFP_KERNEL | GFP_NOFS);
+			if (!hr) {
+				ret = false;
+				goto out;
+			}
+
+			write_lock(&hrtree->lock);
+			hot_rb_range_item_init(hr);
+			hr->start = cur & RANGE_SIZE_MASK;
+			hr->len = RANGE_SIZE;
+			hr->hot_inode = he;
+			hot_rb_add_hot_range_item(hrtree, hr);
+			write_unlock(&hrtree->lock);
+		}
+
+		spin_lock(&hr->lock);
+		hot_rb_update_freq(&hr->hot_freq_data, rw);
+		spin_unlock(&hr->lock);
+		hot_rb_free_hot_range_item(hr);
+	}
+
+out:
+	return ret;
+}
+
+/* main function to update access frequency from read/writepage(s) hooks */
+void hot_rb_update_freqs(struct inode *inode, u64 start,
+			u64 len, int rw)
+{
+	struct hot_inode_item *he;
+
+	he = hot_rb_update_inode_freq(inode, rw);
+
+	WARN_ON(!he);
+
+	if (he) {
+		hot_rb_update_range_freq(he, start, len,
+			rw, &(inode->i_sb->s_hotinfo));
+
+		hot_rb_free_hot_inode_item(he);
+	}
+}
+
+/*
  * Initialize kmem cache for hot_inode_item
  * and hot_range_item
  */
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 269b67a..2ba29e4 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -21,6 +21,21 @@
 #define FREQ_DATA_TYPE_INODE (1 << 0)
 /* freq data struct is for a range */
 #define FREQ_DATA_TYPE_RANGE (1 << 1)
+/* size of sub-file ranges */
+#define RANGE_SIZE (1 << 20)
+#define RANGE_SIZE_MASK (~((u64)(RANGE_SIZE - 1)))
+
+#define FREQ_POWER 4
+
+struct hot_info;
+struct inode;
+
+struct hot_inode_item
+*hot_rb_lookup_hot_inode_item(struct hot_inode_tree *tree,
+				unsigned long inode_num);
+void hot_rb_free_hot_inode_item(struct hot_inode_item *he);
+void hot_rb_update_freqs(struct inode *inode, u64 start, u64 len,
+			int rw);
 
 void __init hot_track_cache_init(void);
 
-- 
1.7.6.5

