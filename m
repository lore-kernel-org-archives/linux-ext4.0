Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541223845B3
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785608005; cv=none; b=BSQbfug2LLLZID+rrJjo1/GEepmx+cm+ICg7izWTiUTp5Wx1tVpfkIbqZ7tyZElxFXV6UQqSGjTr6d/stgJ8dzqXGeoUSLqUNrkr4qDALRcG+7iwp2dqXXvK447om8GbmpclTSj8m8n64+0yyxBIMPV6bp/rxsyRkYuJysO9xe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785608005; c=relaxed/simple;
	bh=+zjqR6vqf7RM+VHUyRO9LuGIEEpImvSh+FON1qC2NZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gzQkyYJPnOXa/XPSVYS3P1+yLi5J1o0WSujK2t+uqxO4Sx1QrGkbVkb7ddNS6HxVaFLIlncqPcrSAZok2yxUOITKcxl+rsxRSh4QhLIoKj1HNzpEpk5Be8sdWZyr1744VMzDfqg8FukSu3gTARPKGJZFcnoo9EjZnOKH3E+qvgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MqJdkP06; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MqJdkP06"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4720f3bf164so1916999f8f.1
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 11:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785608002; x=1786212802; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oFWfJJM6MgHEZd2mWy3WS21qnjFf+k6Jc+fPKp5ygXI=;
        b=MqJdkP06p0JRAkMSO7qs0V4KfovSfBHZzvFn8ehahGfoQkpfmoWPIRWQB1uuUp4hdQ
         7QP0lIMsG156Mxsn9KTiPDftU1JjKGviFc/OoNdD02n3ubZ03m5UdKwlMQLU+aY5k8BL
         7NA8KQjcZEEugVzhMObwsBnauJe8CCaIBIMyvtMf0P3GL4aPMoTaidRjVN/U0d36Tqwx
         s4VryWfQpb1mlt4CBOVcoh30k+/ZtXTEpHkAWw9t4WXQeLljVyjA8tGTJIevGvc7fIP4
         FQJkmVt/KM4/3HuBH6qPCSVBgYEcZCEne2iBB51Ae1sdS4nHBN/OWhcwvioyhpcg0q2J
         febQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785608002; x=1786212802;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oFWfJJM6MgHEZd2mWy3WS21qnjFf+k6Jc+fPKp5ygXI=;
        b=VXK/OoyGSjd09zDfcstDlDYecu99z1deWQDc/b5aZpSalScozNwUWc8Agel8zGoulR
         zX59/9AkXb9ih3Zx5uiQD1kwaXkaDMAI3mesyso+dKfWYlkANym4L3f/MD16Csc/kvNr
         8JGTlSKG0DFfX2Qe9K4456ZTbWJQHHIMB3LN7kCavuTeuqz7dUN3ow7fz7yH9HZ2Bz2g
         /3BrcE4fFln25iPCOJDO77khuMCpyZjCfcfB8dK0IiDT2oYuJkO/EIsLLHQL/2H9jQi4
         D0Rc+JzJDOnTekMVum4HjZpF7p1RtYTDZahgBFFh/HlCKgdr0dDDPblBldx8+XDQyDpW
         bIWg==
X-Gm-Message-State: AOJu0Yy6JYir9p9ouy00PLi9B48h8rLVVQj3ulXg4O7mraV8iWhsRXBA
	2lbc5oZEthlIewRpVkz1w9ZN/uQ9xbdMjcey2cleRVH/5eQCEVRwuL4pewVyQg==
X-Gm-Gg: AR+sD10fCeCDQ8Fg6q0Lgl91j62MMDoAa5h5nyP41fT6bB2RU9jwSND3ZPTVf/bUeL0
	Tv/v6g1Bj90LU6wcF+dkAzFTu4dhCgqnoAIAVgXif8pavfgr9HwDQPYfljfAoHf4Au/lwLmxv3T
	4E1eKdnctl7pZKWC1JTi1kC4eRxxod36slJB+jiEF3nMvhILfPyOK6IZiSyVfCadnTjl1+M1ajv
	3/w3ifOmA6DwShJYqmQn+WzmjqvCxcbjhknwLKUOXh6RGCYJATWjmSU2vL3dfkaFRCD2REzqWDJ
	6YuWPccnxOF67fFCl0mAzinwYRuWP05fDVkaVM31WWaG728PkzAZQvLpugPXgP5bjjnpgKLGFU4
	0Nn1aevRr4fDgBi7vYXg7gmHmHf90AZRLwUhTLt1XAit9sAHQ7vN5U6BWFiomr82IjKQJ4MxtKN
	taCgarsznxBsQfiNhV726jg7HGVL3itIcZr4Ir+9qgaSqrQFSrlwl2nxXL9CwNCawyLB0MuFbmb
	qAUMRWtK2//7OnB3Hi5
