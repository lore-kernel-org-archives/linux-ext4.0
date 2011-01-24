From: Coly Li <colyli@gmail.com>
Subject: [PATCH] mballoc: don't change cpa if cur_distance is equal to new_distance, v2
Date: Tue, 25 Jan 2011 02:44:42 +0800
Message-ID: <1295894682-6745-1-git-send-email-bosong.ly@taobao.com>
Cc: Coly Li <bosong.ly@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54002 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1AXSUr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jan 2011 13:20:47 -0500
Received: by pva4 with SMTP id 4so722680pva.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Jan 2011 10:20:47 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Coly Li <bosong.ly@taobao.com>

(resend for proper patch indent)

In ext4_mb_check_group_pa(), cur_distance is selected to return only
when it's smaller than new_distance, this is unreasonable. If
cur_distance is equal to new_distance, current code will return
new_distance to update cpa from ext4_mb_use_preallocated(), which is
unnecessary and a wast of CPU cycles.

This patch makes new_distance to return only when it's smaller then
cur_distance, which avoids unnecessary cpa update in
ext4_mb_use_preallocated().

Signed-off-by: Coly Li <bosong.ly@taobao.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 851f49b..5f564d7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3188,7 +3188,7 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
 	cur_distance = abs(goal_block - cpa->pa_pstart);
 	new_distance = abs(goal_block - pa->pa_pstart);
 
-	if (cur_distance < new_distance)
+	if (cur_distance <= new_distance)
 		return cpa;
 
 	/* drop the previous reference */
-- 
1.7.3.2

