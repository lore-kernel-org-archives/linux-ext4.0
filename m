Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5593B27C6
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 23:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282260; cv=none; b=Trc7L7LE2T/SwFpTcwcE0RrLdssTPCu5jYyXVvr6UzNKcVBBwXSHqhMUiygsVfB3URysD0wTxleAAyGR0F5dgq4bNgbK0nFtMVpRWdb+AUawbgfwEBn4LT7eSswuG00MUC+Y3vLG9Wq9fabkrKSuCyV6ku/hMo4/y7Xnuu/nAQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282260; c=relaxed/simple;
	bh=nWku3+gg472Z1ziutGEIWRopgqPvC5JMAwwCyxPDoOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNz0ikjxvNGyTPFMY729d6wWwI+ReshrzX8brSlMirkWlisbzNEa6Di0IAuStusLkNAOy3Sc/SJDQ/dC0xAye7B1F1MKG22BF2jMiF6fFEHZN2tydyMAcSQrKxKOinn3x6chbDb1qEfr7lK93JM3EQv63/bkeE7yWK4vzT8/pnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SE8YjLgB; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SE8YjLgB"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-495635a85d2so2717125e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 16:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785282256; x=1785887056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dfDcbfF/R0+jX90HAer+k3zALsvOotfY+1O1lpynXNQ=;
        b=SE8YjLgBTCtMevmpHMvXFwlFO0qzLhEYs/fSPSI7ikZ/Zu8fp30DXCVWSDybpNQ8ZW
         C0WjFBT0ClMAbrfgDyW+DvUnXv3h0bGlPhe98PyfimhsDxLbAIhf5KTX1qq+Ru8aWbj8
         sO3Kg9wGSRwBQsvCjJjV4Fwn+xGsmjw02uxt50PTxxwhb1tH9jbUYty/CBF0Al7Pj03j
         EpzQ+1iG3yq/numpfJ0x8aYCjVq4lAdlkuE4uzQh113jDa6uJwE9+ZUqY0QRqLhj+32Z
         MaFb5Ao08k+SyEreJghjlH6zNnf1z0BuJ+C/eClyt8kp2xnCTmnoPGpJjlguxt38e8Zx
         aCzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785282256; x=1785887056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dfDcbfF/R0+jX90HAer+k3zALsvOotfY+1O1lpynXNQ=;
        b=NuSWA12mrXV/QVIl5s+DnvbI4VmwD13CKqH/XBpB0luoNOe/4GZMSrLSmS2BMEYNrf
         ZC8grHRBCj2pewFWYCIlDc20p90DQOx3mJFX65B4BUnWddegMOQwbmiiH/q7S/lOJ2Qk
         lE8b4CaJCEYAhTjrNM0WWvEV723c7kP6k+dwnczEhB8R66AFzqhEK4ejX5gRIDYk1SeY
         jZI9Ohr86CjaRSiI77XAMNO6He7m3PACAG8GvJKbnJLm1TR5zowI7eRHSyF+MJIZrwES
         AjgS7qw2WMDBPBXAyVPhpcWzID3CUuInf8logS/DWpsMfkcA9ZNDDgx95q3hG0jEJkKA
         KnGg==
X-Gm-Message-State: AOJu0YxseuRUpTCnmfs4SqQ6c587T+T+Ic0Yg8JJl/wJR04k9Q5L2WCB
	rdPN+uSxWdcM0uCnUTv4oJu6uq5CY01i4Xu7uZYie45gjsXL30xmfFmf0w3Wt1Es
