From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/2] ext4: remove redundant argument in mb_find_extent()
Date: Thu, 25 Aug 2011 19:36:31 +0800
Message-ID: <1314272192-7414-1-git-send-email-hao.bigrat@gmail.com>
Cc: Ronbin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55103 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1HYLgp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Aug 2011 07:36:45 -0400
Received: by yie30 with SMTP id 30so1660260yie.19
        for <linux-ext4@vger.kernel.org>; Thu, 25 Aug 2011 04:36:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Ronbin Dong <sanbai@taobao.com>

The argument of "ord" in mb_find_extent is not necessary anymore.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/mballoc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..0702627 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1432,9 +1432,8 @@ static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
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

