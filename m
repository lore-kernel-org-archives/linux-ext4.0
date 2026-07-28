Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9133FF1C4
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 23:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282249; cv=none; b=UYOOmWWpiNQbvnhgsHuG1PyIb+ca99SeyccCfdh1f7zPsN4ruiznlWAUqPqfv0kM/vNZqmjk8bI40SWxYvTWrq9DwwpEEX2qqtzQMmmI4NEbPzIEnW5l76+H2dHp/+plLHDZIhHNj6KTPtPY3IYhDhQrGBBQRutvs0pFu0B6H2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282249; c=relaxed/simple;
	bh=Z8TMlkUPdQ4Za4MfVF9gFNyLjEpLDL7M3EcCGdjz3bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqIM+1uSgFr8NlatNCDJho5IqfVtqVAdLW83Afe9kawxmb5cdT+xacHH0kJw4auq8wqlHYLhl5E+iJWzVnRcB0V40vV/vZwVtDgQSk+WcSBr0/hvKwEVo+99IDAsXgxRjn0NSvVA5Mt4L9VFTHuUldQXaWh7Iw7g2u9lvpHsQX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R9PDaOCu; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R9PDaOCu"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so8266675e9.1
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 16:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785282246; x=1785887046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHd30BKGIiuV71Fr8HIaloI4vSx72662oUfzrq0B9n8=;
        b=R9PDaOCuthORqBbebY71dJMMjCG/TF6QPoDNQi/4ldspnS+OgPCqkaCL4zTRFSRBdZ
         81xjJSRdlMc+RJewCeZXEtHiJUSEDVfO1B1tbjbzhEVe0a8UHEBT3saiikj3mEiJ/7Xt
         FwBSSHDm18COpJfIcz7ebZBso949K7gYKNn0uF4W0MfOP6H3iQriSS2nV9NNabKbWurA
         5kDXN8zgLHdodjdQGxdPYEnI4tgDfXKj4mSSWBDwpIE6O1jvg/chEccFu3u1pkNw127P
         J/fjRvrKl8U/AZBNlefYojRO5NVy0hhWJ9np5rYwL6nVwhAUeeVlAfQ+urYuJ29B4mdX
         pLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785282246; x=1785887046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CHd30BKGIiuV71Fr8HIaloI4vSx72662oUfzrq0B9n8=;
        b=TJ+ZzRoTU/3g0FjZX5PK3BRBL6j6O0cyXibnrND/TClhdJLx5lGcD6A2XkVnOd5HOr
         WBHRoCKtB7kKsrJDEqJNBdPa+0ooW4L01gGiJ+Xj2a0ZfR3VhufEToND46xcDCxuM1AX
         iov8LKUVW2CS9UmO2Dw1jzuMIF0RM0PIG9LTYiG3YhLsWQHlSwWCOHItVQrigE6tE+rC
         XE5o+6qr5aWA0nWZBRW5c3i1rDjzfQmwnO9zeYBxPFtDmCMqd0raKOrI51fO3IEFoxVb
         9gZSyYtPbrOuuw+9jFJixSZkXINcnsase3x4J05pu5vRbpvKvaN/w9VSZrlFkpL0ei35
         tqOQ==
X-Gm-Message-State: AOJu0YytCX0vSANjJUyugIWLLDS9t/GWmMJlonglSZlTultRl43hOXKR
	FcNCkehdvJqJFP1AmfhgbCdROx5L2kWn7AqeHtOjWpL5ib6B969o16KqzT83YlOI
