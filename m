Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73933F660E
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186789; cv=none; b=Ows8XFo9EghbbtjjeJ8m99jFWSYbwuSRPPSEyvPMV/KYigK25GupOYGqM/+cuDCOsQS+EmT4TltlMwSdwRLFHu2O+GqII/X259xTfLCVe0VogzUp+HiWF7CiFauxrG5qkVOzKtDjRlVZammYM3ZFJor4i4xFYONnn85hJ1PjADQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186789; c=relaxed/simple;
	bh=GYPWl9/VD17AHR0JCmxoZNoIB/GKx+f9038Rc077Ylg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ca3Fs+TelzAbFHrs4FG9PUxc0SU6nLLVcPLp/lQO4Ast9rhzaza5FDyI/dZhVTbBzNCT7Xe/N5/XTmgkgl50bCou6/XcMPm8CwEa0Ivwrw1EXlzTHqR3TMBJpF0DqjpUXb46MfgGWuTNcjKzchJu3O4a4mEqU55Wk6NJPVyGiMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OYNJMmqW; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OYNJMmqW"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so21934275e9.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186786; x=1785791586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=krzzom5Z4G8N3x1JS56RyzrtYsUfcPky4K41ibrBAXk=;
        b=OYNJMmqWxOo+DzNDE8vqf7H4P4QpIzxPOBn+dyNCe/ovZY4e6NuCA0cKzkFCKN67t4
         boP78w7BaSfV/sh+oCPtwldhxbIeH9I7WxwC8HU3+Q6SoDtKgwMYxU+xFWyPWQHVaBIR
         JNPTzk3nFGOmshZhUnTFYaEvVE87eWmHXExJRNO7EU+4pxMStc3yo8VsDiPooCZY9ggz
         meu+3TUWxkgk2bfTK+Rh1PImL9f4ceFwVhfvY0V0Go17gj1r91Gi+EG8ZmqEOKMZMP1y
         fRtYuLM29e1OBXicvEuiOaIwd3KdbvSpchIC36eDSxG30Wi26wFXdTYnP7qoagK+YcdC
         d1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186786; x=1785791586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=krzzom5Z4G8N3x1JS56RyzrtYsUfcPky4K41ibrBAXk=;
        b=MqYr0RSL3wtYfzDZuYnjR8IL+q0tHzJRdsOyfAxzT3q8mag68uBLgvo4e2VF8z9p/C
         tnVwGLwW85JEszkyD7kC9dsSh0dwzLHBCdX4K1Z2eBpGst7aOmVEkmFifwaYFM51M0si
         EjMRKE6ywBkqCKPB0jE5zxu3SU/9mPvikMCVWU3QKncmczFTGToQMkg3QLU+gJNkg8ID
         lpW3g0EDLXABpvh85fBfNWF8aA2BcydNOTo3EFcCimY4M7DOYKS1eZqhTfCAs51r4Rns
         cXIf4qpUa+Pbp0oYEcP4EYgFXYEpxt0TX166evDmqEVak+ONeEWGBLN4WZekGzpS9k+y
         L0/A==
X-Gm-Message-State: AOJu0YxW85czqbnvIFYzIule5dcA0MYF/5BA9lZO9XHdyBdsmTm2r9PX
	xpJ1SeWVjEIHMW8m7i8x2irMtkN7ru7rxx9Seidebsqb33vt/XXtnLAs5ohowXc2