X-Gm-Gg: AR+sD13bmWcNFPZyX/NbHrQShHHynTpH21jJA6ykL6omUzlxUjyDmFMT/ROY5rB1Qv6
	16R/J2/Gtd8XWuo91y0jZfyiklSN1Si4C0cVYKlAkXLh0kmHsFyD/AlCIEQ9yTE51YMJfVfSWol
	REw/tIoclSs25IwmFP9KrolNtasbogdhzcI42mpvSYGsEm1DcddGV1/a7YbaFhTPJtO4hMhjFHt
	sKfRMqFrOu3EdzvlCXHfN/uW3Muj+K38mNIuIbZkn7rJdDfAVvuShHakUmarsabU92GrOoUlmy+
	i7gr96VsWrb3mBXNT7y4ZRkuopooaulNTdT+8sh2h/8m9Yn5C+v3HeXRiS44641wOntrUjRR8xy
	bg/0KcuFkM2LxiAdZbQVEyOZufmVYs3kOQwm4ba4vt3Mecy94hIjahBNQIN+dBDg4tX5qRRuCSh
	HGjXF7xqbHX4+Rrgg93tzgnmi3+tGCkivwtMiVezfmFp8rUlcPdDNViOJ5ujX2CnDIY1OVSyPy2
	CtljF/AcIe794wqO/qU
X-Received: by 2002:a05:600c:a44:b0:495:6482:9d8c with SMTP id 5b1f17b1804b1-496c6597960mr47209545e9.37.1785282256345;
        Tue, 28 Jul 2026 16:44:16 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496fa499a96sm13980365e9.3.2026.07.28.16.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:44:15 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v7 11/11] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries
Date: Tue, 28 Jul 2026 19:42:22 -0400
Message-ID: <20260728234226.51753-12-ablagodarenko@thelustrecollective.com>
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

Add a new ioctl command that allows setting LUFID (Locally Unique File ID)
data on existing directory entries. This includes:

- ext4_ioctl_set_lufid(): ioctl handler that validates parameters and
  calls the underlying implementation
- ext4_set_direntry_lufid(): Core function that performs the operation by:
  * Looking up the target directory entry
  * Retrieving the associated inode
  * Deleting the old entry and re-creating it with LUFID data attached

This implementation requires the dirdata feature to be enabled on the
filesystem and properly handles transactions and inode locking to ensure
consistency.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/dir.c             |   3 +-
 fs/ext4/ext4.h            |  36 +++---
 fs/ext4/inline.c          |   4 +-
 fs/ext4/ioctl.c           |  84 +++++++++++++
 fs/ext4/namei.c           | 247 ++++++++++++++++++++++++++++++++++----
 include/uapi/linux/ext4.h |  14 +++
 6 files changed, 345 insertions(+), 43 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 50c48c50a29d..d1379335f40b 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -480,7 +480,8 @@ int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
 	p = &info->root.rb_node;
 
 	/* Create and allocate the fname structure */
-	if (dirent->file_type & ~EXT4_FT_MASK) {
+	if (ext4_has_feature_dirdata(dir_file->f_inode->i_sb) &&
+	    (dirent->file_type & ~EXT4_FT_MASK)) {
 		unsigned int rec_len =
 			ext4_rec_len_from_disk(dirent->rec_len, buf_size);
 		extra_data = ext4_dirent_get_data_len(dirent, rec_len);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 099303c1f672..e7696eb2912c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2591,8 +2591,8 @@ struct ext4_dirent_fid {
 
 #define EXT4_LUFID_MAGIC    0xAD200907UL
 struct ext4_dentry_param {
-	__u32			edp_magic;	/* EXT4_LUFID_MAGIC */
-	struct ext4_dirent_fid	edp_dfid;
+	__u32	edp_magic;	/* EXT4_LUFID_MAGIC */
+	__u8	edp_dfid[];	/* struct ext4_dirent_fid payload */
 };
 
 struct ext4_dirent_hash {
@@ -2607,7 +2607,7 @@ struct ext4_dirent_fid *ext4_dentry_get_fid(struct super_block *sb,
 	if (!ext4_has_feature_dirdata(sb))
 		return NULL;
 	if (p && p->edp_magic == EXT4_LUFID_MAGIC)
-		return &p->edp_dfid;
+		return (struct ext4_dirent_fid *)p->edp_dfid;
 
 	return NULL;
 }
@@ -3057,17 +3057,17 @@ extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     struct ext4_filename *fname,
 			     struct ext4_dir_entry_2 **dest_de,
 			     int dlen);
-void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
-			     struct ext4_dir_entry_2 *de,
-			     int buf_size,
-			     struct ext4_filename *fname,
-			     void *data);
-static inline void ext4_insert_dentry(struct inode *dir, struct inode *inode,
-				      struct ext4_dir_entry_2 *de,
-				      int buf_size,
-				      struct ext4_filename *fname)
+int ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
+			    struct ext4_dir_entry_2 *de,
+			    int buf_size,
+			    struct ext4_filename *fname,
+			    void *data);
+static inline int ext4_insert_dentry(struct inode *dir, struct inode *inode,
+				     struct ext4_dir_entry_2 *de,
+				     int buf_size,
+				     struct ext4_filename *fname)
 {
-	ext4_insert_dentry_data(dir, inode, de, buf_size, fname, NULL);
+	return ext4_insert_dentry_data(dir, inode, de, buf_size, fname, NULL);
 }
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
@@ -3322,6 +3322,9 @@ static inline int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 }
 extern int ext4_dirblock_csum_verify(struct inode *inode,
 				     struct buffer_head *bh);
