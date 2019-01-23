Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0701C282C2
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 18:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72358218A3
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 18:33:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cy5h/q2W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfAWSdL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 13:33:11 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46082 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfAWSdK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2019 13:33:10 -0500
Received: by mail-pl1-f193.google.com with SMTP id t13so1565402ply.13
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2019 10:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jI7TtWjsgeSGskBz4foddOPmCYO9awiayxhQpv+5+sg=;
        b=Cy5h/q2WAmgMHaPSVs+1wHVm/ADjFvR2nUNbriAbuYp3Mxn5oMILS5bP6I32T176GQ
         0l53ZdJ7IKur6EFEdgXoqwZR+HXefmnzEHdQj4HbZv/4RLSG01qYdA5PDvoclDL27yfk
         vSfpaFu9LDvst1eOG7zCub8c3MLOBcM3qENne9GC+H1yaeHj01qKYiogW/fZtQgVa8S+
         +5DY3vzu5Jz2Wt7HVWauTvUcOXEFgsJ8itS9Tc2b3ivGSaMTM64ozIgfBvmjHeFb7NnO
         O6aKmtnxpfTkqS5nLy18WDM82cFOFTbUsQNXabloc2jcmT3KldvRD7XmLFIQIgZz+3dP
         6iEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jI7TtWjsgeSGskBz4foddOPmCYO9awiayxhQpv+5+sg=;
        b=QEbOvPiLTQEQoaEnBbV8iGmZNRMSFD2gPxdRUiX44mSUPw3L43S130IL6MXSqSQ7DR
         oX+6FdhY9Qy6wi9iDF8vNAU6m3mg4ZL8zNosICN3EsDpNUZ1VWoZ6gkHIA1/0s2U/dM4
         6L/0WErHJ+9NqwEOdF6tv8ixhdbFaS16Q4YiDoufXv2JkimHMB0qVlByWtRWX2inKZdN
         xmIhsbtKvuOIzPt1cL8Q1dHYq2sSmeCNYsBsGy4CGBYD0/7klNuV9nVtsZVna877if9H
         zWWR5iBYjP20jB3Svn2RR8VT1IEG2fx/beYtWjvgh1Sn/MUNY0D5rPbKMJEA0zInCsYa
         oWSg==
X-Gm-Message-State: AJcUukfhOfC3FJD1t6lpq9mOCtWNzvfHM8BuhQY+auvF/A6rlAYLafvE
        yRzYF+mcb0+tPMADACDa/52CACYV
X-Google-Smtp-Source: ALg8bN61ExpFq8bd98ZqC77LkRjgW8u90EwgOUFsrm1KQcfGg9M59MeHkYq4DytX+zpJ6K0xIwzB2A==
X-Received: by 2002:a17:902:7c05:: with SMTP id x5mr3250005pll.273.1548268389832;
        Wed, 23 Jan 2019 10:33:09 -0800 (PST)
Received: from harshads0.svl.corp.google.com ([2620:15c:2cd:203:3345:5d82:1105:e6ea])
        by smtp.googlemail.com with ESMTPSA id w185sm27913271pfb.135.2019.01.23.10.33.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 10:33:09 -0800 (PST)
From:   harshadshirwadkar@gmail.com
To:     umka@cloudlinux.com, linux-ext4@vger.kernel.org
Cc:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: [PATCH] ext4: shrink directory when last block is empty
Date:   Wed, 23 Jan 2019 10:32:45 -0800
Message-Id: <20190123183245.154246-1-harshadshirwadkar@gmail.com>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <CAD+ocbwgH6bHrPqB0ERM2YA703nASqRzLYCu-eJQn1uFgh1ivg@mail.gmail.com>
References: <CAD+ocbwgH6bHrPqB0ERM2YA703nASqRzLYCu-eJQn1uFgh1ivg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

This patch is the first step towards shrinking htree based directories
when files are deleted. We truncate directory inode when a directory
entry removal causes last directory block to be empty. This patch just
removes the last block. We may end up in a situation where many
intermediate dirent blocks in directory inode are empty. Removing
those blocks would be handled later.

Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
---
 fs/ext4/namei.c | 130 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 109 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2a4c25c4681d..79cb88ba898a 100644
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
 
@@ -380,6 +381,7 @@ static void ext4_dirent_csum_set(struct inode *inode,
 					   (void *)t - (void *)dirent);
 }
 
+
 int ext4_handle_dirty_dirent_node(handle_t *handle,
 				  struct inode *inode,
 				  struct buffer_head *bh)
