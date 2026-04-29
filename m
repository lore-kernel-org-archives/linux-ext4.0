Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4393C348860;
	Wed, 29 Apr 2026 14:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474405; cv=none; b=I08Ej0y6/4Yi1uaMiehHBDkuu+dKwuyIJyQ6LyZXQdXMRV2tlAuLBkN1jGYnqKh4JJlTPxcFJ7EKPXmwlB8ndiG8mIMaYLhTZCW0ImCdPLwueWxNadPl8IkFgNTfQhzNTeaRxFdbaeCrjyWsAQI+akyPeZcl04NqDfs/bk60cxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474405; c=relaxed/simple;
	bh=5b8JXRY84oGHHIhcsgBig9mNPsyF7xzRBfsqkN+n4uM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8+jvDpXGnWTy5mLDtVoExx8qqR+QWzL/WY7MAW4cEeVrN7GiEWLjcUMT/oqh6Ch1SyFIO65VAPhYYNTUvzQV+7qYkDM9Hk0nHnBBQMQ+sYvvhi+E+o72fxwcPsYTRojt9/tb0yJ1PVa35G1fAB17p+EZIhxzgnJkWBuaDNLz0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQn43XuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQn43XuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6B7C19425;
	Wed, 29 Apr 2026 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474405;
	bh=5b8JXRY84oGHHIhcsgBig9mNPsyF7xzRBfsqkN+n4uM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BQn43XuHFC8bGERwhJdlPVCEp9MXexOURGmZw6Hg42io2BbWvZRRGkTklMl09X/qM
	 A+QbSOi40etPU9GGpBCnY5prYPc768PkuBcxJD67y8dA9haCmZfKwaLQyo7CEH5TUO
	 pBM1ZXq88urPBgoTaqOIXVbI1dzugynczKnkr3Tw876qmU65WLJc+wjL5q25Tc6j9j
	 n1WWbBaktnwUACSWT1W7q8Fh3lw6aUnqvoDTHOKw8cKQe+1vUmm4zWcMXp9T6UC60D
	 k795Jh+O6AGiwu5beZXOoJiy/vYgco6cFewN0Lv2qxXxnvinTaxOZoAAx0XszLVZ6/
	 k7nxbABzQsuRA==
Date: Wed, 29 Apr 2026 07:53:24 -0700
Subject: [PATCH 03/19] fuse2fs: implement iomap configuration
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214590.4107473.12172144510741083607.stgit@frogsfrogsfrogs>
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

Upload the filesystem geometry to the kernel when asked.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 misc/fuse2fs.c    |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 188 insertions(+), 6 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index df2bda7cc22bf2..feb46bdfbac39b 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -208,6 +208,10 @@ static inline uint64_t round_down(uint64_t b, unsigned int align)
 # define FL_ZERO_RANGE_FLAG (0)
 #endif
 
+#ifndef NSEC_PER_SEC
+# define NSEC_PER_SEC	(1000000000L)
+#endif
+
 errcode_t ext2fs_check_ext3_journal(ext2_filsys fs);
 errcode_t ext2fs_run_ext3_journal(ext2_filsys *fs);
 
@@ -995,9 +999,9 @@ static int update_atime(ext2_filsys fs, ext2_ino_t ino)
 	EXT4_INODE_GET_XTIME(i_mtime, &mtime, pinode);
 	get_now(&now);
 
