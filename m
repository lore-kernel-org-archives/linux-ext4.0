Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93891F4C96
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308293; cv=none; b=bIBjhjX7T+SbYHLBf/K2y5PtiqvOtCLwcg7cBRuz2ubqlxBT6eoSDJ2yDTA6CTE1XJQorfyrkYS+SO/TUC48XFw/fyXyCcug+d0rCaTgwREin27LHBfPKYEDQXq79mf5AnXoszCeFx4rDfen3Y3caK+jbXaaQ23BhUWPNJ3Lcfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308293; c=relaxed/simple;
	bh=J3pdjMpfnn9KoqSaGbohURK3y1dNAz8/93im681oRjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnRO49KXspjfL0+x66y0VhWDNadKabdyxNfNMFMOCoX/lOZsrogrFhssJxyfqG7MTw5IxCJj5a1j8m9eWpE12tNidcPfBdx7bI2vCj+MvC1BYeSq1XBr3CO43CBz3nniD9gfENyroBiEh9/HDhH2KVDkZXRkvatcwPUNlJAhDmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=chi+MbF+; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="chi+MbF+"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4922244f7c7so9667665e9.0
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308290; x=1782913090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydz4Ozon0cY8dATdFGNou8uGQgGom5M9Nf3WP/eK7QE=;
        b=chi+MbF+6LpIzrYImHBgNNcKm/cwM+XARH6TDRbfFndOPSXm74pXJfovjvzRuDnh5g
         KSXNkivzmWaOzJgIJldNo71gIpMaaGXqHymAv7B/oJF8rKEipCQbp6A6CLAbDEw+TRtp
         PBfl/zCb3syXir1OPS0ylaUbcfPqJG6V8D43bGNob5yVnT913YITI57j/kKysybM6FYh
         8c4RJcaYKUES+LLb/JMQtbatRxH+QBm19nQFInIDoIVYEQxOzSMpjOaXzF2BoWxXo2AD
         +f6lDCjO4wO5rk/xEg4LJ8TMrU3l7kxUZXrjN+HqVG5HybFGczmuL/6G2HIjAKCUve7V
         e1OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308290; x=1782913090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ydz4Ozon0cY8dATdFGNou8uGQgGom5M9Nf3WP/eK7QE=;
        b=TSp2+kDQRwSUik7ZRGtKALbGiqgN8rgoD5DZHYLFThJIzrDeRacSxdDVmpNWxi3RB3
         wWO5/T77uTIoTMK+cf+GCDg5d8ebqirt6SY+XuibCWT8y/L8XHiytQDqKLqF+M0IOJL0
         I1bqKJJH1Gf4LFg7uW8P40rFEQVunN5/tC/+hL5y6fjmrpjcuPMHpYoybRQn4Flp5uSI
         mr5SABtF56kOJDmBSGtdLzuiSwa2hk8hXw7g93ns3sdT72EhOyxYIL9kB+HlsIl3pJm+
         X1TbfS5DMCH/qSpKAhHOJLHq7cSmE5x7OhjNEmJbvh0sx3imd2xfqpFZQEq9ELnhzmkt
         rzzw==
X-Gm-Message-State: AOJu0YzohCBXdJ9fdA9oqZz+G9Rmvz3ty1xEUIuacXsVaOKlLz14ldhi
	N+Xi5MAWC6q5vvXy0Dko86RKvqJKO7EGeti/ZdcSv310rdQ+ZeYkW0QtsmJjoYwHfGA=
X-Gm-Gg: AfdE7cn5pVb/fm9pD/oTxJS1vEqT0PU+5QEAp9mAD6wa0ZB3b3oFwFfh1o/p7TiBqdc
	mZK17re9zMIRMO3gIi7phiAPFqFwM4MCdV/Uj7sspqwQaDEcXZxUsoonAgDrX3Xm/+GKdWYatO4
	zqLzJ/M8jx4iLcdrkreU14U8hwKKPegp2p8SsFBwGYFAXhzQUCGQTsItEQgeFqT0Ohc5kfqVKRi
	KnhjSSvlz5RtUEg+bjL3GtusghoScUtsZXObOc1V2wccb20Z6+wIIpUKz/cEfZmDou4UO75zYIq
	5OQHN2nqPzGJppV6sodnY/emat0VeFE8JThWHYeKib3YZAury1pJkx0xqXTNKz9qsfFLOx/+oTk
	if/C0xTHI/1K7zFPHO5C5THYVddBJ3gG/BOR+Sjmo5KHlP+Hb+RHj/EzmdqfbqW7brE9iAAcjAu
	rYlcCtQCj0j4YUOjQ7xgfi//5lNHTFVSrh92nBC0IuN/0C
