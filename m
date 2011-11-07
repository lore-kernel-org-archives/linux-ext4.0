From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3/3] ext4: initialize 'error' variable in ext4_xattr_block_find()
Date: Mon,  7 Nov 2011 21:32:04 +0800
Message-ID: <1320672724-4432-4-git-send-email-wenqing.lz@taobao.com>
References: <1320672724-4432-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35180 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1KGNap (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 08:30:45 -0500
Received: by qyk27 with SMTP id 27so2339879qyk.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 05:30:45 -0800 (PST)
In-Reply-To: <1320672724-4432-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

'error' variable is initialized to 0 to avoid a assignment in
ext4_xattr_block_find().

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/xattr.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e985864..bd67d0a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -652,7 +652,7 @@ ext4_xattr_block_find(struct inode *inode, struct ext4_xattr_info *i,
 		      struct ext4_xattr_block_find *bs)
 {
 	struct super_block *sb = inode->i_sb;
-	int error;
+	int error = 0;
 
 	ea_idebug(inode, "name=%d.%s, value=%p, value_len=%ld",
 		  i->name_index, i->name, i->value, (long)i->value_len);
@@ -684,7 +684,6 @@ ext4_xattr_block_find(struct inode *inode, struct ext4_xattr_info *i,
 			goto cleanup;
 		bs->s.not_found = error;
 	}
-	error = 0;
 
 cleanup:
 	return error;
-- 
1.7.4.1

