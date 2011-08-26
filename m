From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/2] ext4: remove redundant argument in mb_find_extent()
Date: Fri, 26 Aug 2011 11:17:21 +0800
Message-ID: <1314328641-27281-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45535 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1HZDRb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Aug 2011 23:17:31 -0400
Received: by pzk37 with SMTP id 37so3527969pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 25 Aug 2011 20:17:30 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The argument of "ord" in mb_find_extent is not necessary.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/mballoc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..cc8ed5a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1390,7 +1390,6 @@ static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
 {
 	int next = block;
 	int max;
-	int ord;
 	void *buddy;
 
 	assert_spin_locked(ext4_group_lock_ptr(e4b->bd_sb, e4b->bd_group));
@@ -1432,9 +1431,8 @@ static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
 		if (mb_test_bit(next, EXT4_MB_BITMAP(e4b)))
 			break;
 
-		ord = mb_find_order_for_block(e4b, next);
+		order = mb_find_order_for_block(e4b, next);
 
-		order = ord;
 		block = next >> order;
 		ex->fe_len += 1 << order;
 	}
-- 
1.7.4.1