X-Gm-Gg: AR+sD12HLeYTEbQFPTJHXZnTaaqzd0gQNImb/z7efsvc6g9iO6e0525JJJod8z1qJHa
	StkHIR7lv5x35B2JasxiYONaYNP+rHK1tXvEMXM8FSZwkzKSSh9xoJXE7Qheqh63pay/Jfm0oGn
	JKfSvT5QbuUenJCMljgIFJ7twYDuZVZwMe0vTMIky/fjpHkI5J0Q3+9eM9yWaA1RzJSzkd66bgg
	TK6DwvNJqeZGLjgy48ACOLOeRyLwgS6v9vzC127GOl40f1yXKbX2Dra0YfyoU/AjmPXG42gMcB6
	gchF4SWRUlJc0SAMfOQcA+/q0SYh8QEvYZzUlQbhoAsJCE0Q0JuZEx/mVaq5bPkPh/Fs6CesioD
	t6dId2LaZ+lJEHP9i6jf5ZPU1c3tB6d5o8Q55jPIYwd2HOMzp3wPiyZsBYPH8vLtA3erEgmsQWt
	YH8eZP6YQu9/PxSbnBSY5S7TSTrTruY8Cuzt5nUNjseX9IYKq32Nh4v3t7rGk4Mdqqynkjnvf3i
	a+zNdd+7RKUglV2yZQq
X-Received: by 2002:a05:600c:5291:b0:495:6193:c6c0 with SMTP id 5b1f17b1804b1-496c658f6cdmr44275805e9.18.1785282246420;
        Tue, 28 Jul 2026 16:44:06 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496fa499a96sm13980365e9.3.2026.07.28.16.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:44:06 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v7 02/11] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Tue, 28 Jul 2026 19:42:13 -0400
Message-ID: <20260728234226.51753-3-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
References: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Replace remaining uses of struct ext4_dir_entry in namei.c
with struct ext4_dir_entry_2.

The code paths affected by this change already depend on the
filetype feature, so using struct ext4_dir_entry_2 is
appropriate and avoids mixing the two directory entry types
unnecessarily.

This change does not affect support for 16-bit rec_len.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h  |  6 ++----
 fs/ext4/namei.c | 38 +++++++++++++++++++-------------------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..aa8a37566a38 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2472,10 +2472,8 @@ static inline int ext4_emergency_state(struct super_block *sb)
  * Structure of a directory entry
  */
 #define EXT4_NAME_LEN 255