+extern int ext4_dirdata_set_lufid(struct mnt_idmap *idmap, struct inode *dir,
+			   const char *filename, int namelen,
+			   struct ext4_dentry_param *edp);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
 extern int ext4_search_dir(struct buffer_head *bh,
@@ -4098,8 +4101,11 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 /*
  * Advance to the next dirdata record header starting from @ddh.
  */
-#define ext4_dirdata_next(ddh) \
-	((struct ext4_dirent_data_header *)((char *)(ddh) + (ddh)->ddh_length))
+static inline struct ext4_dirent_data_header *
+ext4_dirdata_next(struct ext4_dirent_data_header *ddh)
+{
+	return (struct ext4_dirent_data_header *)((char *)ddh + ddh->ddh_length);
+}
 
 /*
  * ext4_dir_entry_is_tail() - Check if a directory entry is a tail entry.
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 1bbf89e18076..1a6d90f012ca 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -995,7 +995,9 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 					    EXT4_JTR_NONE);
 	if (err)
 		return err;
-	ext4_insert_dentry_data(dir, inode, de, inline_size, fname, dfid);
+	err = ext4_insert_dentry_data(dir, inode, de, inline_size, fname, dfid);
+	if (err)
+		return err;
 
 	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c8387e6a2c6e..1b02b931d92e 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1535,6 +1535,87 @@ static int ext4_ioctl_set_tune_sb(struct file *filp,
 	return ret;
 }
 
+/*
+ * ext4_ioctl_set_lufid() - Set LUFID on a directory entry
+ * @filp:	file pointer (parent directory)
+ * @arg:	pointer to ext4_set_lufid structure with filename and LUFID data
+ *
+ * This ioctl allows setting LUFID data on an existing
+ * directory entry. It is called on the parent directory with a filename and
+ * LUFID data.
+ */
+static long ext4_ioctl_set_lufid(struct file *filp, unsigned long arg)
+{
+	struct inode *dir = file_inode(filp);
+	struct mnt_idmap *idmap = file_mnt_idmap(filp);
+	struct ext4_set_lufid lufid_args;
+	struct {
+		__u32 edp_magic;
+		struct ext4_dirent_data_header df_header;
+		char df_fid[255];
+	} edp;
+	int err;
+
+	/* Check if parent is a directory */
+	if (!S_ISDIR(dir->i_mode))
+		return -ENOTDIR;
+
+	/* This ioctl mutates directory entries; merely having the directory
+	 * open (which only ever requires read access) is not enough */
+	err = inode_permission(idmap, dir, MAY_WRITE);
+	if (err)
+		return err;
+
+	/* Copy arguments from user space */
+	if (copy_from_user(&lufid_args, (struct ext4_set_lufid __user *)arg,
+			   sizeof(lufid_args)))
+		return -EFAULT;
+
+	/* Validate parameters.  esl_name_len is NUL-excluded length (1-255). */
+	if (lufid_args.esl_name_len == 0 || lufid_args.esl_name_len > EXT4_NAME_LEN)
+		return -EINVAL;
+
+	/* ddh_length (esl_data_len + the header byte below) must itself fit
+	 * in the __u8 ddh_length field without wrapping */
+	if (lufid_args.esl_data_len == 0 ||
+	    lufid_args.esl_data_len > 255 - sizeof(edp.df_header))
+		return -EINVAL;
+
+	/* Ensure filename is NUL-terminated at exactly esl_name_len */
+	if (lufid_args.esl_name[lufid_args.esl_name_len] != '\0')
+		return -EINVAL;
+
+	/* '.' and '..' are not ordinary entries -- they must stay the first
+	 * two entries in the directory's first block, so they can't go
+	 * through the general delete+re-add path this ioctl uses */
+	if (!strcmp(lufid_args.esl_name, ".") || !strcmp(lufid_args.esl_name, ".."))
+		return -EINVAL;
+
+	/* Prepare the dentry param struct with LUFID data. ddh_length is
+	 * documented (see struct ext4_dirent_data_header) as the length of
+	 * the header plus the whole data blob -- include the header here so
+	 * every dirdata reader/writer that takes ddh_length at face value
+	 * (e.g. ext4_dirdata_set()'s memcpy) copies the full LUFID payload
+	 * instead of silently dropping its last byte. */
+	edp.edp_magic = EXT4_LUFID_MAGIC;
+	edp.df_header.ddh_length = lufid_args.esl_data_len +
+				    sizeof(edp.df_header);
+	memcpy(edp.df_fid, lufid_args.esl_data, lufid_args.esl_data_len);
+
+	/* Want write access */
+	err = mnt_want_write_file(filp);
+	if (err)
+		return err;
+
+	/* Call the helper function to do the actual work */
+	err = ext4_dirdata_set_lufid(idmap, dir, lufid_args.esl_name,
+				    lufid_args.esl_name_len,
+				    (struct ext4_dentry_param *)&edp);
+
+	mnt_drop_write_file(filp);
+	return err;
+}
+
 static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1921,6 +2002,8 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 					      (void __user *)arg);
 	case EXT4_IOC_SET_TUNE_SB_PARAM:
 		return ext4_ioctl_set_tune_sb(filp, (void __user *)arg);
