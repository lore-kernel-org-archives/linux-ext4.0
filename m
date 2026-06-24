Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423FE35F16F
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308294; cv=none; b=X5p57O9hapEK29+Ka7T8vfpC5HzIRe7wbFc13Vhor5mQ6UaEYFv875ryZYInYbcWXTMCb7trKa7ZsPya6IvJPeGP5I9VnaaeIHwa0VamofzroIAZIyUO81sPidz3MRLN7vJNNIoHzwG20nHZuzyrtFVdYfhRlQfALNkWu16ukiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308294; c=relaxed/simple;
	bh=UV27ZqW/dRSHXY0QF1PdhYx9ODXUN2TXx3VzJ510zq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDZWTZuZrqJJnP+lQD1DkyYJqZF26EOkT3j9P8UJQSPWb4ZiEVol0sxHja1tSS46XocSxHd/XjbnjiBJL57MjmqDZ8nADKjNcy4TR1rT+OodqLkYHyEaEypNMn88V5w2ql1DAY3QHP8cs0HyTsjQ4kJB1mCHA3784ZE8bK+7Pzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TptrZH/A; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TptrZH/A"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490aaeabdb4so6823915e9.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308291; x=1782913091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0f1oAIY18YAvT9H6gVFxIwti4x73QPw71Oz3pC41yU=;
        b=TptrZH/AvvWiyyX+EQo8E+sb9CHBGGfVqDz5ELZ+IW53luGDAAQYCbfE0Ec6DyMilQ
         OH9bbJa8Lcn+IFbB3HMO4AxfxFGQmyQ+XyrshtrPmJzhTidtn3jD4DjDOjP950/sydC6
         beTXM67ZJRiqKH/rovfwgh+lp074n5X8X5cxuV5D7zsdooFlwPyAi2XfFrouYonJeYgG
         wU7AtaPLdlgzf0NbO2HyX1ASKDhSJxLINMlV/IF5RJlzVorSAQi1o82SepIPw3fIgJ7c
         jToG2ZyGl6a5+BiO6UJcNLaQCP8YUEqq4xXkBtDh0Ha+a1gySPHzeVghT+aG75CXFKFd
         YYsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308291; x=1782913091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J0f1oAIY18YAvT9H6gVFxIwti4x73QPw71Oz3pC41yU=;
        b=Q8PngKO48ylMK7EhJUZK50L5mFUMZdO4acOgwYLVSt03YDmMuf/vR6ARu0PfW1adZD
         /cqm0fEVCxjSDhXYn+lA4gCBS5KYOyeX9S+0VeKldBK+eGFJzKk7J+0c27btVQoBaqV6
         Hi+QCGGo83Q4OAMPH0ysO5osuMD3xFlhpOxv5aFp41bJCI5X4keeDcRJ2Y+52JdKeqsv
         hZ9sqE07k5EC/dId9BrlyLi2P83xN6V71fpDLOnoHQrO6KFghEnbx2u4oWWT7cf4t7hY
         i44QSC1NwbxmbaloS7E4eGN2T/EGr20AbtxYI50C4iPI/uYNcVp3z6KXRVnboRS+ygEH
         ZL7A==
X-Gm-Message-State: AOJu0YyZTqnJ71dByJS14tpSPMtu2U62sATaIHnHpY6IBxrv1+0cADd7
	40PUSljDC/iPuOVrChusJabVwwCZgwezjtZf43emumUGizrZSggGg5WiOwFN6bRifpM=
