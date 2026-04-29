Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF92308F23;
	Wed, 29 Apr 2026 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474811; cv=none; b=BfYOnCwWqkzqxG746DUK6QB2ESRj5YLD4tqc+HNBBlxTsOsnasTsdGh0o4U7IQ9TrVHMEuXyDR5tqXUCoo/LYk+GYNtimIn8tZJEJ+dzMTOulzMJPGMUSzYI+FOPqDaHizlB2cAuCDopQtyt9mBg7X9IjtfxYsa2kM7lLhukdq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474811; c=relaxed/simple;
	bh=VMzFwbpTknTCG0L5VYbN/WSNN1fFC7Tck7nyL6u7sXA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BpYpOnqfUjV4RbX8lCoyBWDFhQf+svaK3uQxzN0ZzfEf6jXZTM7Y5YbLzERypegaAhH90+Fu//sXkHe4CVi+yE6HRgXGoV1a16WwmBrjsC7pXFHCjSmjP1lh/EIn3bb4V+ItXj5vESj0vc2j/TNBDqr1BV6EA+Lrbtv1ILFBq4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tVQo9MXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tVQo9MXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6D9C19425;
	Wed, 29 Apr 2026 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474811;
	bh=VMzFwbpTknTCG0L5VYbN/WSNN1fFC7Tck7nyL6u7sXA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tVQo9MXcdA/9GzxBaVO44/za2Be8tt1M9QMUrI86SC0dgcoHZIqjvnC9Kjc0LIUZO
	 1RtnHPk5o9TEyyLmm7f3wN1jJ4dbxLKXEigkTwGpy2Sh1vLXMD7cw1exVBjaTHFz0b
	 peciMU8xOLJhDxy7VsFeOAPjkgktxTD4Gcb6a8VdNAW3ypi35TandnVpBMNM/RjzBA
	 dvBdV8uSoWQSCzPhuGkyFdOY3fSNlr04rbObqJshkbcRvOe2ddaLHr5J3zeKdZ/yxK
	 79mQo49aFMshXToCIv4hVooRT6P64ORLh4prTIYMDBoHQCaCisF2L4oWslPESFnQmA
	 QmKuoOkt+yVAw==
Date: Wed, 29 Apr 2026 08:00:11 -0700
Subject: [PATCH 06/10] fuse2fs: use coarse timestamps for iomap mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215490.4110156.16017408606598893564.stgit@frogsfrogsfrogs>
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

In iomap mode, the kernel is responsible for maintaining timestamps
because file writes don't upcall to fuse2fs.  The kernel's predicate for
deciding if [cm]time should be updated bases its decisions off [cm]time
being an exact match for the coarse clock (instead of checking that
[cm]time < coarse_clock) which means that fuse2fs setting a fine-grained
timestamp that is slightly ahead of the coarse clock can result in
timestamps appearing to go backwards.  generic/423 doesn't like seeing
btime > ctime from statx, so we'll use the coarse clock in iomap mode.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |  110 +++++++++++++++++++++++++++++++----------------------
 misc/fuse2fs.c    |   34 ++++++++++++----
 2 files changed, 90 insertions(+), 54 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 567b576e5f5779..8a9ada8905983d 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -1043,8 +1043,24 @@ static inline void fuse4fs_dump_extents(struct fuse4fs *ff, ext2_ino_t ino,
 	ext2fs_extent_free(extents);
 }
 
-static void get_now(struct timespec *now)
+static void fuse4fs_get_now(struct fuse4fs *ff, struct timespec *now)
 {
+#ifdef CLOCK_REALTIME_COARSE
+	/*
+	 * In iomap mode, the kernel is responsible for maintaining timestamps
+	 * because file writes don't upcall to fuse4fs.  The kernel's predicate
+	 * for deciding if [cm]time should be updated bases its decisions off
+	 * [cm]time being an exact match for the coarse clock (instead of
+	 * checking that [cm]time < coarse_clock) which means that fuse4fs
+	 * setting a fine-grained timestamp that is slightly ahead of the
+	 * coarse clock can result in timestamps appearing to go backwards.
+	 * generic/423 doesn't like seeing btime > ctime from statx, so we'll
+	 * use the coarse clock in iomap mode.
+	 */
+	if (fuse4fs_iomap_enabled(ff) &&
+	    !clock_gettime(CLOCK_REALTIME_COARSE, now))
+		return;
+#endif
 #ifdef CLOCK_REALTIME
 	if (!clock_gettime(CLOCK_REALTIME, now))
 		return;
@@ -1067,11 +1083,12 @@ static void increment_version(struct ext2_inode_large *inode)
 		inode->i_version_hi = ver >> 32;
 }
 
