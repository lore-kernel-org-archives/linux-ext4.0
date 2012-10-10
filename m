From: zwu.kernel@gmail.com
Subject: [RFC v3 08/13] vfs: add aging function for old map info
Date: Wed, 10 Oct 2012 18:07:30 +0800
Message-ID: <1349863655-29320-9-git-send-email-zwu.kernel@gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |    6 +++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 717faa7..a8dc599 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -376,6 +376,24 @@ inline void hot_update_freqs(struct hot_info *root,
 	hot_inode_item_put(he);
 }
 
+static bool hot_freq_data_is_aging(struct hot_freq_data *freq_data)
+{
+        int ret = 0;
+        struct timespec ckt = current_kernel_time();
+
+        u64 cur_time = timespec_to_ns(&ckt);
+        u64 last_read_ns =
+                (cur_time - timespec_to_ns(&freq_data->last_read_time));
+        u64 last_write_ns =
+                (cur_time - timespec_to_ns(&freq_data->last_write_time));
+        u64 kick_ns = TIME_TO_KICK * (u64)1000000000;
+
+        if ((last_read_ns > kick_ns) && (last_write_ns > kick_ns))
+                ret = 1;
+
+        return ret;
+}
+
 static u64 hot_raw_shift(u64 counter, u32 bits, bool dir)
 {
 	if (dir)
@@ -529,6 +547,45 @@ static void hot_map_array_update(struct hot_freq_data *freq_data,
 	}
 }
 
+/* Update temperatures for each range item for aging purposes */
+static void hot_range_update(struct hot_inode_item *he,
+					struct hot_info *root)
+{
+	struct hot_range_item *hr_nodes[8];
+	u32 start = 0;
+	bool range_is_aging;
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
+
+		start = hr_nodes[n - 1]->start + 1;
+		for (i = 0; i < n; i++) {
+			kref_get(&hr_nodes[i]->hot_range.refs);
+			hot_map_array_update(
+				&hr_nodes[i]->hot_range.hot_freq_data, root);
+
+			spin_lock(&hr_nodes[i]->hot_range.lock);
+			range_is_aging = hot_freq_data_is_aging(
+					&hr_nodes[i]->hot_range.hot_freq_data);
+			spin_unlock(&hr_nodes[i]->hot_range.lock);
+
+			hot_range_item_put(hr_nodes[i]);
+			if (range_is_aging) {
+				hot_range_item_put(hr_nodes[i]);
+			}
+		}
+		spin_unlock(&he->lock);
+	}
+}
+
 /*
  * Initialize inode and range map arrays.
  */
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 5a9517b..d19e64a 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -31,6 +31,12 @@
 #define FREQ_POWER 4
 
 /*
+ * time to quit keeping track of
+ * tracking data (seconds)
+ */
+#define TIME_TO_KICK 400
+
+/*
  * The following comments explain what exactly comprises a unit of heat.
  *
  * Each of six values of heat are calculated and combined in order to form an
-- 
1.7.6.5
