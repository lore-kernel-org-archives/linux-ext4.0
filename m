Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283CB3B42E9
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033629; cv=none; b=WF4mcMFkGFXA68tv0bL2xmnU/4RibTdP6u5rq2XUznAcVM6iEOQXALWlu0OQneLLceVg/f9JpoeQSr+J+oLsehYq45gBZWkjy8kjPVEj57sUdkknYdHiSOkAsoFCkLpfUycU+/suAOYxBbSwhkryx0TKL2tEdwNeCyKzrhTmGcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033629; c=relaxed/simple;
	bh=Tzyv5YGv0GSRIRIHarAn0NV6GGOsTUY8FdlJIt17UTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3UmpBT39ZWwM1xHwxP8n2bGQ+G4dgAZT0bhWjkj9sOuzeWqf8aiAzuxzUVvx3MwfFa6ijZXwIQqxJYGb1UtlKDp3Vghoa2OXLxLumf5fwq39XFtJAjiwx2SI5jbAD8hmA1EUv3PJxAf/0urz28jZOYaDgxi/0cuTsFjmmwDTes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TsCsY+sl; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TsCsY+sl"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4758b2a9e2aso2664955f8f.2
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 05:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784033625; x=1784638425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6K2WANviuDjtSKp24ZBE/QSUDx5uMM3lMBlZZq/bCUY=;
        b=TsCsY+slPk9NccMsp0YuO3JThxQW/KS141by+gL+9h+oMlu1wXBsUigmLlbZ4ZTm2s
         O4zz+U2L0va87mIazlfkvN65Mrgb7EX0lEwL9HK5tjgiByAa5vAlk42kP+AtIXBoituR
         +YMk6u3/rrOCbhZUn6jauBtlB2lAmAdVG0Gs9tUfy8UMztgEftGi2fUuN+bGgICw5Q8g
         cLXfZ+mKDWNB5wnsNEB+p2xpZla2CBpS0vP4zdtAh74oi4jvn4asuz78AHB9w6IAwIFm
         ACAlPWhD25NbYuq1w/ddhTSo2OW+YBVcxKrMTPVxon5hgJg9aWkbnHbLM41+SvSlBXUh
         4tmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784033625; x=1784638425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6K2WANviuDjtSKp24ZBE/QSUDx5uMM3lMBlZZq/bCUY=;
        b=FPkXA4yVhixQEqThwrzUsJLgacNKe3BuNVdXD8cOlTJEFIv2t9LE1glGtHEA/0GVys
         3Pp01EVvkxGzPWRwvRMMDojk6Bl6Qa+7nb2ZOHF5o++ca+2RZFkFDaZSBkkcyk3KK9vb
         dCwA5BQAGGrXWzFQk2qdfhCNSwIKWNCCW1xDNHgBi2grbPSpWpsFR/8CXV2O0HYPqPL+
         hrG/0iVNJcWv8tRQbV1vLvtkx1SGIIjlSXy/NbCY2kaFXjgFLZLcTmx/RteC3cLuCXSd
         h5MBV9dzTJxSZVIhhWyE8K4Pmzc83cZEbIVE+v+waXdw3eKoGUTZPgZNM7LCrED48eh6
         aosA==
X-Gm-Message-State: AOJu0YxHTazHn++tdFnQBL9rtrGqo03h4APo64ZaaSEJCZJ3ks2hHXuh
	L4Jddfs0Ye21X0UiGsRNh0DILnvMuladKm5pesf6yHByL/1PsuxzcjY43ewCtULLv0A=
X-Gm-Gg: AfdE7cl0kbG4cN1AJ0uiBbNksX68Wjy4gGqSmoEmXXUHvNhF8dHSpnLpZW8czPwDI6U
	WjvXfPZgKrmku20Wcuum1jAlhKhSjoGi2qjQ7PhR0MpE8kFKcHOujQBN2r1lQY8A4FmI+lvvRjF
	/cvpR7IXGxdaNB37YFI0hdUyACTI4BHFtTifTLtPh2odG+yFEscE9h09bMpPm4m9MdHNfVklXH3
	rlIoTIzUnvP8KWjAXnIuvXaBhPNHoDISScherBV1Ba2fJwDlezC1YuvidkN7yZ/4ZNbK9h4kHYr
	zWx9NG6K+1L1BXWA4ty4uBYHfj/xXNcj3U8huZ2Aygse3+Zk8XDghBkqXvQRXHXkF2EuKItDL6c
	o6iz2Y6Ea/4roqPWS6znRMJQq4SOy1qmEVz2ZKjpdCv0yIlyVrahwTAB/fdKnkoxBIvuQ+lYR0l
	0+Y0j9JWqLCcsQ9X/lRhoswmHoJjcJcp4aMQLzy61QCZgAqA==
