From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 07/19] ext3: replace inode uid,gid,mode initialization with helper function
Date: Wed, 17 Feb 2010 21:40:12 +0300
Message-ID: <1266432013-9241-2-git-send-email-dmonakhov@openvz.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:59261 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab0BQSk3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Feb 2010 13:40:29 -0500
In-Reply-To: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/ialloc.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index b399912..1516e6a 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -538,16 +538,13 @@ got:
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
 
-	inode->i_uid = current_fsuid();
-	if (test_opt (sb, GRPID))
-		inode->i_gid = dir->i_gid;
-	else if (dir->i_mode & S_ISGID) {
+
+	if (test_opt (sb, GRPID)) {
+		inode->i_mode = mode;
+		inode->i_uid = current_fsuid();
 		inode->i_gid = dir->i_gid;
-		if (S_ISDIR(mode))
-			mode |= S_ISGID;
 	} else
-		inode->i_gid = current_fsgid();
-	inode->i_mode = mode;
+		inode_init_owner(inode, dir, mode);
 
 	inode->i_ino = ino;
 	/* This is the optimal IO size (for stat), not the fs block size */
-- 
1.6.6