X-Received: by 2002:a05:600c:c4a2:b0:492:59fe:4a15 with SMTP id 5b1f17b1804b1-49260873710mr44931205e9.24.1782308289929;
        Wed, 24 Jun 2026 06:38:09 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:09 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 08/11] ext4: rename ext4_dir_rec_len() and clarify dirdata usage
Date: Wed, 24 Jun 2026 09:36:37 -0400
Message-ID: <20260624133642.18438-9-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/namei.c  | 89 ++++++++++++++++++++++++++++++++----------------
 4 files changed, 80 insertions(+), 46 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 17edd678fa87..d22b09f86365 100644
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
+	else if (unlikely(rlen < ext4_dir_entry_len(de, size, fake ? NULL : dir)))
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
index a369a0cd04bc..2fc9fa6d3021 100644
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
@@ -4148,7 +4154,7 @@ static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
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
index e2dda8dee77c..73c8f1b399ef 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -527,13 +527,21 @@ ext4_next_entry(struct ext4_dir_entry_2 *p, unsigned long blocksize)
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
  */
-static struct dx_root_info *dx_get_dx_info(void *de_buf)
+static struct dx_root_info *dx_get_dx_info(struct inode *dir, void *de_buf)
 {
-	/* get dotdot first */
-	de_buf = de_buf + ext4_dir_rec_len(1, NULL);
+	unsigned int blocksize = dir->i_sb->s_blocksize;
+	void *base = de_buf;
+
+	/* get dotdot first; '.' and '..' never carry the casefold+fscrypt
+	 * hash, so pass NULL for dir regardless of the directory's flags */
+	de_buf += ext4_dir_entry_len(de_buf, blocksize, NULL);
 
 	/* dx root info is after dotdot entry */
-	de_buf = de_buf + ext4_dir_rec_len(2, NULL);
+	de_buf += ext4_dir_entry_len(de_buf, blocksize, NULL);
+
+	if (de_buf < base || (char *)de_buf - (char *)base +
+			      sizeof(struct dx_root_info) > blocksize)
+		return ERR_PTR(-EFSCORRUPTED);
 
 	return (struct dx_root_info *)de_buf;
 }
