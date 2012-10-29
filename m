From: zwu.kernel@gmail.com
Subject: [RFC v4+ hot_track 08/19] vfs: add aging function
Date: Mon, 29 Oct 2012 12:30:50 +0800
Message-ID: <1351485061-12297-9-git-send-email-zwu.kernel@gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |    6 +++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 9245dd3..fff0038 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -397,6 +397,24 @@ static u32 hot_temp_calc(struct hot_freq_data *freq_data)
 	return result;
 }
 
+static bool hot_is_obsolete(struct hot_freq_data *freq_data)
+{
+	int ret = 0;
+	struct timespec ckt = current_kernel_time();
+
+	u64 cur_time = timespec_to_ns(&ckt);
+	u64 last_read_ns =
+		(cur_time - timespec_to_ns(&freq_data->last_read_time));
+	u64 last_write_ns =
+		(cur_time - timespec_to_ns(&freq_data->last_write_time));
+	u64 kick_ns =  TIME_TO_KICK * NSEC_PER_SEC;
+
+	if ((last_read_ns > kick_ns) && (last_write_ns > kick_ns))
+		ret = 1;
+
+	return ret;
+}
+
 /*
  * Calculate a new temperature and, if necessary,
  * move the list_head corresponding to this inode or range
@@ -463,6 +481,44 @@ static void hot_map_array_update(struct hot_freq_data *freq_data,
 	}
 }
 
+/* Update temperatures for each range item for aging purposes */
+static void hot_range_update(struct hot_inode_item *he,
+					struct hot_info *root)
+{
+	struct hot_range_item *hr_nodes[8];
+	u32 start = 0;
+	bool obsolete;
+	int i, n;
+
+	while (1) {
+		spin_lock(&he->lock);
+		n = radix_tree_gang_lookup(&he->hot_range_tree,
+				(void **)hr_nodes, start,
+				ARRAY_SIZE(hr_nodes));
+		if (!n) {
+			spin_unlock(&he->lock);
+			break;
+		}
+		spin_unlock(&he->lock);
+
+		start = hr_nodes[n - 1]->start + 1;
+		for (i = 0; i < n; i++) {
+			kref_get(&hr_nodes[i]->hot_range.refs);
+			hot_map_array_update(
+				&hr_nodes[i]->hot_range.hot_freq_data, root);
+
+			spin_lock(&hr_nodes[i]->hot_range.lock);
+			obsolete = hot_is_obsolete(
+					&hr_nodes[i]->hot_range.hot_freq_data);
+			spin_unlock(&hr_nodes[i]->hot_range.lock);
+
+			hot_range_item_put(hr_nodes[i]);
+			if (obsolete)
+				hot_range_item_put(hr_nodes[i]);
+		}
+	}
+}
+
 /*
  * Initialize inode and range map arrays.
  */
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 196b894..f5ec05a 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -26,6 +26,12 @@
 
 #define FREQ_POWER 4
 
+/*
+ * time to quit keeping track of
+ * tracking data (seconds)
+ */
+#define TIME_TO_KICK 300
+
 /* NRR/NRW heat unit = 2^X accesses */
 #define NRR_MULTIPLIER_POWER 20 /* NRR - number of reads since mount */
 #define NRR_COEFF_POWER 0
-- 
1.7.6.5

