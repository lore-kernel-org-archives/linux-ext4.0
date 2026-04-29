Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC7730DEB2;
	Wed, 29 Apr 2026 14:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474608; cv=none; b=DR7V8T+yyv0dUaJEJgPktOvB59RlUCrPGMW9FDTsj8J7cGeh9lc6ufZtxT1097vpH3DhMkc91N+iSKaNwol/9d+yY4KgyeQswlqASHXXhCyMvrUvveelw74S4uhRKxBQb/TFGxTvKANG2LvTwEzjPiQvzVYYJdtfd5n08F5FALk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474608; c=relaxed/simple;
	bh=L7nT/BDeizWvsJxivEyqjB6WwbDg63LrX95DTnPrtYI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X4benQ93Rmhizy3yqfPjDAKupC+0SOw4Jq22XesTvZpZPu14sHfBYRdpx10rLmPTJmzqdsoV6YvYlQ8WlIb5MyboSM5M4BzFiuypAyDBlg8vVpgdfEf6iQEg6luCeMy5z64AJzdoRpaVQZ5N6WVnodPxXJRoZXU6TDK6zZ07Agg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BV5DCw3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BV5DCw3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3EEC2BCB8;
	Wed, 29 Apr 2026 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474608;
	bh=L7nT/BDeizWvsJxivEyqjB6WwbDg63LrX95DTnPrtYI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BV5DCw3lb5qF/GKc+noc3nCJnFGWR2LVvfg4m6kHejkK0mhdgaAr1M+7y7uuqT+Cs
	 s3bE+UETZ65bGS0al1bsN5e1Jy0WliXeuP2S8atlEQF4o1TE5O02TkOvXpWVPKZOP7
	 VGojvmdD6gHia9VpJFI+ekABACCiYpxzK0RIaYHMV6/Z9gx55/HK9Lm0DgC8dDdwIY
	 /0bzzsINVFaNy3oLPXN40cgsgw+V3nAi0089+VtoFyEHKVwVZbjuC/1SmTaAVR2xBH
	 G4go+ORu4R1viJ4ADU/jgG23y17gxPsw2BUKHNZ/3HJ8oOsuuixOeIhUjai2Ve+L6F
	 0e0x+wnw2PuZQ==
Date: Wed, 29 Apr 2026 07:56:48 -0700
Subject: [PATCH 16/19] fuse2fs: implement statx
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214821.4107473.4235956386247228859.stgit@frogsfrogsfrogs>
In-Reply-To: <177747214459.4107473.9520724883867588970.stgit@frogsfrogsfrogs>
References: <177747214459.4107473.9520724883867588970.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Implement statx.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |  136 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/fuse2fs.c    |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 267 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 6016e23c511ac1..8d994fe490e914 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -24,6 +24,7 @@
 #include <sys/xattr.h>
 #endif
 #include <sys/ioctl.h>
+#include <sys/sysmacros.h>
 #include <unistd.h>
 #include <ctype.h>
 #include <assert.h>
