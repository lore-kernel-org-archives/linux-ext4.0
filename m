From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 3/4] ext4: remove unused argument in mb_find_extent
Date: Thu, 15 Sep 2011 15:09:39 +0800
Message-ID: <1316070580-10723-3-git-send-email-hao.bigrat@gmail.com>
References: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38607 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1IOHKI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 03:10:08 -0400
Received: by yie30 with SMTP id 30so1969128yie.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 00:10:07 -0700 (PDT)
In-Reply-To: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The argument 'ord' in function mb_find_extent is redundant,
so remove it.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/mballoc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d0fc76e..99d123a 100644
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