X-Received: by 2002:a5d:5e8e:0:b0:47f:71a0:c060 with SMTP id ffacd0b85a97d-47fd32b19c5mr12836407f8f.2.1785608001454;
        Sat, 01 Aug 2026 11:13:21 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458adc9sm18819761f8f.27.2026.08.01.11.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 11:13:21 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v12 11/11] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries
Date: Sat,  1 Aug 2026 14:12:25 -0400
Message-ID: <20260801181227.5198-12-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
References: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 fs/ext4/ext4.h            |  25 +--
 fs/ext4/inline.c          |   4 +-
 fs/ext4/ioctl.c           |  85 ++++++++++
 fs/ext4/namei.c           | 347 +++++++++++++++++++++++++++++++++++---
 include/uapi/linux/ext4.h |  14 ++
 6 files changed, 443 insertions(+), 35 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 2a7d85e60ae2..81697fce5e30 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -491,7 +491,8 @@ int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
 	p = &info->root.rb_node;
 
 	/* Create and allocate the fname structure */
-	if (dirent->file_type & ~EXT4_FT_MASK) {
+	if (ext4_has_feature_dirdata(dir_file->f_inode->i_sb) &&
+	    (dirent->file_type & ~EXT4_FT_MASK)) {
 		unsigned int rec_len =
 			ext4_rec_len_from_disk(dirent->rec_len, buf_size);
 		extra_data = ext4_dirent_get_data_len(dirent, rec_len);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 248c8c15e5ba..cb4bd66a2e41 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2606,7 +2606,7 @@ struct ext4_dirent_fid *ext4_dentry_get_fid(struct super_block *sb,
 	if (!ext4_has_feature_dirdata(sb))
 		return NULL;
 	if (p && p->edp_magic == EXT4_LUFID_MAGIC)
-		return &p->edp_dfid;
+		return (struct ext4_dirent_fid *)p->edp_dfid;
 
 	return NULL;
 }
@@ -3056,17 +3056,17 @@ extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
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
@@ -3321,6 +3321,9 @@ static inline int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 }
 extern int ext4_dirblock_csum_verify(struct inode *inode,
 				     struct buffer_head *bh);
+extern int ext4_dirdata_set_lufid(struct mnt_idmap *idmap, struct inode *dir,
+			   const char *filename, int namelen,
+			   struct ext4_dentry_param *edp);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
 extern int ext4_search_dir(struct buffer_head *bh,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index e8b919430da1..ac984e576898 100644
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
index c8387e6a2c6e..5bac4ad834ad 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1535,6 +1535,88 @@ static int ext4_ioctl_set_tune_sb(struct file *filp,
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
+	 * open (which only ever requires read access) is not enough.
+	 * MAY_EXEC is required for entry lookup; MAY_WRITE for modification. */
+	err = inode_permission(idmap, dir, MAY_WRITE | MAY_EXEC);
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
@@ -1921,6 +2003,8 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 					      (void __user *)arg);
 	case EXT4_IOC_SET_TUNE_SB_PARAM:
 		return ext4_ioctl_set_tune_sb(filp, (void __user *)arg);
+	case EXT4_IOC_SET_LUFID:
+		return ext4_ioctl_set_lufid(filp, arg);
 	default:
 		return -ENOTTY;
 	}
@@ -2000,6 +2084,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC_SETFSLABEL:
 	case EXT4_IOC_GETFSUUID:
 	case EXT4_IOC_SETFSUUID:
+	case EXT4_IOC_SET_LUFID:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 41719844e8f0..483cf92c6641 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -543,11 +543,13 @@ static struct dx_root_info *dx_get_dx_info(struct inode *dir, void *de_buf)
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
 
@@ -555,6 +557,11 @@ static struct dx_root_info *dx_get_dx_info(struct inode *dir, void *de_buf)
 	if (de_buf < base || (char *)de_buf - (char *)base +
 	    EXT4_BASE_DIR_LEN > blocksize)
 		return ERR_PTR(-EFSCORRUPTED);
+	rlen = ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->rec_len,
+				      blocksize);
+	if (rlen < EXT4_BASE_DIR_LEN ||
+	    (char *)de_buf - (char *)base + rlen > blocksize)
+		return ERR_PTR(-EFSCORRUPTED);
 	de_buf += ext4_dir_entry_len(de_buf, blocksize, NULL);
 
 	if (de_buf < base || (char *)de_buf - (char *)base +
@@ -614,6 +621,9 @@ static inline unsigned dx_root_limit(struct inode *dir,
 	info = dx_get_dx_info(dir, dot_de);
 	if (IS_ERR(info))
 		return 0;
+	if ((char *)info - (char *)dot_de + info->info_length >
+	    dir->i_sb->s_blocksize)
+		return 0;
 	entry_space = dir->i_sb->s_blocksize - ((char *)info - (char *)dot_de) -
 		info->info_length;
 
@@ -1485,9 +1495,9 @@ unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de, struct inode *dir,
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
@@ -1508,7 +1518,7 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 
 		if (EXT4_BASE_DIR_LEN + data_offset + dlen > rec_len) {
 			EXT4_ERROR_INODE(dir, "Can not insert FID");
-			return;
+			return -EIO;
 		}
 
 		memcpy((char *)de + EXT4_BASE_DIR_LEN + data_offset, dfid, dlen);
@@ -1523,7 +1533,7 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 
 			if (EXT4_BASE_DIR_LEN + data_offset + sizeof(*dh) > rec_len) {
 				EXT4_ERROR_INODE(dir, "Can not insert dhash dirdata");
-				return;
+				return -EIO;
 			}
 
 			dh->dh_header.ddh_length = sizeof(*dh);
@@ -1531,11 +1541,18 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
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
@@ -1543,6 +1560,7 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 						cpu_to_le32(hinfo->minor_hash);
 		}
 	}
