From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: serialize unlocked dio reads with truncate
Date: Mon,  3 Sep 2012 20:40:48 +0400
Message-ID: <1346690448-16917-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562Ab2ICQkx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Sep 2012 12:40:53 -0400
Received: by lagy9 with SMTP id y9so3644096lag.19
        for <linux-ext4@vger.kernel.org>; Mon, 03 Sep 2012 09:40:52 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current serialization will works only for DIO which holds
i_mutex, but nonlocked DIO following race is possable:

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
rearange wait sequance
1) update i_size first
2) wait for outstanding DIO requests
3) and only after that truncate inode blocks

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d12d30e..ee534ab 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4304,8 +4304,6 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		inode_dio_wait(inode);
