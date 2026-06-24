Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB67A3B7B64
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308295; cv=none; b=Bl3cQdmGUloJJ2fUqt5DbUlsUj4ofqpiuHRBqCIjWHHVUGuJw/Su8nk3Ua/eRf0vwnFHPtGPcoHRlQBQ6YxtNJ/lNIqhiSd7TovYWFHYz/5hN788Yrl90sbt69EOq602+bsKn0pWS7ERhKEMe4tM4URkBmd2lgGq+AlBRc20iRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308295; c=relaxed/simple;
	bh=G4sn7qbqXThVWF5FZ+s771TxHP9+bL98nn8LlcWqpKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofeY0OQ1caVH2XlhhWnPkGVqBP24Ybf4ekFEBHYB6MD5z9wgjejxZ0jG+DYBoggYzRA5Pyof26xn77Oj7BUyLfAZOSas2SMN8Pm2ZyNrP/gVTD2uicxdHPK4Z0Z8skVoNCteGc05Vs44k0RW5I9u25GsVx4Jr45jfR4nt/J1GEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fG8IRvrB; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fG8IRvrB"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49241a577d8so6642895e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308292; x=1782913092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PW0c8OMHlE6l9SAAjYQjqcmx6zaFvIOQLIbFJvGXAlc=;
        b=fG8IRvrBMtuIF0+XzdeO0Uyg7ZpKiZV2rJ/RjZUJdWifgfECpWStCPf8PcUz5gB5ba
         CBUVqVjORN+PGakhJliCOQsKpfxHGQ08Trw5zYH5GgTj7xccyr485xws0FZZFEsNf/DW
         KuDAOZOedWcK8p/ng8w+rVLQzsTOEN6MJjsNT/GoyJTD1xn9y1e/pKAI+5wGAYJHLInj
         saYB+hTQ/J/0mDlmZwwQ7IxoIdfPCEwjFZrvABD7zG9sAQ0ACh1lFa++6Cf9X9H4+e0v
         wbMVqIuFzURTRT/toifIDvmHywynP/lmE9ML1f4Fiu8wLzyUv3/vlY/hc1UhWLOfe/+Z
         u1Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308292; x=1782913092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PW0c8OMHlE6l9SAAjYQjqcmx6zaFvIOQLIbFJvGXAlc=;
        b=FCnrig978aszobHJeEbysMv6LaAW2hjjFUlfbTq/7zfLxaQx/N2jRTH4VHFoaDuhpN
         PsiXq5h9xYrQvNLjH3s01e8gAKxswAxuzZYkrkg1I2bK8j+pRsstya4u7GQZK5gYQppg
         A/bb6bTdVC8jTFed9JQdxW4PenqDvl/GymYPjMHfYQsNDBwjvJywaA9udoE/nj5+SriB
         lOBuvNC60QJdUTo+wVHecAjZqR3DrBou5a1gZoF2T3+ybHDxkAZeXpmB29fOgIkufsMJ
         BcNUFYFP17B56h5ATj6zgA9BYPWTzZUKMb6nMO1pvxhiB4k2r6DTOkCn49GDXUA2ZtTc
         Q89Q==
X-Gm-Message-State: AOJu0Yy0GgBg1ggIBs8hxXNVytNHhRx/9s35w1hgv9DODblyzlHl+wEu
	71/PHKabBq5dYi6R2D7bxK+a53lUpG5p2X1eX8V46U6GB+UyJSHOO8ZfSHeELWfHcB0=
X-Gm-Gg: AfdE7clmnn9UZO7ZDmmGLHHpAPTAbHRQy923rZKox2zB6bEBM2QhyqBJMEZtNu9Q1Vg
	yESCDLymHbBqfEz0ftJLNqcKPx4ff0MyuIyiulVxnv6bbIoe/IO5MXp8ONxzNVydQdpLt7/saNj
	m6YFDU1zhiCEM91dn+FCUiq+iJ52lmzIkY/llnI0v+LxCeQf8IHCaY9dfQ1nU18w4yBF40YfM7v
	IlJNRGMjkqc5EhgZ8iPgSP4+wHH+jk2xy795gBxZonXzuiZj4mIU05Wbl8e53igxAzjHhulu0VZ
	OSTI6LD/DEX+AAip1v1na5LKfUM9edZdCXj4GbrQfaS9eVbTdR0KFFKlMOn56pK87DdL/KAViFF
	kVZ8grx8PnSH6tkHTymNqV0q8Vw/gjp/PwjeobHtrvNf4izUOg/dm25Gk8Hh+wX99ci3SFeQ/SK
	VD7O4ak4safoBx+2WeA2hVJiDUztBmnA==
X-Received: by 2002:a05:600c:608c:b0:492:62d8:2da8 with SMTP id 5b1f17b1804b1-49262d82dcdmr15713155e9.29.1782308292066;
        Wed, 24 Jun 2026 06:38:12 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:11 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 11/11] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries
Date: Wed, 24 Jun 2026 09:36:40 -0400
Message-ID: <20260624133642.18438-12-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ioctl.c           |  84 +++++++++++++++++++++
 fs/ext4/namei.c           | 155 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/ext4.h |  13 ++++
 4 files changed, 267 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5674a64f830f..252a5a529205 100644
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
index c8387e6a2c6e..725e46e1e46d 100644
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
+	/* Validate parameters */
+	if (lufid_args.esl_name_len == 0 || lufid_args.esl_name_len > EXT4_NAME_LEN)
+		return -EINVAL;
+
+	/* ddh_length (esl_data_len + the header byte below) must itself fit
+	 * in the __u8 ddh_length field without wrapping */
+	if (lufid_args.esl_data_len == 0 ||
+	    lufid_args.esl_data_len > 255 - sizeof(edp.df_header))
+		return -EINVAL;
+
+	/* Ensure filename is NUL-terminated and unmodified */
+	if (lufid_args.esl_name[lufid_args.esl_name_len - 1] != '\0')
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
index 6fba1a7c0876..3aeea503f12d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2319,6 +2319,8 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	dfid = ext4_dentry_get_fid(inode->i_sb,
+		(struct ext4_dentry_param *)EXT4_I(inode)->i_dirdata);
 	if (!de) {
 		if (dfid)
 			dlen = dfid->df_header.ddh_length;
@@ -2665,6 +2667,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 {
 	struct inode *dir = d_inode(dentry->d_parent);
 
+	EXT4_I(inode)->i_dirdata = dentry->d_fsdata;
 	if (fscrypt_is_nokey_name(dentry))
 		return -ENOKEY;
 	return __ext4_add_entry(handle, dir, &dentry->d_name, inode);
@@ -4426,6 +4429,158 @@ static int ext4_rename2(struct mnt_idmap *idmap,
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
+	/* EXT4_I(inode)->i_dirdata below is a *shared* per-inode field used
+	 * to smuggle the LUFID payload into ext4_add_entry(); locking only
+	 * dir does not stop a concurrent EXT4_IOC_SET_LUFID call targeting a
+	 * different hardlink of the same inode (different dir, same inode)
+	 * from clobbering it mid-call with its own stack-local pointer.
+	 * Lock the target inode too, consistently dir-then-inode, to
+	 * serialize the i_dirdata set/use/restore window below. */
+	if (inode != dir)
+		inode_lock_nested(inode, I_MUTEX_NONDIR2);
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
+	if (inode != dir)
+		inode_unlock(inode);
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

