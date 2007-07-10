From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 6/7] ext4: support new modes in ext4
Date: Wed, 11 Jul 2007 01:54:41 +0530
Message-ID: <20070710202441.GF8797@amitarora.in.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37150 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042AbXGJUY2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 16:24:28 -0400
Content-Disposition: inline
In-Reply-To: <20070710201200.GA10255@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Amit Arora <aarora@in.ibm.com>
Support new values of mode in ext4.

This patch supports new mode values/flags in ext4. With this patch ext4
will be able to support FALLOC_ALLOCATE and FALLOC_RESV_SPACE modes. Supporting
FALLOC_DEALLOCATE and FALLOC_UNRESV_SPACE fallocate modes in ext4 is a work for
future.

Signed-off-by: Amit Arora <aarora@in.ibm.com>

Index: linux-2.6.22/fs/ext4/extents.c
===================================================================
--- linux-2.6.22.orig/fs/ext4/extents.c
+++ linux-2.6.22/fs/ext4/extents.c
@@ -2453,8 +2453,9 @@ int ext4_ext_writepage_trans_blocks(stru
 /*
  * preallocate space for a file. This implements ext4's fallocate inode
  * operation, which gets called from sys_fallocate system call.
- * Currently only FA_ALLOCATE mode is supported on extent based files.
- * We may have more modes supported in future - like FA_DEALLOCATE, which
+ * Currently only FALLOC_ALLOCATE  and FALLOC_RESV_SPACE modes are supported on
+ * extent based files.
+ * We may have more modes supported in future - like FALLOC_DEALLOCATE, which
  * tells fallocate to unallocate previously (pre)allocated blocks.
  * For block-mapped files, posix_fallocate should fall back to the method
  * of writing zeroes to the required new blocks (the same behavior which is
@@ -2475,7 +2476,8 @@ long ext4_fallocate(struct inode *inode,
 	 * currently supporting (pre)allocate mode for extent-based
 	 * files _only_
 	 */
-	if (mode != FA_ALLOCATE || !(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) ||
+		!(mode == FALLOC_ALLOCATE || mode == FALLOC_RESV_SPACE))
 		return -EOPNOTSUPP;
 
 	/* preallocation to directories is currently not supported */
@@ -2548,9 +2550,11 @@ retry:
 
 	/*
 	 * Time to update the file size.
-	 * Update only when preallocation was requested beyond the file size.
+	 * Update only when preallocation was requested beyond the file size
+	 * and when FALLOC_FL_KEEP_SIZE mode is not specified!
 	 */
-	if ((offset + len) > i_size_read(inode)) {
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	    (offset + len) > i_size_read(inode)) {
 		if (ret > 0) {
 			/*
 			 * if no error, we assume preallocation succeeded
