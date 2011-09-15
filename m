From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/4] ext4: use stream-alloc when mb_group_prealloc set to zero
Date: Thu, 15 Sep 2011 15:09:37 +0800
Message-ID: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32913 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1IOHKD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 03:10:03 -0400
Received: by pzk32 with SMTP id 32so2239825pzk.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 00:10:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The kernel will crash on 

ext4_mb_mark_diskspace_used:
	BUG_ON(ac->ac_b_ex.fe_len <= 0);

after we set /sys/fs/ext4/sda/mb_group_prealloc to zero and create new files in an ext4 filesystem.

The reason is: ac_b_ex.fe_len also set to zero(mb_group_prealloc) in ext4_mb_normalize_group_request
because the ac_flags contains EXT4_MB_HINT_GROUP_ALLOC.

I think when someone set mb_group_prealloc to zero, it means DO NOT USE GROUP PREALLOCATION,
so we should set alloc-strategy to STREAM in this case.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/mballoc.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..6b58247 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3969,6 +3969,11 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 		return;
 	}
 
+	if (sbi->s_mb_group_prealloc <= 0) {
+		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
+		return;
+	}
+
 	/* don't use group allocation for large files */
 	size = max(size, isize);
 	if (size > sbi->s_mb_stream_request) {
-- 
1.7.4.1

