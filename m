From: number9652 <number9652@yahoo.com>
Subject: [PATCH] libext2fs: fix memory leak in block_iterate
Date: Tue, 14 Jul 2009 09:45:27 -0700 (PDT)
Message-ID: <900111.75858.qm@web43503.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n54.bullet.mail.sp1.yahoo.com ([98.136.44.32]:38049 "HELO
	n54.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753901AbZGNQp2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jul 2009 12:45:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


One of the error paths in block_iterate could return before freeing the
scratch memory.  Here we free that memory before returning.

Signed-off-by: Nic Case <number9652@yahoo.com>
---
diff --git a/e2fsprogs-1.41.8-orig/lib/ext2fs/block.c b/e2fsprogs-1.41.8/lib/ext2fs/block.c
index de5342d..bb20f6e 100644
--- a/e2fsprogs-1.41.8-orig/lib/ext2fs/block.c
+++ b/e2fsprogs-1.41.8/lib/ext2fs/block.c
@@ -488,8 +488,11 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 abort_exit:
        if (ret & BLOCK_CHANGED) {
                retval = ext2fs_write_inode(fs, ino, &inode);
-               if (retval)
+               if (retval) {
+                       if (!block_buf)
+                               ext2fs_free_mem(&ctx.ind_buf);
                        return retval;
+               }
        }
 errout:
        if (!block_buf)
---


      

