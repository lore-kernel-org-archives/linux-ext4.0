From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3] ext4: Do no use yield() in ext4 code
Date: Fri,  8 Mar 2013 09:23:18 +0100
Message-ID: <1362730998-3263-3-git-send-email-lczerner@redhat.com>
References: <1362730998-3263-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab3CHIX0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Mar 2013 03:23:26 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r288NPAE001492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 8 Mar 2013 03:23:25 -0500
In-Reply-To: <1362730998-3263-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Using yield() is strongly discouraged (see sched/core.c) especially
since we can just use cond_resched().

Replace all use of yield() with cond_resched().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c   |    2 +-
 fs/ext4/mballoc.c |    8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9ea0cde..ab28090 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1263,7 +1263,7 @@ repeat:
 		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
 		spin_unlock(&ei->i_block_reservation_lock);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-			yield();
+			cond_resched();
 			goto repeat;
 		}
 		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0a493a1..d2ec0d8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3692,11 +3692,7 @@ repeat:
 	if (free < needed && busy) {
 		busy = 0;
 		ext4_unlock_group(sb, group);
-		/*
-		 * Yield the CPU here so that we don't get soft lockup
-		 * in non preempt case.
-		 */
-		yield();
+		cond_resched();
 		goto repeat;
 	}
 
@@ -4246,7 +4242,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 			ext4_claim_free_clusters(sbi, ar->len, ar->flags)) {
 
 			/* let others to free the space */
-			yield();
+			cond_resched();
 			ar->len = ar->len >> 1;
 		}
 		if (!ar->len) {
-- 
1.7.7.6

