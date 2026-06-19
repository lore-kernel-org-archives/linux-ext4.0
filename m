Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE993438B7
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781896321; cv=none; b=DrQVmDjNNljO34muWRpQUzngLFCQcWKrauXpHbnHgiXuRcckXYUWYQjorzs/QpyWJeb+9Bs7SNUetP8iki6dvgosejmTye8R9PPSKgsl09/h2w7HXkxe3KxxA+Q5sHjnLewC9smRMGwVlTyVaTLnQYXUSzULxojN17VkrPxaEng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781896321; c=relaxed/simple;
	bh=IRoNqbbcVke2bH2/OXiwer8RNi35KVtikGv3AykVXIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGkEcWqr8niFJ8v6mUvb2A4+1Ug1o14YQH/4/44LBU/ntZ/nVkgowX2W/mwKYbFnOotbLHUawTg1R9kvq1+G8gOg0vSvFeD9zLsoQTX8xQO2KEvpIjalV+gX8U+WlXFiBVo+oC/ipaZ+L3CS7GUYPokxI/nZAuRuvxWvbcfD4x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IOQEl6O+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IOQEl6O+"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so18326515e9.1
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896318; x=1782501118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LtTABHSDIwaPyARHnZRF1jPUtjHHbe8EqzS06LyI3Ac=;
        b=IOQEl6O+mQ4/LV+LkBdD15EycS4dHanFoLx8f13P+uzZ5DJ5RxlLT5H/p1n6MrIOFx
         uQF5aO6Ngs3HsUcZI8ibNdxWUY2HXQVIDR2yd+F3T9BslYZ6IijWyOpLiHzUanoKcpn3
         tryLm/aYZkf+RFnB+USYhw/J7mY39FLq4eRqs5Uwzkyr3XD6lDaSz09KMX7znmShi3IA
         D5L7M1u5OT1N/roL7QvXKGrOBFCY34WC1Sbbjpp/142LBl7Pp0fzTy/aKkdncfQg3iBv
         uiwZ2RrCYqdY5+OsziB2RtLnDVI6vekNgPrZ0Z+HsJuBbr2NRHREPtnr3c3UzQGqgOWT
         5wKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896318; x=1782501118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LtTABHSDIwaPyARHnZRF1jPUtjHHbe8EqzS06LyI3Ac=;
        b=I4GeBBt219crCnHrCzAHkeAiwe0X7WuJI1r8BQKJwAIKaIWeX+LM7m+SEiy93pt6oS
         l4S7rOC7VJLBRO7k09+wYxlKOJuR9D8YJkR0V0lkoA5BZwIyoCnJ7ex63XTyI6bcI4bf
         Rr7bSP4WxVNqHamWFp189O8cjtXWfYgQEGO5ouu8/6FtKV1Gc+YL0JERHq2Lm8lrC+Wd
         cHfHdI5dctEZh8wE2TnRp2KnKCOk4j7CA08bPKbZY6EgBw2p1rNo5iQ3PTdrcNr9Sham
         HU+CnCSL5o6uHGoxZKfSAfANylZNajWnLCK4Fr4t6uNAR0OcZeAftenKdtT+UwLpwQbM
         NOlA==
X-Gm-Message-State: AOJu0Yw9MfAp44DRQktVBNSVHSicCN830H2MpgeDACqnINgVXen6MWzc
	b7RsD5Hf7lF/BaRQZ8edKP7knDMTQ8qjx8DIixapaF96HiYJrsyOEeIoE1sm94+Le1a2LA==
