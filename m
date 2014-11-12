From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v2 1/3] e2fsprogs/tune2fs: fix memory leak in inode_scan_and_fix()
Date: Wed, 12 Nov 2014 17:49:38 +0800
Message-ID: <1415785780-3832-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <darrick.wong@oracle.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42315 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752511AbaKLJwk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2014 04:52:40 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we use ext2fs_open_inode_scan() to iterate inodes and finish
jobs, we also need a ext2fs_close_inode_scan(scan) operation, but in
inode_scan_and_fix(), we forgot to call it, fix this error.

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 misc/tune2fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 7fee870..065b483 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2147,6 +2147,7 @@ static int inode_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 
 err_out:
 	ext2fs_free_mem(&block_buf);
+	ext2fs_close_inode_scan(scan);
 
 	return retval;
 }
-- 
1.8.2.1