X-Received: by 2002:a05:600c:54c8:b0:493:bc4a:fb50 with SMTP id 5b1f17b1804b1-495389e3322mr18745285e9.38.1784033625188;
        Tue, 14 Jul 2026 05:53:45 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:1827:2101:7130:c718:1edf:8590])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2ed840sm70052405e9.10.2026.07.14.05.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:53:44 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v5 08/11] ext4: dirdata feature
Date: Tue, 14 Jul 2026 08:51:06 -0400
Message-ID: <20260714125111.14699-9-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
References: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/dir.c         |  22 +++++++--
 fs/ext4/ext4.h        |  44 +++++++++++++++---
 fs/ext4/fast_commit.c |   1 +
 fs/ext4/fast_commit.h |   1 +
 fs/ext4/inline.c      |  31 ++++++++++---
 fs/ext4/namei.c       | 102 ++++++++++++++++++++++++++++++------------
 fs/ext4/sysfs.c       |   2 +
 7 files changed, 159 insertions(+), 44 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 3294947f8555..50c48c50a29d 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -467,27 +467,43 @@ void ext4_htree_free_dir_info(struct dir_private_info *p)
  * The decrypted filename is passed in via ent_name.  parameter.
  */
 int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
-			     __u32 minor_hash,
+			     __u32 minor_hash, int buf_size,
 			    struct ext4_dir_entry_2 *dirent,
 			    struct fscrypt_str *ent_name)
 {
 	struct rb_node **p, *parent = NULL;
 	struct fname *fname, *new_fn;
 	struct dir_private_info *info;
+	int extra_data = 0;
 
 	info = dir_file->private_data;
 	p = &info->root.rb_node;
 
 	/* Create and allocate the fname structure */
-	new_fn = kzalloc_flex(*new_fn, name, ent_name->len + 1);
+	if (dirent->file_type & ~EXT4_FT_MASK) {
+		unsigned int rec_len =
+			ext4_rec_len_from_disk(dirent->rec_len, buf_size);
+		extra_data = ext4_dirent_get_data_len(dirent, rec_len);
+	}
+
+	/* exta_data contains +1 byte for NULL */
+	new_fn = kzalloc_flex(*new_fn, name, ent_name->len +
+			      (extra_data ? extra_data : 1));
 	if (!new_fn)
 		return -ENOMEM;
 	new_fn->hash = hash;
 	new_fn->minor_hash = minor_hash;
 	new_fn->inode = le32_to_cpu(dirent->inode);
-	new_fn->name_len = ent_name->len;
 	new_fn->file_type = dirent->file_type;
+	new_fn->name_len = ent_name->len;
 	memcpy(new_fn->name, ent_name->name, ent_name->len);
+	if (extra_data)
+		/* Dirdata bytes lie past the __counted_by(name_len) bound but
+		 * within the kzalloc_flex allocation; use unsafe_memcpy to
+		 * avoid a FORTIFY_SOURCE false positive. */
+		unsafe_memcpy(new_fn->name + ent_name->len,
+			      dirent->name + dirent->name_len, extra_data,
+			      /* within kzalloc_flex allocation */);
 
 	while (*p) {
 		parent = *p;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 02501363ea12..cc881a940c0a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1227,6 +1227,7 @@ struct ext4_inode_info {
 #ifdef CONFIG_FS_ENCRYPTION
 	struct fscrypt_inode_info *i_crypt_info;
 #endif
+	void *i_dirdata;
 };
 
 /*
@@ -2334,6 +2335,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(casefold,		CASEFOLD)
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
 					 EXT4_FEATURE_INCOMPAT_EA_INODE| \
 					 EXT4_FEATURE_INCOMPAT_MMP | \
+					 EXT4_FEATURE_INCOMPAT_DIRDATA | \
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
 					 EXT4_FEATURE_INCOMPAT_CASEFOLD | \
@@ -2598,6 +2600,18 @@ struct ext4_dirent_hash {
 	struct ext4_dir_entry_hash	dh_hash;
 } __packed;
 
+static inline
+struct ext4_dirent_fid *ext4_dentry_get_fid(struct super_block *sb,
+					    struct ext4_dentry_param *p)
+{
+	if (!ext4_has_feature_dirdata(sb))
+		return NULL;
+	if (p && p->edp_magic == EXT4_LUFID_MAGIC)
+		return &p->edp_dfid;
+
+	return NULL;
+}
+
 #define EXT4_FT_DIR_CSUM	0xDE
 
 /*
@@ -2721,6 +2735,8 @@ struct ext4_filename {
 #if IS_ENABLED(CONFIG_UNICODE)
 	struct qstr cf_name;
 #endif
+	/* LUFID/dirdata payload to embed in the new directory entry, or NULL */
+	struct ext4_dirent_fid *dfid;
 };
 
 #define fname_name(p) ((p)->disk_name.name)
@@ -3032,7 +3048,7 @@ extern int __ext4_check_dir_entry(const char *, unsigned int, struct inode *,
 	unlikely(__ext4_check_dir_entry(__func__, __LINE__, (dir), (filp), \
 				(de), (bh), (buf), (size), (offset)))
 extern int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
-				__u32 minor_hash,
+				__u32 minor_hash, int buf_size,
 				struct ext4_dir_entry_2 *dirent,
 				struct fscrypt_str *ent_name);
 extern void ext4_htree_free_dir_info(struct dir_private_info *p);
@@ -3041,10 +3057,18 @@ extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
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
@@ -3288,8 +3312,14 @@ extern int ext4_ext_migrate(struct inode *);
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
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 8e2259799614..006d45e9ce87 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2697,6 +2697,7 @@ static const char * const fc_ineligible_reasons[] = {
 	[EXT4_FC_REASON_MIGRATE] = "Inode format migration",
 	[EXT4_FC_REASON_VERITY] = "fs-verity enable",
 	[EXT4_FC_REASON_MOVE_EXT] = "Move extents",
+	[EXT4_FC_REASON_DIRDATA] = "Dirdata LUFID (not recorded by fast-commit)",
 };
 
 int ext4_fc_info_show(struct seq_file *seq, void *v)
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index 2f77a37fb101..899faeb4e6e0 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -100,6 +100,7 @@ enum {
 	EXT4_FC_REASON_MIGRATE,
 	EXT4_FC_REASON_VERITY,
 	EXT4_FC_REASON_MOVE_EXT,
+	EXT4_FC_REASON_DIRDATA,
 	EXT4_FC_REASON_MAX
 };
 
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 5b3faacdf143..8221459cc656 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -973,11 +973,20 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 				     struct ext4_iloc *iloc,
 				     void *inline_start, int inline_size)
 {
-	int		err;
+	int		err, dlen = 0;
 	struct ext4_dir_entry_2 *de;
+	struct ext4_dirent_fid *dfid = NULL;
+
+	/* fname->dfid was set in ext4_add_entry() */
+	dfid = fname->dfid;
+	if (dfid)
+		dlen = dfid->df_header.ddh_length;
+	if (ext4_hash_in_dirent(dir) &&
+	    ext4_has_feature_dirdata(dir->i_sb))
+		dlen += sizeof(struct ext4_dirent_hash);
 
 	err = ext4_find_dest_de(dir, iloc->bh, inline_start,
-				inline_size, fname, &de, 0);
+				inline_size, fname, &de, dlen);
 	if (err)
 		return err;
 
