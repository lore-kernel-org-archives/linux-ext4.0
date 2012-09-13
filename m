From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/9] ext4: endless truncate due to nonlocked dio readers V2
Date: Thu, 13 Sep 2012 19:01:11 +0400
Message-ID: <1347548474-31897-7-git-send-email-dmonakhov@openvz.org>
References: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51413 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab2IMPB3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 11:01:29 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so2024059lbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 08:01:28 -0700 (PDT)
In-Reply-To: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have enough aggressive DIO readers, truncate and other dio
waiters will wait forever inside inode_dio_wait(). It is reasonable
to disable nonlock DIO read optimization during truncate.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 658f649..a295b3a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4333,9 +4333,13 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (attr->ia_size != inode->i_size) {
 			truncate_setsize(inode, attr->ia_size);
-			/* Inode size will be reduced, wait for dio in flight */
-			if (orphan)
+			/* Inode size will be reduced, wait for dio in flight.
+			 * Temproraly disable unlocked DIO to prevent livelock */
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