-	datime = atime.tv_sec + ((double)atime.tv_nsec / 1000000000);
-	dmtime = mtime.tv_sec + ((double)mtime.tv_nsec / 1000000000);
-	dnow = now.tv_sec + ((double)now.tv_nsec / 1000000000);
+	datime = atime.tv_sec + ((double)atime.tv_nsec / NSEC_PER_SEC);
+	dmtime = mtime.tv_sec + ((double)mtime.tv_nsec / NSEC_PER_SEC);
+	dnow = now.tv_sec + ((double)now.tv_nsec / NSEC_PER_SEC);
 
 	/*
 	 * If atime is newer than mtime and atime hasn't been updated in thirty
@@ -6459,6 +6463,93 @@ static void op_iomap_end(fuse_req_t req, fuse_ino_t fino, uint64_t dontcare,
 
 	fuse_reply_err(req, 0);
 }
+
+/*
+ * Maximal extent format file size.
+ * Resulting logical blkno at s_maxbytes must fit in our on-disk
+ * extent format containers, within a sector_t, and within i_blocks
+ * in the vfs.  ext4 inode has 48 bits of i_block in fsblock units,
+ * so that won't be a limiting factor.
+ *
+ * However there is other limiting factor. We do store extents in the form
+ * of starting block and length, hence the resulting length of the extent
+ * covering maximum file size must fit into on-disk format containers as
+ * well. Given that length is always by 1 unit bigger than max unit (because
+ * we count 0 as well) we have to lower the s_maxbytes by one fs block.
+ *
+ * Note, this does *not* consider any metadata overhead for vfs i_blocks.
+ */
+static off_t fuse4fs_max_size(struct fuse4fs *ff, off_t upper_limit)
+{
+	off_t res;
+
+	if (!ext2fs_has_feature_huge_file(ff->fs->super)) {
+		upper_limit = (1LL << 32) - 1;
+
+		/* total blocks in file system block size */
+		upper_limit >>= (ff->blocklog - 9);
+		upper_limit <<= ff->blocklog;
+	}
+
+	/*
+	 * 32-bit extent-start container, ee_block. We lower the maxbytes
+	 * by one fs block, so ee_len can cover the extent of maximum file
+	 * size
+	 */
+	res = (1LL << 32) - 1;
+	res <<= ff->blocklog;
+
+	/* Sanity check against vm- & vfs- imposed limits */
+	if (res > upper_limit)
+		res = upper_limit;
+
+	return res;
+}
+
+static void op_iomap_config(fuse_req_t req,
+			    const struct fuse_iomap_config_params *p,
+			    size_t psize)
+{
+	struct fuse_iomap_config cfg = { };
+	struct fuse4fs *ff = fuse4fs_get(req);
+	ext2_filsys fs;
+
+	FUSE4FS_CHECK_CONTEXT(req);
+
+	dbg_printf(ff, "%s: flags=0x%llx maxbytes=0x%llx\n", __func__,
+		   (unsigned long long)p->flags,
+		   (unsigned long long)p->maxbytes);
+	fs = fuse4fs_start(ff);
+
+	cfg.flags |= FUSE_IOMAP_CONFIG_UUID;
+	memcpy(cfg.s_uuid, fs->super->s_uuid, sizeof(cfg.s_uuid));
+	cfg.s_uuid_len = sizeof(fs->super->s_uuid);
+
+	cfg.flags |= FUSE_IOMAP_CONFIG_BLOCKSIZE;
+	cfg.s_blocksize = FUSE4FS_FSB_TO_B(ff, 1);
+
+	/*
+	 * If there inode is large enough to house i_[acm]time_extra then we
+	 * can turn on nanosecond timestamps; i_crtime was the next field added
+	 * after i_atime_extra.
+	 */
+	cfg.flags |= FUSE_IOMAP_CONFIG_TIME;
+	if (fs->super->s_inode_size >=
+	    offsetof(struct ext2_inode_large, i_crtime)) {
+		cfg.s_time_gran = 1;
+		cfg.s_time_max = EXT4_EXTRA_TIMESTAMP_MAX;
+	} else {
+		cfg.s_time_gran = NSEC_PER_SEC;
+		cfg.s_time_max = EXT4_NON_EXTRA_TIMESTAMP_MAX;
+	}
+	cfg.s_time_min = EXT4_TIMESTAMP_MIN;
+
+	cfg.flags |= FUSE_IOMAP_CONFIG_MAXBYTES;
+	cfg.s_maxbytes = fuse4fs_max_size(ff, p->maxbytes);
+
+	fuse4fs_finish(ff, 0);
+	fuse_reply_iomap_config(req, &cfg);
+}
 #endif /* HAVE_FUSE_IOMAP */
 
 static struct fuse_lowlevel_ops fs_ops = {
@@ -6507,6 +6598,7 @@ static struct fuse_lowlevel_ops fs_ops = {
 #ifdef HAVE_FUSE_IOMAP
 	.iomap_begin = op_iomap_begin,
 	.iomap_end = op_iomap_end,
+	.iomap_config = op_iomap_config,
 #endif /* HAVE_FUSE_IOMAP */
 };
 
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 15ebe6b39f1288..7df4e127e5981a 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -191,6 +191,10 @@ static inline uint64_t round_down(uint64_t b, unsigned int align)
 # define FL_ZERO_RANGE_FLAG (0)
 #endif
 
+#ifndef NSEC_PER_SEC
+# define NSEC_PER_SEC	(1000000000L)
+#endif
+
 errcode_t ext2fs_check_ext3_journal(ext2_filsys fs);
 errcode_t ext2fs_run_ext3_journal(ext2_filsys *fs);
 
@@ -806,9 +810,9 @@ static int update_atime(ext2_filsys fs, ext2_ino_t ino)
 	EXT4_INODE_GET_XTIME(i_mtime, &mtime, pinode);
 	get_now(&now);
 
-	datime = atime.tv_sec + ((double)atime.tv_nsec / 1000000000);
-	dmtime = mtime.tv_sec + ((double)mtime.tv_nsec / 1000000000);
-	dnow = now.tv_sec + ((double)now.tv_nsec / 1000000000);
+	datime = atime.tv_sec + ((double)atime.tv_nsec / NSEC_PER_SEC);
+	dmtime = mtime.tv_sec + ((double)mtime.tv_nsec / NSEC_PER_SEC);
+	dnow = now.tv_sec + ((double)now.tv_nsec / NSEC_PER_SEC);
 
 	/*
 	 * If atime is newer than mtime and atime hasn't been updated in thirty
@@ -5692,6 +5696,91 @@ static int op_iomap_end(const char *path, uint64_t nodeid, uint64_t attr_ino,
 
 	return 0;
 }
+
+/*
+ * Maximal extent format file size.
+ * Resulting logical blkno at s_maxbytes must fit in our on-disk
+ * extent format containers, within a sector_t, and within i_blocks
+ * in the vfs.  ext4 inode has 48 bits of i_block in fsblock units,
+ * so that won't be a limiting factor.
+ *
+ * However there is other limiting factor. We do store extents in the form
+ * of starting block and length, hence the resulting length of the extent
+ * covering maximum file size must fit into on-disk format containers as
+ * well. Given that length is always by 1 unit bigger than max unit (because
+ * we count 0 as well) we have to lower the s_maxbytes by one fs block.
+ *
+ * Note, this does *not* consider any metadata overhead for vfs i_blocks.
+ */
+static off_t fuse2fs_max_size(struct fuse2fs *ff, off_t upper_limit)
+{
+	off_t res;
+
+	if (!ext2fs_has_feature_huge_file(ff->fs->super)) {
+		upper_limit = (1LL << 32) - 1;
+
+		/* total blocks in file system block size */
+		upper_limit >>= (ff->blocklog - 9);
+		upper_limit <<= ff->blocklog;
+	}
+
+	/*
+	 * 32-bit extent-start container, ee_block. We lower the maxbytes
+	 * by one fs block, so ee_len can cover the extent of maximum file
+	 * size
+	 */
+	res = (1LL << 32) - 1;
+	res <<= ff->blocklog;
+
+	/* Sanity check against vm- & vfs- imposed limits */
+	if (res > upper_limit)
+		res = upper_limit;
+
+	return res;
+}
+
+static int op_iomap_config(const struct fuse_iomap_config_params *p,
+			   size_t psize, struct fuse_iomap_config *cfg)
+{
+	struct fuse2fs *ff = fuse2fs_get();
+	ext2_filsys fs;
+
+	FUSE2FS_CHECK_CONTEXT(ff);
+
+	dbg_printf(ff, "%s: flags=0x%llx maxbytes=0x%llx\n", __func__,
+		   (unsigned long long)p->flags,
+		   (unsigned long long)p->maxbytes);
+	fs = fuse2fs_start(ff);
+
+	cfg->flags |= FUSE_IOMAP_CONFIG_UUID;
+	memcpy(cfg->s_uuid, fs->super->s_uuid, sizeof(cfg->s_uuid));
+	cfg->s_uuid_len = sizeof(fs->super->s_uuid);
+
+	cfg->flags |= FUSE_IOMAP_CONFIG_BLOCKSIZE;
+	cfg->s_blocksize = FUSE2FS_FSB_TO_B(ff, 1);
+
+	/*
+	 * If there inode is large enough to house i_[acm]time_extra then we
+	 * can turn on nanosecond timestamps; i_crtime was the next field added
+	 * after i_atime_extra.
+	 */
+	cfg->flags |= FUSE_IOMAP_CONFIG_TIME;
+	if (fs->super->s_inode_size >=
+	    offsetof(struct ext2_inode_large, i_crtime)) {
+		cfg->s_time_gran = 1;
+		cfg->s_time_max = EXT4_EXTRA_TIMESTAMP_MAX;
+	} else {
+		cfg->s_time_gran = NSEC_PER_SEC;
+		cfg->s_time_max = EXT4_NON_EXTRA_TIMESTAMP_MAX;
+	}
+	cfg->s_time_min = EXT4_TIMESTAMP_MIN;
+
+	cfg->flags |= FUSE_IOMAP_CONFIG_MAXBYTES;
+	cfg->s_maxbytes = fuse2fs_max_size(ff, p->maxbytes);
+
+	fuse2fs_finish(ff, 0);
+	return 0;
+}
 #endif /* HAVE_FUSE_IOMAP */
 
 static struct fuse_operations fs_ops = {
@@ -5738,6 +5827,7 @@ static struct fuse_operations fs_ops = {
 #ifdef HAVE_FUSE_IOMAP
 	.iomap_begin = op_iomap_begin,
 	.iomap_end = op_iomap_end,
+	.iomap_config = op_iomap_config,
 #endif /* HAVE_FUSE_IOMAP */
 };
 

