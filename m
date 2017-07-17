From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] ext4: correcting copy paste error.
Date: Mon, 17 Jul 2017 11:37:44 +0530
Message-ID: <1500271664-42794-1-git-send-email-maninder1.s@samsung.com>
References: <CGME20170717061114epcas5p3b984798b45e9b87ebd8b5586e3bdff9c@epcas5p3.samsung.com>
Content-Type: text/plain; charset="utf-8"
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        pankaj.m@samsung.com, Maninder Singh <maninder1.s@samsung.com>,
        Vaneet Narang <v.narang@samsung.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:56431 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdGQGLQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Jul 2017 02:11:16 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20170717061115epoutp0213df09f924efaace93e8b6f88dcbe797~SCVJdllsJ0300703007epoutp02I
        for <linux-ext4@vger.kernel.org>; Mon, 17 Jul 2017 06:11:15 +0000 (GMT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Error reported by static tool for copy paste
issue, fixing the same.

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2a97dff..5d337ca 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5837,7 +5837,7 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 			if (e1_blk > lblk1)
 				next1 = e1_blk;
 			if (e2_blk > lblk2)
-				next2 = e1_blk;
+				next2 = e2_blk;
 			/* Do we have something to swap */
 			if (next1 == EXT_MAX_BLOCKS || next2 == EXT_MAX_BLOCKS)
 				goto finish;
-- 
1.9.1
