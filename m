Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33848 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbeK3UmD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Nov 2018 15:42:03 -0500
From: Huijin Park <huijin.park@samsung.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Michael Callahan <michaelcallahan@fb.com>
Cc: Omar Sandoval <osandov@fb.com>, js07.lee@samsung.com,
        Huijin Park <huijin.park@samsung.com>,
        Huijin Park <bbanghj.park@gmail.com>,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH,1/2] genhd: avoid overflow of sectors in disk_stats
Date: Fri, 30 Nov 2018 04:32:40 -0500
Message-id: <1543570361-3168-1-git-send-email-huijin.park@samsung.com>
References: <CGME20181130093318eucas1p24feb8e649c8f244ce149a7f87e43c828@eucas1p2.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "huijin.park" <huijin.park@samsung.com>

This patch changes the 'sectors' type to an u64.
In 32 bit system, the 'sectors' can accumulate up to about 2TiB.
If a 32 bit system makes i/o over 2TiB while running,
the 'sectors' will overflow.
As a result, the part_stat_read(sectors), the diskstats in proc and
the (lifetime|session)_write_kbytes in sysfs return invalid statistic.

Signed-off-by: huijin.park <huijin.park@samsung.com>
---
 block/genhd.c         |    6 +++---
 include/linux/genhd.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 0145bcb..7518dcd 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1343,10 +1343,10 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		part_stat_unlock();
 		part_in_flight(gp->queue, hd, inflight);
 		seq_printf(seqf, "%4d %7d %s "
-			   "%lu %lu %lu %u "
-			   "%lu %lu %lu %u "
+			   "%lu %lu %llu %u "
+			   "%lu %lu %llu %u "
 			   "%u %u %u "
-			   "%lu %lu %lu %u\n",
+			   "%lu %lu %llu %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
 			   disk_name(gp, hd->partno, buf),
 			   part_stat_read(hd, ios[STAT_READ]),
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 0c5ee17..5bf86f9 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -84,7 +84,7 @@ struct partition {
 
 struct disk_stats {
 	u64 nsecs[NR_STAT_GROUPS];
-	unsigned long sectors[NR_STAT_GROUPS];
+	u64 sectors[NR_STAT_GROUPS];
 	unsigned long ios[NR_STAT_GROUPS];
 	unsigned long merges[NR_STAT_GROUPS];
 	unsigned long io_ticks;
-- 
1.7.9.5