+	case EXT4_IOC_SET_LUFID:
+		return ext4_ioctl_set_lufid(filp, arg);
 	default:
 		return -ENOTTY;
 	}
@@ -2000,6 +2083,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC_SETFSLABEL:
 	case EXT4_IOC_GETFSUUID:
 	case EXT4_IOC_SETFSUUID:
+	case EXT4_IOC_SET_LUFID:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index f1985f1d9b60..4f55d3b75b3f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -542,11 +542,13 @@ static struct dx_root_info *dx_get_dx_info(struct inode *dir, void *de_buf)
 {
 	unsigned int blocksize = dir->i_sb->s_blocksize;
 	void *base = de_buf;
+	unsigned int rlen;
 
 	/* '.' and '..' never carry the casefold+fscrypt hash, so pass NULL
 	 * for dir regardless of the directory's flags */
-	if (ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->rec_len,
-				   blocksize) < EXT4_BASE_DIR_LEN)
+	rlen = ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->rec_len,
+				      blocksize);
+	if (rlen < EXT4_BASE_DIR_LEN || rlen > blocksize)
 		return ERR_PTR(-EFSCORRUPTED);
 	de_buf += ext4_dir_entry_len(de_buf, blocksize, NULL);
 
@@ -554,6 +556,10 @@ static struct dx_root_info *dx_get_dx_info(struct inode *dir, void *de_buf)
 	if (de_buf < base || (char *)de_buf - (char *)base +
 	    EXT4_BASE_DIR_LEN > blocksize)
 		return ERR_PTR(-EFSCORRUPTED);
