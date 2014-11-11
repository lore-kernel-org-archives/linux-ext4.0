From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] e2fsprogs/tune2fs: fix memory leak in inode_scan_and_fix()
Date: Tue, 11 Nov 2014 14:59:27 +0800
Message-ID: <1415689169-19393-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <1415689169-19393-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <darrick.wong@oracle.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7711 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751544AbaKKIAg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Nov 2014 03:00:36 -0500
In-Reply-To: <1415689169-19393-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
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