@@ -986,7 +995,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 					    EXT4_JTR_NONE);
 	if (err)
 		return err;
-	ext4_insert_dentry(dir, inode, de, inline_size, fname);
+	ext4_insert_dentry_data(dir, inode, de, inline_size, fname, dfid);
 
 	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
 
@@ -1264,6 +1273,7 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 	int err = 0, count = 0;
 	unsigned int parent_ino;
 	int pos;
+	unsigned int de_len;
 	struct ext4_dir_entry_2 *de;
 	struct inode *inode = file_inode(dir_file);
 	int ret, inline_size = 0;
@@ -1325,14 +1335,24 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			de = &fake;
 			pos = EXT4_INLINE_DOTDOT_SIZE;
 		} else {
+			if (pos + EXT4_BASE_DIR_LEN > inline_size) {
+				ret = count;
+				goto out;
+			}
 			de = (struct ext4_dir_entry_2 *)(dir_buf + pos);
-			pos += ext4_rec_len_from_disk(de->rec_len, inline_size);
+			de_len = ext4_rec_len_from_disk(de->rec_len, inline_size);
+			if (de_len < EXT4_BASE_DIR_LEN ||
+			    pos + de_len > (unsigned int)inline_size) {
+				ret = count;
+				goto out;
+			}
 			if (ext4_check_dir_entry(inode, dir_file, de,
 					 iloc.bh, dir_buf,
 					 inline_size, pos)) {
 				ret = count;
 				goto out;
 			}
+			pos += de_len;
 		}
 
 		if (ext4_hash_in_dirent(dir)) {
@@ -1354,7 +1374,8 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 		tmp_str.name = de->name;
 		tmp_str.len = de->name_len;
 		err = ext4_htree_store_dirent(dir_file, hinfo->hash,
-					      hinfo->minor_hash, de, &tmp_str);
+					      hinfo->minor_hash, inline_size,
+					      de, &tmp_str);
 		if (err) {
 			ret = err;
 			goto out;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 13d37b108a54..4a6f7ffa656f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -401,23 +401,31 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
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
+		if (rlen < EXT4_BASE_DIR_LEN ||
+		    rlen + EXT4_BASE_DIR_LEN > blocksize)
+			return NULL;
+		de = (struct ext4_dir_entry_2 *)(((char *)dirent) + rlen);
+		if (le16_to_cpu(de->rec_len) != (blocksize - rlen))
+			return NULL;
+		/* de->rec_len covers whole dx_root block, calculate actual length.
+		 * This is the '..' entry, which never carries the casefold+fscrypt
+		 * hash, so pass NULL for dir regardless of the directory's flags */
+		dotdot_rec_len = ext4_dir_entry_len(de, blocksize, NULL);
+		if (rlen + dotdot_rec_len + sizeof(struct dx_root_info) > blocksize)
 			return NULL;
-		root = (struct dx_root_info *)(((void *)de + 12));
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
@@ -724,7 +732,9 @@ static struct stats dx_show_leaf(struct inode *dir,
 				       (unsigned) ((char *) de - base));
 #endif
 			}