X-Gm-Gg: AfdE7cmYqhcvcxgw7mWwRmEhHo7sib0bYdpIt4CcWCo+bKb/ES8b2zd2rVPYBayD0o+
	SH3ZA6r6Mb8EKvQlwcrhDEOLB75wXzXvKym3w5ziqDpPcPISNhnB69k7MUiqGJPUfOIm9FmZOEO
	tngT+CCbbfMM0sWcywcTb7Y2VUmS3CpeaThojaaiw7oYeZnZM+AvUcNuCzCbt0C7SfrMdb0/son
	0L2aYyTSaRNMU6UtDjDFmgf/Rs2P2dqT0KNq/FAGbO42gJeSvAv5efeNQnFhJHMCyJ0Fx8Sgg00
	A7FbMlJ3lIMac5qJEecqIo+amYS9gHRhJ8K/5dRdHSzEHU9SPLfZsaIvcdOBWYkOZbAH93CZIBX
	9fKkHbiGbWQzCvmoIJeTZev2fi4g+GlFSFC3gLW0JcqgdAlqwfZGvh7lNXoNRAlKPBPaaxo/chn
	bLG6po8UhDWd49qOX5BdDob0TFGrfSpNswCV3cKfojyQ==
X-Received: by 2002:a5d:4c4f:0:b0:460:65bc:780f with SMTP id ffacd0b85a97d-46500fc9b94mr6876998f8f.13.1781896318009;
        Fri, 19 Jun 2026 12:11:58 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm1384222f8f.7.2026.06.19.12.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:11:57 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 07/10] ext4: rename ext4_dir_rec_len() and clarify dirdata usage
Date: Fri, 19 Jun 2026 15:10:11 -0400
Message-ID: <20260619191022.27008-8-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
References: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/dir.c    |  9 +++--
 fs/ext4/ext4.h   | 14 +++++---
 fs/ext4/inline.c | 14 ++++----
 fs/ext4/namei.c  | 86 ++++++++++++++++++++++++++++++++----------------
 4 files changed, 78 insertions(+), 45 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 17edd678fa87..012687822b82 100644
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
+	else if (unlikely(rlen < ext4_dir_entry_len(de, fake ? NULL : dir)))
 		error_msg = "rec_len is too small for name_len";
 	else if (unlikely(next_offset > size))
 		error_msg = "directory entry overrun";
