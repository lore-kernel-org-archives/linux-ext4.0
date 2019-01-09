Return-Path: <SRS0=BVhb=PR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:11916 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730795AbfAIPdg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2019 10:33:36 -0500
From: Kanchan Joshi <joshi.k@samsung.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nvme@lists.infradead.org, jack@suse.com, david@fromorbit.com,
        tytso@mit.edu, prakash.v@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 1/4] block: Increase count of supported write-hints
Date: Wed, 09 Jan 2019 21:00:58 +0530
Message-id: <1547047861-7271-2-git-send-email-joshi.k@samsung.com>
In-reply-to: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
References: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
        <CGME20190109153332epcas1p187b419176a8d1d0be4982a275c0b9e86@epcas1p1.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch bumps up write-hint count to support four new, in-kernel
hints.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/blkdev.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 338604d..df07759 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -568,7 +568,10 @@ struct request_queue {
 
 	struct work_struct	release_work;
 
-#define BLK_MAX_WRITE_HINTS	5
+#define BLK_MAX_USER_WRITE_HINTS	5
+#define BLK_MAX_KERNEL_WRITE_HINTS	4
+#define BLK_MAX_WRITE_HINTS	(BLK_MAX_USER_WRITE_HINTS + \
+				BLK_MAX_KERNEL_WRITE_HINTS)
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
 };
 
-- 
2.7.4