X-Gm-Gg: AfdE7cluAMaB3+h8N6l7t5kil5Kiobte2enaZazujJNe+VbAsv+7wqgRqLXwGQJXipm
	9QAkVVkGsOGq3m+JQz3/uycsNJ/fzqTorpfFArwjGKlqkxRJqhL4t9jTsgN/5dC3iW7E9krLiw/
	L9Jf1fGmi/LzWlZUnBlJnaHOfEr5ncRnYW9/Qp7u/Uvl447sfvz2Etr3LLLDb7wMZjs8SSJ5Tko
	pME92W+EyErconyf+n2h1iQhvozQi2VmPrz9BzCgxX2NhPHhP4wZM6i6HCsjzDli/+W7JC8cvJQ
	f6+n9/72v91NuOvVqTsPR+9+vJPNLkoOW+vKpsCApL8EhouBtAMzHSKX6vrwvzaWlBbm6yJu8Yw
	jfBMCdOs+G9x+tK+fNO5JedJ2XFyvJK/ZE11IkgyhBl7HXtpLsiCj0yphhgn4CaxcTFrK5DC5k+
	AqzjdyNYXQ7x8ATv/bKDMv+koEwKCMfyxv1/cJRN1oHkk71If0s5L6pVk=
X-Received: by 2002:a05:600c:8b4b:b0:492:4a56:690b with SMTP id 5b1f17b1804b1-49260881747mr48038045e9.35.1782308290686;
        Wed, 24 Jun 2026 06:38:10 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:10 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 09/11] ext4: dirdata feature
Date: Wed, 24 Jun 2026 09:36:38 -0400
Message-ID: <20260624133642.18438-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
References: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

When fscrypt and casefold are enabled together for a directory,
all ext4_dir_entry[_2] in that directory store a n 8-byte hash
of the filename after 'name' between 'name_len' and 'rec_len'.

However, there is no clear indication there is important data
stored in these bytes, which are only for padding and alignment
in other directory entries.  This adds complexity to code handling
the on-disk directory entries, and there is no provision for other
metadata to be stored in each dir entry after 'name'.

The dirdata feature adds a mechanism to store multiple metadata
entries in each dir entry after 'name' (including the fchash).
The unused high 4 bits of 'file_type' are used to indicate whether
additional data fields are stored after 'name'.  If a bit is set,
the corresponding dirdata record is present, starting after a NUL
filename terminator.  If present, a record starts with a 1-byte
length (including the length byte itself) and the data immediately
follows the length byte without any alignment.

This allows up to four different dirdata records to be stored in
each entry, and allows unhandled record bytes to be skipped without
having to process the contents, providing forward compatibility.

If and when the fourth and last dirdata record is needed, it is
recommended to further subdivide it into sub-records, with
the first byte being the total length, and then there being a
second byte that gives the sub-record length, etc. as long as
the total record length is less than 255 bytes.  However, this
would not affect compatibility with the current code since the
record length would allow it to be skipped without processing.

Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h   | 27 +++++++++++++++++++++------
 fs/ext4/inline.c | 23 +++++++++++++++++++----
 fs/ext4/namei.c  | 45 +++++++++++++++++++++++----------------------
 fs/ext4/sysfs.c  |  2 ++
 4 files changed, 65 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2fc9fa6d3021..1e61ce13ed07 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2334,6 +2334,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(casefold,		CASEFOLD)
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
 					 EXT4_FEATURE_INCOMPAT_EA_INODE| \
 					 EXT4_FEATURE_INCOMPAT_MMP | \
+					 EXT4_FEATURE_INCOMPAT_DIRDATA | \
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
 					 EXT4_FEATURE_INCOMPAT_CASEFOLD | \
@@ -3035,10 +3036,18 @@ extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     struct ext4_filename *fname,
 			     struct ext4_dir_entry_2 **dest_de,
 			     int dlen);
