From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/4] ext4: endless truncate due to nonlocked dio readers V2
Date: Tue,  4 Sep 2012 21:36:53 +0400
Message-ID: <1346780214-29845-3-git-send-email-dmonakhov@openvz.org>
References: <1346780214-29845-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52420 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2IDRhB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 13:37:01 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so3278468lbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Sep 2012 10:37:00 -0700 (PDT)
In-Reply-To: <1346780214-29845-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have enough aggressive DIO readers, truncate will wait
forever inside inode_dio_wait(). It is reasonable to disable
nonlock DIO read optimization during truncate.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 709ec5a..5a75908 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4354,7 +4354,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (attr->ia_size != i_size_read(inode))
 			truncate_setsize(inode, attr->ia_size);
+		ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
 		inode_dio_wait(inode);
+		ext4_clear_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
 		ext4_truncate(inode);
 	}
 
-- 
1.7.7.6

