From: zwu.kernel@gmail.com
Subject: [RFC v4 07/15] vfs,hot_track: add the aging function
Date: Thu, 25 Oct 2012 23:08:59 +0800
Message-ID: <1351177747-19389-8-git-send-email-zwu.kernel@gmail.com>
References: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |    6 +++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 05624ad..575cd3a 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -331,6 +331,24 @@ static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
 	}
 }
 
+static bool hot_freq_data_is_obsolete(struct hot_freq_data *freq_data)
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
 static u64 hot_raw_shift(u64 counter, u32 bits, bool dir)
 {
 	if (dir)
@@ -495,6 +513,44 @@ static void hot_map_array_update(struct hot_freq_data *freq_data,
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
+			obsolete = hot_freq_data_is_obsolete(
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
index be2365c..67c6fb6 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -26,6 +26,12 @@
 #define FREQ_POWER 4
 
 /*
+ * time to quit keeping track of
+ * tracking data (seconds)
+ */
+#define TIME_TO_KICK 300
+
+/*
  * The following comments explain what exactly comprises a unit of heat.
  *
  * Each of six values of heat are calculated and combined in order to form an
-- 
1.7.6.5