-void ext4_insert_dentry(struct inode *dir, struct inode *inode,
-			struct ext4_dir_entry_2 *de,
-			int buf_size,
-			struct ext4_filename *fname);
+void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
+			     struct ext4_dir_entry_2 *de,
+			     int buf_size,
+			     struct ext4_filename *fname,
+			     void *data);
+static inline void ext4_insert_dentry(struct inode *dir, struct inode *inode,
+				      struct ext4_dir_entry_2 *de,
+				      int buf_size,
+				      struct ext4_filename *fname)
+{
+	ext4_insert_dentry_data(dir, inode, de, buf_size, fname, NULL);
+}
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
 	if (!ext4_has_feature_dir_index(inode->i_sb) &&
@@ -3283,8 +3292,14 @@ extern int ext4_ext_migrate(struct inode *);
 extern int ext4_ind_migrate(struct inode *inode);
 
 /* namei.c */
-extern int ext4_init_new_dir(handle_t *handle, struct inode *dir,
-			     struct inode *inode);
+extern int ext4_init_new_dir_data(handle_t *handle, struct inode *dir,
+				  struct inode *inode,
+				  const void *data1, const void *data2);
+static inline int ext4_init_new_dir(handle_t *handle, struct inode *dir,
+				    struct inode *inode)
+{
+	return ext4_init_new_dir_data(handle, dir, inode, NULL, NULL);
+}
 extern int ext4_dirblock_csum_verify(struct inode *inode,
 				     struct buffer_head *bh);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 5b3faacdf143..1fff4defd45b 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -973,11 +973,16 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 				     struct ext4_iloc *iloc,
 				     void *inline_start, int inline_size)
 {
-	int		err;
+	int		err, dlen = 0;
 	struct ext4_dir_entry_2 *de;
+	unsigned char *data = NULL;
+
+	/* Deliver data in any appropriate way here. Now it is NULL */
+	if (data)
+		dlen = (*data) + 1;
 
 	err = ext4_find_dest_de(dir, iloc->bh, inline_start,
-				inline_size, fname, &de, 0);
+				inline_size, fname, &de, dlen);
 	if (err)
 		return err;
 
@@ -986,7 +991,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 					    EXT4_JTR_NONE);
 	if (err)
 		return err;
-	ext4_insert_dentry(dir, inode, de, inline_size, fname);
+	ext4_insert_dentry_data(dir, inode, de, inline_size, fname, NULL);
 
 	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
 
@@ -1326,7 +1331,17 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			pos = EXT4_INLINE_DOTDOT_SIZE;
 		} else {
 			de = (struct ext4_dir_entry_2 *)(dir_buf + pos);
-			pos += ext4_rec_len_from_disk(de->rec_len, inline_size);
+			/* Use ext4_dir_entry_len to account for dirdata extensions.
+			 * This buffer is the inline-data buffer (inline_size bytes),
+			 * not a full directory block -- pass the real buffer size so
+			 * a corrupted/sentinel on-disk rec_len doesn't get decoded as
+			 * a full block's worth of bytes. */
+			pos += ext4_dir_entry_len(de, inline_size, dir);
+			/* Validate pos doesn't exceed buffer to prevent use-after-free */
+			if (pos > inline_size) {
+				ret = count;
+				goto out;
+			}
 			if (ext4_check_dir_entry(inode, dir_file, de,
 					 iloc.bh, dir_buf,
 					 inline_size, pos)) {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 73c8f1b399ef..91def9e0f84d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -401,23 +401,26 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
 {
 	struct ext4_dir_entry_2 *de;
 	struct dx_root_info *root;
-	int count_offset;
+	int count_offset, dotdot_rec_len;
 	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 	unsigned int rlen = ext4_rec_len_from_disk(dirent->rec_len, blocksize);
 
-	if (rlen == blocksize)
+	if (rlen == blocksize) {
 		count_offset = sizeof(struct dx_node);
-	else if (rlen == 12) {
-		de = (struct ext4_dir_entry_2 *)(((void *)dirent) + 12);
-		if (ext4_rec_len_from_disk(de->rec_len, blocksize) != blocksize - 12)
+	} else {
+		de = (struct ext4_dir_entry_2 *)(((char *)dirent) + rlen);
+		if (le16_to_cpu(de->rec_len) != (blocksize - rlen))
 			return NULL;
-		root = (struct dx_root_info *)(((void *)de + 12));
+		/* de->rec_len covers whole dx_root block, calculate actual length.
+		 * This is the '..' entry, which never carries the casefold+fscrypt
+		 * hash, so pass NULL for dir regardless of the directory's flags */
+		dotdot_rec_len = ext4_dir_entry_len(de, blocksize, NULL);
+		root = (struct dx_root_info *)(((char *)de + dotdot_rec_len));
 		if (root->reserved_zero ||
 		    root->info_length != sizeof(struct dx_root_info))
 			return NULL;
-		count_offset = 32;
-	} else
-		return NULL;
+		count_offset = root->info_length + rlen + dotdot_rec_len;
+	}
 
 	if (offset)
 		*offset = count_offset;
@@ -716,7 +719,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 				       (unsigned) ((char *) de - base));
 #endif
 			}
-			space += ext4_dir_rec_len(de->name_len, dir);
+			space += ext4_dir_entry_len(de, size, dir);
 			names++;
 		}
 		de = ext4_next_entry(de, size);