-static void init_times(struct ext2_inode_large *inode)
+static void fuse4fs_init_timestamps(struct fuse4fs *ff,
+				    struct ext2_inode_large *inode)
 {
 	struct timespec now;
 
-	get_now(&now);
+	fuse4fs_get_now(ff, &now);
 	EXT4_INODE_SET_XTIME(i_atime, &now, inode);
 	EXT4_INODE_SET_XTIME(i_ctime, &now, inode);
 	EXT4_INODE_SET_XTIME(i_mtime, &now, inode);
@@ -1079,14 +1096,15 @@ static void init_times(struct ext2_inode_large *inode)
 	increment_version(inode);
 }
 
-static int update_ctime(ext2_filsys fs, ext2_ino_t ino,
-			struct ext2_inode_large *pinode)
+static int fuse4fs_update_ctime(struct fuse4fs *ff, ext2_ino_t ino,
+				struct ext2_inode_large *pinode)
 {
-	errcode_t err;
 	struct timespec now;
 	struct ext2_inode_large inode;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
 
-	get_now(&now);
+	fuse4fs_get_now(ff, &now);
 
 	/* If user already has a inode buffer, just update that */
 	if (pinode) {
@@ -1110,12 +1128,13 @@ static int update_ctime(ext2_filsys fs, ext2_ino_t ino,
 	return 0;
 }
 
-static int update_atime(ext2_filsys fs, ext2_ino_t ino)
+static int fuse4fs_update_atime(struct fuse4fs *ff, ext2_ino_t ino)
 {
-	errcode_t err;
 	struct ext2_inode_large inode, *pinode;
 	struct timespec atime, mtime, now;
+	ext2_filsys fs = ff->fs;
 	double datime, dmtime, dnow;
+	errcode_t err;
 
 	err = fuse4fs_read_inode(fs, ino, &inode);
 	if (err)
@@ -1124,7 +1143,7 @@ static int update_atime(ext2_filsys fs, ext2_ino_t ino)
 	pinode = &inode;
 	EXT4_INODE_GET_XTIME(i_atime, &atime, pinode);
 	EXT4_INODE_GET_XTIME(i_mtime, &mtime, pinode);
-	get_now(&now);
+	fuse4fs_get_now(ff, &now);
 
 	datime = atime.tv_sec + ((double)atime.tv_nsec / NSEC_PER_SEC);
 	dmtime = mtime.tv_sec + ((double)mtime.tv_nsec / NSEC_PER_SEC);
@@ -1146,15 +1165,16 @@ static int update_atime(ext2_filsys fs, ext2_ino_t ino)
 	return 0;
 }
 
-static int update_mtime(ext2_filsys fs, ext2_ino_t ino,
-			struct ext2_inode_large *pinode)
+static int fuse4fs_update_mtime(struct fuse4fs *ff, ext2_ino_t ino,
+				struct ext2_inode_large *pinode)
 {
-	errcode_t err;
 	struct ext2_inode_large inode;
 	struct timespec now;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
 
 	if (pinode) {
-		get_now(&now);
+		fuse4fs_get_now(ff, &now);
 		EXT4_INODE_SET_XTIME(i_mtime, &now, pinode);
 		EXT4_INODE_SET_XTIME(i_ctime, &now, pinode);
 		increment_version(pinode);
@@ -1165,7 +1185,7 @@ static int update_mtime(ext2_filsys fs, ext2_ino_t ino,
 	if (err)
 		return translate_error(fs, ino, err);
 
-	get_now(&now);
+	fuse4fs_get_now(ff, &now);
 	EXT4_INODE_SET_XTIME(i_mtime, &now, &inode);
 	EXT4_INODE_SET_XTIME(i_ctime, &now, &inode);
 	increment_version(&inode);
@@ -2701,7 +2721,7 @@ static void op_readlink(fuse_req_t req, fuse_ino_t fino)
 	buf[len] = 0;
 
 	if (fuse4fs_is_writeable(ff)) {
-		ret = update_atime(fs, ino);
+		ret = fuse4fs_update_atime(ff, ino);
 		if (ret)
 			goto out;
 	}
@@ -2970,7 +2990,7 @@ static void op_mknod(fuse_req_t req, fuse_ino_t fino, const char *name,
 		goto out2;
 	}
 
-	ret = update_mtime(fs, parent, NULL);
+	ret = fuse4fs_update_mtime(ff, parent, NULL);
 	if (ret)
 		goto out2;
 
@@ -2993,7 +3013,7 @@ static void op_mknod(fuse_req_t req, fuse_ino_t fino, const char *name,
 	}
 
 	inode.i_generation = ff->next_generation++;
-	init_times(&inode);
+	fuse4fs_init_timestamps(ff, &inode);
 	err = fuse4fs_write_inode(fs, child, &inode);
 	if (err) {
 		ret = translate_error(fs, child, err);
@@ -3055,7 +3075,7 @@ static void op_mkdir(fuse_req_t req, fuse_ino_t fino, const char *name,
 		goto out2;
 	}
 
-	ret = update_mtime(fs, parent, NULL);
+	ret = fuse4fs_update_mtime(ff, parent, NULL);
 	if (ret)
 		goto out2;
 
@@ -3081,7 +3101,7 @@ static void op_mkdir(fuse_req_t req, fuse_ino_t fino, const char *name,
 	if (parent_sgid)
 		inode.i_mode |= S_ISGID;
 	inode.i_generation = ff->next_generation++;
-	init_times(&inode);
+	fuse4fs_init_timestamps(ff, &inode);
 
 	err = fuse4fs_write_inode(fs, child, &inode);
 	if (err) {
@@ -3432,7 +3452,7 @@ static int fuse4fs_remove_inode(struct fuse4fs *ff, ext2_ino_t ino)
 		inode.i_links_count--;
 	}
 
-	ret = update_ctime(fs, ino, &inode);
+	ret = fuse4fs_update_ctime(ff, ino, &inode);
 	if (ret)
 		return ret;
 
@@ -3504,7 +3524,7 @@ static int fuse4fs_unlink(struct fuse4fs *ff, ext2_ino_t parent,
 		goto out;
 	}
 
-	ret = update_mtime(fs, parent, NULL);
+	ret = fuse4fs_update_mtime(ff, parent, NULL);
 	if (ret)
 		goto out;
 out:
@@ -3638,7 +3658,7 @@ static int fuse4fs_rmdir(struct fuse4fs *ff, ext2_ino_t parent,
 			goto out;
 		}
 		ext2fs_dec_nlink(EXT2_INODE(&inode));
-		ret = update_mtime(fs, rds.parent, &inode);
+		ret = fuse4fs_update_mtime(ff, rds.parent, &inode);
 		if (ret)
 			goto out;
 		err = fuse4fs_write_inode(fs, rds.parent, &inode);
@@ -3742,7 +3762,7 @@ static void op_symlink(fuse_req_t req, const char *target, fuse_ino_t fino,
 	}
 
 	/* Update parent dir's mtime */
-	ret = update_mtime(fs, parent, NULL);
+	ret = fuse4fs_update_mtime(ff, parent, NULL);
 	if (ret)
 		goto out2;
 
@@ -3765,7 +3785,7 @@ static void op_symlink(fuse_req_t req, const char *target, fuse_ino_t fino,
 	fuse4fs_set_uid(&inode, ctxt->uid);
 	fuse4fs_set_gid(&inode, gid);
 	inode.i_generation = ff->next_generation++;
-	init_times(&inode);
+	fuse4fs_init_timestamps(ff, &inode);
 
 	err = fuse4fs_write_inode(fs, child, &inode);
 	if (err) {
@@ -3996,11 +4016,11 @@ static void op_rename(fuse_req_t req, fuse_ino_t from_parent, const char *from,
 	}
 
 	/* Update timestamps */
-	ret = update_ctime(fs, from_ino, NULL);
+	ret = fuse4fs_update_ctime(ff, from_ino, NULL);
 	if (ret)
 		goto out;
 
-	ret = update_mtime(fs, to_dir_ino, NULL);
+	ret = fuse4fs_update_mtime(ff, to_dir_ino, NULL);
 	if (ret)
 		goto out;
 
@@ -4079,7 +4099,7 @@ static void op_link(fuse_req_t req, fuse_ino_t child_fino,
 	}
 
 	ext2fs_inc_nlink(fs, EXT2_INODE(&inode));
-	ret = update_ctime(fs, child, &inode);
+	ret = fuse4fs_update_ctime(ff, child, &inode);
 	if (ret)
 		goto out2;
 
@@ -4096,7 +4116,7 @@ static void op_link(fuse_req_t req, fuse_ino_t child_fino,
 		goto out2;
 	}
 
-	ret = update_mtime(fs, parent, NULL);
+	ret = fuse4fs_update_mtime(ff, parent, NULL);
 	if (ret)
 		goto out2;
 
@@ -4332,7 +4352,7 @@ static int fuse4fs_truncate(struct fuse4fs *ff, ext2_ino_t ino, off_t new_size)
 	if (err)
 		return translate_error(fs, ino, err);
 
-	ret = update_mtime(fs, ino, NULL);
+	ret = fuse4fs_update_mtime(ff, ino, NULL);
 	if (ret)
 		return ret;
 
@@ -4541,7 +4561,7 @@ static void op_read(fuse_req_t req, fuse_ino_t fino EXT2FS_ATTR((unused)),
 	}
 
 	if (fh->check_flags != X_OK && fuse4fs_is_writeable(ff)) {
-		ret = update_atime(fs, fh->ino);
+		ret = fuse4fs_update_atime(ff, fh->ino);
 		if (ret)
 			goto out;
 	}
@@ -4615,7 +4635,7 @@ static void op_write(fuse_req_t req, fuse_ino_t fino EXT2FS_ATTR((unused)),
 		goto out;
 	}
 
-	ret = update_mtime(fs, fh->ino, NULL);
+	ret = fuse4fs_update_mtime(ff, fh->ino, NULL);
 	if (ret)
 		goto out;
 
@@ -5062,7 +5082,7 @@ static void op_setxattr(fuse_req_t req, fuse_ino_t fino, const char *key,
 		goto out2;
 	}
 
-	ret = update_ctime(fs, ino, NULL);
+	ret = fuse4fs_update_ctime(ff, ino, NULL);
 out2:
 	err = ext2fs_xattrs_close(&h);
 	if (!ret && err)
@@ -5156,7 +5176,7 @@ static void op_removexattr(fuse_req_t req, fuse_ino_t fino, const char *key)
 		goto out2;
 	}
 
-	ret = update_ctime(fs, ino, NULL);
+	ret = fuse4fs_update_ctime(ff, ino, NULL);
 out2:
 	err = ext2fs_xattrs_close(&h);
 	if (err && !ret)
@@ -5303,7 +5323,7 @@ static void __op_readdir(fuse_req_t req, fuse_ino_t fino, size_t size,
 	}
 
 	if (fuse4fs_is_writeable(ff)) {
-		ret = update_atime(i.fs, fh->ino);
+		ret = fuse4fs_update_atime(i.ff, fh->ino);
 		if (ret)
 			goto out;
 	}
@@ -5403,7 +5423,7 @@ static void op_create(fuse_req_t req, fuse_ino_t fino, const char *name,
 			goto out2;
 		}
 
-		ret = update_mtime(fs, parent, NULL);
+		ret = fuse4fs_update_mtime(ff, parent, NULL);
 		if (ret)
 			goto out2;
 	} else {
@@ -5444,7 +5464,7 @@ static void op_create(fuse_req_t req, fuse_ino_t fino, const char *name,
 	}
 
 	inode.i_generation = ff->next_generation++;
-	init_times(&inode);
+	fuse4fs_init_timestamps(ff, &inode);
 	err = fuse4fs_write_inode(fs, child, &inode);
 	if (err) {
 		ret = translate_error(fs, child, err);
@@ -5523,7 +5543,7 @@ static int fuse4fs_utimens(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 	int ret = 0;
 
 	if (to_set & (FUSE_SET_ATTR_ATIME_NOW | FUSE_SET_ATTR_MTIME_NOW))
-		get_now(&now);
+		fuse4fs_get_now(ff, &now);
 
 	if (to_set & FUSE_SET_ATTR_ATIME_NOW) {
 		atime = now;
@@ -5661,7 +5681,7 @@ static void op_setattr(fuse_req_t req, fuse_ino_t fino, struct stat *attr,
 	}
 
 	/* Update ctime for any attribute change */
-	ret = update_ctime(fs, ino, &inode);
+	ret = fuse4fs_update_ctime(ff, ino, &inode);
 	if (ret)
 		goto out;
 
@@ -5743,7 +5763,7 @@ static int ioctl_setflags(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 	if (ret)
 		return ret;
 
-	ret = update_ctime(fs, fh->ino, &inode);
+	ret = fuse4fs_update_ctime(ff, fh->ino, &inode);
 	if (ret)
 		return ret;
 
@@ -5796,7 +5816,7 @@ static int ioctl_setversion(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 
 	inode.i_generation = *indata;
 
-	ret = update_ctime(fs, fh->ino, &inode);
+	ret = fuse4fs_update_ctime(ff, fh->ino, &inode);
 	if (ret)
 		return ret;
 
@@ -5932,7 +5952,7 @@ static int ioctl_fssetxattr(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 	if (ext2fs_inode_includes(inode_size, i_projid))
 		inode.i_projid = fsx->fsx_projid;
 
-	ret = update_ctime(fs, fh->ino, &inode);
+	ret = fuse4fs_update_ctime(ff, fh->ino, &inode);
 	if (ret)
 		return ret;
 
@@ -6228,7 +6248,7 @@ static int fuse4fs_allocate_range(struct fuse4fs *ff,
 		}
 	}
 
-	err = update_mtime(fs, fh->ino, &inode);
+	err = fuse4fs_update_mtime(ff, fh->ino, &inode);
 	if (err)
 		return err;
 
@@ -6401,7 +6421,7 @@ static int fuse4fs_punch_range(struct fuse4fs *ff,
 			return translate_error(fs, fh->ino, err);
 	}
 
-	err = update_mtime(fs, fh->ino, &inode);
+	err = fuse4fs_update_mtime(ff, fh->ino, &inode);
 	if (err)
 		return err;
 
@@ -8739,7 +8759,7 @@ static int __translate_error(ext2_filsys fs, ext2_ino_t ino, errcode_t err,
 			error_message(err), func, line);
 
 	/* Make a note in the error log */
-	get_now(&now);
+	fuse4fs_get_now(ff, &now);
 	ext2fs_set_tstamp(fs->super, s_last_error_time, now.tv_sec);
 	fs->super->s_last_error_ino = ino;
 	fs->super->s_last_error_line = line;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 935a66af66603e..458fd6e5bf6dd8 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -841,8 +841,24 @@ static inline void fuse2fs_dump_extents(struct fuse2fs *ff, ext2_ino_t ino,
 	ext2fs_extent_free(extents);
 }
 
-static void get_now(struct timespec *now)
+static void fuse2fs_get_now(struct fuse2fs *ff, struct timespec *now)
 {
+#ifdef CLOCK_REALTIME_COARSE
+	/*
+	 * In iomap mode, the kernel is responsible for maintaining timestamps
+	 * because file writes don't upcall to fuse2fs.  The kernel's predicate
+	 * for deciding if [cm]time should be updated bases its decisions off
+	 * [cm]time being an exact match for the coarse clock (instead of
+	 * checking that [cm]time < coarse_clock) which means that fuse2fs
+	 * setting a fine-grained timestamp that is slightly ahead of the
+	 * coarse clock can result in timestamps appearing to go backwards.
+	 * generic/423 doesn't like seeing btime > ctime from statx, so we'll
+	 * use the coarse clock in iomap mode.
+	 */
+	if (fuse2fs_iomap_enabled(ff) &&
+	    !clock_gettime(CLOCK_REALTIME_COARSE, now))
+		return;
+#endif
 #ifdef CLOCK_REALTIME
 	if (!clock_gettime(CLOCK_REALTIME, now))
 		return;
@@ -870,7 +886,7 @@ static void fuse2fs_init_timestamps(struct fuse2fs *ff, ext2_ino_t ino,
 {
 	struct timespec now;
 
-	get_now(&now);
+	fuse2fs_get_now(ff, &now);
 	EXT4_INODE_SET_XTIME(i_atime, &now, inode);
 	EXT4_INODE_SET_XTIME(i_ctime, &now, inode);
 	EXT4_INODE_SET_XTIME(i_mtime, &now, inode);
@@ -889,7 +905,7 @@ static int fuse2fs_update_ctime(struct fuse2fs *ff, ext2_ino_t ino,
 	struct timespec now;
 	struct ext2_inode_large inode;
 
-	get_now(&now);
+	fuse2fs_get_now(ff, &now);
 
 	/* If user already has a inode buffer, just update that */
 	if (pinode) {
@@ -935,7 +951,7 @@ static int fuse2fs_update_atime(struct fuse2fs *ff, ext2_ino_t ino)
 	pinode = &inode;
 	EXT4_INODE_GET_XTIME(i_atime, &atime, pinode);
 	EXT4_INODE_GET_XTIME(i_mtime, &mtime, pinode);
-	get_now(&now);
+	fuse2fs_get_now(ff, &now);
 
 	datime = atime.tv_sec + ((double)atime.tv_nsec / NSEC_PER_SEC);
 	dmtime = mtime.tv_sec + ((double)mtime.tv_nsec / NSEC_PER_SEC);
@@ -970,7 +986,7 @@ static int fuse2fs_update_mtime(struct fuse2fs *ff, ext2_ino_t ino,
 	struct timespec now;
 
 	if (pinode) {
-		get_now(&now);
+		fuse2fs_get_now(ff, &now);
 		EXT4_INODE_SET_XTIME(i_mtime, &now, pinode);
 		EXT4_INODE_SET_XTIME(i_ctime, &now, pinode);
 		increment_version(pinode);
@@ -985,7 +1001,7 @@ static int fuse2fs_update_mtime(struct fuse2fs *ff, ext2_ino_t ino,
 	if (err)
 		return translate_error(fs, ino, err);
 
-	get_now(&now);
+	fuse2fs_get_now(ff, &now);
 	EXT4_INODE_SET_XTIME(i_mtime, &now, &inode);
 	EXT4_INODE_SET_XTIME(i_ctime, &now, &inode);
 	increment_version(&inode);
@@ -4987,9 +5003,9 @@ static int op_utimens(const char *path, const struct timespec ctv[2],
 	tv[1] = ctv[1];
 #ifdef UTIME_NOW
 	if (tv[0].tv_nsec == UTIME_NOW)
-		get_now(tv);
+		fuse2fs_get_now(ff, tv);
 	if (tv[1].tv_nsec == UTIME_NOW)
-		get_now(tv + 1);
+		fuse2fs_get_now(ff, tv + 1);
 #endif /* UTIME_NOW */
 #ifdef UTIME_OMIT
 	if (tv[0].tv_nsec != UTIME_OMIT)
@@ -7747,7 +7763,7 @@ static int __translate_error(ext2_filsys fs, ext2_ino_t ino, errcode_t err,
 			error_message(err), func, line);
 
 	/* Make a note in the error log */
-	get_now(&now);
+	fuse2fs_get_now(ff, &now);
 	ext2fs_set_tstamp(fs->super, s_last_error_time, now.tv_sec);
 	fs->super->s_last_error_ino = ino;
 	fs->super->s_last_error_line = line;

