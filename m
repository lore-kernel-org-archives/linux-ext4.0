From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 07/10] ext4: serialize unlocked dio reads with truncate
Date: Mon, 24 Sep 2012 15:44:17 +0400
Message-ID: <1348487060-19598-8-git-send-email-dmonakhov@openvz.org>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52474 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab2IXLok (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 07:44:40 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so6549331lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 04:44:40 -0700 (PDT)
In-Reply-To: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
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
2) if i_size about to be reduced wait for outstanding DIO requests
3) and only after that truncate inode blocks

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 542a462..32e9701 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4280,7 +4280,6 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		inode_dio_wait(inode);
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -4329,8 +4328,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		if (attr->ia_size != i_size_read(inode))
+		if (attr->ia_size != inode->i_size) {
 			truncate_setsize(inode, attr->ia_size);
+			/* Inode size will be reduced, wait for dio in flight */
+			if (orphan)
+				inode_dio_wait(inode);
+		}
 		ext4_truncate(inode);
 	}
 
-- 
1.7.7.6

