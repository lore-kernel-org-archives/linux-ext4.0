From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -mm] ext4: use NULL for pointers
Date: Wed, 21 Mar 2007 19:25:43 -0700
Message-ID: <20070321192543.e17e23cd.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:38806 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbXCVCbA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Mar 2007 22:31:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointers:
fs/ext4/writeback.c:874:24: warning: Using plain integer as NULL pointer
fs/ext4/writeback.c:1105:23: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/ext4/writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc4-mm1.orig/fs/ext4/writeback.c
+++ linux-2.6.21-rc4-mm1/fs/ext4/writeback.c
@@ -41,6 +41,7 @@
 #include <linux/jbd.h>
 #include <linux/ext4_fs_extents.h>
 #include <linux/smp_lock.h>
+#include <linux/stddef.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
@@ -871,7 +872,7 @@ int ext4_wb_prepare_write(struct file *f
 				wb_debug("read block %u\n",
 						(unsigned) bhw->b_blocknr);
 				set_bh_page(bhw, page, 0);
-				bhw->b_this_page = 0;
+				bhw->b_this_page = NULL;
 				bhw->b_size = 1 << inode->i_blkbits;
 				atomic_set(&bhw->b_count, 1);
 				ll_rw_block(READ, 1, &bhw);
@@ -1102,7 +1103,7 @@ int ext4_wb_block_truncate_page(handle_t
 			wb_debug("read block %u for part.trunc on %lu\n",
 					(unsigned) bhw->b_blocknr, page->index);
 			set_bh_page(bhw, page, 0);
-			bhw->b_this_page = 0;
+			bhw->b_this_page = NULL;
 			bhw->b_size = 1 << inode->i_blkbits;
 			atomic_set(&bhw->b_count, 1);
 			ll_rw_block(READ, 1, &bhw);
