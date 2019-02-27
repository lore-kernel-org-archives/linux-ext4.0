Return-Path: <SRS0=GcgC=RC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794B2C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 04:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EC4D218CD
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 04:02:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrVcrms3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbfB0ECp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Feb 2019 23:02:45 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40389 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729129AbfB0ECp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Feb 2019 23:02:45 -0500
Received: by mail-pg1-f195.google.com with SMTP id u9so7260631pgo.7
        for <linux-ext4@vger.kernel.org>; Tue, 26 Feb 2019 20:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EJMJVQ3C9aoLTb+P8tmBXMZDeJacL4LimGqbCb2gQHg=;
        b=VrVcrms3+NkQflMMr53vRaWjxGKL5tm16/3VN0hnAtiKfdKqouVQsKsmMq1TZAfCYv
         ohFCLarz9Aatc1plRIwlzAtJ1tVIJixfvVjb7DM1jwHdBw4IO+fETcp8ICgaanZA2J5E
         5AuBILerj3pUmQPYt2c++WA6NR6KaKLkiayXkeoovgdFYEf4lIvzyy/VderTbrFdakLE
         CD6RNb6W2d/rLArA/5du3EWXuaMU1odd+S9f3xoSk1ruyWieQfVcd8uKwWeR+DdGrfr2
         iGOqOnn37RizfiH91vZn7KE0Wpfcas/HVkacrfzC3aoQSKTGM7rZtB6HqOOICGdJvfqK
         zX/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EJMJVQ3C9aoLTb+P8tmBXMZDeJacL4LimGqbCb2gQHg=;
        b=imYJg55kE7vVqZ7P5O1hjl6GL9u5pDp9a+LyEld2Q/ZfspjPWeJDC8QiTlz9Pwj4uI
         ouDbFnUg7PB63j+hBGkCs0uO/4P0yzju2lQ4PWK0cWsBE+MAM/ym4v1IS02bgKhxUtig
         5rYi4f88PTIVU9RIrLfDPlcAh1CrrwEoj5DqXsfv79FEOBaKvxQezF9rNxRb9lJz0VeH
         Kr0FTlmL/eJV/fhqrONsjd2AhOzp45SHnduW5WXWv7vrxBiRNT6ctatu+OmNi42ejNgJ
         RQBBBv8difpY0zyxKQ1h0ayg/Zzw1sQhHIsW0y2tJ7oO4BOBZwENettZrubtpQJsNdz2
         kW8w==
X-Gm-Message-State: AHQUAub5Bdy8QsxBAcjxWdtYUI7u1wqwMKCf9DPJjADGv3+K4lh6avqk
        rbi320POuKPQEL7y3h3XNsS2xGJrQWM=
X-Google-Smtp-Source: AHgI3IaX9JeqEsRikj1wNlyNsFA9kTJXccoYDZmv3MRaV/j5LeDdZEc1Z0EH6N74Y4HpphyfFwYMaw==
X-Received: by 2002:a63:101c:: with SMTP id f28mr974234pgl.224.1551240163439;
        Tue, 26 Feb 2019 20:02:43 -0800 (PST)
Received: from harshads0.svl.corp.google.com ([2620:15c:2cd:203:3345:5d82:1105:e6ea])
        by smtp.googlemail.com with ESMTPSA id a1sm18938498pfn.26.2019.02.26.20.02.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 20:02:42 -0800 (PST)
From:   harshadshirwadkar@gmail.com
To:     linux-ext4@vger.kernel.org
Cc:     tytso@mit.edu, adilger@dilger.ca,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: [PATCH v3] ext4: shrink directory when last block is empty
Date:   Tue, 26 Feb 2019 20:01:18 -0800
Message-Id: <20190227040118.246464-1-harshadshirwadkar@gmail.com>
X-Mailer: git-send-email 2.21.0.rc2.261.ga7da99ff1b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

This patch is the first step towards shrinking htree based directories
when files are deleted. We truncate directory inode when a directory
entry removal causes last directory block to be empty. In order to be
backwards compatible, we don't remove empty last directory block if it
results in one of the intermediate htree nodes to be empty.

This optimization by itself doesn't shrink directory that much. That's
because in order for this optimization to be effective, the order of
deletion of dirents matters. If dirents are deleted in such a way that
the directory inode blocks become empty in the reverse logical offset
order, then this optimization shrinks directory inode to a large
extent. However, if that order is not followed, this optimization
hardly shrinks the inode. But, with this code in place, we could add
quick optimizations allowing us to make this much more effective.

Changes since v2:
- style fixes

Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/namei.c | 132 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 108 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2a4c25c4681d..1ec8880115fc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -273,7 +273,8 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 				 __u32 *start_hash);
 static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 		struct ext4_filename *fname,
-		struct ext4_dir_entry_2 **res_dir);
+		struct ext4_dir_entry_2 **res_dir,
+		struct dx_frame *dx_frame);
 static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			     struct inode *dir, struct inode *inode);
 
