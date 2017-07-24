From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [e2fsprogs PATCH] libsupport: fix error handling in quota_write_inode
Date: Mon, 24 Jul 2017 15:01:26 +0800
Message-ID: <1500879686-741-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <yi.zhang@huawei.com>,
        <miaoxie@huawei.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:9405 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752708AbdGXG50 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jul 2017 02:57:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The error return value of quota_file_create() is no longer < 0,
and the error handling in quota_write_inode() is incorrect,
fix these. This also fix a tune2fs segfault that currently
occurs when we add project and quota features to an inode
exhaustion ext4 filesystem.

Fixes: a701823a3150("libsupport: fix gcc -Wall nits")

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 lib/support/mkquota.c | 15 ++++++++-------
 lib/support/quotaio.c |  8 +++++---
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index 11a878e..00f3a40 100644
--- a/lib/support/mkquota.c
+++ b/lib/support/mkquota.c
@@ -193,20 +193,21 @@ errcode_t quota_write_inode(quota_ctx_t qctx, unsigned int qtype_bits)
 			continue;
 
 		retval = quota_file_create(h, fs, qtype, fmt);
-		if (retval < 0) {
-			log_debug("Cannot initialize io on quotafile");
-			continue;
+		if (retval) {
+			log_debug("Cannot initialize io on quotafile: %s",
+				  error_message(retval));
+			goto out;
 		}
 
 		write_dquots(dict, h);
 		retval = quota_file_close(qctx, h);
-		if (retval < 0) {
-			log_err("Cannot finish IO on new quotafile: %s",
-				strerror(errno));
+		if (retval) {
+			log_debug("Cannot finish IO on new quotafile: %s",
+				  strerror(errno));
 			if (h->qh_qf.e2_file)
 				ext2fs_file_close(h->qh_qf.e2_file);
 			(void) quota_inode_truncate(fs, h->qh_qf.ino);
-			continue;
+			goto out;
 		}
 
 		/* Set quota inode numbers in superblock. */
diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
index 240eab3..2daf178 100644
--- a/lib/support/quotaio.c
+++ b/lib/support/quotaio.c
@@ -273,11 +273,13 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 	if (h->qh_ops->check_file &&
 	    (h->qh_ops->check_file(h, qtype, fmt) == 0)) {
 		log_err("qh_ops->check_file failed");
+		err = EIO;
 		goto errout;
 	}
 
 	if (h->qh_ops->init_io && (h->qh_ops->init_io(h) < 0)) {
 		log_err("qh_ops->init_io failed");
+		err = EIO;
 		goto errout;
 	}
 	if (allocated_handle)
@@ -288,7 +290,7 @@ errout:
 	ext2fs_file_close(e2_file);
 	if (allocated_handle)
 		ext2fs_free_mem(&h);
-	return -1;
+	return err;
 }
 
 static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
@@ -405,12 +407,12 @@ errcode_t quota_file_close(quota_ctx_t qctx, struct quota_handle *h)
 {
 	if (h->qh_io_flags & IOFL_INFODIRTY) {
 		if (h->qh_ops->write_info && h->qh_ops->write_info(h) < 0)
-			return -1;
+			return EIO;
 		h->qh_io_flags &= ~IOFL_INFODIRTY;
 	}
 
 	if (h->qh_ops->end_io && h->qh_ops->end_io(h) < 0)
-		return -1;
+		return EIO;
 	if (h->qh_qf.e2_file) {
 		__u64 new_size, size;
 
-- 
2.5.0
