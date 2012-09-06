From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/2 v2] ext4: check free block counters in ext4_mb_find_by_goal
Date: Thu,  6 Sep 2012 21:16:54 +0800
Message-ID: <1346937415-2866-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2IFNw0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Sep 2012 09:52:26 -0400
Received: by pbbrr13 with SMTP id rr13so2536070pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 06 Sep 2012 06:52:26 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Free block counters should be checked before doing allocation.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/mballoc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6873571..5d4c21a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1659,10 +1659,13 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 	int max;
 	int err;
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
+	struct ext4_group_info *grp = ext4_get_group_info(ac->ac_sb, group);
 	struct ext4_free_extent ex;
 
 	if (!(ac->ac_flags & EXT4_MB_HINT_TRY_GOAL))
 		return 0;
+	if (grp->bb_free == 0)
+		return 0;
 
 	err = ext4_mb_load_buddy(ac->ac_sb, group, e4b);
 	if (err)
-- 
1.7.5.1

