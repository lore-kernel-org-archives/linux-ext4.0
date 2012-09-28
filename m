From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 08/11] ext4: endless truncate due to nonlocked dio readers V2
Date: Fri, 28 Sep 2012 19:44:08 +0400
Message-ID: <1348847051-6746-9-git-send-email-dmonakhov@openvz.org>
References: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35250 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab2I1Poa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2012 11:44:30 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so3591549bkc.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Sep 2012 08:44:29 -0700 (PDT)
In-Reply-To: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have enough aggressive DIO readers, truncate and other dio
waiters will wait forever inside inode_dio_wait(). It is reasonable
to disable nonlock DIO read optimization during truncate.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 583cb3f..c40a98d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4305,9 +4305,14 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (attr->ia_size != inode->i_size) {
 			truncate_setsize(inode, attr->ia_size);
-			/* Inode size will be reduced, wait for dio in flight */
-			if (orphan)
+			/* Inode size will be reduced, wait for dio in flight.
+			 * Temporarily disable dioread_nolock to prevent
+			 * livelock. */
+			if (orphan) {
+				ext4_inode_block_unlocked_dio(inode);
 				inode_dio_wait(inode);
+				ext4_inode_resume_unlocked_dio(inode);
+			}
 		}
 		ext4_truncate(inode);
 	}
-- 
1.7.7.6

