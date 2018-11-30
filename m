Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33874 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbeK3UmG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Nov 2018 15:42:06 -0500
From: Huijin Park <huijin.park@samsung.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Michael Callahan <michaelcallahan@fb.com>
Cc: Omar Sandoval <osandov@fb.com>, js07.lee@samsung.com,
        Huijin Park <huijin.park@samsung.com>,
        Huijin Park <bbanghj.park@gmail.com>,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH,2/2] ext4: change type to same as sectors in disk_stats
Date: Fri, 30 Nov 2018 04:32:41 -0500
Message-id: <1543570361-3168-2-git-send-email-huijin.park@samsung.com>
In-reply-to: <1543570361-3168-1-git-send-email-huijin.park@samsung.com>
References: <1543570361-3168-1-git-send-email-huijin.park@samsung.com>
        <CGME20181130093322eucas1p2aab6a9716469d9d2a9de1ffa91dd42f0@eucas1p2.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "huijin.park" <huijin.park@samsung.com>

This patch changes the 's_sectors_written_start' type to u64
same as the 'sectors' type in disk_stats.
Because if the 'sectors' has more than about 2TiB,
the 's_sectors_written_start' will overflow in 32 bit system.
And it makes invalid statistics([session|lifetime]_write_kbytes).

Signed-off-by: huijin.park <huijin.park@samsung.com>
---
 fs/ext4/ext4.h  |    2 +-
 fs/ext4/sysfs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3f89d0a..d3a08b2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1457,7 +1457,7 @@ struct ext4_sb_info {
 	struct ext4_locality_group __percpu *s_locality_groups;
 
 	/* for write statistics */
-	unsigned long s_sectors_written_start;
+	u64 s_sectors_written_start;
 	u64 s_kbytes_written;
 
 	/* the size of zero-out chunk */
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 9212a02..59ac5cf 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -57,7 +57,7 @@ static ssize_t session_write_kbytes_show(struct ext4_sb_info *sbi, char *buf)
 
 	if (!sb->s_bdev->bd_part)
 		return snprintf(buf, PAGE_SIZE, "0\n");
-	return snprintf(buf, PAGE_SIZE, "%lu\n",
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
 			(part_stat_read(sb->s_bdev->bd_part,
 					sectors[STAT_WRITE]) -
 			 sbi->s_sectors_written_start) >> 1);
-- 
1.7.9.5
