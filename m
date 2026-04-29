Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2A234D4DE;
	Wed, 29 Apr 2026 14:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474796; cv=none; b=E8g4/C72zbPNZwa9S8xWZkxqWTWIvKId3viQobYS99z1YQoAKOC6o0XL1O6PwtmQRfUsOQWNZUIcaIz4vsebl5qHhOYWEQ6fQkn3In9w5vWRYtdmyMSitytJQHF4LFpr3urNy2hpVwe9OJh9a0nn3foMK60sLh7F56afNA1MsYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474796; c=relaxed/simple;
	bh=wkTRk0lyQcXtUZPg/xHMF/gqicvuifEmlCVCYczKjXI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qITYlTVNM+yC4fof6gKEiXokms9NNveDj42Bhb9mSHUneZdoroSHe78vbJBwdnimxmuSFaOO27CZzqvJxuXIELNvhGbrF6O9mzI20AMeEeirdHgxjSC3xn+r2sFZmr55dGjwYdIQ3fUrapGZq+eZNmRxw4WFJaeAquc0BidUgvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/CzXCB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/CzXCB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5ECEC19425;
	Wed, 29 Apr 2026 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474795;
	bh=wkTRk0lyQcXtUZPg/xHMF/gqicvuifEmlCVCYczKjXI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c/CzXCB/IjVgBzHF3LFPg+1ku7eOKSqK/g/vlK2yiqh/ItKr+1FQckhdNrp4b1xXo
	 f2XElRwaVzg16vdO2dqQPcwgTuM1ykBFBGF0e1L5NfATIldc95d22IeFjO/FOrx+Vm
	 Nl0lz4xuVAuxnw4R8DmgR1knBNYwZgtGujh/+MtxVwrZRRBDbov6f6UUTcckI80217
	 QyDiJzpZla+ann3nhhdETLvbW8yaFhn64SfjFsaXHDlhXGvZ/wn7/1mWUT7WCeigWH
	 4HPIpHPb7FK3pFjVl5rtKW6ld+MPFucwvcZTT8mXtTjSxq1+coXYM/4UWE08/jC96r
	 XyYkze2bmIWDA==
Date: Wed, 29 Apr 2026 07:59:55 -0700
Subject: [PATCH 05/10] fuse2fs: debug timestamp updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215472.4110156.17046590126106040747.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215344.4110156.17216553139316774040.stgit@frogsfrogsfrogs>
References: <177747215344.4110156.17216553139316774040.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add tracing for timestamp updates to files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 misc/fuse2fs.c |   97 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 36 deletions(-)


diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 2e0fdeda963de2..935a66af66603e 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -865,7 +865,8 @@ static void increment_version(struct ext2_inode_large *inode)
 		inode->i_version_hi = ver >> 32;
 }
 
-static void init_times(struct ext2_inode_large *inode)
+static void fuse2fs_init_timestamps(struct fuse2fs *ff, ext2_ino_t ino,
+				    struct ext2_inode_large *inode)
 {
 	struct timespec now;
 
@@ -875,11 +876,15 @@ static void init_times(struct ext2_inode_large *inode)
 	EXT4_INODE_SET_XTIME(i_mtime, &now, inode);
 	EXT4_EINODE_SET_XTIME(i_crtime, &now, inode);
 	increment_version(inode);
+
+	dbg_printf(ff, "%s: ino=%u time %ld:%lu\n", __func__, ino, now.tv_sec,
+		   now.tv_nsec);
 }
 