+	return 0;
 }
 
 /*
@@ -2372,9 +2390,9 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
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
 
@@ -2392,7 +2410,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
 	de->name_len = fname_len(fname);
 	memcpy(de->name, fname_name(fname), fname_len(fname));
-	ext4_dirdata_set(de, dir, data, fname);
+	return ext4_dirdata_set(de, dir, data, fname);
 }
 
 /*
@@ -2444,7 +2462,11 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
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
@@ -3258,14 +3280,15 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
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
 
@@ -3285,7 +3308,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			blocksize - csum_size);
 	} else {
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + ext4_dirent_rec_len(1, NULL)),
+					(csum_size + dot_rec_len),
 					blocksize);
 	}
 
@@ -3318,6 +3341,12 @@ int ext4_init_new_dir_data(handle_t *handle, struct inode *dir,
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
@@ -4451,14 +4480,13 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (!new.bh && old_snap.fid) {
 		unsigned fid_size = old_snap.fid->df_header.ddh_length;
 
-		edp = kmalloc(offsetof(struct ext4_dentry_param,
-				       edp_dfid) + fid_size, GFP_NOFS);
+		edp = kmalloc(sizeof(*edp) + fid_size, GFP_NOFS);
 		if (!edp) {
 			retval = -ENOMEM;
 			goto end_rename;
 		}
 		edp->edp_magic = EXT4_LUFID_MAGIC;
-		memcpy(&edp->edp_dfid, old_snap.fid, fid_size);
+		memcpy(edp->edp_dfid, old_snap.fid, fid_size);
 	}
 
 	if (whiteout) {
@@ -4578,6 +4606,21 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	ext4_lufid_snap_release(&old_snap);
 	if (whiteout) {
 		if (retval) {
+			/* Known limitation: if the old entry carried both LUFID
+			 * and CFHASH, ext4_setent_compact_exts() slid CFHASH
+			 * into the LUFID slot above, and old_snap was released
+			 * before this point, so resetent can only restore the
+			 * LUFID flag — not the original byte layout.  This
+			 * leaves the entry with CFHASH data at the LUFID offset
+			 * and garbage at the CFHASH offset until the next
+			 * SET_LUFID ioctl re-writes it.  The scenario requires
+			 * RENAME_WHITEOUT on a casefolded+encrypted dirdata
+			 * directory whose entry has a LUFID, followed by a
+			 * journal IO error in the single ext4_mark_inode_dirty()
+			 * call that follows — an extremely unlikely combination
+			 * in practice.  (OOM during the LUFID wrapper allocation
+			 * cannot trigger this path because that allocation is
+			 * hoisted before ext4_setent() modifies the entry.) */
 			ext4_resetent(handle, &old,
 				      old.inode->i_ino, old_file_type);
 			drop_nlink(whiteout);
