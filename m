From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3 1/3] e2fsprogs/tune2fs: fix memory leak in inode_scan_and_fix()
Date: Fri, 14 Nov 2014 17:15:35 +0800
Message-ID: <1415956537-11212-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <1415785780-3832-3-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <darrick.wong@oracle.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22783 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754660AbaKNJSh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2014 04:18:37 -0500
In-Reply-To: <1415785780-3832-3-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we use ext2fs_open_inode_scan() to iterate inodes and finish
jobs, we also need a ext2fs_close_inode_scan(scan) operation, but in
inode_scan_and_fix(), we forgot to call it, fix this error.

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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

