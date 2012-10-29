From: zwu.kernel@gmail.com
Subject: [RFC v4+ hot_track 07/19] vfs: add map info update function
Date: Mon, 29 Oct 2012 12:30:49 +0800
Message-ID: <1351485061-12297-8-git-send-email-zwu.kernel@gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |   21 +++++++++++++++++
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 83e590c..9245dd3 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -398,6 +398,72 @@ static u32 hot_temp_calc(struct hot_freq_data *freq_data)
 }
 
 /*
+ * Calculate a new temperature and, if necessary,
+ * move the list_head corresponding to this inode or range
+ * to the proper list with the new temperature
+ */
+static void hot_map_array_update(struct hot_freq_data *freq_data,
+				struct hot_info *root)
+{
+	struct hot_map_head *buckets, *cur_bucket;
+	struct hot_comm_item *comm_item;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+	u32 temp = hot_temp_calc(freq_data);
+	u8 a_temp = temp >> (32 - HEAT_MAP_BITS);
+	u8 b_temp = freq_data->last_temp >> (32 - HEAT_MAP_BITS);
+
+	comm_item = container_of(freq_data,
+			struct hot_comm_item, hot_freq_data);
+
+	if (freq_data->flags & FREQ_DATA_TYPE_INODE) {
+		he = container_of(comm_item,
+			struct hot_inode_item, hot_inode);
+		buckets = root->heat_inode_map;
+
+		if (he == NULL)
+			return;
+
+		spin_lock(&he->hot_inode.lock);
+		if (list_empty(&he->hot_inode.n_list) || (a_temp != b_temp)) {
+			if (!list_empty(&he->hot_inode.n_list)) {
+				list_del_init(&he->hot_inode.n_list);
+				root->hot_map_nr--;
+			}
+
+			cur_bucket = buckets + a_temp;
+			list_add_tail(&he->hot_inode.n_list,
+					&cur_bucket->node_list);
+			root->hot_map_nr++;
+			freq_data->last_temp = temp;
+		}
+		spin_unlock(&he->hot_inode.lock);
+	} else if (freq_data->flags & FREQ_DATA_TYPE_RANGE) {
+		hr = container_of(comm_item,
+			struct hot_range_item, hot_range);
+		buckets = root->heat_range_map;
+
+		if (hr == NULL)
+			return;
+
+		spin_lock(&hr->hot_range.lock);
+		if (list_empty(&hr->hot_range.n_list) || (a_temp != b_temp)) {
+			if (!list_empty(&hr->hot_range.n_list)) {
+				list_del_init(&hr->hot_range.n_list);
+				root->hot_map_nr--;
+			}
+
+			cur_bucket = buckets + a_temp;
+			list_add_tail(&hr->hot_range.n_list,
+					&cur_bucket->node_list);
+			root->hot_map_nr++;
+			freq_data->last_temp = temp;
+		}
+		spin_unlock(&hr->hot_range.lock);
+	}
+}
+
+/*
  * Initialize inode and range map arrays.
  */
 static void hot_map_array_init(struct hot_info *root)
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index cc4666e..196b894 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -26,6 +26,27 @@
 
 #define FREQ_POWER 4
 
+/* NRR/NRW heat unit = 2^X accesses */
+#define NRR_MULTIPLIER_POWER 20 /* NRR - number of reads since mount */
+#define NRR_COEFF_POWER 0
+#define NRW_MULTIPLIER_POWER 20 /* NRW - number of writes since mount */
+#define NRW_COEFF_POWER 0
+
+/* LTR/LTW heat unit = 2^X ns of age */
+#define LTR_DIVIDER_POWER 30 /* LTR - time elapsed since last read(ns) */
+#define LTR_COEFF_POWER 1
+#define LTW_DIVIDER_POWER 30 /* LTW - time elapsed since last write(ns) */
+#define LTW_COEFF_POWER 1
+
+/*
+ * AVR/AVW cold unit = 2^X ns of average delta
+ * AVR/AVW heat unit = HEAT_MAX_VALUE - cold unit
+ */
+#define AVR_DIVIDER_POWER 40 /* AVR - average delta between recent reads(ns) */
+#define AVR_COEFF_POWER 0
+#define AVW_DIVIDER_POWER 40 /* AVW - average delta between recent writes(ns) */
+#define AVW_COEFF_POWER 0
+
 void hot_inode_item_put(struct hot_inode_item *he);
 struct hot_inode_item *hot_inode_item_find(struct hot_info *root, u64 ino);
 
-- 
1.7.6.5
