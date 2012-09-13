From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/9] ext4: serialize unlocked dio reads with truncate
Date: Thu, 13 Sep 2012 19:01:10 +0400
Message-ID: <1347548474-31897-6-git-send-email-dmonakhov@openvz.org>
References: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52491 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758097Ab2IMPB2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 11:01:28 -0400
Received: by lagy9 with SMTP id y9so1991611lag.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 08:01:26 -0700 (PDT)
In-Reply-To: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
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
index c34d38c..658f649 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4283,7 +4283,6 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		inode_dio_wait(inode);
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -4332,8 +4331,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
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

