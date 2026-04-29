Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD082E7BB6;
	Wed, 29 Apr 2026 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474624; cv=none; b=WYY8Q8XhvdkzrLIfcpTAb2G96TzXYRiOPBRdTpZBwiGz0xkr6E/r+QtHl45FESAeXqMu5ISxOD2fjilaGaxwWPEB5ZUy9KfBxgR0gtAE96KRVQqtbmBd+a5yoLewt1jU7vR3DMQZSWOTMURMbutKH7jZRRF/mc7qN0lgXSzoYbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474624; c=relaxed/simple;
	bh=HeDk+cI+KH+JqCJO5D4u2awR+sk/9tvtfvBT9S+sE/s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JYV+KRBp2DjYKWMIfQl3jHdY3hCfqfkl2QoqoxX9jQNjEJmGuBbaGClhnQ77ALI5UkKCZEQqodBpT04+2c3imYevy8oVFHWMcpLZJGqDyy5NR2+g07u4TkESfmYJ2TAgL+kH2TOgpak82Y1JF35Y/kjX2r7KsYNJ8w52/9gKHM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjCDdnrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjCDdnrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0BCC19425;
	Wed, 29 Apr 2026 14:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474624;
	bh=HeDk+cI+KH+JqCJO5D4u2awR+sk/9tvtfvBT9S+sE/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PjCDdnrz+Uq68GQTUZGr50KFht+8Qqv/FRbv5MVR69jOSB47inYBUAUxX+pn81mFT
	 UL/05tBSoQF4bRddu1rUETY7vDFiOgKorDQ6a8ebjwOA1UUFqoQnFhFETUVDOHUyuF
	 W+lG0QKmpxxU+sDso2ySXeHpYriKhQ57khseW4HB4otLUDo1ciSPL4lRF3DUum3pzd
	 q5yGaP/X74BcqR/G67yRrfgYc2MBSRfkXFjIHef6fuQvQ+uGVDB5nOmrMsHkBaAkMf
	 9gheeHmp9toUOx8MWUmmb0wajOLVdylSyvES/NWvWVnul10o5a6lhp+XgCBc51rfHd
	 hIJdA3FZuVrWw==
Date: Wed, 29 Apr 2026 07:57:03 -0700
Subject: [PATCH 17/19] fuse2fs: enable atomic writes
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214838.4107473.16875762054281793441.stgit@frogsfrogsfrogs>
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

