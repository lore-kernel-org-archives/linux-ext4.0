From: Li Xi <pkuelelixi@gmail.com>
Subject: [PATCH] ext4: fix return value of ext4_do_update_inode
Date: Mon, 29 Sep 2014 09:58:34 +0800
Message-ID: <1411955914-550-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60459 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaI2CBd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Sep 2014 22:01:33 -0400
Received: by mail-pd0-f171.google.com with SMTP id ft15so569699pdb.16
        for <linux-ext4@vger.kernel.org>; Sun, 28 Sep 2014 19:01:32 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext4_do_update_inode() gets error from ext4_inode_blocks_set(),
error number should be returned.

Signed-off-by: Li Xi <lixi@ddn.com>
---
 fs/ext4/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d5dd7d4..03ddfd7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4204,7 +4204,8 @@ static int ext4_do_update_inode(handle_t *handle,
 	EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
 	EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);
 
-	if (ext4_inode_blocks_set(handle, raw_inode, ei)) {
+	err = ext4_inode_blocks_set(handle, raw_inode, ei);
+	if (err) {
 		spin_unlock(&ei->i_raw_lock);
 		goto out_brelse;
 	}
-- 
1.7.1

