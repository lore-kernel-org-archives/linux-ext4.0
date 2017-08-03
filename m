From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH] ext4: release discard bio after sending discard commands
Date: Thu, 03 Aug 2017 10:21:36 +0900
Message-ID: <1501723296-21336-1-git-send-email-daeho.jeong@samsung.com>
References: <CGME20170803012120epcas2p1dddb2f7e1ee7b26172142ec40246a09f@epcas2p1.samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:35333 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbdHCBVX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Aug 2017 21:21:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We've changed the discard command handling into parallel manner.
But, in this change, I forgot decreasing the usage count of the bio
which was used to send discard request. I'm sorry about that.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Fixes: a015434480dc ("ext4: send parallel discards on commit
completions")
---
 fs/ext4/mballoc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ab70b69e644c..88317b0cf7b8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2892,8 +2892,10 @@ void ext4_process_freed_data(struct super_block *sb, tid_t commit_tid)
 				break;
 		}
 
-		if (discard_bio)
+		if (discard_bio) {
 			submit_bio_wait(discard_bio);
+			bio_put(discard_bio);
+		}
 	}
 
 	list_for_each_entry_safe(entry, tmp, &freed_data_list, efd_list)
-- 
2.13.0