@@ -797,7 +799,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	dxtrace(printk("Look up %x", hash));
 	while (1) {
 		count = dx_get_count(entries);
-		if (!count || count > dx_get_limit(entries)) {
+		if (count > dx_get_limit(entries)) {
 			ext4_warning_inode(dir,
 					   "dx entry: count %u beyond limit %u",
 					   count, dx_get_limit(entries));
@@ -866,6 +868,42 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	return ret_err;
 }
 
+static void
+ext4_dx_delete_entry(handle_t *handle, struct inode *dir,
+		     struct dx_frame *dx_frame, __le64 block)
+{
+	struct dx_entry *entries;
+	unsigned int count, limit;
+	int err, i;
+
+	entries = dx_frame->entries;
+	count = dx_get_count(entries);
+	limit = dx_get_limit(entries);
+
+	for (i = 0; i < count; i++)
+		if (entries[i].block == block)
+			break;
+
+	if (i >= count)
+		return;
+
+	err = ext4_journal_get_write_access(handle, dx_frame->bh);
+	if (err) {
+		ext4_std_error(dir->i_sb, err);
+		return;
+	}
+
+	for (; i < count - 1; i++)
+		entries[i] = entries[i + 1];
+
+	dx_set_count(entries, count - 1);
+	dx_set_limit(entries, limit);
+
+	err = ext4_handle_dirty_dx_node(handle, dir, dx_frame->bh);
+	if (err)
+		ext4_std_error(dir->i_sb, err);
+}
+
 static void dx_release(struct dx_frame *frames)
 {
 	struct dx_root_info *info;
@@ -1309,6 +1347,14 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 	return 0;
 }
 
+static int is_empty_dirent_block(struct inode *dir, struct buffer_head *bh)
+{
+	struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)bh->b_data;
+
+	return (ext4_rec_len_from_disk(de->rec_len, dir->i_sb->s_blocksize)
+		== dir->i_sb->s_blocksize);
+}
+
 static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
 			       struct ext4_dir_entry *de)
 {
@@ -1339,7 +1385,8 @@ static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
 static struct buffer_head * ext4_find_entry (struct inode *dir,
 					const struct qstr *d_name,
 					struct ext4_dir_entry_2 **res_dir,
-					int *inlined)
+					int *inlined,
+					struct dx_frame *dx_frame)
 {
 	struct super_block *sb;
 	struct buffer_head *bh_use[NAMEI_RA_SIZE];
@@ -1388,7 +1435,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		goto restart;
 	}
 	if (is_dx(dir)) {
-		ret = ext4_dx_find_entry(dir, &fname, res_dir);
+		ret = ext4_dx_find_entry(dir, &fname, res_dir, dx_frame);
 		/*
 		 * On success, or if the error was file not found,
 		 * return.  Otherwise, fall back to doing a search the
@@ -1486,9 +1533,10 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 	return ret;
 }
 
-static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
-			struct ext4_filename *fname,
-			struct ext4_dir_entry_2 **res_dir)
+static struct buffer_head *ext4_dx_find_entry(
+			struct inode *dir, struct ext4_filename *fname,
+			struct ext4_dir_entry_2 **res_dir,
+			struct dx_frame *dx_frame)
 {
 	struct super_block * sb = dir->i_sb;
 	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
@@ -1502,6 +1550,10 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 	frame = dx_probe(fname, dir, NULL, frames);
 	if (IS_ERR(frame))
 		return (struct buffer_head *) frame;
+	if (dx_frame) {
+		*dx_frame = *frame;
+		get_bh(dx_frame->bh);
+	}
 	do {
 		block = dx_get_block(frame->at);
 		bh = ext4_read_dirblock(dir, block, DIRENT);
@@ -1553,7 +1605,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 	if (dentry->d_name.len > EXT4_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL, NULL);
 	if (IS_ERR(bh))
 		return (struct dentry *) bh;
 	inode = NULL;
@@ -1597,7 +1649,7 @@ struct dentry *ext4_get_parent(struct dentry *child)
 	struct ext4_dir_entry_2 * de;
 	struct buffer_head *bh;
 
-	bh = ext4_find_entry(d_inode(child), &dotdot, &de, NULL);
+	bh = ext4_find_entry(d_inode(child), &dotdot, &de, NULL, NULL);
 	if (IS_ERR(bh))
 		return (struct dentry *) bh;
 	if (!bh)
@@ -2337,9 +2389,13 @@ int ext4_generic_delete_entry(handle_t *handle,
 static int ext4_delete_entry(handle_t *handle,
 			     struct inode *dir,
 			     struct ext4_dir_entry_2 *de_del,
-			     struct buffer_head *bh)
+			     struct buffer_head *bh,
+			     struct dx_frame *dx_frame)
 {
+	struct ext4_map_blocks map;
 	int err, csum_size = 0;
+	int should_truncate = 0;
+
 
 	if (ext4_has_inline_data(dir)) {
 		int has_inline_data = 1;
@@ -2363,11 +2419,35 @@ static int ext4_delete_entry(handle_t *handle,
 	if (err)
 		goto out;
 
+	if (dx_frame && dx_frame->bh && is_empty_dirent_block(dir, bh)) {
+
+		map.m_lblk = (dir->i_size - 1) >>
+			     (dir->i_sb->s_blocksize_bits);
+		map.m_len = 1;
+		err = ext4_map_blocks(handle, dir, &map, 0);
+
+		if ((err > 0) && (bh->b_blocknr == map.m_pblk)) {
+			ext4_dx_delete_entry(handle, dir, dx_frame,
+					     cpu_to_le64(map.m_lblk));
+			should_truncate = 1;
+		}
+	}
+
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+
 	err = ext4_handle_dirty_dirent_node(handle, dir, bh);
 	if (unlikely(err))
 		goto out;
 
+	if (should_truncate) {
+		dir->i_size -= dir->i_sb->s_blocksize;
+		ext4_truncate(dir);
+		if (dir->i_size == dir->i_sb->s_blocksize) {
+			ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
+			ext4_mark_inode_dirty(handle, dir);
+		}
+	}
+
 	return 0;
 out:
 	if (err != -ENOENT)
@@ -2923,7 +3003,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 		return retval;
 
 	retval = -ENOENT;
-	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL, NULL);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
 	if (!bh)
@@ -2950,7 +3030,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
-	retval = ext4_delete_entry(handle, dir, de, bh);
+	retval = ext4_delete_entry(handle, dir, de, bh, NULL);
 	if (retval)
 		goto end_rmdir;
 	if (!EXT4_DIR_LINK_EMPTY(inode))
@@ -2985,6 +3065,9 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle = NULL;
+	struct dx_frame dx_frame;
+
+	memset(&dx_frame, 0, sizeof(dx_frame));
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
 		return -EIO;
@@ -3000,7 +3083,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		return retval;
 
 	retval = -ENOENT;
-	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL, &dx_frame);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
 	if (!bh)
@@ -3028,9 +3111,10 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 				   dentry->d_name.len, dentry->d_name.name);
 		set_nlink(inode, 1);
 	}
-	retval = ext4_delete_entry(handle, dir, de, bh);
+	retval = ext4_delete_entry(handle, dir, de, bh, &dx_frame);
 	if (retval)
 		goto end_unlink;
+
 	dir->i_ctime = dir->i_mtime = current_time(dir);
 	ext4_update_dx_flag(dir);
 	ext4_mark_inode_dirty(handle, dir);
@@ -3042,6 +3126,8 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 
 end_unlink:
 	brelse(bh);
+	if (dx_frame.bh)
+		brelse(dx_frame.bh);
 	if (handle)
 		ext4_journal_stop(handle);
 	trace_ext4_unlink_exit(dentry, retval);
@@ -3362,11 +3448,11 @@ static int ext4_find_delete_entry(handle_t *handle, struct inode *dir,
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
@@ -3390,7 +3476,8 @@ static void ext4_rename_delete(handle_t *handle, struct ext4_renament *ent,
 		retval = ext4_find_delete_entry(handle, ent->dir,
 						&ent->dentry->d_name);
 	} else {
-		retval = ext4_delete_entry(handle, ent->dir, ent->de, ent->bh);
+		retval = ext4_delete_entry(handle, ent->dir, ent->de, ent->bh,
+					   NULL);
 		if (retval == -ENOENT) {
 			retval = ext4_find_delete_entry(handle, ent->dir,
 							&ent->dentry->d_name);
@@ -3497,7 +3584,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			return retval;
 	}
 
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL,
+				 NULL);
 	if (IS_ERR(old.bh))
 		return PTR_ERR(old.bh);
 	/*
@@ -3511,7 +3599,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto end_rename;
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
-				 &new.de, &new.inlined);
+				 &new.de, &new.inlined, NULL);
 	if (IS_ERR(new.bh)) {
 		retval = PTR_ERR(new.bh);
 		new.bh = NULL;
@@ -3691,7 +3779,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return retval;
 
 	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name,
-				 &old.de, &old.inlined);
+				 &old.de, &old.inlined, NULL);
 	if (IS_ERR(old.bh))
 		return PTR_ERR(old.bh);
 	/*
@@ -3705,7 +3793,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto end_rename;
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
-				 &new.de, &new.inlined);
+				 &new.de, &new.inlined, NULL);
 	if (IS_ERR(new.bh)) {
 		retval = PTR_ERR(new.bh);
 		new.bh = NULL;
-- 
2.20.1.321.g9e740568ce-goog