@@ -4790,6 +4833,266 @@ static int ext4_rename2(struct mnt_idmap *idmap,
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
+	struct ext4_lufid_snap old_snap = {};
+	struct qstr d_name;
+	/* on-disk name snapshot for non-encrypted casefolded directories: the
+	 * on-disk case may differ from what the caller supplied. */
+	char ondisk_name[EXT4_NAME_LEN];
+	struct qstr real_name = {};
+	/* name to pass to ext4_add_entry() for the re-add and rollback */
+	const struct qstr *add_name;
+	__u32 ino = 0;
+	bool child_locked = false;
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
+	/* Lock dir with the VFS parent-mutation subclass.  The lookup and any
+	 * mutation must be inside this lock to prevent TOCTOU races. */
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+
+	/* Phase 1: look up the entry without holding a journal handle to
+	 * obtain the child inode reference before taking the child lock.
+	 * VFS locking order requires all inode locks to be acquired before
+	 * starting a jbd2 transaction; starting the journal while already
+	 * holding the child lock would invert that order and risk deadlock
+	 * if jbd2 blocks waiting for a commit that the child lock holder
+	 * prevents from finishing. */
+	bh = ext4_find_entry(dir, &d_name, &de, NULL);
+	if (IS_ERR(bh)) {
+		err = PTR_ERR(bh);
+		bh = NULL;
+		goto out_unlock_dir;
+	}
+	if (!bh) {
+		err = -ENOENT;
+		goto out_unlock_dir;
+	}
+	ino = le32_to_cpu(de->inode);
+	brelse(bh);
+	bh = NULL;
+	de = NULL;
+
+	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		inode = NULL;
+		goto out_unlock_dir;
+	}
+
+	/* Enforce sticky-bit restriction: on a sticky directory only the
+	 * directory owner, the file owner, or a privileged process may
+	 * modify entries.  inode_permission(MAY_WRITE) alone does not cover
+	 * this, so check it explicitly here as may_delete() does. */
+	err = check_sticky(idmap, dir, inode);
+	if (err)
+		goto out_iput;
+
+	/* The ioctl calls ext4_delete_entry() on the parent directory, which
+	 * bypasses the VFS may_delete() path.  inode_permission(MAY_WRITE)
+	 * above blocks IS_IMMUTABLE(dir) but does NOT block IS_APPEND(dir):
+	 * append-only directories allow new entries but forbid deletion, and
+	 * that restriction lives only in may_delete(), not in
+	 * inode_permission().  Enforce it explicitly here. */
+	if (IS_APPEND(dir)) {
+		err = -EPERM;
+		goto out_iput;
+	}
+
+	/* The ioctl deletes and re-creates the directory entry, which
+	 * effectively modifies the target file's namespace presence.
+	 * Refuse if the target itself is immutable or append-only. */
+	if (IS_IMMUTABLE(inode) || IS_APPEND(inode)) {
+		err = -EPERM;
+		goto out_iput;
+	}
+
+	/* Lock the target inode BEFORE starting the journal (dir-then-child,
+	 * VFS-locks-before-journal ordering).  Use I_MUTEX_CHILD for directory
+	 * inodes (consistent with VFS rename/rmdir) and I_MUTEX_NONDIR2 for
+	 * all others; mixing subclasses on the same inode triggers lockdep
+	 * cycles with concurrent rename. */
+	if (inode != dir) {
+		if (S_ISDIR(inode->i_mode))
+			inode_lock_nested(inode, I_MUTEX_CHILD);
+		else
+			inode_lock_nested(inode, I_MUTEX_NONDIR2);
+		child_locked = true;
+	}
+
+	handle = ext4_journal_start(dir, EXT4_HT_DIR,
+				    3 * EXT4_DATA_TRANS_BLOCKS(sb) +
+				    2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		handle = NULL;
+		goto out_unlock;
+	}
+
+	/* Phase 2: re-look up the entry inside the journal to obtain a stable
+	 * de pointer.  Verify it still refers to the same inode (TOCTOU
+	 * guard: a concurrent unlink+create between phase 1 and here would
+	 * change the inode number). */
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
+	if (le32_to_cpu(de->inode) != ino) {
+		err = -ENOENT;
+		goto out_brelse;
+	}
+
+	/* Choose the name to use for re-adding the entry after deletion.
+	 *
+	 * For non-encrypted casefolded directories ext4_find_entry() matches
+	 * case-insensitively, so de->name may differ in case from the
+	 * caller-supplied filename.  Re-adding with the caller's case would
+	 * silently rename the entry, so preserve the on-disk bytes.
+	 *
+	 * For encrypted directories (with or without casefold) de->name holds
+	 * the raw ciphertext.  ext4_fname_setup_filename() deterministically
+	 * re-encrypts d_name (the plaintext) to the identical ciphertext, so
+	 * using d_name for the re-add is correct.  Passing the raw ciphertext
+	 * bytes would cause double-encryption and make the entry unreachable. */
+	if (IS_CASEFOLDED(dir) && !IS_ENCRYPTED(dir)) {
+		memcpy(ondisk_name, de->name, de->name_len);
+		real_name.name = ondisk_name;
+		real_name.len = de->name_len;
+		add_name = &real_name;
+	} else {
+		add_name = &d_name;
+	}
+
+	/* Snapshot the old LUFID before deleting so we can restore it if the
+	 * re-add fails.  Without this the rollback path re-adds the entry
+	 * without any LUFID, silently orphaning the old FID-to-path mapping. */
+	err = ext4_lufid_snapshot(de, sb->s_blocksize, &old_snap);
+	if (err)
+		goto out_brelse;
+
+	err = ext4_delete_entry(handle, dir, de, bh);
+	if (err)
+		goto out_brelse;
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
+			.d_name = *add_name,
+			.d_parent = &parent_dentry,
+			.d_inode = inode,
+			.d_fsdata = edp,
+		};
+		err = ext4_add_entry(handle, &new_dentry, inode);
+	}
+
+	if (err) {
+		/* Delete succeeded but re-add failed; try to restore so the
+		 * inode is not left without a directory entry.  Restore the
+		 * original LUFID too: without it the entry is re-added clean
+		 * and the old FID-to-path mapping is silently lost. */
+		struct dentry parent_dentry = { .d_inode = dir };
+		struct dentry orig_dentry = {
+			.d_name = *add_name,
+			.d_parent = &parent_dentry,
+			.d_inode = inode,
+		};
+		int rollback_err;
+
+		if (old_snap.fid) {
+			unsigned int fid_size = old_snap.fid->df_header.ddh_length;
+			struct ext4_dentry_param *old_edp =
+				kmalloc(sizeof(*old_edp) + fid_size, GFP_NOFS);
+
+			if (old_edp) {
+				old_edp->edp_magic = EXT4_LUFID_MAGIC;
+				memcpy(old_edp->edp_dfid, old_snap.fid, fid_size);
+				orig_dentry.d_fsdata = old_edp;
+			}
+		}
+
+		rollback_err = ext4_add_entry(handle, &orig_dentry, inode);
+		kfree(orig_dentry.d_fsdata);
+
+		if (rollback_err)
+			EXT4_ERROR_INODE(dir,
+				"Failed to set LUFID on '%.*s' (err=%d) and failed to restore the original directory entry (err=%d); inode %llu may be orphaned",
+				namelen, filename, err, rollback_err,
+				(unsigned long long)inode->i_ino);
+		goto out_journal;
+	}
+
+	inode_set_ctime_current(dir);
+	inode_inc_iversion(dir);
+	ext4_mark_inode_dirty(handle, dir);
+
+out_brelse:
+	brelse(bh);
+out_journal:
+	ext4_lufid_snap_release(&old_snap);
+	if (handle)
+		ext4_journal_stop(handle);
+out_unlock:
+	if (child_locked)
+		inode_unlock(inode);
+out_iput:
+	iput(inode);
+out_unlock_dir:
+	inode_unlock(dir);
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

