From: Qinghuang Feng <qhfeng.kernel@gmail.com>
Subject: [PATCH] EXT2: cleanup comment of ext2_splice_branch
Date: Sun, 16 Nov 2008 13:49:51 +0800
Message-ID: <491fb489.04506e0a.0b9a.ffff85fb@mx.google.com>
Cc: qhfeng.kernel@gmail.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:40307 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYKPFuE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 00:50:04 -0500
Received: by ti-out-0910.google.com with SMTP id b6so1193489tic.23
        for <linux-ext4@vger.kernel.org>; Sat, 15 Nov 2008 21:50:02 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

No argument named @chain in ext2_splice_branch,
remove it.

The comments of ext{3|4}_splice_branch and some other 
functions in */inode.c shoud be updated too, but I 
am not sure how to change them precisely.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 7658b33..da31ee9 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -497,8 +497,6 @@ static int ext2_alloc_branch(struct inode *inode,
  * ext2_splice_branch - splice the allocated branch onto inode.
  * @inode: owner
  * @block: (logical) number of block we are adding
- * @chain: chain of indirect blocks (with a missing link - see
- *	ext2_alloc_branch)
  * @where: location of missing link
  * @num:   number of indirect blocks we are adding
  * @blks:  number of direct blocks we are adding