Advertise the single-fsblock atomic write capability that iomap can do.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/fuse2fs.c    |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 134 insertions(+), 2 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 8d994fe490e914..49708bdf7b655d 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -297,6 +297,9 @@ struct fuse4fs {
 	void (*old_alloc_stats)(ext2_filsys fs, blk64_t blk, int inuse);
 	void (*old_alloc_stats_range)(ext2_filsys fs, blk64_t blk, blk_t num,
 				      int inuse);
+#ifdef STATX_WRITE_ATOMIC
+	unsigned int awu_min, awu_max;
+#endif
 #endif
 	unsigned int blockmask;
 	unsigned long offset;
@@ -938,10 +941,22 @@ static inline bool fuse4fs_can_iomap(const struct fuse4fs *ff)
 {
 	return ff->iomap_cap & FUSE_IOMAP_SUPPORT_FILEIO;
 }
+
+static inline bool fuse4fs_iomap_supports_hw_atomic(const struct fuse4fs *ff)
+{
+	return fuse4fs_iomap_enabled(ff) &&
+	       (ff->iomap_cap & FUSE_IOMAP_SUPPORT_ATOMIC) &&
+#ifdef STATX_WRITE_ATOMIC
+		ff->awu_max > 0 && ff->awu_min > 0;
+#else
+		0;
+#endif
+}
 #else
 # define fuse4fs_iomap_enabled(...)	(0)
 # define fuse4fs_discover_iomap(...)	((void)0)
 # define fuse4fs_can_iomap(...)		(false)
+# define fuse4fs_iomap_supports_hw_atomic(...)	(0)
 #endif
 
 static inline void fuse4fs_dump_extents(struct fuse4fs *ff, ext2_ino_t ino,
@@ -2337,8 +2352,12 @@ static int fuse4fs_stat_inode(struct fuse4fs *ff, ext2_ino_t ino,
 
 	fstat->iflags = 0;
 #ifdef HAVE_FUSE_IOMAP
-	if (fuse4fs_iomap_enabled(ff))
+	if (fuse4fs_iomap_enabled(ff)) {
 		fstat->iflags |= FUSE_IFLAG_IOMAP | FUSE_IFLAG_EXCLUSIVE;
+
+		if (fuse4fs_iomap_supports_hw_atomic(ff))
+			fstat->iflags |= FUSE_IFLAG_ATOMIC;
+	}
 #endif
 
 	return 0;
@@ -2516,6 +2535,15 @@ static int fuse4fs_statx(struct fuse4fs *ff, ext2_ino_t ino, int statx_mask,
 
 	fuse4fs_statx_directio(ff, stx);
 
+#ifdef STATX_WRITE_ATOMIC
+	if (fuse4fs_iomap_supports_hw_atomic(ff)) {
+		stx->stx_mask |= STATX_WRITE_ATOMIC;
+		stx->stx_atomic_write_unit_min = ff->awu_min;
+		stx->stx_atomic_write_unit_max = ff->awu_max;
+		stx->stx_atomic_write_segments_max = 1;
+	}
+#endif
+
 	return 0;
 }
 
@@ -6902,6 +6930,9 @@ static void op_iomap_begin(fuse_req_t req, fuse_ino_t fino, uint64_t dontcare,
 		}
 	}
 
+	if (opflags & FUSE_IOMAP_OP_ATOMIC)
+		read.flags |= FUSE_IOMAP_F_ATOMIC_BIO;
+
 out_unlock:
 	fuse4fs_finish(ff, ret);
 	if (ret)
@@ -7066,6 +7097,38 @@ static int fuse4fs_set_bdev_blocksize(struct fuse4fs *ff, int fd)
 	return -EIO;
 }
 
+#ifdef STATX_WRITE_ATOMIC
+static void fuse4fs_configure_atomic_write(struct fuse4fs *ff, int bdev_fd)
+{
+	struct statx devx;
+	unsigned int awu_min, awu_max;
+	int ret;
+
+	if (!ext2fs_has_feature_extents(ff->fs->super))
+		return;
+
+	ret = statx(bdev_fd, "", AT_EMPTY_PATH, STATX_WRITE_ATOMIC, &devx);
+	if (ret)
+		return;
+	if (!(devx.stx_mask & STATX_WRITE_ATOMIC))
+		return;
+
+	awu_min = max(ff->fs->blocksize, devx.stx_atomic_write_unit_min);
+	awu_max = min(ff->fs->blocksize, devx.stx_atomic_write_unit_max);
+	if (awu_min > awu_max)
+		return;
+
+	log_printf(ff, "%s awu_min: %u, awu_max: %u\n",
+		   _("Supports (experimental) DIO atomic writes"),
+		   awu_min, awu_max);
+
+	ff->awu_min = awu_min;
+	ff->awu_max = awu_max;
+}
+#else
+# define fuse4fs_configure_atomic_write(...)	((void)0)
+#endif
+
 static int fuse4fs_iomap_config_devices(struct fuse4fs *ff)
 {
 	errcode_t err;
@@ -7090,6 +7153,8 @@ static int fuse4fs_iomap_config_devices(struct fuse4fs *ff)
 	dbg_printf(ff, "%s: registered iomap dev fd=%d iomap_dev=%u\n",
 		   __func__, fd, ff->iomap_dev);
 
+	fuse4fs_configure_atomic_write(ff, fd);
+
 	ff->iomap_dev = ret;
 	return 0;
 }
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index f9e8fca096ec2c..fe45ffa86823b0 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -280,6 +280,9 @@ struct fuse2fs {
 	void (*old_alloc_stats)(ext2_filsys fs, blk64_t blk, int inuse);
 	void (*old_alloc_stats_range)(ext2_filsys fs, blk64_t blk, blk_t num,
 				      int inuse);
+#ifdef STATX_WRITE_ATOMIC
+	unsigned int awu_min, awu_max;
+#endif
 #endif
 	unsigned int blockmask;
 	unsigned long offset;
@@ -750,10 +753,22 @@ static inline bool fuse2fs_can_iomap(const struct fuse2fs *ff)
 {
 	return ff->iomap_cap & FUSE_IOMAP_SUPPORT_FILEIO;
 }
+
+static inline bool fuse2fs_iomap_supports_hw_atomic(const struct fuse2fs *ff)
+{
+	return fuse2fs_iomap_enabled(ff) &&
+	       (ff->iomap_cap & FUSE_IOMAP_SUPPORT_ATOMIC) &&
+#ifdef STATX_WRITE_ATOMIC
+		ff->awu_max > 0 && ff->awu_min > 0;
+#else
+		0;
+#endif
+}
 #else
 # define fuse2fs_iomap_enabled(...)	(0)
 # define fuse2fs_discover_iomap(...)	((void)0)
 # define fuse2fs_can_iomap(...)		(false)
+# define fuse2fs_iomap_supports_hw_atomic(...)	(0)
 #endif
 
 static inline void fuse2fs_dump_extents(struct fuse2fs *ff, ext2_ino_t ino,
@@ -1995,14 +2010,19 @@ static int op_getattr(const char *path, struct stat *statbuf,
 static int op_getattr_iflags(const char *path, struct stat *statbuf,
 			     unsigned int *iflags, struct fuse_file_info *fi)
 {
+	struct fuse2fs *ff = fuse2fs_get();
 	int ret = op_getattr(path, statbuf, fi);
 
 	if (ret)
 		return ret;
 
-	if (fuse_fs_can_enable_iomap(statbuf))
+	if (fuse_fs_can_enable_iomap(statbuf)) {
 		*iflags |= FUSE_IFLAG_IOMAP | FUSE_IFLAG_EXCLUSIVE;
 
+		if (fuse2fs_iomap_supports_hw_atomic(ff))
+			*iflags |= FUSE_IFLAG_ATOMIC;
+	}
+
 	return 0;
 }
 #endif
@@ -2111,6 +2131,16 @@ static int fuse2fs_statx(struct fuse2fs *ff, ext2_ino_t ino, int statx_mask,
 
 	fuse2fs_statx_directio(ff, stx);
 
+#ifdef STATX_WRITE_ATOMIC
+	if (fuse_fs_can_enable_iomapx(stx) &&
+	    fuse2fs_iomap_supports_hw_atomic(ff)) {
+		stx->stx_mask |= STATX_WRITE_ATOMIC;
+		stx->stx_atomic_write_unit_min = ff->awu_min;
+		stx->stx_atomic_write_unit_max = ff->awu_max;
+		stx->stx_atomic_write_segments_max = 1;
+	}
+#endif
+
 	return 0;
 }
 
@@ -6220,6 +6250,9 @@ static int op_iomap_begin(const char *path, uint64_t nodeid, uint64_t attr_ino,
 		}
 	}
 
+	if (opflags & FUSE_IOMAP_OP_ATOMIC)
+		read->flags |= FUSE_IOMAP_F_ATOMIC_BIO;
+
 out_unlock:
 	fuse2fs_finish(ff, ret);
 	return ret;
@@ -6381,6 +6414,38 @@ static int fuse2fs_set_bdev_blocksize(struct fuse2fs *ff, int fd)
 	return -EIO;
 }
 
+#ifdef STATX_WRITE_ATOMIC
+static void fuse2fs_configure_atomic_write(struct fuse2fs *ff, int bdev_fd)
+{
+	struct statx devx;
+	unsigned int awu_min, awu_max;
+	int ret;
+
+	if (!ext2fs_has_feature_extents(ff->fs->super))
+		return;
+
+	ret = statx(bdev_fd, "", AT_EMPTY_PATH, STATX_WRITE_ATOMIC, &devx);
+	if (ret)
+		return;
+	if (!(devx.stx_mask & STATX_WRITE_ATOMIC))
+		return;
+
+	awu_min = max(ff->fs->blocksize, devx.stx_atomic_write_unit_min);
+	awu_max = min(ff->fs->blocksize, devx.stx_atomic_write_unit_max);
+	if (awu_min > awu_max)
+		return;
+
+	log_printf(ff, "%s awu_min: %u, awu_max: %u\n",
+		   _("Supports (experimental) DIO atomic writes"),
+		   awu_min, awu_max);
+
+	ff->awu_min = awu_min;
+	ff->awu_max = awu_max;
+}
+#else
+# define fuse2fs_configure_atomic_write(...)	((void)0)
+#endif
+
 static int fuse2fs_iomap_config_devices(struct fuse2fs *ff)
 {
 	errcode_t err;
@@ -6405,6 +6470,8 @@ static int fuse2fs_iomap_config_devices(struct fuse2fs *ff)
 	dbg_printf(ff, "%s: registered iomap dev fd=%d iomap_dev=%u\n",
 		   __func__, fd, ff->iomap_dev);
 
+	fuse2fs_configure_atomic_write(ff, fd);
+
 	ff->iomap_dev = ret;
 	return 0;
 }

