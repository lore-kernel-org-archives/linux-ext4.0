Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D2630DEB2;
	Wed, 29 Apr 2026 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474546; cv=none; b=joHQflVHZJtgg5i3lH/XP+qw8fLuJ2xe1wGDrEJryYfWxNtmZipuHCe35/oqli8PNaLvUW657pCkEk5PjQ2pN5L8soVOEhAt1B2ageSpF1Xw2z4oEHA18TsSXEQUo5Gziip5OWBgSODCwZr6b8t0KTxRZ/rfeqqLfTOFnROwX9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474546; c=relaxed/simple;
	bh=vC0PqMOvfQp4AQ9S5lpIqmerdNSlZq9S5sto/3QKq6Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CmPZOcYWiiDG+3UYEvqQT/wsvPO/ZpgWdd5zVZkFySegy80kR8LogZoXZTv9Bwk7h6zpRpCG/q1hG4/8L0lJP8x+j4UE2/WGDrOi8yQ+hh8d8SovS48bt6QZKUIg4R6odXng2FmdCxtEJYx+em5LTFPRBB94WOWOx8IF9KqOffE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIzn0dFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIzn0dFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE7FC19425;
	Wed, 29 Apr 2026 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474546;
	bh=vC0PqMOvfQp4AQ9S5lpIqmerdNSlZq9S5sto/3QKq6Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AIzn0dFvxxN6taaTDgsG+af2pq8BulbgD1lU/kUXCfmB64ePZNen9JZtqYaXodtcH
	 Y6pIgUUdcYziG+91dCiZdOOd9pgQBVNLrgg2OPhb42xWbL9NHaVJqKaXmzw2Qdt9bN
	 1p8lp3OJe857aByBKDh+022YrE8DCovc7WopruZQ1Xfd3tZOqvgI/N6PgppQ+XtaTP
	 oASiaEZw0/pcEwJnFfl39+dkuMDVwJo5Hy7YDKAJ6EXbN32SIB39KaTpoeDDjaSoAB
	 +3f0lFkXPM/jNia6LA3vbpFNfCnuk8XX5Defsaw402uxZ55oMJF2twIuOxy4LH/sS5
	 VvWoGcWYjvEoA==
Date: Wed, 29 Apr 2026 07:55:45 -0700
Subject: [PATCH 12/19] fuse2fs: enable file IO to inline data files
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214752.4107473.16188658739141343172.stgit@frogsfrogsfrogs>
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

Enable file reads and writes from inline data files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |    3 ++-
 misc/fuse2fs.c    |   42 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 3 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 3c3debb6f60ac7..e2421dda75475a 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -6566,7 +6566,8 @@ static int fuse4fs_iomap_begin_read(struct fuse4fs *ff, ext2_ino_t ino,
 {
 	/* fall back to slow path for inline data reads */
 	if (inode->i_flags & EXT4_INLINE_DATA_FL)
-		return -ENOSYS;
+		return fuse4fs_iomap_begin_inline(ff, ino, inode, pos, count,
+						  read);
 
 	if (inode->i_flags & EXT4_EXTENTS_FL)
 		return fuse4fs_iomap_begin_extent(ff, ino, inode, pos, count,
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 3c76eba683a10d..eecbf60a3360c6 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -1846,7 +1846,16 @@ static void *op_init(struct fuse_conn_info *conn,
 	cfg->use_ino = 1;
 	if (ff->debug)
 		cfg->debug = 1;
-	cfg->nullpath_ok = 1;
+
+	/*
+	 * Inline data file io depends on op_read/write being fed a path, so we
+	 * have to slow everyone down to look up the path from the nodeid.
+	 */
+	if (fuse2fs_iomap_enabled(ff) &&
+	    ext2fs_has_feature_inline_data(ff->fs->super))
+		cfg->nullpath_ok = 0;
+	else
+		cfg->nullpath_ok = 1;
 
 	fuse2fs_detach_losetup(ff);
 
@@ -3840,6 +3849,9 @@ static int op_read(const char *path EXT2FS_ATTR((unused)), char *buf,
 		   size_t len, off_t offset,
 		   struct fuse_file_info *fp)
 {
+	struct fuse2fs_file_handle fhurk = {
+		.magic = FUSE2FS_FILE_MAGIC,
+	};
 	struct fuse2fs *ff = fuse2fs_get();
 	struct fuse2fs_file_handle *fh = fuse2fs_get_handle(fp);
 	ext2_filsys fs;
@@ -3849,10 +3861,21 @@ static int op_read(const char *path EXT2FS_ATTR((unused)), char *buf,
 	int ret = 0;
 
 	FUSE2FS_CHECK_CONTEXT(ff);
+
+	if (!fh)
+		fh = &fhurk;
+
 	FUSE2FS_CHECK_HANDLE(ff, fh);
 	dbg_printf(ff, "%s: ino=%d off=0x%llx len=0x%zx\n", __func__, fh->ino,
 		   (unsigned long long)offset, len);
 	fs = fuse2fs_start(ff);
+
+	if (fh == &fhurk) {
+		ret = fuse2fs_file_ino(ff, path, NULL, &fhurk.ino);
+		if (ret)
+			goto out;
+	}
+
 	err = ext2fs_file_open(fs, fh->ino, fh->open_flags, &efp);
 	if (err) {
 		ret = translate_error(fs, fh->ino, err);
@@ -3894,6 +3917,10 @@ static int op_write(const char *path EXT2FS_ATTR((unused)),
 		    const char *buf, size_t len, off_t offset,
 		    struct fuse_file_info *fp)
 {
+	struct fuse2fs_file_handle fhurk = {
+		.magic = FUSE2FS_FILE_MAGIC,
+		.open_flags = EXT2_FILE_WRITE,
+	};
 	struct fuse2fs *ff = fuse2fs_get();
 	struct fuse2fs_file_handle *fh = fuse2fs_get_handle(fp);
 	ext2_filsys fs;
@@ -3903,6 +3930,10 @@ static int op_write(const char *path EXT2FS_ATTR((unused)),
 	int ret = 0;
 
 	FUSE2FS_CHECK_CONTEXT(ff);
+
+	if (!fh)
+		fh = &fhurk;
+
 	FUSE2FS_CHECK_HANDLE(ff, fh);
 	dbg_printf(ff, "%s: ino=%d off=0x%llx len=0x%zx\n", __func__, fh->ino,
 		   (unsigned long long) offset, len);
@@ -3917,6 +3948,12 @@ static int op_write(const char *path EXT2FS_ATTR((unused)),
 		goto out;
 	}
 
+	if (fh == &fhurk) {
+		ret = fuse2fs_file_ino(ff, path, NULL, &fhurk.ino);
+		if (ret)
+			goto out;
+	}
+
 	err = ext2fs_file_open(fs, fh->ino, fh->open_flags, &efp);
 	if (err) {
 		ret = translate_error(fs, fh->ino, err);
@@ -5860,7 +5897,8 @@ static int fuse2fs_iomap_begin_read(struct fuse2fs *ff, ext2_ino_t ino,
 {
 	/* fall back to slow path for inline data reads */
 	if (inode->i_flags & EXT4_INLINE_DATA_FL)
-		return -ENOSYS;
+		return fuse2fs_iomap_begin_inline(ff, ino, inode, pos, count,
+						  read);
 
 	if (inode->i_flags & EXT4_EXTENTS_FL)
 		return fuse2fs_iomap_begin_extent(ff, ino, inode, pos, count,

