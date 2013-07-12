From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: yield during large unlinks
Date: Fri, 12 Jul 2013 17:45:14 -0400
Message-ID: <1373665514-709-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37326 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab3GLVpQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Jul 2013 17:45:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During large unlink operations on files with extents, we can use a lot
of CPU time.  This adds a cond_resched() call when starting to examine
the next level of a multi-level extent tree.  Multi-level extent trees
are rare in the first place, and this should rarely be executed.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3d99b18..cc4731fd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2861,6 +2861,9 @@ again:
 				err = PTR_ERR(bh);
 				break;
 			}
+			/* Yield here to deal with large extent trees. Should be
+			 * a no-op if we did IO for the above sb_bread. */
+			cond_resched();
 			if (WARN_ON(i + 1 > depth)) {
 				err = -EIO;
 				break;
-- 
1.7.12.rc0.22.gcdd159b

