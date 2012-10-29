From: zwu.kernel@gmail.com
Subject: [RFC v4+ hot_track 06/19] vfs: add temp calculation function
Date: Mon, 29 Oct 2012 12:30:48 +0800
Message-ID: <1351485061-12297-7-git-send-email-zwu.kernel@gmail.com>
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
 fs/hot_tracking.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 0a603a1..83e590c 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -323,6 +323,80 @@ static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
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
+ * criteria down into a single temperature value for the data,
+ * which is an integer between 0 and HEAT_MAX_VALUE.
+ */
+static u32 hot_temp_calc(struct hot_freq_data *freq_data)
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
 /*
  * Initialize inode and range map arrays.
  */
-- 
1.7.6.5
