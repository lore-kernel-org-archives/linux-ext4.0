Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B343438A1
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781896324; cv=none; b=uLTvL44MUiUv28GQNiH/mKliL1+nY3p4gw+WZMQRgQfLhTEIWE5H850dA4jmwmHKSw4O+3UvPbXM7WgkmvI4vJcDiyqqYC73xw/HrybOQXruraKZj0dlco67MgIA7vg9db7r96d+L78o9xvPq98thuw+V5IJ5qQeQrXHtz31Bwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781896324; c=relaxed/simple;
	bh=rvERa4RRJxnQ0rc6s8Asop+oOCcXCa7tgn0nRWJJQnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6avj11JkbS6zgu9+SvOTZU67MARYWZ2MlAH0uu76XU33ryQcPFUELS/KfSnx0SpP7svSe2ZVM7W9bHL+Ne6m6BWxoKcbXSp4MjAtUl2E731HJDZUHvPvUXxBsaBEqTg/bRP/DE0tRoGjaxUn4UBqwBgUpxN0VqiFcUNrSZIx0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QCJU1D7Q; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QCJU1D7Q"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49241896317so5383365e9.3
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896321; x=1782501121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A5hGrRcBzIcM870Ss8z9W49PEvTmsF5AyZebSkjKI44=;
        b=QCJU1D7QWpeTjQBh/5zKBxYVJ+ee/ORcKLh/oeOuNjSd/S+I1c4NanxxOfD+2dFQQc
         CAOkhFfYLwHXxYJvkHYTWbbXpFAieY5Z4+8u33SEaVCPelSa3Vf6wXU+MOcITNSJIYvI
         fG5aTKGLNEmehwfT5AK4UnFLcjrg0MmXhsFCMfqhJnY1gAbmGg4+AYgLj7Bw6Rhca2tK
         Np34du0m5/J5FZVNPaF2ImrqQ36qRWW4g2ealWaWytirW3nx0/TIr0WqN8EeY0LTKs0p
         8r195nSg3+aposb4C2y7lvK62C1p9JE7KK1merEtyOzI07FImq04GIBa0r3yejMzASmY
         iGIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896321; x=1782501121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A5hGrRcBzIcM870Ss8z9W49PEvTmsF5AyZebSkjKI44=;
        b=R7dNKkP1xIeUNadQZvROuwlnnJN1YqGXLN0cus8GwZk989Z1/bdJ3sbfzlrSAMxjHg
         qH2N9DdGXCvCOYexCCUfLiuD3g4qVfSyRs2XmP35PCnmd/PORN62x5uspNNKwjo0OfTd
         x/wgh6JWGNgn3kuoc+8sLfWe9DJE2RHGBaxn+7/1Hf3GiDvUUoGbtlIE/cmIguYxoojx
         WmKjUcEbqg5fiOFCh888L6fp4YvMhZkJpjYih5jmAsHQzDZbNOttibokHLv3MtB19BQx
         wrYIbESHZsrXF4jibHQ36pTAjlMRzOLhDgE/wsUYWHsaavfOSADVGPmxfwSUw21jSG1v
         7joQ==
X-Gm-Message-State: AOJu0YxzCYmtsG+3Iv9Hg8+29WR8xw9n06s9yS9CbM3E8oFJ03XEL096
	cJ/i5UJwTc3HkhiXrSaJ0KLmJOw6lU92hf26QPRzzlMvnDjJXNxNbv07m2BnpQnztK/+4Q==
X-Gm-Gg: AfdE7cnC3JKHc9DUo6JXIUDzr+PFT5ixSl3B0WKNO/J6eQEIG48H2RenEkBy1YMe3Te
	K+PHv0zrxB0VyLmrFxi3HnDAu956ncnnB+0j7524ilJYR6v0F22+Pc0DxhegDVs/xzgB0Bql57e
	dsZTna+o1egd9qSo0r1WCySV0TE0tq9vyprhqI39C0cJ7HOpdk8AnEd2iziZ0/zzJMu0LQQYH0S
	7CfxKBGeMNm0lkblOw+JB2jlvvLYHRO2L9e/TrFOgTEI4yFlgVt0v6i4yfYG3s1AqHjzgIBP7YJ
	x1NXcItfYc6vGFCHM6oCHiPffmh6h8UXBPhN13Mz3EpaZk1491Q9ZUJj2vCb+5GwfIx0JVw/3EC
	anKrii7GF3RpWiIbGNbd9DeSHNdoomJBXvXpT0654/4/qr/AZws4UGTh3HFpBw+GUWvY6VH50MD
	uP/mz9KlnQ2eQFVmVIpFPQbrXwlAZ3XH5UUIJfNiZztw==