+	rlen = ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->rec_len,
+				      blocksize);
+	if (rlen < EXT4_BASE_DIR_LEN || rlen > blocksize)
+		return ERR_PTR(-EFSCORRUPTED);
 	de_buf += ext4_dir_entry_len(de_buf, blocksize, NULL);
 
 	if (de_buf < base || (char *)de_buf - (char *)base +
@@ -612,6 +618,9 @@ static inline unsigned dx_root_limit(struct inode *dir,
 	info = dx_get_dx_info(dir, dot_de);
 	if (IS_ERR(info))
 		return 0;
+	if ((char *)info - (char *)dot_de + info->info_length >
+	    dir->i_sb->s_blocksize)
+		return 0;
 	entry_space = dir->i_sb->s_blocksize - ((char *)info - (char *)dot_de) -
 		info->info_length;
 
@@ -1467,9 +1476,9 @@ unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de, struct inode *dir,
  * directories requires an e2fsck migration pass before tune2fs sets the
  * EXT4_FEATURE_INCOMPAT_DIRDATA superblock flag.
  */
-static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
-			     struct ext4_dirent_fid *dfid,
-			     struct ext4_filename *fname)
+static int ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
+			    struct ext4_dirent_fid *dfid,
+			    struct ext4_filename *fname)
 {
 	struct dx_hash_info *hinfo = &fname->hinfo;
 	unsigned int data_offset = de->name_len + 1;
@@ -1490,7 +1499,7 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 
 		if (EXT4_BASE_DIR_LEN + data_offset + dlen > rec_len) {
 			EXT4_ERROR_INODE(dir, "Can not insert FID");
-			return;
+			return -EIO;
 		}
 
 		memcpy((char *)de + EXT4_BASE_DIR_LEN + data_offset, dfid, dlen);
@@ -1505,7 +1514,7 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 
 			if (EXT4_BASE_DIR_LEN + data_offset + sizeof(*dh) > rec_len) {
 				EXT4_ERROR_INODE(dir, "Can not insert dhash dirdata");
-				return;
+				return -EIO;
 			}
 
 			dh->dh_header.ddh_length = sizeof(*dh);
@@ -1513,11 +1522,18 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 			dh->dh_hash.minor_hash = cpu_to_le32(hinfo->minor_hash);
 			de->file_type |= EXT4_DIRENT_CFHASH;
 		} else {
-			/* Compatibility: store hash inline after filename */
-			if (EXT4_BASE_DIR_LEN + data_offset +
-			    sizeof(struct ext4_dir_entry_hash) > rec_len) {
+			/* Compatibility: store hash inline after filename.
+			 * EXT4_DIRENT_HASHES places the hash at the
+			 * 4-byte-aligned offset (8 + name_len + 3) & ~3, which
+			 * may be less than EXT4_BASE_DIR_LEN + data_offset when
+			 * name_len is a multiple of 4 (gap byte counted twice).
+			 * Use the same aligned offset for the bounds check. */
+			unsigned int hash_off =
+				(EXT4_BASE_DIR_LEN + de->name_len + 3) & ~3;
+
+			if (hash_off + sizeof(struct ext4_dir_entry_hash) > rec_len) {
 				EXT4_ERROR_INODE(dir, "Can not insert dhash");
-				return;
+				return -EIO;
 			}
 
 			EXT4_DIRENT_HASHES(de)->hash = cpu_to_le32(hinfo->hash);
@@ -1525,6 +1541,7 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 						cpu_to_le32(hinfo->minor_hash);
 		}
 	}
+	return 0;
 }
 
 /*
@@ -2324,9 +2341,9 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 	return 0;
 }
 
-void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
-			     struct ext4_dir_entry_2 *de, int buf_size,
-			     struct ext4_filename *fname, void *data)
+int ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
+			    struct ext4_dir_entry_2 *de, int buf_size,
+			    struct ext4_filename *fname, void *data)
 {
 	int nlen, rlen;
 
@@ -2344,7 +2361,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
 	de->name_len = fname_len(fname);
 	memcpy(de->name, fname_name(fname), fname_len(fname));
-	ext4_dirdata_set(de, dir, data, fname);
+	return ext4_dirdata_set(de, dir, data, fname);
 }
 
 /*
@@ -2396,7 +2413,11 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	}
 
 	/* By now the buffer is marked for journaling */
