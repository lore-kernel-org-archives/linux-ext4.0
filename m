From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 08/10] ext4: endless truncate due to nonlocked dio readers V2
Date: Mon, 24 Sep 2012 15:44:18 +0400
Message-ID: <1348487060-19598-9-git-send-email-dmonakhov@openvz.org>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62207 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab2IXLom (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 07:44:42 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so6549540lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 04:44:42 -0700 (PDT)
In-Reply-To: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
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
index 32e9701..d3f86e7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4330,9 +4330,13 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
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

