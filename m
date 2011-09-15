From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/4] ext4: remove unused argument in ext4_mb_generate_from_pa
Date: Thu, 15 Sep 2011 15:09:38 +0800
Message-ID: <1316070580-10723-2-git-send-email-hao.bigrat@gmail.com>
References: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32913 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1IOHKF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 03:10:05 -0400
Received: by mail-pz0-f46.google.com with SMTP id 32so2239825pzk.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 00:10:05 -0700 (PDT)
In-Reply-To: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The argument 'count' in function ext4_mb_generate_from_pa looks useless,
so clean it.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/mballoc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6b58247..d0fc76e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3312,7 +3312,6 @@ void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 	ext4_group_t groupnr;
 	ext4_grpblk_t start;
 	int preallocated = 0;
-	int count = 0;
 	int len;
 
 	/* all form of preallocation discards first load group,
@@ -3335,7 +3334,6 @@ void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 		BUG_ON(groupnr != group);
 		ext4_set_bits(bitmap, start, len);
 		preallocated += len;
-		count++;
 	}
 	mb_debug(1, "prellocated %u for group %u\n", preallocated, group);
 }
-- 
1.7.4.1

