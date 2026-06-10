Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88671426EBB
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105143; cv=none; b=u5js5UQpw6GTlpN1SMD2ri/OPlnUQgGxKRF1QEOQSVSo8Joc2FO3vUFOZkkjQ8L1MwwkhDKjpurTfgX65Sfml73lHdINcXyzU6SpLMzBWzHKwVvcdiWEI7aUmA65BNMR7jY8BUkqMysbi3ha2NjwmUJoLeqIZN247MUEfLICYXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105143; c=relaxed/simple;
	bh=UBvCs62cvPabfSI0lCvQdjbJswL0fIL44kOyothi9n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ex86gZE1GPy+iPKbI5DUbnOuDLAtReH7fqA4qBpldDRKiFaSjOEAel+B0m9vVLghwwMOYUckx9YcoKBorIr0wDgwmMcQeuPO6T+0FP6Cu9aUlrgZkgv0yRSgvUc8kjxtUtW9+02ELqjpOkRvChS05V8K10JKKc/+3mAOBgP0OCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pdqSssT0; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pdqSssT0"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490c1915793so49531265e9.2
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 08:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781105139; x=1781709939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfg/xsM2Bv8eyC+xGaZwBBNmF0nFNh5uTDHm18lAqqo=;
        b=pdqSssT0sGwUsulu6fezHLR7mnTYoBg8i+MiZY0GLfOcwKskBeCnH8HV/JLldmh7mj
         PdNXkU9G85AMV68EeFfYEh/OmgfMIvtDPqnmdM1CF/Y6bAHtFTMIw7L3UwKBxcZxPfPj
         3uVvPeQvju88mrEieZoXg/flpEBEwGreUyhl16wpUWRO1+AazxX9n1+ZnsG+ipbo5feK
         Ru5HfMW8Xil6GfBQajyGMXgHdPtF+HqF1EAzsPwufZpkZc25tjw4eVU6wxFNpmBlupn3
         YKUj692ula13chn2l9sqFH6Jsgp2HtsukSXocoUL5BIXW4p9suzT1Dp+fg9R6FvnMW49
         F5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781105139; x=1781709939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dfg/xsM2Bv8eyC+xGaZwBBNmF0nFNh5uTDHm18lAqqo=;
        b=jdF1FjHfeFkD4Vk8uKBGa0OPR9BWxiQxo26aVsiBEdNSN8jpsEd9+JBE8qKPaJheIl
         1wqXd/sm3cSJHS3/tKR/ue1GneR84mZJYBEARnsoYHbyfGCHUNluf45G7Ag15JIibwvl
         G8BJRiy1xCpYBOQpifSMCqZhvqBYOzowajhs6VVXZHG7uVLm2grIcTowGbaCO5lWPaou
         aVCHcyWI4MkJ6bDKrKkDXT6pkISe9WjBAx06KFjbglJcALDnnapmp07j41mUb4qlLDtx
         fjPv5swBQ3kTTKoh34HFusrNmeAHsuXjZEQgDlCeYeWpXJ7Eslac23lvwgt53krD/MvZ
         hSWg==
X-Gm-Message-State: AOJu0YzTMly2EZNFRDiJYC/uIVOYRt97u3vcsbArRgGElaz6H4K6fcP5
	AO4HffiIcgqA3hDgqzcGcx7rj4NiYx0gzg3IBKEtpPpYSyMIz9F9e72/21dSPNMA5y8=
X-Gm-Gg: Acq92OFcqk8JXdkrjk9JFV8iajZfPrK8qie+hkEafve+dDocZrEI5P8Ldg4tbPsJU1E
	B3JfaWcPc7mDjmxcgooloqy5XDYFQq9Sk33fNP6i1/utiwWcj0VvrEf6FDRNLwciOWnRRS2b22V
	hdouqADBgbfmNtGqjPyMUZeoQxCAHDRL2V3NozyKCWrVOU4yxq44x/leKTqKVYHYJafQCEm8Xup
	+xwfl2iFwIT5hamVWOsXWBOpqob++fQCfAyl/xX0SDKtE711IHYoGUDsDCctFUk9gutxpuZ7Gw/
	k47sR5hNqH5fvVojbFWw5GzofKJ94h/EaKuOgLrH65kXSbJOMUxAWeZyta8CzAdEAJHZa1Ph0pU
	3cjIA35Q9liPvAjtRT30Xc2buCQOmOtmMPOSxOe3YJswVoG/GYq6v/LooS7X4eylahIr2ma2CHi
	/oqMI2wC/rzD/kxSfjtmjORzJd2u4asuxu5e08NV8gV77d4fsYg01vjpdlVAQm/I4=
