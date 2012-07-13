From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 1/4] tune2fs/quota: always create hidden quota files
Date: Fri, 13 Jul 2012 15:25:06 -0700
Message-ID: <1342218309-25983-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: tytso@mit.edu, johann@whamcloud.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57177 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2GMWZP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2012 18:25:15 -0400
Received: by bkcjc3 with SMTP id jc3so206765bkc.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2012 15:25:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently 'tune2fs -O quota <dev>' will try to use existing
quota files and write their inode numbers in the superblock.
Next e2fsck run then converts these into hidden quota inodes
(ino #3 & #4). But this approach has problems:
1) Before e2fsck run, the inodes are visible to the user and
   might get corrupted or removed or replaced by the user.
2) Since these are user visible, we have to include
   their block usage in the quota accounting. But once
   these inodes are hidden, e2fsck will have to decrement
   their usage from the quota accounting (which e2fsck
   currently doesn't do and instead reports error).
   (the following used to give e2fsck error previously:
    # assume <dev> has aquota.user & aquota.group files
    $ tune2fs -O quota <dev> # stores ino# of quota files in
                             # ext4 superblock
    $ e2fsck -f <dev>  # hides quota files, but now quota
                       # usage is incorrect.
     << quota errors >>
Instead of making e2fsck complicated, this patch creates the
hidden quota inodes at 'tune2fs -O quota' time iteself. The
usage is computed freshly and limits are copied from the
aquota.user and aquota.group files as earlier.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 lib/quota/mkquota.c |   17 ++++++++++-------
 lib/quota/mkquota.h |    2 +-
 misc/tune2fs.c      |   22 ++++++----------------
 3 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index c7869fd..42af1f2 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -386,7 +386,9 @@ errcode_t quota_compute_usage(quota_ctx_t qctx)
 		}
 		if (ino == 0)
 			break;
-		if (inode.i_links_count) {
+		if (inode.i_links_count &&
+		    (ino == EXT2_ROOT_INO ||
+		     ino >= EXT2_FIRST_INODE(fs->super))) {
 			space = ext2fs_inode_i_blocks(fs, &inode) << 9;
 			quota_data_add(qctx, &inode, ino, space);
 			quota_data_inodes(qctx, &inode, ino, +1);
@@ -413,13 +415,15 @@ static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
 
 	dq = get_dq(quota_dict, dquot->dq_id);
 	dq->dq_id = dquot->dq_id;
+	dq->dq_dqb.u.v2_mdqb.dqb_off = dquot->dq_dqb.u.v2_mdqb.dqb_off;
 
 	/* Check if there is inconsistancy. */
 	if (dq->dq_dqb.dqb_curspace != dquot->dq_dqb.dqb_curspace ||
 	    dq->dq_dqb.dqb_curinodes != dquot->dq_dqb.dqb_curinodes) {
 		scan_data->usage_is_inconsistent = 1;
-		log_err("Usage inconsistent for ID %d: (%llu, %llu) != "
-			"(%llu,	%llu)", dq->dq_id, dq->dq_dqb.dqb_curspace,
+		fprintf(stderr, "[QUOTA WARNING] Usage inconsistent for ID %d:"
+			"actual (%llu, %llu) != expected (%llu, %llu)\n",
+			dq->dq_id, dq->dq_dqb.dqb_curspace,
 			dq->dq_dqb.dqb_curinodes, dquot->dq_dqb.dqb_curspace,
 			dquot->dq_dqb.dqb_curinodes);
 	}
@@ -473,9 +477,9 @@ static errcode_t quota_write_all_dquots(struct quota_handle *qh,
 }
 
 /*
- * Update usage of in quota file, limits keep unchaged
+ * Updates the in-memory quota limits from the given quota inode.
  */
-errcode_t quota_update_inode(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
+errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
 {
 	struct quota_handle *qh;
 	errcode_t err;
@@ -489,14 +493,13 @@ errcode_t quota_update_inode(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
 		return err;
 	}
 
-	err = quota_file_open(qh, qctx->fs, qf_ino, type, -1, EXT2_FILE_WRITE);
+	err = quota_file_open(qh, qctx->fs, qf_ino, type, -1, 0);
 	if (err) {
 		log_err("Open quota file failed", "");
 		goto out;
 	}
 
 	quota_read_all_dquots(qh, qctx, 1);
-	quota_write_all_dquots(qh, qctx);
 
 	err = quota_file_close(qh);
 	if (err) {
diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
index a0c603f..ee15071 100644
--- a/lib/quota/mkquota.h
+++ b/lib/quota/mkquota.h
@@ -51,7 +51,7 @@ void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 		qsize_t space);
 errcode_t quota_write_inode(quota_ctx_t qctx, int qtype);
-errcode_t quota_update_inode(quota_ctx_t qctx, ext2_ino_t qf_ino, int type);
+errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type);
 errcode_t quota_compute_usage(quota_ctx_t qctx);
 void quota_release_context(quota_ctx_t *qctx);
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index f1f0bcf..73bc10c 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -713,28 +713,18 @@ void handle_quota_options(ext2_filsys fs)
 
 	if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
 		if ((qf_ino = quota_file_exists(fs, USRQUOTA,
-						QFMT_VFS_V1)) > 0) {
-			if (quota_update_inode(qctx, qf_ino, USRQUOTA) == 0)
-				quota_set_sb_inum(fs, qf_ino, USRQUOTA);
-			else
-				quota_write_inode(qctx, USRQUOTA);
-		} else {
-			quota_write_inode(qctx, USRQUOTA);
-		}
+						QFMT_VFS_V1)) > 0)
+			quota_update_limits(qctx, qf_ino, USRQUOTA);
+		quota_write_inode(qctx, USRQUOTA);
 	} else if (usrquota == QOPT_DISABLE) {
 		quota_remove_inode(fs, USRQUOTA);
 	}
 
 	if (grpquota == QOPT_ENABLE && !fs->super->s_grp_quota_inum) {
 		if ((qf_ino = quota_file_exists(fs, GRPQUOTA,
-						QFMT_VFS_V1)) > 0) {
-			if (quota_update_inode(qctx, qf_ino, GRPQUOTA) == 0)
-				quota_set_sb_inum(fs, qf_ino, GRPQUOTA);
-			else
-				quota_write_inode(qctx, GRPQUOTA);
-		} else {
-			quota_write_inode(qctx, GRPQUOTA);
-		}
+						QFMT_VFS_V1)) > 0)
+			quota_update_limits(qctx, qf_ino, GRPQUOTA);
+		quota_write_inode(qctx, GRPQUOTA);
 	} else if (grpquota == QOPT_DISABLE) {
 		quota_remove_inode(fs, GRPQUOTA);
 	}
-- 
1.7.7.3