-static int update_ctime(ext2_filsys fs, ext2_ino_t ino,
-			struct ext2_inode_large *pinode)
+static int fuse2fs_update_ctime(struct fuse2fs *ff, ext2_ino_t ino,
+				struct ext2_inode_large *pinode)
 {
+	ext2_filsys fs = ff->fs;
 	errcode_t err;
 	struct timespec now;
 	struct ext2_inode_large inode;
@@ -890,6 +895,10 @@ static int update_ctime(ext2_filsys fs, ext2_ino_t ino,
 	if (pinode) {
 		increment_version(pinode);
 		EXT4_INODE_SET_XTIME(i_ctime, &now, pinode);
+
+		dbg_printf(ff, "%s: ino=%u ctime %ld:%lu\n", __func__, ino,
+			   now.tv_sec, now.tv_nsec);
+
 		return 0;
 	}
 
@@ -901,6 +910,9 @@ static int update_ctime(ext2_filsys fs, ext2_ino_t ino,
 	increment_version(&inode);
 	EXT4_INODE_SET_XTIME(i_ctime, &now, &inode);
 
+	dbg_printf(ff, "%s: ino=%u ctime %ld:%lu\n", __func__, ino,
+		   now.tv_sec, now.tv_nsec);
+
 	err = fuse2fs_write_inode(fs, ino, &inode);
 	if (err)
 		return translate_error(fs, ino, err);
@@ -908,8 +920,9 @@ static int update_ctime(ext2_filsys fs, ext2_ino_t ino,
 	return 0;
 }
 
-static int update_atime(ext2_filsys fs, ext2_ino_t ino)
+static int fuse2fs_update_atime(struct fuse2fs *ff, ext2_ino_t ino)
 {
+	ext2_filsys fs = ff->fs;
 	errcode_t err;
 	struct ext2_inode_large inode, *pinode;
 	struct timespec atime, mtime, now;
@@ -928,6 +941,10 @@ static int update_atime(ext2_filsys fs, ext2_ino_t ino)
 	dmtime = mtime.tv_sec + ((double)mtime.tv_nsec / NSEC_PER_SEC);
 	dnow = now.tv_sec + ((double)now.tv_nsec / NSEC_PER_SEC);
 
+	dbg_printf(ff, "%s: ino=%u atime %ld:%lu mtime %ld:%lu now %ld:%lu\n",
+		   __func__, ino, atime.tv_sec, atime.tv_nsec, mtime.tv_sec,
+		   mtime.tv_nsec, now.tv_sec, now.tv_nsec);
+
 	/*
 	 * If atime is newer than mtime and atime hasn't been updated in thirty
 	 * seconds, skip the atime update.  Same idea as Linux "relatime".  Use
@@ -944,9 +961,10 @@ static int update_atime(ext2_filsys fs, ext2_ino_t ino)
 	return 0;
 }
 
-static int update_mtime(ext2_filsys fs, ext2_ino_t ino,
-			struct ext2_inode_large *pinode)
+static int fuse2fs_update_mtime(struct fuse2fs *ff, ext2_ino_t ino,
+				struct ext2_inode_large *pinode)
 {
+	ext2_filsys fs = ff->fs;
 	errcode_t err;
 	struct ext2_inode_large inode;
 	struct timespec now;
@@ -956,6 +974,10 @@ static int update_mtime(ext2_filsys fs, ext2_ino_t ino,
 		EXT4_INODE_SET_XTIME(i_mtime, &now, pinode);
 		EXT4_INODE_SET_XTIME(i_ctime, &now, pinode);
 		increment_version(pinode);
+
+		dbg_printf(ff, "%s: ino=%u mtime/ctime %ld:%lu\n",
+			   __func__, ino, now.tv_sec, now.tv_nsec);
+
 		return 0;
 	}
 
@@ -968,6 +990,9 @@ static int update_mtime(ext2_filsys fs, ext2_ino_t ino,
 	EXT4_INODE_SET_XTIME(i_ctime, &now, &inode);
 	increment_version(&inode);
 
+	dbg_printf(ff, "%s: ino=%u mtime/ctime %ld:%lu\n",
+		   __func__, ino, now.tv_sec, now.tv_nsec);
+
 	err = fuse2fs_write_inode(fs, ino, &inode);
 	if (err)
 		return translate_error(fs, ino, err);
@@ -2237,7 +2262,7 @@ static int op_readlink(const char *path, char *buf, size_t len)
 	buf[len] = 0;
 
 	if (fuse2fs_is_writeable(ff)) {
-		ret = update_atime(fs, ino);
+		ret = fuse2fs_update_atime(ff, ino);
 		if (ret)
 			goto out;
 	}
@@ -2511,7 +2536,7 @@ static int op_mknod(const char *path, mode_t mode, dev_t dev)
 		goto out2;
 	}
 
-	ret = update_mtime(fs, parent, NULL);
+	ret = fuse2fs_update_mtime(ff, parent, NULL);
 	if (ret)
 		goto out2;
 
@@ -2534,7 +2559,7 @@ static int op_mknod(const char *path, mode_t mode, dev_t dev)
 	}
 
 	inode.i_generation = ff->next_generation++;
-	init_times(&inode);
+	fuse2fs_init_timestamps(ff, child, &inode);
 	err = fuse2fs_write_inode(fs, child, &inode);
 	if (err) {
 		ret = translate_error(fs, child, err);
@@ -2620,7 +2645,7 @@ static int op_mkdir(const char *path, mode_t mode)
 		goto out2;
 	}
 
-	ret = update_mtime(fs, parent, NULL);
+	ret = fuse2fs_update_mtime(ff, parent, NULL);
 	if (ret)
 		goto out2;
 
@@ -2647,7 +2672,7 @@ static int op_mkdir(const char *path, mode_t mode)
 	if (parent_sgid)
 		inode.i_mode |= S_ISGID;
 	inode.i_generation = ff->next_generation++;
-	init_times(&inode);
+	fuse2fs_init_timestamps(ff, child, &inode);
 
 	err = fuse2fs_write_inode(fs, child, &inode);
 	if (err) {
@@ -2730,7 +2755,7 @@ static int fuse2fs_unlink(struct fuse2fs *ff, const char *path,
 	if (err)
 		return translate_error(fs, dir, err);
 
-	ret = update_mtime(fs, dir, NULL);
+	ret = fuse2fs_update_mtime(ff, dir, NULL);
 	if (ret)
 		return ret;
 
@@ -2821,7 +2846,7 @@ static int remove_inode(struct fuse2fs *ff, ext2_ino_t ino)
 			ext2fs_set_dtime(fs, EXT2_INODE(&inode));
 	}
 
-	ret = update_ctime(fs, ino, &inode);
+	ret = fuse2fs_update_ctime(ff, ino, &inode);
 	if (ret)
 		return ret;
 
@@ -2991,7 +3016,7 @@ static int __op_rmdir(struct fuse2fs *ff, const char *path)
 			goto out;
 		}
 		ext2fs_dec_nlink(EXT2_INODE(&inode));
-		ret = update_mtime(fs, rds.parent, &inode);
+		ret = fuse2fs_update_mtime(ff, rds.parent, &inode);
 		if (ret)
 			goto out;
 		err = fuse2fs_write_inode(fs, rds.parent, &inode);
@@ -3088,7 +3113,7 @@ static int op_symlink(const char *src, const char *dest)
 	}
 
 	/* Update parent dir's mtime */
-	ret = update_mtime(fs, parent, NULL);
+	ret = fuse2fs_update_mtime(ff, parent, NULL);
 	if (ret)
 		goto out2;
 
@@ -3112,7 +3137,7 @@ static int op_symlink(const char *src, const char *dest)
 	fuse2fs_set_uid(&inode, ctxt->uid);
 	fuse2fs_set_gid(&inode, gid);
 	inode.i_generation = ff->next_generation++;
-	init_times(&inode);
+	fuse2fs_init_timestamps(ff, child, &inode);
 
 	err = fuse2fs_write_inode(fs, child, &inode);
 	if (err) {
@@ -3397,11 +3422,11 @@ static int op_rename(const char *from, const char *to,
 	}
 
 	/* Update timestamps */
-	ret = update_ctime(fs, from_ino, NULL);
+	ret = fuse2fs_update_ctime(ff, from_ino, NULL);
 	if (ret)
 		goto out2;
 
-	ret = update_mtime(fs, to_dir_ino, NULL);
+	ret = fuse2fs_update_mtime(ff, to_dir_ino, NULL);
 	if (ret)
 		goto out2;
 
@@ -3495,7 +3520,7 @@ static int op_link(const char *src, const char *dest)
 	}
 
 	ext2fs_inc_nlink(fs, EXT2_INODE(&inode));
-	ret = update_ctime(fs, ino, &inode);
+	ret = fuse2fs_update_ctime(ff, ino, &inode);
 	if (ret)
 		goto out2;
 
@@ -3514,7 +3539,7 @@ static int op_link(const char *src, const char *dest)
 		goto out2;
 	}
 
-	ret = update_mtime(fs, parent, NULL);
+	ret = fuse2fs_update_mtime(ff, parent, NULL);
 	if (ret)
 		goto out2;
 
@@ -3662,7 +3687,7 @@ static int op_chmod(const char *path, mode_t mode, struct fuse_file_info *fi)
 
 	inode.i_mode = new_mode;
 
-	ret = update_ctime(fs, ino, &inode);
+	ret = fuse2fs_update_ctime(ff, ino, &inode);
 	if (ret)
 		goto out;
 
@@ -3729,7 +3754,7 @@ static int op_chown(const char *path, uid_t owner, gid_t group,
 		fuse2fs_set_gid(&inode, group);
 	}
 
-	ret = update_ctime(fs, ino, &inode);
+	ret = fuse2fs_update_ctime(ff, ino, &inode);
 	if (ret)
 		goto out;
 
@@ -3859,7 +3884,7 @@ static int fuse2fs_truncate(struct fuse2fs *ff, ext2_ino_t ino, off_t new_size)
 	if (err)
 		return translate_error(fs, ino, err);
 
-	ret = update_mtime(fs, ino, NULL);
+	ret = fuse2fs_update_mtime(ff, ino, NULL);
 	if (ret)
 		return ret;
 
@@ -4094,7 +4119,7 @@ static int op_read(const char *path EXT2FS_ATTR((unused)), char *buf,
 	}
 
 	if (fh->check_flags != X_OK && fuse2fs_is_writeable(ff)) {
-		ret = update_atime(fs, fh->ino);
+		ret = fuse2fs_update_atime(ff, fh->ino);
 		if (ret)
 			goto out;
 	}
@@ -4178,7 +4203,7 @@ static int op_write(const char *path EXT2FS_ATTR((unused)),
 		goto out;
 	}
 
-	ret = update_mtime(fs, fh->ino, NULL);
+	ret = fuse2fs_update_mtime(ff, fh->ino, NULL);
 	if (ret)
 		goto out;
 
@@ -4540,7 +4565,7 @@ static int op_setxattr(const char *path EXT2FS_ATTR((unused)),
 		goto out2;
 	}
 
-	ret = update_ctime(fs, ino, NULL);
+	ret = fuse2fs_update_ctime(ff, ino, NULL);
 out2:
 	err = ext2fs_xattrs_close(&h);
 	if (!ret && err)
@@ -4634,7 +4659,7 @@ static int op_removexattr(const char *path, const char *key)
 		goto out2;
 	}
 
-	ret = update_ctime(fs, ino, NULL);
+	ret = fuse2fs_update_ctime(ff, ino, NULL);
 out2:
 	err = ext2fs_xattrs_close(&h);
 	if (err && !ret)
@@ -4752,7 +4777,7 @@ static int op_readdir(const char *path EXT2FS_ATTR((unused)), void *buf,
 	}
 
 	if (fuse2fs_is_writeable(ff)) {
-		ret = update_atime(i.fs, fh->ino);
+		ret = fuse2fs_update_atime(ff, fh->ino);
 		if (ret)
 			goto out;
 	}
@@ -4857,7 +4882,7 @@ static int op_create(const char *path, mode_t mode, struct fuse_file_info *fp)
 		goto out2;
 	}
 
-	ret = update_mtime(fs, parent, NULL);
+	ret = fuse2fs_update_mtime(ff, parent, NULL);
 	if (ret)
 		goto out2;
 
@@ -4888,7 +4913,7 @@ static int op_create(const char *path, mode_t mode, struct fuse_file_info *fp)
 	}
 
 	inode.i_generation = ff->next_generation++;