-	ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
+	err = ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
+	if (err) {
+		ext4_std_error(dir->i_sb, err);
+		return err;
+	}
 
 	/*
 	 * XXX shouldn't update any times until successful
@@ -3210,14 +3231,15 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) bh->b_data;
 	size_t			blocksize = bh->b_size;
 	int			csum_size = 0, header_size;
+	unsigned int		dot_rec_len;
 
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(ext4_dirent_rec_len(de->name_len, NULL),
-					   blocksize);
+	dot_rec_len = ext4_dirent_rec_len(de->name_len, NULL);
+	de->rec_len = ext4_rec_len_to_disk(dot_rec_len, blocksize);
 	memcpy(de->name, ".", 2);
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 
@@ -3237,7 +3259,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			blocksize - csum_size);
 	} else {
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + ext4_dirent_rec_len(1, NULL)),
+					(csum_size + dot_rec_len),
 					blocksize);
 	}
 
@@ -3270,6 +3292,12 @@ int ext4_init_new_dir_data(handle_t *handle, struct inode *dir,
 	dir_block = ext4_append(handle, inode, &block);
 	if (IS_ERR(dir_block))
 		return PTR_ERR(dir_block);
+	/*
+	 * data1 and data2 are reserved for callers that need to embed
+	 * dirdata into the '.' and '..' entries of a new directory.
+	 * That path is not yet implemented here; a caller requiring it
+	 * must write the dirdata entries after this function returns.
+	 */
 	err = ext4_init_dirblock(handle, inode, dir_block, dir->i_ino, NULL, 0);
 out:
 	brelse(dir_block);
@@ -3968,13 +3996,24 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 				if (ddh_off + sizeof(*ddh) > rec_len ||
 				    ddh->ddh_length != copy_len ||
 				    ddh_off + copy_len > rec_len) {
-					/* Cannot copy: clear the flag so the
-					 * slot does not advertise a stale LUFID
-					 * from the old inode. */
-					ent->de->file_type &= ~EXT4_DIRENT_LUFID;
+					/* Cannot copy in-place (slot too small,
+					 * size mismatch, or out of bounds).
+					 * Clear all dirdata extension flags: the
+					 * old LUFID bytes remain at their offset
+					 * in the padding, so any extension that
+					 * follows LUFID in flag order (INO64,
+					 * CFHASH) would be misread by a parser
+					 * that no longer skips past LUFID first.
+					 * Dropping all upper bits is safer than
+					 * trying to compact the extension chain. */
+					ent->de->file_type &= EXT4_FT_MASK;
 				} else {
 					memcpy(ddh, src_fid, copy_len);
 				}
+			} else if (src_fid) {
+				/* Destination has no LUFID slot; cannot
+				 * propagate the source LUFID in-place. */
+				return -ENODATA;
 			} else if (!src_fid) {
 				/* Sync the LUFID flag with what file_type requests.
 				 * For normal rename (source has no LUFID) and for
@@ -4357,14 +4396,13 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 			 * ext4_add_entry() picks it up via d_fsdata. */
 			unsigned fid_size = old_snap.fid->df_header.ddh_length;
 
-			edp = kmalloc(offsetof(struct ext4_dentry_param,
-					       edp_dfid) + fid_size, GFP_NOFS);
+			edp = kmalloc(sizeof(*edp) + fid_size, GFP_NOFS);
 			if (!edp) {
 				retval = -ENOMEM;
 				goto end_rename;
 			}
 			edp->edp_magic = EXT4_LUFID_MAGIC;
-			memcpy(&edp->edp_dfid, old_snap.fid, fid_size);
+			memcpy(edp->edp_dfid, old_snap.fid, fid_size);
 		}
 		new.dentry->d_fsdata = edp;
 		retval = ext4_add_entry(handle, new.dentry, old.inode);
