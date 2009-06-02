From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 03/24] ext4: Print the find_group_flex() warning only once
Date: Tue,  2 Jun 2009 08:09:15 -0400
Message-ID: <1243944576-20915-3-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59247 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZFBMJn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:43 -0400
In-Reply-To: <1243944576-20915-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a short-term warning, and even printk_ratelimit() can result
in too much noise in system logs.  So only print it once as a warning.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 2842c3b5449f31470b61db716f1926b594fb6156)
---
 fs/ext4/ialloc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f9b9fad..b9457e1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -687,6 +687,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
+	static int once = 1;
 	ext4_group_t flex_group;
 
 	/* Cannot create files in a deleted directory */
@@ -706,7 +707,8 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 		ret2 = find_group_flex(sb, dir, &group);
 		if (ret2 == -1) {
 			ret2 = find_group_other(sb, dir, &group);
-			if (ret2 == 0 && printk_ratelimit())
+			if (ret2 == 0 && once)
+				once = 0;
 				printk(KERN_NOTICE "ext4: find_group_flex "
 				       "failed, fallback succeeded dir %lu\n",
 				       dir->i_ino);
-- 
1.6.3.1.1.g75fc.dirty