-	init_times(&inode);
+	fuse2fs_init_timestamps(ff, child, &inode);
 	err = fuse2fs_write_inode(fs, child, &inode);
 	if (err) {
 		ret = translate_error(fs, child, err);
@@ -4972,7 +4997,7 @@ static int op_utimens(const char *path, const struct timespec ctv[2],
 	if (tv[1].tv_nsec != UTIME_OMIT)
 		EXT4_INODE_SET_XTIME(i_mtime, &tv[1], &inode);
 #endif /* UTIME_OMIT */
-	ret = update_ctime(fs, ino, &inode);
+	ret = fuse2fs_update_ctime(ff, ino, &inode);
 	if (ret)
 		goto out;
 
@@ -5040,7 +5065,7 @@ static int ioctl_setflags(struct fuse2fs *ff, struct fuse2fs_file_handle *fh,
 	if (ret)
 		return ret;
 
-	ret = update_ctime(fs, fh->ino, &inode);
+	ret = fuse2fs_update_ctime(ff, fh->ino, &inode);
 	if (ret)
 		return ret;
 
@@ -5087,7 +5112,7 @@ static int ioctl_setversion(struct fuse2fs *ff, struct fuse2fs_file_handle *fh,
 
 	inode.i_generation = generation;
 
-	ret = update_ctime(fs, fh->ino, &inode);
+	ret = fuse2fs_update_ctime(ff, fh->ino, &inode);
 	if (ret)
 		return ret;
 
@@ -5218,7 +5243,7 @@ static int ioctl_fssetxattr(struct fuse2fs *ff, struct fuse2fs_file_handle *fh,
 	if (ext2fs_inode_includes(inode_size, i_projid))
 		inode.i_projid = fsx->fsx_projid;
 
-	ret = update_ctime(fs, fh->ino, &inode);
+	ret = fuse2fs_update_ctime(ff, fh->ino, &inode);
 	if (ret)
 		return ret;
 
@@ -5490,7 +5515,7 @@ static int fuse2fs_allocate_range(struct fuse2fs *ff,
 		}
 	}
 
-	err = update_mtime(fs, fh->ino, &inode);
+	err = fuse2fs_update_mtime(ff, fh->ino, &inode);
 	if (err)
 		return err;
 
@@ -5663,7 +5688,7 @@ static int fuse2fs_punch_range(struct fuse2fs *ff,
 			return translate_error(fs, fh->ino, err);
 	}
 
-	err = update_mtime(fs, fh->ino, &inode);
+	err = fuse2fs_update_mtime(ff, fh->ino, &inode);
 	if (err)
 		return err;
 