X-Received: by 2002:a05:600c:620f:b0:490:3d62:eb0 with SMTP id 5b1f17b1804b1-490c2612b74mr380185485e9.24.1781105138821;
        Wed, 10 Jun 2026 08:25:38 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d6c65sm559103835e9.12.2026.06.10.08.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 08:25:38 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 10/10] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries
Date: Wed, 10 Jun 2026 11:24:13 -0400
Message-ID: <20260610152417.13576-11-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
References: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ext4.h            |  15 +++++
 fs/ext4/ioctl.c           |  62 ++++++++++++++++++++
 fs/ext4/namei.c           | 120 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/ext4.h |  13 +++++
 4 files changed, 210 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index defa18d98c74..975b0975e032 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1193,6 +1193,7 @@ struct ext4_inode_info {
 #ifdef CONFIG_FS_ENCRYPTION
 	struct fscrypt_inode_info *i_crypt_info;
 #endif
+	void *i_dirdata;
 };
 
 /*
@@ -2515,6 +2516,18 @@ struct ext4_dirent_hash {
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
@@ -3215,6 +3228,8 @@ static inline int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 }
 extern int ext4_dirblock_csum_verify(struct inode *inode,
 				     struct buffer_head *bh);
+extern int ext4_dirdata_set_lufid(struct inode *dir, const char *filename,
+			   int namelen, struct ext4_dentry_param *edp);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
 extern int ext4_search_dir(struct buffer_head *bh,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 1d0c3d4bdf47..9f32f21d9b3a 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1529,6 +1529,65 @@ static int ext4_ioctl_set_tune_sb(struct file *filp,
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
@@ -1912,6 +1971,8 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 					      (void __user *)arg);
 	case EXT4_IOC_SET_TUNE_SB_PARAM:
 		return ext4_ioctl_set_tune_sb(filp, (void __user *)arg);
+	case EXT4_IOC_SET_LUFID:
+		return ext4_ioctl_set_lufid(filp, arg);
 	default:
 		return -ENOTTY;
 	}
@@ -1991,6 +2052,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC_SETFSLABEL:
 	case EXT4_IOC_GETFSUUID:
 	case EXT4_IOC_SETFSUUID:
+	case EXT4_IOC_SET_LUFID:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c799f87d7459..65c53c08213a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2264,6 +2264,8 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	dfid = ext4_dentry_get_fid(inode->i_sb,
+		(struct ext4_dentry_param *)EXT4_I(inode)->i_dirdata);
 	if (!de) {
 		if (dfid)
 			dlen = dfid->df_header.ddh_length;
@@ -2605,6 +2607,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 {
 	struct inode *dir = d_inode(dentry->d_parent);
 
+	EXT4_I(inode)->i_dirdata = dentry->d_fsdata;
 	if (fscrypt_is_nokey_name(dentry))
 		return -ENOKEY;
 	return __ext4_add_entry(handle, dir, &dentry->d_name, inode);
@@ -4361,6 +4364,123 @@ static int ext4_rename2(struct mnt_idmap *idmap,
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
index 9c683991c32f..b04bbb2818a3 100644
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
+	__u8 esl_data_len;	/* length of LUFID data */
+	char  esl_name[255 + 1]; /* filename (NUL-terminated) */
+	char  esl_data[255 + 1]; /* LUFID data (raw bytes) */
+};
+
 /*
  * Flags used by EXT4_IOC_SHUTDOWN
  */
-- 
2.43.7