-/*
- * Base length of the ext4 directory entry excluding the name length
- */
-#define EXT4_BASE_DIR_LEN (sizeof(struct ext4_dir_entry_2) - EXT4_NAME_LEN)
+/* offsetof avoids sizeof()+padding giving 9 instead of the correct on-disk 8 */
+#define EXT4_BASE_DIR_LEN offsetof(struct ext4_dir_entry_2, name)
 
 struct ext4_dir_entry {
 	__le32	inode;			/* Inode number */
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a283e285937a..c2f330c75c81 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -102,7 +102,7 @@ static struct buffer_head *ext4_append(handle_t *handle,
 }
 
 static int ext4_dx_csum_verify(struct inode *inode,
-			       struct ext4_dir_entry *dirent);
+			       struct ext4_dir_entry_2 *dirent);
 
 /*
  * Hints to ext4_read_dirblock regarding whether we expect a directory
@@ -128,7 +128,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 						unsigned int line)
 {
 	struct buffer_head *bh;
-	struct ext4_dir_entry *dirent;
+	struct ext4_dir_entry_2 *dirent;
 	int is_dx_block = 0;
 
 	if (block >= inode->i_size >> inode->i_blkbits) {
@@ -160,7 +160,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 	}
 	if (!bh)
 		return NULL;
-	dirent = (struct ext4_dir_entry *) bh->b_data;
+	dirent = (struct ext4_dir_entry_2 *) bh->b_data;
 	/* Determine whether or not we have an index block */
 	if (is_dx(inode)) {
 		if (block == 0)
@@ -317,13 +317,13 @@ static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
 	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 
 #ifdef PARANOID
-	struct ext4_dir_entry *d, *top;
+	struct ext4_dir_entry_2 *d, *top;
 
-	d = (struct ext4_dir_entry *)bh->b_data;
-	top = (struct ext4_dir_entry *)(bh->b_data +
+	d = (struct ext4_dir_entry_2 *)bh->b_data;
+	top = (struct ext4_dir_entry_2 *)(bh->b_data +
 		(blocksize - sizeof(struct ext4_dir_entry_tail)));
 	while (d < top && ext4_rec_len_from_disk(d->rec_len, blocksize))
-		d = (struct ext4_dir_entry *)(((void *)d) +
+		d = (struct ext4_dir_entry_2 *)(((void *)d) +
 		    ext4_rec_len_from_disk(d->rec_len, blocksize));
 
 	if (d != top)
@@ -410,22 +410,22 @@ int ext4_handle_dirty_dirblock(handle_t *handle,
 }
 
 static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
-					       struct ext4_dir_entry *dirent,
+					       struct ext4_dir_entry_2 *dirent,
 					       int *offset)
 {
-	struct ext4_dir_entry *dp;
+	struct ext4_dir_entry_2 *de;
 	struct dx_root_info *root;
 	int count_offset;
 	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 	unsigned int rlen = ext4_rec_len_from_disk(dirent->rec_len, blocksize);
 
 	if (rlen == blocksize)
-		count_offset = 8;
+		count_offset = sizeof(struct dx_node);
 	else if (rlen == 12) {
-		dp = (struct ext4_dir_entry *)(((void *)dirent) + 12);
-		if (ext4_rec_len_from_disk(dp->rec_len, blocksize) != blocksize - 12)
+		de = (struct ext4_dir_entry_2 *)(((void *)dirent) + 12);
+		if (ext4_rec_len_from_disk(de->rec_len, blocksize) != blocksize - 12)
 			return NULL;
-		root = (struct dx_root_info *)(((void *)dp + 12));
+		root = (struct dx_root_info *)(((void *)de + 12));
 		if (root->reserved_zero ||
 		    root->info_length != sizeof(struct dx_root_info))
 			return NULL;
@@ -438,7 +438,7 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
 	return (struct dx_countlimit *)(((void *)dirent) + count_offset);
 }
 
-static __le32 ext4_dx_csum(struct inode *inode, struct ext4_dir_entry *dirent,
+static __le32 ext4_dx_csum(struct inode *inode, struct ext4_dir_entry_2 *dirent,
 			   int count_offset, int count, struct dx_tail *t)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -456,7 +456,7 @@ static __le32 ext4_dx_csum(struct inode *inode, struct ext4_dir_entry *dirent,
 }
 
 static int ext4_dx_csum_verify(struct inode *inode,
-			       struct ext4_dir_entry *dirent)
+			       struct ext4_dir_entry_2 *dirent)
 {
 	struct dx_countlimit *c;
 	struct dx_tail *t;
@@ -489,7 +489,7 @@ static int ext4_dx_csum_verify(struct inode *inode,
 	return 1;
 }
 
-static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
+static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry_2 *dirent)
 {
 	struct dx_countlimit *c;
 	struct dx_tail *t;
@@ -523,7 +523,7 @@ static inline int ext4_handle_dirty_dx_node(handle_t *handle,
 					    struct inode *inode,
 					    struct buffer_head *bh)
 {
-	ext4_dx_csum_set(inode, (struct ext4_dir_entry *)bh->b_data);
+	ext4_dx_csum_set(inode, (struct ext4_dir_entry_2 *)bh->b_data);
 	return ext4_handle_dirty_metadata(handle, inode, bh);
 }
 
@@ -1496,7 +1496,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 }
 
 static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
-			       struct ext4_dir_entry *de)
+			       struct ext4_dir_entry_2 *de)
 {
 	struct super_block *sb = dir->i_sb;
 
@@ -1627,7 +1627,7 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
 		}
 		if (!buffer_verified(bh) &&
 		    !is_dx_internal_node(dir, block,
-					 (struct ext4_dir_entry *)bh->b_data) &&
+					 (struct ext4_dir_entry_2 *)bh->b_data) &&
 		    !ext4_dirblock_csum_verify(dir, bh)) {
 			EXT4_ERROR_INODE_ERR(dir, EFSBADCRC,
 					     "checksumming directory "
-- 
2.43.7