@@ -866,6 +867,47 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	return ret_err;
 }
 
+static bool
+ext4_dx_delete_entry(handle_t *handle, struct inode *dir,
+		     struct dx_frame *dx_frame, __le64 block)
+{
+	struct dx_entry *entries;
+	unsigned int count;
+	int err, i;
+
+	entries = dx_frame->entries;
+	count = dx_get_count(entries);
+
+	if (count == 1)
+		return false;
+
+	for (i = 0; i < count; i++)
+		if (entries[i].block == block)
+			break;
+
+	if (i >= count)
+		return false;
+
+	err = ext4_journal_get_write_access(handle, dx_frame->bh);
+	if (err) {
+		ext4_std_error(dir->i_sb, err);
+		return false;
+	}
+
+	for (; i < count - 1; i++)
+		entries[i] = entries[i + 1];
+
+	dx_set_count(entries, count - 1);
+
+	err = ext4_handle_dirty_dx_node(handle, dir, dx_frame->bh);
+	if (err) {
+		ext4_std_error(dir->i_sb, err);
+		return false;
+	}
+
+	return true;
+}
+
 static void dx_release(struct dx_frame *frames)
 {
 	struct dx_root_info *info;
@@ -1309,6 +1351,24 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 	return 0;
 }
 
+static inline bool is_empty_dirent_block(struct inode *dir,
+					 struct buffer_head *bh)
+{
+	struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)bh->b_data;
+
+	return ext4_rec_len_from_disk(de->rec_len, dir->i_sb->s_blocksize) ==
+			dir->i_sb->s_blocksize && de->inode == 0;
+}
+
+static inline bool should_try_dx_delete(struct dx_frame *dx_frame,
+					struct buffer_head *bh,
+					struct inode *dir)
+{
+	return dx_frame && dx_frame->bh && is_empty_dirent_block(dir, bh) &&
+			dx_get_block(dx_frame->at) ==
+			(dir->i_size - 1) >> dir->i_sb->s_blocksize_bits;
+}
+
 static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
 			       struct ext4_dir_entry *de)
 {
@@ -1336,10 +1396,11 @@ static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
  * The returned buffer_head has ->b_count elevated.  The caller is expected
  * to brelse() it when appropriate.
  */
-static struct buffer_head * ext4_find_entry (struct inode *dir,
-					const struct qstr *d_name,
-					struct ext4_dir_entry_2 **res_dir,
-					int *inlined)
+static struct buffer_head *ext4_find_entry(struct inode *dir,
+					   const struct qstr *d_name,
+					   struct ext4_dir_entry_2 **res_dir,
+					   int *inlined,
+					   struct dx_frame *dx_frame)
 {
 	struct super_block *sb;
 	struct buffer_head *bh_use[NAMEI_RA_SIZE];
@@ -1388,7 +1449,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		goto restart;
 	}
 	if (is_dx(dir)) {
-		ret = ext4_dx_find_entry(dir, &fname, res_dir);
+		ret = ext4_dx_find_entry(dir, &fname, res_dir, dx_frame);
 		/*
 		 * On success, or if the error was file not found,
 		 * return.  Otherwise, fall back to doing a search the
@@ -1486,9 +1547,10 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 	return ret;
 }
 
-static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
-			struct ext4_filename *fname,
-			struct ext4_dir_entry_2 **res_dir)
+static struct buffer_head *ext4_dx_find_entry(struct inode *dir,
+					      struct ext4_filename *fname,
+					      struct ext4_dir_entry_2 **res_dir,
+					      struct dx_frame *dx_frame)
 {
 	struct super_block * sb = dir->i_sb;
 	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
@@ -1511,8 +1573,13 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 		retval = search_dirblock(bh, dir, fname,
 					 block << EXT4_BLOCK_SIZE_BITS(sb),
 					 res_dir);
-		if (retval == 1)
+		if (retval == 1) {
+			if (dx_frame) {
+				*dx_frame = *frame;
+				get_bh(dx_frame->bh);
+			}
 			goto success;
+		}
 		brelse(bh);
 		if (retval == -1) {
 			bh = ERR_PTR(ERR_BAD_DX_DIR);
@@ -1553,7 +1620,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 	if (dentry->d_name.len > EXT4_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL, NULL);
 	if (IS_ERR(bh))
 		return (struct dentry *) bh;
 	inode = NULL;
@@ -1597,7 +1664,7 @@ struct dentry *ext4_get_parent(struct dentry *child)
 	struct ext4_dir_entry_2 * de;
 	struct buffer_head *bh;
 
-	bh = ext4_find_entry(d_inode(child), &dotdot, &de, NULL);
+	bh = ext4_find_entry(d_inode(child), &dotdot, &de, NULL, NULL);
 	if (IS_ERR(bh))
 		return (struct dentry *) bh;
 	if (!bh)
@@ -2337,9 +2404,11 @@ int ext4_generic_delete_entry(handle_t *handle,
 static int ext4_delete_entry(handle_t *handle,
 			     struct inode *dir,
 			     struct ext4_dir_entry_2 *de_del,
-			     struct buffer_head *bh)
+			     struct buffer_head *bh,
+			     struct dx_frame *dx_frame)
 {
 	int err, csum_size = 0;
+	bool should_truncate = false;
 
 	if (ext4_has_inline_data(dir)) {
 		int has_inline_data = 1;
@@ -2363,11 +2432,21 @@ static int ext4_delete_entry(handle_t *handle,
 	if (err)
 		goto out;
 
+	if (should_try_dx_delete(dx_frame, bh, dir) &&
+	    ext4_dx_delete_entry(handle, dir, dx_frame,
+				 cpu_to_le64(dx_get_block(dx_frame->at))))
+		should_truncate = true;
+
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
 	err = ext4_handle_dirty_dirent_node(handle, dir, bh);
 	if (unlikely(err))
 		goto out;
 
+	if (should_truncate) {
+		dir->i_size -= dir->i_sb->s_blocksize;
+		ext4_truncate(dir);
+	}
+
 	return 0;
 out:
 	if (err != -ENOENT)
@@ -2923,7 +3002,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 		return retval;
 
 	retval = -ENOENT;
-	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL, NULL);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
 	if (!bh)
@@ -2950,7 +3029,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
-	retval = ext4_delete_entry(handle, dir, de, bh);
+	retval = ext4_delete_entry(handle, dir, de, bh, NULL);
 	if (retval)
 		goto end_rmdir;
 	if (!EXT4_DIR_LINK_EMPTY(inode))
@@ -2985,6 +3064,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle = NULL;
+	struct dx_frame dx_frame = { NULL };
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
 		return -EIO;
@@ -3000,7 +3080,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		return retval;
 
 	retval = -ENOENT;
-	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL, &dx_frame);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
 	if (!bh)
@@ -3028,7 +3108,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 				   dentry->d_name.len, dentry->d_name.name);
 		set_nlink(inode, 1);
 	}
-	retval = ext4_delete_entry(handle, dir, de, bh);
+	retval = ext4_delete_entry(handle, dir, de, bh, &dx_frame);
 	if (retval)
 		goto end_unlink;
 	dir->i_ctime = dir->i_mtime = current_time(dir);
@@ -3042,6 +3122,8 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 
 end_unlink:
 	brelse(bh);
+	if (dx_frame.bh)
+		brelse(dx_frame.bh);
 	if (handle)
 		ext4_journal_stop(handle);
 	trace_ext4_unlink_exit(dentry, retval);
@@ -3362,11 +3444,11 @@ static int ext4_find_delete_entry(handle_t *handle, struct inode *dir,
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
 
-	bh = ext4_find_entry(dir, d_name, &de, NULL);
+	bh = ext4_find_entry(dir, d_name, &de, NULL, NULL);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
 	if (bh) {
-		retval = ext4_delete_entry(handle, dir, de, bh);
+		retval = ext4_delete_entry(handle, dir, de, bh, NULL);
 		brelse(bh);
 	}
 	return retval;
@@ -3390,7 +3472,8 @@ static void ext4_rename_delete(handle_t *handle, struct ext4_renament *ent,
 		retval = ext4_find_delete_entry(handle, ent->dir,
 						&ent->dentry->d_name);
 	} else {
-		retval = ext4_delete_entry(handle, ent->dir, ent->de, ent->bh);
+		retval = ext4_delete_entry(handle, ent->dir, ent->de, ent->bh,
+					   NULL);
 		if (retval == -ENOENT) {
 			retval = ext4_find_delete_entry(handle, ent->dir,
 							&ent->dentry->d_name);
@@ -3497,7 +3580,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			return retval;
 	}
 
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL,
+				 NULL);
 	if (IS_ERR(old.bh))
 		return PTR_ERR(old.bh);
 	/*
@@ -3511,7 +3595,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto end_rename;
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
-				 &new.de, &new.inlined);
+				 &new.de, &new.inlined, NULL);
 	if (IS_ERR(new.bh)) {
 		retval = PTR_ERR(new.bh);
 		new.bh = NULL;
@@ -3691,7 +3775,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return retval;
 
 	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name,
-				 &old.de, &old.inlined);
+				 &old.de, &old.inlined, NULL);
 	if (IS_ERR(old.bh))
 		return PTR_ERR(old.bh);
 	/*
@@ -3705,7 +3789,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto end_rename;
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
-				 &new.de, &new.inlined);
+				 &new.de, &new.inlined, NULL);
 	if (IS_ERR(new.bh)) {
 		retval = PTR_ERR(new.bh);
 		new.bh = NULL;
-- 
2.20.1.791.gb4d0f1c61a-goog