@@ -2090,13 +2093,10 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 	return 0;
 }
 
-void ext4_insert_dentry(struct inode *dir,
-			struct inode *inode,
-			struct ext4_dir_entry_2 *de,
-			int buf_size,
-			struct ext4_filename *fname)
+void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
+			     struct ext4_dir_entry_2 *de, int buf_size,
+			     struct ext4_filename *fname, void *data)
 {
-
 	int nlen, rlen;
 
 	nlen = ext4_dir_entry_len(de, buf_size, dir);
@@ -2138,15 +2138,15 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	int		csum_size = 0;
 	int		err, err2, dlen = 0;
-	unsigned char	*data = NULL;
+	struct ext4_dirent_fid *dfid = NULL;
 
 	/* Deliver data in any appropriate way here. Now it is NULL */
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	if (!de) {
-		if (data)
-			dlen = (*data) + 1;
+		if (dfid)
+			dlen = dfid->df_header.ddh_length;
 		err = ext4_find_dest_de(dir, bh, bh->b_data,
 					blocksize - csum_size, fname, &de, dlen);
 		if (err)
@@ -2161,7 +2161,7 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	}
 
 	/* By now the buffer is marked for journaling */
-	ext4_insert_dentry(dir, inode, de, blocksize, fname);
+	ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
 
 	/*
 	 * XXX shouldn't update any times until successful
@@ -3000,8 +3000,9 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	return ext4_handle_dirty_dirblock(handle, inode, bh);
 }
 
-int ext4_init_new_dir(handle_t *handle, struct inode *dir,
-			     struct inode *inode)
+int ext4_init_new_dir_data(handle_t *handle, struct inode *dir,
+			   struct inode *inode,
+			   const void *data1, const void *data2)
 {
 	struct buffer_head *dir_block = NULL;
 	ext4_lblk_t block = 0;
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 923b375e017f..80074fb15ee9 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -362,6 +362,7 @@ EXT4_ATTR_FEATURE(verity);
 #endif
 EXT4_ATTR_FEATURE(metadata_csum_seed);
 EXT4_ATTR_FEATURE(fast_commit);
+EXT4_ATTR_FEATURE(dirdata);
 #if IS_ENABLED(CONFIG_UNICODE) && defined(CONFIG_FS_ENCRYPTION)
 EXT4_ATTR_FEATURE(encrypted_casefold);
 #endif
@@ -385,6 +386,7 @@ static struct attribute *ext4_feat_attrs[] = {
 #endif
 	ATTR_LIST(metadata_csum_seed),
 	ATTR_LIST(fast_commit),
+	ATTR_LIST(dirdata),
 #if IS_ENABLED(CONFIG_UNICODE) && defined(CONFIG_FS_ENCRYPTION)
 	ATTR_LIST(encrypted_casefold),
 #endif
-- 
2.43.7

