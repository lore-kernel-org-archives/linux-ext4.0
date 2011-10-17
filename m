From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4: fix wrong verification in ext4_ext_insert_index
Date: Mon, 17 Oct 2011 14:11:07 +0800
Message-ID: <1318831867-8225-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38743 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1JQHrV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Oct 2011 03:47:21 -0400
Received: by yxp4 with SMTP id 4so3430415yxp.5
        for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 00:47:21 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After inserting an new index, current number of indexes should
be greater than original number by 1.  So if the new index is
less or equal than LAST_INDEX + 1, then indexes are continugous.
If new index will be placed on the end, then ix will equals
LAST_INDEX + 1. Index entries has been verifiyed in pervious code
in ext4_ext_insert_index.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2dff31e..322398e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -779,7 +779,7 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 		ix = curp->p_idx;
 	}
 
-	if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
+	if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr) + 1)) {
 		EXT4_ERROR_INODE(inode, "ix > EXT_LAST_INDEX!");
 		return -EIO;
 	}
-- 
1.7.5.1

