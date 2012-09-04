From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] ext4: serialize unlocked dio reads with truncate
Date: Tue,  4 Sep 2012 21:36:52 +0400
Message-ID: <1346780214-29845-2-git-send-email-dmonakhov@openvz.org>
References: <1346780214-29845-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32769 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab2IDRhA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 13:37:00 -0400
Received: by lbbgj3 with SMTP id gj3so3278491lbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Sep 2012 10:36:59 -0700 (PDT)
In-Reply-To: <1346780214-29845-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current serialization will works only for DIO which holds
i_mutex, but nonlocked DIO following race is possible:

dio_nolock_read_task            truncate_task
				->ext4_setattr()
				 ->inode_dio_wait()
->ext4_ext_direct_IO
  ->ext4_ind_direct_IO
    ->__blockdev_direct_IO
      ->ext4_get_block
				 ->truncate_setsize()
				 ->ext4_truncate()
				 #alloc truncated blocks
				 #to other inode
      ->submit_io()
     #INFORMATION LEAK

In order to serialize with unlocked DIO reads we have to
rearrange wait sequence
1) update i_size first
2) wait for outstanding DIO requests
3) and only after that truncate inode blocks

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 58ef61a..709ec5a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4304,7 +4304,6 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		inode_dio_wait(inode);
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -4355,6 +4354,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (attr->ia_size != i_size_read(inode))
 			truncate_setsize(inode, attr->ia_size);
+		inode_dio_wait(inode);
 		ext4_truncate(inode);
 	}
 
-- 
1.7.7.6