@@ -4676,6 +4714,163 @@ static int ext4_rename2(struct mnt_idmap *idmap,
 	return ext4_rename(idmap, old_dir, old_dentry, new_dir, new_dentry, flags);
 }
 
+/*
+ * ext4_dirdata_set_lufid() - Set LUFID data on an existing directory entry
+ * @dir:        parent directory inode
+ * @filename:   name of the file in the directory
+ * @namelen:    length of filename
+ * @edp:        pointer to initialized dentry param with LUFID data
+ *
+ * This function finds an existing directory entry, deletes it, and re-creates it
+ * with LUFID data attached. Used by the EXT4_IOC_SET_LUFID ioctl.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int ext4_dirdata_set_lufid(struct mnt_idmap *idmap, struct inode *dir,
+			    const char *filename, int namelen,
+			    struct ext4_dentry_param *edp)
+{
+	struct super_block *sb = dir->i_sb;
+	 /* zero-init: safe to free on any path */
+	struct ext4_filename fname = {};
+	struct ext4_dir_entry_2 *de = NULL;
+	struct buffer_head *bh = NULL;
+	struct inode *inode = NULL;
+	handle_t *handle = NULL;
+	struct qstr d_name;
+	int err = 0;
+
+	if (!ext4_has_feature_dirdata(sb))
+		return -EOPNOTSUPP;
+
+	if (namelen > EXT4_NAME_LEN)
+		return -ENAMETOOLONG;
+	if (namelen != strnlen(filename, namelen + 1))
+		return -EINVAL;
+
+	d_name.name = filename;
+	d_name.len = namelen;
+
+	err = ext4_fname_setup_filename(dir, &d_name, 0, &fname);
+	if (err)
+		goto out_free;
+
+	/* Lock dir with the VFS parent-mutation subclass before starting the
+	 * journal.  Holding i_rwsem while calling ext4_journal_start() is safe
+	 * (ext4_setattr, ext4_fallocate etc. do the same).  The lookup must be
+	 * inside the lock to prevent TOCTOU: the bh/de pointers must be stable
+	 * from find_entry through delete_entry. */
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+
+	handle = ext4_journal_start(dir, EXT4_HT_DIR,
+				    3 * EXT4_DATA_TRANS_BLOCKS(sb) +
+				    2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		handle = NULL;
+		goto out_unlock_dir;
+	}
+
+	bh = ext4_find_entry(dir, &d_name, &de, NULL);
+	if (IS_ERR(bh)) {
+		err = PTR_ERR(bh);
+		bh = NULL;
+		goto out_journal;
+	}
+	if (!bh) {
+		err = -ENOENT;
+		goto out_journal;
+	}
+
+	inode = ext4_iget(sb, le32_to_cpu(de->inode), EXT4_IGET_NORMAL);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		inode = NULL;
+		goto out_brelse;
+	}
+
+	/* Enforce sticky-bit restriction: on a sticky directory only the
+	 * directory owner, the file owner, or a privileged process may
+	 * modify entries.  inode_permission(MAY_WRITE) alone does not cover
+	 * this, so check it explicitly here as may_delete() does. */
+	err = check_sticky(idmap, dir, inode);
+	if (err)
+		goto out_brelse;
+
+	/* Lock the target inode after the directory (dir-then-child ordering)
+	 * to serialize concurrent EXT4_IOC_SET_LUFID calls on different
+	 * hardlinks of the same inode.  Use I_MUTEX_CHILD for directory inodes
+	 * (consistent with VFS rename/rmdir) and I_MUTEX_NONDIR2 for all
+	 * others; mixing subclasses on the same inode triggers lockdep cycles
+	 * with concurrent rename. */
+	if (inode != dir) {
+		if (S_ISDIR(inode->i_mode))
+			inode_lock_nested(inode, I_MUTEX_CHILD);
+		else
+			inode_lock_nested(inode, I_MUTEX_NONDIR2);
+	}
+
+	err = ext4_delete_entry(handle, dir, de, bh);
+	if (err)
+		goto out_unlock;
+
+	brelse(bh);
+	bh = NULL;
+
+	/* Re-add with LUFID via dentry->d_fsdata.  ext4_add_entry() resolves
+	 * dfid from d_fsdata into fname.dfid and passes it through to
+	 * add_dirent_to_buf() without touching the shared i_dirdata field,
+	 * eliminating the race with concurrent link() calls. */
+	{
+		struct dentry parent_dentry = { .d_inode = dir };
+		struct dentry new_dentry = {
+			.d_name = d_name,
+			.d_parent = &parent_dentry,
+			.d_inode = inode,
+			.d_fsdata = edp,
+		};
+		err = ext4_add_entry(handle, &new_dentry, inode);
+	}
+
+	if (err) {
+		/* Delete succeeded but re-add failed; try to restore so the
+		 * inode is not left without a directory entry. */
+		struct dentry parent_dentry = { .d_inode = dir };
+		struct dentry orig_dentry = {
+			.d_name = d_name,
+			.d_parent = &parent_dentry,
+			.d_inode = inode,
+		};
+		int rollback_err = ext4_add_entry(handle, &orig_dentry, inode);
+
+		if (rollback_err)
+			EXT4_ERROR_INODE(dir,
+				"Failed to set LUFID on '%.*s' (err=%d) and failed to restore the original directory entry (err=%d); inode %llu may be orphaned",
+				namelen, filename, err, rollback_err,
+				inode->i_ino);
+		goto out_unlock;
+	}
+
+	inode_set_ctime_current(dir);
+	inode_inc_iversion(dir);
+	ext4_mark_inode_dirty(handle, dir);
+
+out_unlock:
+	if (inode != dir)
+		inode_unlock(inode);
+out_brelse:
+	brelse(bh);
+out_journal:
+	ext4_journal_stop(handle);
+out_unlock_dir:
+	inode_unlock(dir);
+	iput(inode);
+out_free:
+	ext4_fname_free_filename(&fname);
+
+	return err;
+}
+
 /*
  * directories can handle most operations...
  */