X-Received: by 2002:a05:600c:c088:b0:492:2f3c:d0ed with SMTP id 5b1f17b1804b1-4923f594511mr80627315e9.30.1781896320655;
        Fri, 19 Jun 2026 12:12:00 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm1384222f8f.7.2026.06.19.12.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:12:00 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 10/10] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries
Date: Fri, 19 Jun 2026 15:10:14 -0400
Message-ID: <20260619191022.27008-11-ablagodarenko@thelustrecollective.com>
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

Signed-off-by: Artem Blagodarenko artem.blagodarenko@gmail.com
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h            |  15 ++++
 fs/ext4/ioctl.c           |  62 +++++++++++++++++
 fs/ext4/namei.c           | 143 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/ext4.h |  13 ++++
 4 files changed, 233 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 543c8e87f207..0a8b9116dc7b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1227,6 +1227,7 @@ struct ext4_inode_info {
 #ifdef CONFIG_FS_ENCRYPTION
 	struct fscrypt_inode_info *i_crypt_info;
 #endif
+	void *i_dirdata;
 };
 
 /*
@@ -2601,6 +2602,18 @@ struct ext4_dirent_hash {
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
@@ -3302,6 +3315,8 @@ static inline int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 }
 extern int ext4_dirblock_csum_verify(struct inode *inode,
 				     struct buffer_head *bh);
+extern int ext4_dirdata_set_lufid(struct inode *dir, const char *filename,
+			   int namelen, struct ext4_dentry_param *edp);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
 extern int ext4_search_dir(struct buffer_head *bh,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c8387e6a2c6e..19d6588092d3 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1535,6 +1535,65 @@ static int ext4_ioctl_set_tune_sb(struct file *filp,
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
+	/* Copy arguments from user space */
+	if (copy_from_user(&lufid_args, (struct ext4_set_lufid __user *)arg,
+			   sizeof(lufid_args)))
+		return -EFAULT;
+
+	/* Validate parameters */
+	if (lufid_args.esl_name_len == 0 || lufid_args.esl_name_len > EXT4_NAME_LEN)
+		return -EINVAL;
+
+	if (lufid_args.esl_data_len == 0 || lufid_args.esl_data_len > 255)
+		return -EINVAL;
+
+	/* Ensure filename is NUL-terminated and unmodified */
+	if (lufid_args.esl_name[lufid_args.esl_name_len - 1] != '\0')
+		return -EINVAL;
+
+	/* Prepare the dentry param struct with LUFID data */
+	edp.edp_magic = EXT4_LUFID_MAGIC;
+	edp.df_header.ddh_length = lufid_args.esl_data_len;
+	memcpy(edp.df_fid, lufid_args.esl_data, lufid_args.esl_data_len);
+
+	/* Want write access */
+	err = mnt_want_write_file(filp);
+	if (err)
+		return err;
+
+	/* Call the helper function to do the actual work */
+	err = ext4_dirdata_set_lufid(dir, lufid_args.esl_name,
+				    lufid_args.esl_name_len - 1,
+				    (struct ext4_dentry_param *)&edp);
+
+	mnt_drop_write_file(filp);
+	return err;
+}
+
 static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1921,6 +1980,8 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 					      (void __user *)arg);
 	case EXT4_IOC_SET_TUNE_SB_PARAM:
 		return ext4_ioctl_set_tune_sb(filp, (void __user *)arg);
+	case EXT4_IOC_SET_LUFID:
+		return ext4_ioctl_set_lufid(filp, arg);
 	default:
 		return -ENOTTY;
 	}
@@ -2000,6 +2061,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC_SETFSLABEL:
 	case EXT4_IOC_GETFSUUID:
 	case EXT4_IOC_SETFSUUID:
+	case EXT4_IOC_SET_LUFID:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c8fa8d4940c2..29d5b70b84bf 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2282,6 +2282,8 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	dfid = ext4_dentry_get_fid(inode->i_sb,
+		(struct ext4_dentry_param *)EXT4_I(inode)->i_dirdata);
 	if (!de) {
 		if (dfid)
 			dlen = dfid->df_header.ddh_length;
@@ -2628,6 +2630,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 {
 	struct inode *dir = d_inode(dentry->d_parent);
 
+	EXT4_I(inode)->i_dirdata = dentry->d_fsdata;
 	if (fscrypt_is_nokey_name(dentry))
 		return -ENOKEY;
 	return __ext4_add_entry(handle, dir, &dentry->d_name, inode);
@@ -4389,6 +4392,146 @@ static int ext4_rename2(struct mnt_idmap *idmap,
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
+int ext4_dirdata_set_lufid(struct inode *dir, const char *filename,
+			    int namelen, struct ext4_dentry_param *edp)
+{
+	struct super_block *sb = dir->i_sb;
+	struct ext4_filename fname;
+	struct ext4_dir_entry_2 *de = NULL;
+	struct buffer_head *bh = NULL;
+	struct inode *inode = NULL;
+	handle_t *handle = NULL;
+	struct qstr d_name;
+	void *old_dirdata = NULL;
+	int err = 0;
+
+	/* Check if dirdata feature is enabled */
+	if (!ext4_has_feature_dirdata(sb))
+		return -ENOTSUPP;
+
+	if (namelen > EXT4_NAME_LEN)
+               return -ENAMETOOLONG;
+        if (namelen != strnlen(filename, namelen + 1))
+               return -EINVAL;
+
+	/* Setup the filename for lookup */
+	d_name.name = filename;
+	d_name.len = namelen;
+
+	/* Lookup the filename in the directory */
+	err = ext4_fname_setup_filename(dir, &d_name, 0, &fname);
+	if (err)
+		goto out_free;
+
+	bh = ext4_find_entry(dir, &d_name, &de, NULL);
+	if (!bh) {
+		err = -ENOENT;
+		goto out_free;
+	}
+
+	/* Get the inode number from the directory entry */
+	inode = ext4_iget(sb, le32_to_cpu(de->inode), EXT4_IGET_NORMAL);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		inode = NULL;
+		goto out_brelse;
+	}
+
+	/* Start a transaction */
+	handle = ext4_journal_start(dir, EXT4_HT_DIR, 
+				     2 * EXT4_DATA_TRANS_BLOCKS(sb) + 
+				     EXT4_INDEX_EXTRA_TRANS_BLOCKS);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		handle = NULL;
+		goto out_iput;
+	}
+
+	inode_lock(dir);
+
+	/* Delete the old entry */
+	err = ext4_delete_entry(handle, dir, de, bh);
+	if (err)
+		goto out_unlock;
+
+	brelse(bh);
+	bh = NULL;
+
+	/* Re-add the entry with LUFID data
+	 * We set i_dirdata before adding so the entry can include it
+	 */
+	old_dirdata = EXT4_I(inode)->i_dirdata;
+	EXT4_I(inode)->i_dirdata = edp;
+
+	/* Use ext4_add_entry() to properly handle hash table management
+	 * and block splitting, just like rename does. This ensures the entry
+	 * is placed in the correct hash block and avoids breaking dirhash.
+	 */
+	{
+		struct dentry parent_dentry = { .d_inode = dir };
+		struct dentry new_dentry = {
+			.d_name = d_name,
+			.d_parent = &parent_dentry,
+			.d_inode = inode,  /* Same inode (in-place update) */
+			.d_fsdata = edp,   /* required */
+		};
+		err = ext4_add_entry(handle, &new_dentry, inode);
+	}
+	EXT4_I(inode)->i_dirdata = old_dirdata;
+
+	if (err) {
+		/*
+		 * The original entry was already removed above and the
+		 * re-add with the new LUFID failed; try to restore the
+		 * original entry so the inode isn't left without any
+		 * directory entry pointing at it.
+		 */
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
+	/* Update inode times */
+	inode_set_ctime_current(dir);
+	inode_inc_iversion(dir);
+	ext4_mark_inode_dirty(handle, dir);
+
+out_unlock:
+	inode_unlock(dir);
+	ext4_journal_stop(handle);
+out_iput:
+	iput(inode);
+out_brelse:
+	brelse(bh);
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
index 9c683991c32f..9fab8978843b 100644
--- a/include/uapi/linux/ext4.h
+++ b/include/uapi/linux/ext4.h
@@ -35,6 +35,7 @@
 #define EXT4_IOC_SETFSUUID		_IOW('f', 44, struct fsuuid)
 #define EXT4_IOC_GET_TUNE_SB_PARAM	_IOR('f', 45, struct ext4_tune_sb_params)
 #define EXT4_IOC_SET_TUNE_SB_PARAM	_IOW('f', 46, struct ext4_tune_sb_params)
+#define EXT4_IOC_SET_LUFID		_IOW('f', 47, struct ext4_set_lufid)
 
 #define EXT4_IOC_SHUTDOWN _IOR('X', 125, __u32)
 
@@ -92,6 +93,18 @@ struct move_extent {
 	__u64 moved_len;	/* moved block length */
 };
 
+/*
+ * Structure for EXT4_IOC_SET_LUFID
+ * Sets LUFID on a directory entry
+ * Called on parent directory with filename and LUFID data as arguments
+ */
+struct ext4_set_lufid {
+	__u8 esl_name_len;	/* length of filename */
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

