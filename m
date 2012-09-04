From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/4] ext4: endless truncate due to nonlocked dio readers
Date: Tue,  4 Sep 2012 21:22:50 +0400
Message-ID: <1346779371-28203-3-git-send-email-dmonakhov@openvz.org>
References: <1346779371-28203-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38455 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757405Ab2IDRXA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 13:23:00 -0400
Received: by lagy9 with SMTP id y9so4335476lag.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Sep 2012 10:22:59 -0700 (PDT)
In-Reply-To: <1346779371-28203-1-git-send-email-dmonakhov@openvz.org>
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
index 709ec5a..e696f19 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4354,7 +4354,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (attr->ia_size != i_size_read(inode))
 			truncate_setsize(inode, attr->ia_size);
+		ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
 		inode_dio_wait(inode);
+		ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
 		ext4_truncate(inode);
 	}
 
-- 
1.7.7.6