-			space += ext4_dir_rec_len(de->name_len, dir);
+			if ((char *)de + EXT4_BASE_DIR_LEN > base + size)
+				break;
+			space += ext4_dir_entry_len(de, size, dir);
 			names++;
 		}
 		de = ext4_next_entry(de, size);
@@ -1144,8 +1154,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 			tmp_str.name = de->name;
 			tmp_str.len = de->name_len;
 			err = ext4_htree_store_dirent(dir_file,
-				   hinfo->hash, hinfo->minor_hash, de,
-				   &tmp_str);
+				   hinfo->hash, hinfo->minor_hash,
+				   dir->i_sb->s_blocksize, de, &tmp_str);
 		} else {
 			int save_len = fname_crypto_str.len;
 			struct fscrypt_str de_name = FSTR_INIT(de->name,
@@ -1160,8 +1170,9 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 				goto errout;
 			}
 			err = ext4_htree_store_dirent(dir_file,
-				   hinfo->hash, hinfo->minor_hash, de,
-					&fname_crypto_str);
+						hinfo->hash, hinfo->minor_hash,
+						dir->i_sb->s_blocksize, de,
+						&fname_crypto_str);
 			fname_crypto_str.len = save_len;
 		}
 		if (err != 0) {
@@ -1239,6 +1250,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		tmp_str.name = de->name;
 		tmp_str.len = de->name_len;
 		err = ext4_htree_store_dirent(dir_file, 0, 0,
+					      dir->i_sb->s_blocksize,
 					      de, &tmp_str);
 		if (err != 0)
 			goto errout;
@@ -1250,6 +1262,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		tmp_str.name = de->name;
 		tmp_str.len = de->name_len;
 		err = ext4_htree_store_dirent(dir_file, 2, 0,
+					      dir->i_sb->s_blocksize,
 					      de, &tmp_str);
 		if (err != 0)
 			goto errout;
@@ -2076,7 +2089,11 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 		      int dlen)
 {
 	struct ext4_dir_entry_2 *de;
-	unsigned short reclen = ext4_dirent_rec_len(fname_len(fname) + dlen, dir);
+	/* When dirdata extensions are present, a NUL gap byte sits between
+	 * the filename and the first extension; account for it so the found
+	 * slot is always large enough for ext4_dirdata_set() to write into. */
+	unsigned short reclen = ext4_dirent_rec_len(fname_len(fname) + dlen +
+						    (dlen ? 1 : 0), dir);
 	int nlen, rlen;
 	unsigned int offset = 0;
 	char *top;
@@ -2103,13 +2120,10 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
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
@@ -2150,14 +2164,28 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 {
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	int		csum_size = 0;
-	int		err, err2;
+	int		err, err2, dlen = 0;
+	struct ext4_dirent_fid *dfid;
 
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	/* dfid is resolved once by ext4_add_entry() and stored in fname so
+	 * that all add_dirent_to_buf() calls within the same add operation
+	 * use a consistent value without touching the shared i_dirdata field. */
+	dfid = fname->dfid;
 	if (!de) {
+		if (dfid)
+			dlen = dfid->df_header.ddh_length;
+		/* ext4_dirent_rec_len() does not add CFHASH size when dirdata is
+		 * enabled (it assumes the caller included it in name_len).  Add
+		 * it here so ext4_find_dest_de() allocates a slot large enough
+		 * for ext4_dirdata_set() to write the hash extension. */
+		if (ext4_hash_in_dirent(dir) &&
+		    ext4_has_feature_dirdata(dir->i_sb))
+			dlen += sizeof(struct ext4_dirent_hash);
 		err = ext4_find_dest_de(dir, bh, bh->b_data,
-					blocksize - csum_size, fname, &de);
+					blocksize - csum_size, fname, &de, dlen);
 		if (err)
 			return err;
 	}
@@ -2170,7 +2198,7 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	}
 
 	/* By now the buffer is marked for journaling */