X-Gm-Gg: AR+sD10lDx/yR7TK2lveD6jWEXEZmDPhJ4QGbjTHE8HPOEIAt7lt7p4+YqHC7vreWse
	IBd+gmowF1BNdOX0MQjTyu2KLA2fJPSe+FbpOwfNUUnkKCot3NV/vYRTvV9ruZ1JxnbqYjcerad
	aDwGGimBWVVl6q2VcZmPKzPYkDBRZ4PbpyWuhDJHaLxgs/C874PSscLK7IburTx4vB90n/zr5aH
	DPvfAeJ/GoVpN1Cu39XnnPPLJryS9FGhB3Rl836G9Pbe0OM3hi7Txstb0i2S/C/zzitVhbzYq/g
	Qh/vwuNZxBpXxuptoQfPb40m+nsKQyBVAFnQ+aCWyqYTTiCZURYAP1Ak77jTGFwOAD6b9sJ6j16
	XvN3rI4OJgE/VDKa3mzCWOBgS3YE3Jh90McOZ41q4OHIkSdIz4zwiK/0vdjJK7iop+UoX5nc5W2
	rYUzDhkKTAKSQ8ip3tdHL4d8MZrzypR3+AuA==
X-Received: by 2002:a05:600c:5754:b0:495:515a:dad9 with SMTP id 5b1f17b1804b1-496c4fe2756mr4610425e9.37.1785186786083;
        Mon, 27 Jul 2026 14:13:06 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44afaecsm24910245e9.2.2026.07.27.14.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:05 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v6 07/11] ext4: rename ext4_dir_rec_len() and clarify dirdata usage
Date: Mon, 27 Jul 2026 17:11:19 -0400
Message-ID: <20260727211125.19632-8-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
References: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Rename ext4_dir_rec_len() to ext4_dirent_rec_len() to better
reflect that it computes the record length for a directory
entry based on the provided name length.

Update the comment to clarify handling of dirdata-enabled
directories and document the use of ext4_dir_entry_len()
when dirdata is present.

No functional changes.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/dir.c    | 11 +++++------
 fs/ext4/ext4.h   | 14 ++++++++++----
 fs/ext4/inline.c | 14 +++++++-------
 fs/ext4/namei.c  | 25 +++++++++++++------------
 4 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 17edd678fa87..3294947f8555 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -89,16 +89,15 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 	bool fake = is_fake_dir_entry(de);
 	bool has_csum = ext4_has_feature_metadata_csum(dir->i_sb);
 
-	if (unlikely(rlen < ext4_dir_rec_len(1, fake ? NULL : dir)))
+	if (unlikely(rlen < ext4_dirent_rec_len(1, fake ? NULL : dir)))
 		error_msg = "rec_len is smaller than minimal";
 	else if (unlikely(rlen % 4 != 0))
 		error_msg = "rec_len % 4 != 0";
-	else if (unlikely(rlen < ext4_dir_rec_len(de->name_len,
-							fake ? NULL : dir)))
-		error_msg = "rec_len is too small for name_len";
 	else if (unlikely(next_offset > size))
 		error_msg = "directory entry overrun";
