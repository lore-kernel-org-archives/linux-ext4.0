From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] ext2 : correct comments in fs/ext2/balloc.c
Date: Sat, 31 May 2008 23:45:56 +0530
Message-ID: <ea11fea30805311115t72773c4u66999762bb53d157@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch corrects the wrong function name mentioned in the comments
of ext2_free_blocks()  function

========================================================

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

--- a/fs/ext2/balloc.c   2008-05-11 23:54:40.000000000 +0530
+++ b/fs/ext2/balloc.c        2008-05-31 23:44:20.000000000 +0530
@@ -478,7 +478,7 @@
 }

 /**
- * ext2_free_blocks_sb() -- Free given blocks and update quota and i_blocks
+ * ext2_free_blocks() -- Free given blocks and update quota and i_blocks
  * @inode:             inode
  * @block:             start physcial block to free
  * @count:             number of blocks to free


==========================================================

-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