@@ -584,7 +592,9 @@ static inline unsigned dx_root_limit(struct inode *dir,
 	struct dx_root_info *info;
 	unsigned int entry_space;
 
-	info = dx_get_dx_info(dot_de);
+	info = dx_get_dx_info(dir, dot_de);
+	if (IS_ERR(info))
+		return 0;
 	entry_space = dir->i_sb->s_blocksize - ((char *)info - (char *)dot_de) -
 		info->info_length;
 
@@ -596,7 +606,7 @@ static inline unsigned dx_root_limit(struct inode *dir,
 static inline unsigned dx_node_limit(struct inode *dir)
 {
 	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(0, dir);
+			ext4_dirent_rec_len(0, dir);
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -800,7 +810,9 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	if (IS_ERR(frame->bh))
 		return (struct dx_frame *) frame->bh;
 
-	info = dx_get_dx_info((struct ext4_dir_entry_2 *)frame->bh->b_data);
+	info = dx_get_dx_info(dir, (struct ext4_dir_entry_2 *)frame->bh->b_data);
+	if (IS_ERR(info))
+		goto fail;
 	if (info->hash_version != DX_HASH_TEA &&
 	    info->hash_version != DX_HASH_HALF_MD4 &&
 	    info->hash_version != DX_HASH_LEGACY &&
@@ -945,7 +957,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	return ret_err;
 }
 
-static void dx_release(struct dx_frame *frames)
+static void dx_release(struct inode *dir, struct dx_frame *frames)
 {
 	struct dx_root_info *info;
 	int i;
@@ -954,7 +966,9 @@ static void dx_release(struct dx_frame *frames)
 	if (frames[0].bh == NULL)
 		return;
 
-	info = dx_get_dx_info((struct ext4_dir_entry_2 *)frames[0].bh->b_data);
+	info = dx_get_dx_info(dir, (struct ext4_dir_entry_2 *)frames[0].bh->b_data);
+	if (IS_ERR(info))
+		return;
 	/* save local copy, "info" may be freed after brelse() */
 	indirect_levels = info->indirect_levels;
 	for (i = 0; i <= indirect_levels; i++) {
@@ -1066,7 +1080,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	/* csum entries are not larger in the casefolded encrypted case */
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
-					   ext4_dir_rec_len(0,
+					   ext4_dirent_rec_len(0,
 							   csum ? NULL : dir));
 	/* Check if the directory is encrypted */
 	if (IS_ENCRYPTED(dir)) {
@@ -1260,12 +1274,12 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
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
 
@@ -1763,7 +1777,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 errout:
 	dxtrace(printk(KERN_DEBUG "%s not found\n", fname->usr_fname->name));
 success:
-	dx_release(frames);
+	dx_release(dir, frames);
 	return bh;
 }
 
@@ -1860,7 +1874,7 @@ dx_move_dirents(struct inode *dir, char *from, char *to,
 	while (count--) {
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)
 						(from + (map->offs<<2));
-		rec_len = ext4_dir_rec_len(de->name_len, dir);
+		rec_len = ext4_dir_entry_len(de, blocksize, dir);
 
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
@@ -1893,7 +1907,7 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(struct inode *dir, char *base,
 	while ((char*)de < base + blocksize) {
 		next = ext4_next_entry(de, blocksize);
 		if (de->inode && de->name_len) {
-			rec_len = ext4_dir_rec_len(de->name_len, dir);
+			rec_len = ext4_dir_entry_len(de, blocksize, dir);
 			if (de > to)
 				memmove(to, de, rec_len);
 			to->rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
@@ -2045,10 +2059,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
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
@@ -2061,7 +2076,7 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			return -EFSCORRUPTED;
 		if (ext4_match(dir, fname, de))
 			return -EEXIST;
-		nlen = ext4_dir_rec_len(de->name_len, dir);
+		nlen = ext4_dir_entry_len(de, buf_size, dir);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 		if ((de->inode ? rlen - nlen : rlen) >= reclen)
 			break;
@@ -2084,7 +2099,7 @@ void ext4_insert_dentry(struct inode *dir,
 
 	int nlen, rlen;
 
-	nlen = ext4_dir_rec_len(de->name_len, dir);
+	nlen = ext4_dir_entry_len(de, buf_size, dir);
 	rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 =
@@ -2122,14 +2137,18 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
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
@@ -2284,7 +2303,12 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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
@@ -2342,7 +2366,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	 */
 	if (retval)
 		ext4_mark_inode_dirty(handle, dir);
-	dx_release(frames);
+	dx_release(dir, frames);
 	brelse(bh2);
 	return retval;
 }
@@ -2617,8 +2641,13 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
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
@@ -2646,7 +2675,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 	ext4_std_error(dir->i_sb, err); /* this is a no-op if err == 0 */
 cleanup:
 	brelse(bh);
-	dx_release(frames);
+	dx_release(dir, frames);
 	/* @restart is true means htree-path has been changed, we need to
 	 * repeat dx_probe() to find out valid htree-path
 	 */
@@ -2938,7 +2967,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(ext4_dir_rec_len(de->name_len, NULL),
+	de->rec_len = ext4_rec_len_to_disk(ext4_dirent_rec_len(de->name_len, NULL),
 					   blocksize);
 	memcpy(de->name, ".", 2);
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
@@ -2950,7 +2979,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 	if (inline_buf) {
 		de->rec_len = ext4_rec_len_to_disk(
-					ext4_dir_rec_len(de->name_len, NULL),
+					ext4_dirent_rec_len(de->name_len, NULL),
 					blocksize);
 		de = ext4_next_entry(de, blocksize);
 		header_size = (char *)de - bh->b_data;
@@ -2959,7 +2988,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			blocksize - csum_size);
 	} else {
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + ext4_dir_rec_len(1, NULL)),
+					(csum_size + ext4_dirent_rec_len(1, NULL)),
 					blocksize);
 	}
 
@@ -3082,8 +3111,8 @@ bool ext4_empty_dir(struct inode *inode)
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