diff --git a/include/uapi/linux/ext4.h b/include/uapi/linux/ext4.h
index 9c683991c32f..9134fe64947a 100644
--- a/include/uapi/linux/ext4.h
+++ b/include/uapi/linux/ext4.h
@@ -35,6 +35,7 @@
 #define EXT4_IOC_SETFSUUID		_IOW('f', 44, struct fsuuid)
 #define EXT4_IOC_GET_TUNE_SB_PARAM	_IOR('f', 45, struct ext4_tune_sb_params)
 #define EXT4_IOC_SET_TUNE_SB_PARAM	_IOW('f', 46, struct ext4_tune_sb_params)
+#define EXT4_IOC_SET_LUFID		_IOW('f', 47, struct ext4_set_lufid)
 
 #define EXT4_IOC_SHUTDOWN _IOR('X', 125, __u32)
 
@@ -92,6 +93,19 @@ struct move_extent {
 	__u64 moved_len;	/* moved block length */
 };
 
+/*
+ * Structure for EXT4_IOC_SET_LUFID
+ * Sets LUFID on a directory entry
+ * Called on parent directory with filename and LUFID data as arguments
+ */
+struct ext4_set_lufid {
+	__u8 esl_name_len;	/* length of filename, NOT including NUL terminator
+				 * (valid range: 1-255, matching EXT4_NAME_LEN) */
+	char  esl_name[255 + 1]; /* filename (NUL-terminated) */
+	__u8 esl_data_len;	/* length of LUFID data */
+	char  esl_data[255]; /* LUFID data (raw bytes) */
+};
+
 /*
  * Flags used by EXT4_IOC_SHUTDOWN
  */
-- 
2.43.7