-	ext4_insert_dentry(dir, inode, de, blocksize, fname);
+	ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
 
 	/*
 	 * XXX shouldn't update any times until successful
@@ -2397,7 +2425,8 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
  */
 static int __ext4_add_entry(handle_t *handle, struct inode *dir,
 			  const struct qstr *d_name,
-			  struct inode *inode)
+			  struct inode *inode,
+			  struct ext4_dentry_param *edp)
 {
 	struct buffer_head *bh = NULL;
 	struct ext4_dir_entry_2 *de;
@@ -2422,6 +2451,13 @@ static int __ext4_add_entry(handle_t *handle, struct inode *dir,
 	if (retval)
 		return retval;
 
+	/* Resolve the LUFID payload once here and store it in fname so every
+	 * add_dirent_to_buf() call in this add operation uses the same value
+	 * without touching the shared EXT4_I(inode)->i_dirdata field. */
+	fname.dfid = ext4_dentry_get_fid(sb, edp);
+	if (fname.dfid)
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_DIRDATA, handle);
+
 	if (ext4_has_inline_data(dir)) {
 		retval = ext4_try_add_inline_entry(handle, &fname, dir, inode);
 		if (retval < 0)
@@ -2506,7 +2542,8 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 
 	if (fscrypt_is_nokey_name(dentry))
 		return -ENOKEY;
-	return __ext4_add_entry(handle, dir, &dentry->d_name, inode);
+	return __ext4_add_entry(handle, dir, &dentry->d_name, inode,
+				dentry->d_fsdata);
 }
 
 /*
@@ -3014,8 +3051,9 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
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
@@ -3515,10 +3553,16 @@ int __ext4_link(struct inode *dir, struct inode *inode,
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
+	/* Fast-commit does not record dirdata in its journal format; force a
+	 * full journal commit so the LUFID survives crash+replay. */
+	if (ext4_dentry_get_fid(dir->i_sb, dentry ? dentry->d_fsdata : NULL))
+		ext4_fc_mark_ineligible(dir->i_sb, EXT4_FC_REASON_DIRDATA, handle);
+
 	inode_set_ctime_current(inode);
 	ext4_inc_count(inode);
 
-	err = __ext4_add_entry(handle, dir, d_name, inode);
+	err = __ext4_add_entry(handle, dir, d_name, inode,
+			       dentry ? dentry->d_fsdata : NULL);
 	if (!err) {
 		err = ext4_mark_inode_dirty(handle, inode);
 		/* this can happen only for tmpfile being
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