@@ -2411,6 +2412,138 @@ static void op_getattr(fuse_req_t req, fuse_ino_t fino,
 				       fstat.entry.attr_timeout);
 }
 
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 18) && defined(STATX_BASIC_STATS)
+static inline void fuse4fs_set_statx_attr(struct statx *stx,
+					  uint64_t statx_flag, int set)
+{
+	if (set)
+		stx->stx_attributes |= statx_flag;
+	stx->stx_attributes_mask |= statx_flag;
+}
+
+static void fuse4fs_statx_directio(struct fuse4fs *ff, struct statx *stx)
+{
+	struct statx devx;
+	errcode_t err;
+	int fd;
+
+	err = io_channel_get_fd(ff->fs->io, &fd);
+	if (err)
+		return;
+
+	err = statx(fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &devx);
+	if (err)
+		return;
+	if (!(devx.stx_mask & STATX_DIOALIGN))
+		return;
+
+	stx->stx_mask |= STATX_DIOALIGN;
+	stx->stx_dio_mem_align = devx.stx_dio_mem_align;
+	stx->stx_dio_offset_align = devx.stx_dio_offset_align;
+}
+
+static int fuse4fs_statx(struct fuse4fs *ff, ext2_ino_t ino, int statx_mask,
+			 struct statx *stx)
+{
+	struct ext2_inode_large inode;
+	ext2_filsys fs = ff->fs;;
+	dev_t fakedev = 0;
+	errcode_t err;
+	struct timespec tv;
+
+	err = fuse4fs_read_inode(fs, ino, &inode);
+	if (err)
+		return translate_error(fs, ino, err);
+
+	memcpy(&fakedev, fs->super->s_uuid, sizeof(fakedev));
+	stx->stx_mask = STATX_BASIC_STATS;
+	stx->stx_dev_major = major(fakedev);
+	stx->stx_dev_minor = minor(fakedev);
+	stx->stx_ino = ino;
+	stx->stx_mode = inode.i_mode;
+	stx->stx_nlink = inode.i_links_count;
+	stx->stx_uid = inode_uid(inode);
+	stx->stx_gid = inode_gid(inode);
+	stx->stx_size = EXT2_I_SIZE(&inode);
+	stx->stx_blksize = fs->blocksize;
+	stx->stx_blocks = ext2fs_get_stat_i_blocks(fs,
+						EXT2_INODE(&inode));
+	EXT4_INODE_GET_XTIME(i_atime, &tv, &inode);
+	stx->stx_atime.tv_sec = tv.tv_sec;
+	stx->stx_atime.tv_nsec = tv.tv_nsec;
+
+	EXT4_INODE_GET_XTIME(i_mtime, &tv, &inode);
+	stx->stx_mtime.tv_sec = tv.tv_sec;
+	stx->stx_mtime.tv_nsec = tv.tv_nsec;
+
+	EXT4_INODE_GET_XTIME(i_ctime, &tv, &inode);
+	stx->stx_ctime.tv_sec = tv.tv_sec;
+	stx->stx_ctime.tv_nsec = tv.tv_nsec;
+
+	if (EXT4_FITS_IN_INODE(&inode, i_crtime)) {
+		stx->stx_mask |= STATX_BTIME;
+		EXT4_INODE_GET_XTIME(i_crtime, &tv, &inode);
+		stx->stx_btime.tv_sec = tv.tv_sec;
+		stx->stx_btime.tv_nsec = tv.tv_nsec;
+	}
+
+	dbg_printf(ff, "%s: ino=%d atime=%lld.%d mtime=%lld.%d ctime=%lld.%d btime=%lld.%d\n",
+		   __func__, ino,
+		   (long long int)stx->stx_atime.tv_sec, stx->stx_atime.tv_nsec,
+		   (long long int)stx->stx_mtime.tv_sec, stx->stx_mtime.tv_nsec,
+		   (long long int)stx->stx_ctime.tv_sec, stx->stx_ctime.tv_nsec,
+		   (long long int)stx->stx_btime.tv_sec, stx->stx_btime.tv_nsec);
+
+	if (LINUX_S_ISCHR(inode.i_mode) ||
+	    LINUX_S_ISBLK(inode.i_mode)) {
+		if (inode.i_block[0]) {
+			stx->stx_rdev_major = major(inode.i_block[0]);
+			stx->stx_rdev_minor = minor(inode.i_block[0]);
+		} else {
+			stx->stx_rdev_major = major(inode.i_block[1]);
+			stx->stx_rdev_minor = minor(inode.i_block[1]);
+		}
+	}
+
+	fuse4fs_set_statx_attr(stx, STATX_ATTR_COMPRESSED,
+			       inode.i_flags & EXT2_COMPR_FL);
+	fuse4fs_set_statx_attr(stx, STATX_ATTR_IMMUTABLE,
+			       inode.i_flags & EXT2_IMMUTABLE_FL);
+	fuse4fs_set_statx_attr(stx, STATX_ATTR_APPEND,
+			       inode.i_flags & EXT2_APPEND_FL);
+	fuse4fs_set_statx_attr(stx, STATX_ATTR_NODUMP,
+			       inode.i_flags & EXT2_NODUMP_FL);
+
+	fuse4fs_statx_directio(ff, stx);
+
+	return 0;
+}
+
+static void op_statx(fuse_req_t req, fuse_ino_t fino, int flags, int mask,
+		     struct fuse_file_info *fi)
+{
+	struct statx stx = { };
+	struct fuse4fs *ff = fuse4fs_get(req);
+	ext2_ino_t ino;
+	int ret = 0;
+
+	FUSE4FS_CHECK_CONTEXT(req);
+	FUSE4FS_CONVERT_FINO(req, &ino, fino);
+	fuse4fs_start(ff);
+	ret = fuse4fs_statx(ff, ino, mask, &stx);
+	if (ret)
+		goto out;
+out:
+	fuse4fs_finish(ff, ret);
+	if (ret)
+		fuse_reply_err(req, -ret);
+	else
+		fuse_reply_statx(req, 0, &stx, FUSE4FS_ATTR_TIMEOUT);
+}
+#else
+# define op_statx		NULL
+#endif
+
 static void op_readlink(fuse_req_t req, fuse_ino_t fino)
 {
 	struct ext2_inode inode;
@@ -7484,6 +7617,9 @@ static struct fuse_lowlevel_ops fs_ops = {
 #ifdef SUPPORT_FALLOCATE
 	.fallocate = op_fallocate,
 #endif
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 18)
+	.statx = op_statx,
+#endif
 #ifdef HAVE_FUSE_IOMAP
 	.iomap_begin = op_iomap_begin,
 	.iomap_end = op_iomap_end,
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 138346fcc4517f..f9e8fca096ec2c 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -23,6 +23,7 @@
 #include <sys/xattr.h>
 #endif
 #include <sys/ioctl.h>
+#include <sys/sysmacros.h>
 #include <unistd.h>
 #include <ctype.h>
 #ifdef HAVE_FUSE_LOOPDEV
@@ -2006,6 +2007,133 @@ static int op_getattr_iflags(const char *path, struct stat *statbuf,
 }
 #endif
 
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 18) && defined(STATX_BASIC_STATS)
+static inline void fuse2fs_set_statx_attr(struct statx *stx,
+					  uint64_t statx_flag, int set)
+{
+	if (set)
+		stx->stx_attributes |= statx_flag;
+	stx->stx_attributes_mask |= statx_flag;
+}
+
+static void fuse2fs_statx_directio(struct fuse2fs *ff, struct statx *stx)
+{
+	struct statx devx;
+	errcode_t err;
+	int fd;
+
+	err = io_channel_get_fd(ff->fs->io, &fd);
+	if (err)
+		return;
+
+	err = statx(fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &devx);
+	if (err)
+		return;
+	if (!(devx.stx_mask & STATX_DIOALIGN))
+		return;
+
+	stx->stx_mask |= STATX_DIOALIGN;
+	stx->stx_dio_mem_align = devx.stx_dio_mem_align;
+	stx->stx_dio_offset_align = devx.stx_dio_offset_align;
+}
+
+static int fuse2fs_statx(struct fuse2fs *ff, ext2_ino_t ino, int statx_mask,
+			 struct statx *stx)
+{
+	struct ext2_inode_large inode;
+	ext2_filsys fs = ff->fs;;
+	dev_t fakedev = 0;
+	errcode_t err;
+	struct timespec tv;
+
+	err = fuse2fs_read_inode(fs, ino, &inode);
+	if (err)
+		return translate_error(fs, ino, err);
+
+	memcpy(&fakedev, fs->super->s_uuid, sizeof(fakedev));
+	stx->stx_mask = STATX_BASIC_STATS;
+	stx->stx_dev_major = major(fakedev);
+	stx->stx_dev_minor = minor(fakedev);
+	stx->stx_ino = ino;
+	stx->stx_mode = inode.i_mode;
+	stx->stx_nlink = inode.i_links_count;
+	stx->stx_uid = inode_uid(inode);
+	stx->stx_gid = inode_gid(inode);
+	stx->stx_size = EXT2_I_SIZE(&inode);
+	stx->stx_blksize = fs->blocksize;
+	stx->stx_blocks = ext2fs_get_stat_i_blocks(fs,
+						EXT2_INODE(&inode));
+	EXT4_INODE_GET_XTIME(i_atime, &tv, &inode);
+	stx->stx_atime.tv_sec = tv.tv_sec;
+	stx->stx_atime.tv_nsec = tv.tv_nsec;
+
+	EXT4_INODE_GET_XTIME(i_mtime, &tv, &inode);
+	stx->stx_mtime.tv_sec = tv.tv_sec;
+	stx->stx_mtime.tv_nsec = tv.tv_nsec;
+
+	EXT4_INODE_GET_XTIME(i_ctime, &tv, &inode);
+	stx->stx_ctime.tv_sec = tv.tv_sec;
+	stx->stx_ctime.tv_nsec = tv.tv_nsec;
+
+	if (EXT4_FITS_IN_INODE(&inode, i_crtime)) {
+		stx->stx_mask |= STATX_BTIME;
+		EXT4_INODE_GET_XTIME(i_crtime, &tv, &inode);
+		stx->stx_btime.tv_sec = tv.tv_sec;
+		stx->stx_btime.tv_nsec = tv.tv_nsec;
+	}
+
+	dbg_printf(ff, "%s: ino=%d atime=%lld.%d mtime=%lld.%d ctime=%lld.%d btime=%lld.%d\n",
+		   __func__, ino,
+		   (long long int)stx->stx_atime.tv_sec, stx->stx_atime.tv_nsec,
+		   (long long int)stx->stx_mtime.tv_sec, stx->stx_mtime.tv_nsec,
+		   (long long int)stx->stx_ctime.tv_sec, stx->stx_ctime.tv_nsec,
+		   (long long int)stx->stx_btime.tv_sec, stx->stx_btime.tv_nsec);
+
+	if (LINUX_S_ISCHR(inode.i_mode) ||
+	    LINUX_S_ISBLK(inode.i_mode)) {
+		if (inode.i_block[0]) {
+			stx->stx_rdev_major = major(inode.i_block[0]);
+			stx->stx_rdev_minor = minor(inode.i_block[0]);
+		} else {
+			stx->stx_rdev_major = major(inode.i_block[1]);
+			stx->stx_rdev_minor = minor(inode.i_block[1]);
+		}
+	}
+
+	fuse2fs_set_statx_attr(stx, STATX_ATTR_COMPRESSED,
+			       inode.i_flags & EXT2_COMPR_FL);
+	fuse2fs_set_statx_attr(stx, STATX_ATTR_IMMUTABLE,
+			       inode.i_flags & EXT2_IMMUTABLE_FL);
+	fuse2fs_set_statx_attr(stx, STATX_ATTR_APPEND,
+			       inode.i_flags & EXT2_APPEND_FL);
+	fuse2fs_set_statx_attr(stx, STATX_ATTR_NODUMP,
+			       inode.i_flags & EXT2_NODUMP_FL);
+
+	fuse2fs_statx_directio(ff, stx);
+
+	return 0;
+}
+
+static int op_statx(const char *path, int statx_flags, int statx_mask,
+		    struct statx *stx, struct fuse_file_info *fi)
+{
+	struct fuse2fs *ff = fuse2fs_get();
+	ext2_ino_t ino;
+	int ret = 0;
+
+	FUSE2FS_CHECK_CONTEXT(ff);
+	fuse2fs_start(ff);
+	ret = fuse2fs_file_ino(ff, path, fi, &ino);
+	if (ret)
+		goto out;
+	ret = fuse2fs_statx(ff, ino, statx_mask, stx);
+out:
+	fuse2fs_finish(ff, ret);
+	return ret;
+}
+#else
+# define op_statx		NULL
+#endif
 
 static int op_readlink(const char *path, char *buf, size_t len)
 {
@@ -6793,6 +6921,9 @@ static struct fuse_operations fs_ops = {
 #ifdef SUPPORT_FALLOCATE
 	.fallocate = op_fallocate,
 #endif
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 18)
+	.statx = op_statx,
+#endif
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 99)
 	.getattr_iflags = op_getattr_iflags,
 #endif

