From: zwu.kernel@gmail.com
Subject: [RFC v4 06/15] vfs,hot_track: add the function for updating map arrays
Date: Thu, 25 Oct 2012 23:08:58 +0800
Message-ID: <1351177747-19389-7-git-send-email-zwu.kernel@gmail.com>
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
 fs/hot_tracking.c |  164 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |   54 +++++++++++++++++
 2 files changed, 218 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index b5568bc..05624ad 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -331,6 +331,170 @@ static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
 	}
 }
 
+static u64 hot_raw_shift(u64 counter, u32 bits, bool dir)
+{
+	if (dir)
+		return counter << bits;
+	else
+		return counter >> bits;
+}
+
+/*
+ * hot_temp_calc() is responsible for distilling the six heat
+ * criteria, which are described in detail in hot_tracking.h) down into a single
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
+ * heat list array, to normalize the temperature to the proper granularity.
+ */
+u32 hot_temp_calc(struct hot_freq_data *freq_data)
+{
+	u32 result = 0;
+
+	struct timespec ckt = current_kernel_time();
+	u64 cur_time = timespec_to_ns(&ckt);
+
+	u32 nrr_heat = (u32)hot_raw_shift((u64)freq_data->nr_reads,
+					NRR_MULTIPLIER_POWER, true);
+	u32 nrw_heat = (u32)hot_raw_shift((u64)freq_data->nr_writes,
+					NRW_MULTIPLIER_POWER, true);
+
+	u64 ltr_heat =
+	hot_raw_shift((cur_time - timespec_to_ns(&freq_data->last_read_time)),
+			LTR_DIVIDER_POWER, false);
+	u64 ltw_heat =
+	hot_raw_shift((cur_time - timespec_to_ns(&freq_data->last_write_time)),
+			LTW_DIVIDER_POWER, false);
+
+	u64 avr_heat =
+	hot_raw_shift((((u64) -1) - freq_data->avg_delta_reads),
+			AVR_DIVIDER_POWER, false);
+	u64 avw_heat =
+	hot_raw_shift((((u64) -1) - freq_data->avg_delta_writes),
+			AVW_DIVIDER_POWER, false);
+
+	/* ltr_heat is now guaranteed to be u32 safe */
+	if (ltr_heat >= hot_raw_shift((u64) 1, 32, true))
+		ltr_heat = 0;
+	else
+		ltr_heat = hot_raw_shift((u64) 1, 32, true) - ltr_heat;
+
+	/* ltw_heat is now guaranteed to be u32 safe */
+	if (ltw_heat >= hot_raw_shift((u64) 1, 32, true))
+		ltw_heat = 0;
+	else
+		ltw_heat = hot_raw_shift((u64) 1, 32, true) - ltw_heat;
+
+	/* avr_heat is now guaranteed to be u32 safe */
+	if (avr_heat >= hot_raw_shift((u64) 1, 32, true))
+		avr_heat = (u32) -1;
+
+	/* avw_heat is now guaranteed to be u32 safe */
+	if (avw_heat >= hot_raw_shift((u64) 1, 32, true))
+		avw_heat = (u32) -1;
+
+	nrr_heat = (u32)hot_raw_shift((u64)nrr_heat,
+		(3 - NRR_COEFF_POWER), false);
+	nrw_heat = (u32)hot_raw_shift((u64)nrw_heat,
+		(3 - NRW_COEFF_POWER), false);
+	ltr_heat = hot_raw_shift(ltr_heat, (3 - LTR_COEFF_POWER), false);
+	ltw_heat = hot_raw_shift(ltw_heat, (3 - LTW_COEFF_POWER), false);
+	avr_heat = hot_raw_shift(avr_heat, (3 - AVR_COEFF_POWER), false);
+	avw_heat = hot_raw_shift(avw_heat, (3 - AVW_COEFF_POWER), false);
+
+	result = nrr_heat + nrw_heat + (u32) ltr_heat +
+		(u32) ltw_heat + (u32) avr_heat + (u32) avw_heat;
+
+	return result;
+}
+
+/*
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
+	u8 a_temp, b_temp;
+	u32 temp = 0;
+
+	comm_item = container_of(freq_data,
+			struct hot_comm_item, hot_freq_data);
+
+	if (freq_data->flags & FREQ_DATA_TYPE_INODE) {
+		he = container_of(comm_item,
+			struct hot_inode_item, hot_inode);
+		buckets = root->heat_inode_map;
+
+		spin_lock(&he->hot_inode.lock);
+		temp = hot_temp_calc(freq_data);
+		spin_unlock(&he->hot_inode.lock);
+
+		if (he == NULL)
+			return;
+
+		spin_lock(&he->hot_inode.lock);
+		a_temp = temp >> (32 - HEAT_MAP_BITS);
+		b_temp = freq_data->last_temp >> (32 - HEAT_MAP_BITS);
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
+		spin_lock(&hr->hot_range.lock);
+		temp = hot_temp_calc(freq_data);
+		spin_unlock(&hr->hot_range.lock);
+
+		if (hr == NULL)
+			return;
+
+		spin_lock(&hr->hot_range.lock);
+		a_temp = temp >> (32 - HEAT_MAP_BITS);
+		b_temp = freq_data->last_temp >> (32 - HEAT_MAP_BITS);
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
 /*
  * Initialize inode and range map arrays.
  */
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 3e5f5d0..be2365c 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -25,8 +25,62 @@
 
 #define FREQ_POWER 4
 
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
 struct hot_inode_item
 *hot_inode_item_find(struct hot_info *root, u64 ino);
 void hot_inode_item_put(struct hot_inode_item *he);
+u32 hot_temp_calc(struct hot_freq_data *freq_data);
 
 #endif /* __HOT_TRACKING__ */
-- 
1.7.6.5
