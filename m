From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext4: no need to cond_resched() in ext4_trim_all_free()
Date: Thu, 27 Apr 2017 10:36:40 +0200
Message-ID: <1493282200-32257-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967368AbdD0Ih2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 27 Apr 2017 04:37:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E20D9C057FA5
        for <linux-ext4@vger.kernel.org>; Thu, 27 Apr 2017 08:37:17 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is no need to call cond_resched() in ext4_trim_all_free() since
blkdev_issue_discard() already takes care of that. So just remove it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 354dc1a..4879766 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5163,12 +5163,6 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 			break;
 		}
 
-		if (need_resched()) {
-			ext4_unlock_group(sb, group);
-			cond_resched();
-			ext4_lock_group(sb, group);
-		}
