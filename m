Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA2443F8A5
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 12:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033631; cv=none; b=jBm7OD2M2sJTlpK97j9tWH4jHMcMmmKmU6xWHbyofX6NbLSKT9OAfbl7lFktrdcJe7eHSiKKzuWlFTDgVLvTddroSVH4RjWFiygpyH22V48rXS8+TBz9OWzh6UV93KZLsMtpK4+9lCovFngEupBC+fV//l4P/mkTGb9pMXlJ9fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033631; c=relaxed/simple;
	bh=NKy37dMN+TZD+xnEhw8OU8lQ4qSc7fixOXUQsQWALww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm0CGrHXl8D9ILbNkuwHnFvczZYtsc8eej1AQ1B3+kadMVuDPQ6X3NBatAmzt6IE9tKsOZSwXyuY1i1N1V2RAGlbR/dmIUUcGjZq9rTQPSVA6pr2aGlIifB2LQnumJr2nmOB/4XXNW8MSFCgZ4wRKDOVvny7mo3yItQi45NGXAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HQ59L/is; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQ59L/is"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493e497643fso4839095e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 05:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784033628; x=1784638428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xdCshfKi3jIY3oF9YjMWCrcpVr4fGA6IDCkW9Spn1Dc=;
        b=HQ59L/isiiA43WDFmR+t4KIrS1vs9DVQEjmb96VLbA9AvaC8usTY7zXDJZzik2grUY
         z99nfgkkneVUghLRqXP7Hqp0xBDJMcquCzUs0CFKFZSRKnVahdunD41CImyxxBcKTnIa
         eKC2g5wJWSvbG9PsY9uCpvF0vgbcpWnGw09eqfgp3y8NPZcObTaGZ2WZNpl+aKvZwgDH
         ycXe32CrKrPbstOzpdpz0IRPOxc5isNUgPN49JFgmOCFGr5hqM08De+4nJC25FLTqIGc
         ccz+b3cJBewz22asa+OLV9MKt42cJ1RHrgnVAQGy5HOKbxpOJ/KnHAVLUmAskIy5AJOW
         yr3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784033628; x=1784638428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xdCshfKi3jIY3oF9YjMWCrcpVr4fGA6IDCkW9Spn1Dc=;
        b=U1kUhA9jzTjmsKRBUZg8DltAOh5rIq6GcfATtFIDQYVHO2+MdTiWElr6zb8r6Bjql1
         S4gLeCE8kiTLZC7QY88TZIbSHTZa2xBJB32I6qmieV/jSy3/T+iBwZQlQfEyJ3twXi8h
         sfSPQ9kQxfDi+g5Cel8IIm5LrTsI71OHyxGLPyqgjY90iwf30VvpB2nqu6sjneYY6GTU
         M0LOPs7cXp1E4ipbqx4ZB42D3wINwJYDWNPNDiVXZsWYCnDYXUlRj2nDJRmBVkLtHvNc
         Vtcs29bbJdo5kurJWhusMJVafMoUFneSf9X0u3ftOktGoYkrypoM5LAbBXqKuoeD8Pey
         RVcQ==
X-Gm-Message-State: AOJu0YynICb5gc1DLrer1NpLNMb/ulIZ1/YTaoQQtsWrsCL5EEWcX9io
	18Az3wTbr4L8VgEJNYJRJvUQH4ixcnOG4ApvtgrsBSTxmMkbP3P9qAhKJ6f5WRoEFVM=
X-Gm-Gg: AfdE7clcVCYwPeYwOR5GD0/YUZoy24XJIxY9v5WLl1aU8VUfBGYo1nJRDTAxF3mAwld
	k7BVvECUhOjXXXR2jScLbPWhSh6fMUvOKQhZ/O58sE+KtpRjzDypZe8sWDuov+y1kxmQUXilkU6
	xTe8OeVny2QPQfyKnn2n+gYycSuSQM4SyJFOAxwd576F9qGS+zyCwtgjVB8JLvg8JMlGOMsLFYt
	+Z25AdKHbeYFXYVPK4JC7nd8D8Mek+oFNomC3cSBHIlMGZPN5jX/SogT1oKEtSN3bhi/H9XMwuZ
	nL2sZ6P7lNdaeABJj2zQt0883B+nFYCVHgXeYgDPqwCKoY1Pm0VcSgT60FpArufd1GEArCHWIiY
	O++vjRJswTSMC+Id75U1/fbAGRVcco5nFVPdPUEM7g4014I1CylIbMxFDnxaWZ00RP4Bqj0bS6t
	bdsuCdraHai4r6HEdGXrVprO9+tfA2YVCwMnrsLMq7tfj4bQ==
X-Received: by 2002:a05:600c:3e88:b0:493:915b:dc4a with SMTP id 5b1f17b1804b1-493f87d8a97mr125862075e9.8.1784033627744;
        Tue, 14 Jul 2026 05:53:47 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:1827:2101:7130:c718:1edf:8590])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2ed840sm70052405e9.10.2026.07.14.05.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:53:47 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v5 11/11] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries
Date: Tue, 14 Jul 2026 08:51:09 -0400
Message-ID: <20260714125111.14699-12-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ext4.h            |   2 +
 fs/ext4/ioctl.c           |  84 ++++++++++++++++++++++
 fs/ext4/namei.c           | 148 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/ext4.h |  14 ++++
 4 files changed, 248 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d6ee2cc90191..15d885cf3bd0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3322,6 +3322,8 @@ static inline int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 }
 extern int ext4_dirblock_csum_verify(struct inode *inode,
 				     struct buffer_head *bh);
+extern int ext4_dirdata_set_lufid(struct inode *dir, const char *filename,
+			   int namelen, struct ext4_dentry_param *edp);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
 extern int ext4_search_dir(struct buffer_head *bh,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c8387e6a2c6e..b5421d59f7a0 100644
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
+	err = ext4_dirdata_set_lufid(dir, lufid_args.esl_name,
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
index 1eecb6b29b69..ba39ecc690bc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -4610,6 +4610,154 @@ static int ext4_rename2(struct mnt_idmap *idmap,
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