-	else if (unlikely(next_offset > size - ext4_dir_rec_len(1,
+	else if (unlikely(rlen < ext4_dir_entry_len(de, size, fake ? NULL : dir)))
+		error_msg = "rec_len is too small for name_len";
+	else if (unlikely(next_offset > size - ext4_dirent_rec_len(1,
 						  has_csum ? NULL : dir) &&
 			  next_offset != size))
 		error_msg = "directory entry too close to block end";
@@ -245,7 +244,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 				 * failure will be detected in the
 				 * dirent test below. */
 				if (ext4_rec_len_from_disk(de->rec_len,
-					sb->s_blocksize) < ext4_dir_rec_len(1,
+					sb->s_blocksize) < ext4_dirent_rec_len(1,
 									inode))
 					break;
 				i += ext4_rec_len_from_disk(de->rec_len,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a6e857690352..fff8e4abe4ab 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2614,11 +2614,16 @@ struct ext4_dirent_hash {
  * casefolded and encrypted need to store the hash as well, so we add room for
  * ext4_extended_dir_entry_2. For all entries related to '.' or '..' you should
  * pass NULL for dir, as those entries do not use the extra fields.
+ *
+ * For directories with the dirdata feature, extra data may follow the filename.
+ * Use ext4_dir_entry_len() to compute the length of a directory entry
+ * including any dirdata, or ext4_dirent_rec_len() directly when the total
+ * name_len (including dirdata length) is already known.
  */
-static inline unsigned int ext4_dir_rec_len(__u8 name_len,
+static inline unsigned int ext4_dirent_rec_len(unsigned int name_len,
 						const struct inode *dir)
 {
-	int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
+	unsigned int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
 
 	/*
 	 * Without dirdata, the casefold+fscrypt hash lives at a fixed position
@@ -3034,7 +3039,8 @@ extern void ext4_htree_free_dir_info(struct dir_private_info *p);
 extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size,
 			     struct ext4_filename *fname,
-			     struct ext4_dir_entry_2 **dest_de);
+			     struct ext4_dir_entry_2 **dest_de,
+			     int dlen);
 void ext4_insert_dentry(struct inode *dir, struct inode *inode,
 			struct ext4_dir_entry_2 *de,
 			int buf_size,
@@ -4158,7 +4164,7 @@ static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
 	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, blocksize);
 	unsigned int dirdata = ext4_dirent_get_data_len(de, rec_len);
 
-	return ext4_dir_rec_len(de->name_len + dirdata, dir);
+	return ext4_dirent_rec_len(de->name_len + dirdata, dir);
 }
 
 extern const struct iomap_ops ext4_iomap_ops;
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..5b3faacdf143 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -977,7 +977,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	struct ext4_dir_entry_2 *de;
 
 	err = ext4_find_dest_de(dir, iloc->bh, inline_start,
-				inline_size, fname, &de);
+				inline_size, fname, &de, 0);
 	if (err)
 		return err;
 
@@ -1055,7 +1055,7 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
 	int old_size = EXT4_I(dir)->i_inline_size - EXT4_MIN_INLINE_DATA_SIZE;
 	int new_size = get_max_inline_xattr_value_size(dir, iloc);
 
-	if (new_size - old_size <= ext4_dir_rec_len(1, NULL))
+	if (new_size - old_size <= ext4_dirent_rec_len(1, NULL))
 		return -ENOSPC;
 
 	ret = ext4_update_inline_data(handle, dir,
@@ -1309,7 +1309,7 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			fake.name_len = 1;
 			memcpy(fake.name, ".", 2);
 			fake.rec_len = ext4_rec_len_to_disk(
-					  ext4_dir_rec_len(fake.name_len, NULL),
+					  ext4_dirent_rec_len(fake.name_len, NULL),
 					  inline_size);
 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
 			de = &fake;
@@ -1319,7 +1319,7 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			fake.name_len = 2;
 			memcpy(fake.name, "..", 3);
 			fake.rec_len = ext4_rec_len_to_disk(
-					  ext4_dir_rec_len(fake.name_len, NULL),
+					  ext4_dirent_rec_len(fake.name_len, NULL),
 					  inline_size);
 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
 			de = &fake;
@@ -1427,8 +1427,8 @@ int ext4_read_inline_dir(struct file *file,
 	 * So we will use extra_offset and extra_size to indicate them
 	 * during the inline dir iteration.
 	 */
-	dotdot_offset = ext4_dir_rec_len(1, NULL);
-	dotdot_size = dotdot_offset + ext4_dir_rec_len(2, NULL);
+	dotdot_offset = ext4_dirent_rec_len(1, NULL);
+	dotdot_size = dotdot_offset + ext4_dirent_rec_len(2, NULL);
 	extra_offset = dotdot_size - EXT4_INLINE_DOTDOT_SIZE;
 	extra_size = extra_offset + inline_size;
 
@@ -1463,7 +1463,7 @@ int ext4_read_inline_dir(struct file *file,
 			 * failure will be detected in the
 			 * dirent test below. */
 			if (ext4_rec_len_from_disk(de->rec_len, extra_size)
-				< ext4_dir_rec_len(1, NULL))
+				< ext4_dirent_rec_len(1, NULL))
 				break;
 			i += ext4_rec_len_from_disk(de->rec_len,
 						    extra_size);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5115d660d9fc..3279698365b3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1100,7 +1100,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	/* csum entries are not larger in the casefolded encrypted case */
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
-					   ext4_dir_rec_len(0,
+					   ext4_dirent_rec_len(0,
 							   csum ? NULL : dir));
 	/* Check if the directory is encrypted */
 	if (IS_ENCRYPTED(dir)) {
@@ -1894,7 +1894,7 @@ dx_move_dirents(struct inode *dir, char *from, char *to,
 	while (count--) {
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)
 						(from + (map->offs<<2));
-		rec_len = ext4_dir_rec_len(de->name_len, dir);
+		rec_len = ext4_dir_entry_len(de, blocksize, dir);
 
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
@@ -1927,7 +1927,7 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(struct inode *dir, char *base,
 	while ((char*)de < base + blocksize) {
 		next = ext4_next_entry(de, blocksize);
 		if (de->inode && de->name_len) {
-			rec_len = ext4_dir_rec_len(de->name_len, dir);
+			rec_len = ext4_dir_entry_len(de, blocksize, dir);
 			if (de > to)
 				memmove(to, de, rec_len);
 			to->rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
@@ -2079,10 +2079,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 		      void *buf, int buf_size,
 		      struct ext4_filename *fname,
-		      struct ext4_dir_entry_2 **dest_de)
+		      struct ext4_dir_entry_2 **dest_de,
+		      int dlen)
 {
 	struct ext4_dir_entry_2 *de;
-	unsigned short reclen = ext4_dir_rec_len(fname_len(fname), dir);
+	unsigned short reclen = ext4_dirent_rec_len(fname_len(fname) + dlen, dir);
 	int nlen, rlen;
 	unsigned int offset = 0;
 	char *top;
@@ -2095,7 +2096,7 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			return -EFSCORRUPTED;
 		if (ext4_match(dir, fname, de))
 			return -EEXIST;
-		nlen = ext4_dir_rec_len(de->name_len, dir);
+		nlen = ext4_dir_entry_len(de, buf_size, dir);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 		if ((de->inode ? rlen - nlen : rlen) >= reclen)
 			break;
@@ -2118,7 +2119,7 @@ void ext4_insert_dentry(struct inode *dir,
 
 	int nlen, rlen;
 
-	nlen = ext4_dir_rec_len(de->name_len, dir);
+	nlen = ext4_dir_entry_len(de, buf_size, dir);
 	rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 =
@@ -2987,7 +2988,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(ext4_dir_rec_len(de->name_len, NULL),
+	de->rec_len = ext4_rec_len_to_disk(ext4_dirent_rec_len(de->name_len, NULL),
 					   blocksize);
 	memcpy(de->name, ".", 2);
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
@@ -2999,7 +3000,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 	if (inline_buf) {
 		de->rec_len = ext4_rec_len_to_disk(
-					ext4_dir_rec_len(de->name_len, NULL),
+					ext4_dirent_rec_len(de->name_len, NULL),
 					blocksize);
 		de = ext4_next_entry(de, blocksize);
 		header_size = (char *)de - bh->b_data;
@@ -3008,7 +3009,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			blocksize - csum_size);
 	} else {
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + ext4_dir_rec_len(1, NULL)),
+					(csum_size + ext4_dirent_rec_len(1, NULL)),
 					blocksize);
 	}
 
@@ -3131,8 +3132,8 @@ bool ext4_empty_dir(struct inode *inode)
 	}
 
 	sb = inode->i_sb;
-	if (inode->i_size < ext4_dir_rec_len(1, NULL) +
-					ext4_dir_rec_len(2, NULL)) {
+	if (inode->i_size < ext4_dirent_rec_len(1, NULL) +
+					ext4_dirent_rec_len(2, NULL)) {
 		EXT4_ERROR_INODE(inode, "invalid size");
 		return false;
 	}
-- 
2.43.7

