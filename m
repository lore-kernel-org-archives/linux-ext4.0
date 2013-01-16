From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH V2 1/2] Ext2: return ENOMEM rather than EIO if sb_getblk fails
Date: Tue, 15 Jan 2013 21:19:06 -0800
Message-ID: <50F6384A.1070909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60801 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3AONRL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 08:17:11 -0500
Received: by mail-pb0-f45.google.com with SMTP id mc8so38855pbc.4
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2013 05:17:10 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

As the only reason that sb_getblks fails is that allocation fails.
It will be better to use ENOMEM rather than EIO.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext2/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 06209ec..2d7557d 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -665,7 +665,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 			if (unlikely(!new_bh)) {
 				ext2_free_blocks(inode, block, 1);
 				mark_inode_dirty(inode);
-				error = -EIO;
+				error = -ENOMEM;
 				goto cleanup;
 			}
 			lock_buffer(new_bh);
-- 1.7.7.6

