From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: cleanup in ext4_discard_allocated_blocks()
Date: Sun, 26 Feb 2012 23:54:37 +0800
Message-ID: <1330271677-10200-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51965 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2BZPtx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Feb 2012 10:49:53 -0500
Received: by iazz13 with SMTP id z13so2204288iaz.19
        for <linux-ext4@vger.kernel.org>; Sun, 26 Feb 2012 07:49:52 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

remove 'len' variable in ext4_discard_allocated_blocks() because it is useless.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/mballoc.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cb990b2..8f8889f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3123,12 +3123,9 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
 {
 	struct ext4_prealloc_space *pa = ac->ac_pa;
-	int len;
 
-	if (pa && pa->pa_type == MB_INODE_PA) {
-		len = ac->ac_b_ex.fe_len;
-		pa->pa_free += len;
-	}
+	if (pa && pa->pa_type == MB_INODE_PA)
+		pa->pa_free += ac->ac_b_ex.fe_len;
 
 }
 
-- 
1.7.4.1