-	else if (unlikely(next_offset > size - ext4_dir_rec_len(1,
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
index fd979452391f..682dd141072d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2616,11 +2616,16 @@ struct ext4_dirent_hash {
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
 
 	if (dir && ext4_hash_in_dirent(dir))
 		rec_len += sizeof(struct ext4_dir_entry_hash);
@@ -3028,7 +3033,8 @@ extern void ext4_htree_free_dir_info(struct dir_private_info *p);
 extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size,
 			     struct ext4_filename *fname,
-			     struct ext4_dir_entry_2 **dest_de);
+			     struct ext4_dir_entry_2 **dest_de,
+			     int dlen);
 void ext4_insert_dentry(struct inode *dir, struct inode *inode,
 			struct ext4_dir_entry_2 *de,
 			int buf_size,
@@ -4142,7 +4148,7 @@ static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
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
index a20ba9a6a15b..7bca813c0627 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -519,13 +519,20 @@ ext4_next_entry(struct ext4_dir_entry_2 *p, unsigned long blocksize)
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
  */
-static struct dx_root_info *dx_get_dx_info(void *de_buf)
+static struct dx_root_info *dx_get_dx_info(struct inode *dir, void *de_buf)
 {
+	unsigned int blocksize = dir->i_sb->s_blocksize;
+	void *base = de_buf;
+
 	/* get dotdot first */
-	de_buf = de_buf + ext4_dir_rec_len(1, NULL);
+	de_buf += ext4_dir_entry_len(de_buf, dir);
 
 	/* dx root info is after dotdot entry */
-	de_buf = de_buf + ext4_dir_rec_len(2, NULL);
+	de_buf += ext4_dir_entry_len(de_buf, dir);
+
+	if (de_buf < base || (char *)de_buf - (char *)base +
+			      sizeof(struct dx_root_info) > blocksize)
+		return ERR_PTR(-EFSCORRUPTED);
 
 	return (struct dx_root_info *)de_buf;
 }
@@ -576,7 +583,9 @@ static inline unsigned dx_root_limit(struct inode *dir,
 	struct dx_root_info *info;
 	unsigned int entry_space;
 
-	info = dx_get_dx_info(dot_de);
+	info = dx_get_dx_info(dir, dot_de);
+	if (IS_ERR(info))
+		return 0;
 	entry_space = dir->i_sb->s_blocksize - ((char *)info - (char *)dot_de) -
 		info->info_length;
 
@@ -588,7 +597,7 @@ static inline unsigned dx_root_limit(struct inode *dir,
 static inline unsigned dx_node_limit(struct inode *dir)
 {
 	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(0, dir);
+			ext4_dirent_rec_len(0, dir);
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -792,7 +801,9 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	if (IS_ERR(frame->bh))
 		return (struct dx_frame *) frame->bh;
 
-	info = dx_get_dx_info((struct ext4_dir_entry_2 *)frame->bh->b_data);
+	info = dx_get_dx_info(dir, (struct ext4_dir_entry_2 *)frame->bh->b_data);
+	if (IS_ERR(info))
+		goto fail;
 	if (info->hash_version != DX_HASH_TEA &&
 	    info->hash_version != DX_HASH_HALF_MD4 &&
 	    info->hash_version != DX_HASH_LEGACY &&
@@ -937,7 +948,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	return ret_err;
 }
 
-static void dx_release(struct dx_frame *frames)
+static void dx_release(struct inode *dir, struct dx_frame *frames)
 {
 	struct dx_root_info *info;
 	int i;
@@ -946,7 +957,9 @@ static void dx_release(struct dx_frame *frames)
 	if (frames[0].bh == NULL)
 		return;
 
-	info = dx_get_dx_info((struct ext4_dir_entry_2 *)frames[0].bh->b_data);
+	info = dx_get_dx_info(dir, (struct ext4_dir_entry_2 *)frames[0].bh->b_data);
+	if (IS_ERR(info))
+		return;
 	/* save local copy, "info" may be freed after brelse() */
 	indirect_levels = info->indirect_levels;
 	for (i = 0; i <= indirect_levels; i++) {
@@ -1058,7 +1071,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	/* csum entries are not larger in the casefolded encrypted case */
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
-					   ext4_dir_rec_len(0,
+					   ext4_dirent_rec_len(0,
 							   csum ? NULL : dir));
 	/* Check if the directory is encrypted */
 	if (IS_ENCRYPTED(dir)) {
@@ -1252,12 +1265,12 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		    (count && ((hashval & 1) == 0)))
 			break;
 	}
-	dx_release(frames);
+	dx_release(dir, frames);
 	dxtrace(printk(KERN_DEBUG "Fill tree: returned %d entries, "
 		       "next hash: %x\n", count, *next_hash));
 	return count;
 errout:
-	dx_release(frames);
+	dx_release(dir, frames);
 	return (err);
 }
 
@@ -1755,7 +1768,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 errout:
 	dxtrace(printk(KERN_DEBUG "%s not found\n", fname->usr_fname->name));
 success:
-	dx_release(frames);
+	dx_release(dir, frames);
 	return bh;
 }
 
@@ -1852,7 +1865,7 @@ dx_move_dirents(struct inode *dir, char *from, char *to,
 	while (count--) {
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)
 						(from + (map->offs<<2));
-		rec_len = ext4_dir_rec_len(de->name_len, dir);
+		rec_len = ext4_dir_entry_len(de, dir);
 
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
@@ -1885,7 +1898,7 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(struct inode *dir, char *base,
 	while ((char*)de < base + blocksize) {
 		next = ext4_next_entry(de, blocksize);
 		if (de->inode && de->name_len) {
-			rec_len = ext4_dir_rec_len(de->name_len, dir);
+			rec_len = ext4_dir_entry_len(de, dir);
 			if (de > to)
 				memmove(to, de, rec_len);
 			to->rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
@@ -2037,10 +2050,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
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
@@ -2053,7 +2067,7 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			return -EFSCORRUPTED;
 		if (ext4_match(dir, fname, de))
 			return -EEXIST;
-		nlen = ext4_dir_rec_len(de->name_len, dir);
+		nlen = ext4_dir_entry_len(de, dir);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 		if ((de->inode ? rlen - nlen : rlen) >= reclen)
 			break;
@@ -2076,7 +2090,7 @@ void ext4_insert_dentry(struct inode *dir,
 
 	int nlen, rlen;
 
-	nlen = ext4_dir_rec_len(de->name_len, dir);
+	nlen = ext4_dir_entry_len(de, dir);
 	rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 =
@@ -2114,14 +2128,18 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 {
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	int		csum_size = 0;
-	int		err, err2;
+	int		err, err2, dlen = 0;
+	unsigned char	*data = NULL;
 
+	/* Deliver data in any appropriate way here. Now it is NULL */
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	if (!de) {
+		if (data)
+			dlen = (*data) + 1;
 		err = ext4_find_dest_de(dir, bh, bh->b_data,
-					blocksize - csum_size, fname, &de);
+					blocksize - csum_size, fname, &de, dlen);
 		if (err)
 			return err;
 	}
@@ -2276,7 +2294,12 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 				     blocksize);
 
 	/* initialize hashing info */
-	dx_info = dx_get_dx_info(dot_de);
+	dx_info = dx_get_dx_info(dir, dot_de);
+	if (IS_ERR(dx_info)) {
+		brelse(bh2);
+		brelse(bh);
+		return PTR_ERR(dx_info);
+	}
 	memset(dx_info, 0, sizeof(*dx_info));
 	dx_info->info_length = sizeof(*dx_info);
 	if (ext4_hash_in_dirent(dir))
@@ -2334,7 +2357,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	 */
 	if (retval)
 		ext4_mark_inode_dirty(handle, dir);
-	dx_release(frames);
+	dx_release(dir, frames);
 	brelse(bh2);
 	return retval;
 }
@@ -2609,8 +2632,13 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			/* Set up root */
 			dx_set_count(entries, 1);
 			dx_set_block(entries + 0, newblock);
-			info = dx_get_dx_info((struct ext4_dir_entry_2 *)
+			info = dx_get_dx_info(dir, (struct ext4_dir_entry_2 *)
 					      frames[0].bh->b_data);
+			if (IS_ERR(info)) {
+				err = PTR_ERR(info);
+				brelse(bh2);
+				goto journal_error;
+			}
 			info->indirect_levels += 1;
 			dxtrace(printk(KERN_DEBUG
 				       "Creating %d level index...\n",
@@ -2638,7 +2666,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 	ext4_std_error(dir->i_sb, err); /* this is a no-op if err == 0 */
 cleanup:
 	brelse(bh);
-	dx_release(frames);
+	dx_release(dir, frames);
 	/* @restart is true means htree-path has been changed, we need to
 	 * repeat dx_probe() to find out valid htree-path
 	 */
@@ -2930,7 +2958,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(ext4_dir_rec_len(de->name_len, NULL),
+	de->rec_len = ext4_rec_len_to_disk(ext4_dirent_rec_len(de->name_len, NULL),
 					   blocksize);
 	memcpy(de->name, ".", 2);
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
@@ -2942,7 +2970,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 	if (inline_buf) {
 		de->rec_len = ext4_rec_len_to_disk(
-					ext4_dir_rec_len(de->name_len, NULL),
+					ext4_dirent_rec_len(de->name_len, NULL),
 					blocksize);
 		de = ext4_next_entry(de, blocksize);
 		header_size = (char *)de - bh->b_data;
@@ -2951,7 +2979,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			blocksize - csum_size);
 	} else {
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + ext4_dir_rec_len(1, NULL)),
+					(csum_size + ext4_dirent_rec_len(1, NULL)),
 					blocksize);
 	}
 
@@ -3074,8 +3102,8 @@ bool ext4_empty_dir(struct inode *inode)
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

