Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2594361DA2;
	Wed, 29 Apr 2026 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474858; cv=none; b=Vzy3y7V+fUp5xTMoWx8OzaeuqJPI/uu3tywr0A3HQWItTfUYZN4fIBm9QKorSWyMjH3giy+ny3S32RGEDVB4fqw3A8JYz6Udqwz1yYzAjXraFWr0hSLsYuwLz/3XDeTrokDE+TCDiKBMqzc0J3gqevtujnJ3Oo/CqornrdOgN2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474858; c=relaxed/simple;
	bh=NhaC0QNCt71AY0orHcuq9ayVQKStY2oGN6eFZ3zXh4w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jA5gkN52SNBPF1N1+FCBijuurFBlabXZHsPi5YojS6ms9klkScbqknVAdrxNpxiGQDzwI3zYxu/m5co2WdxIehVedX7CjMfTnCRmqBTwDQjsC6RqKdde7Jj4BBU9D0MTMpab4PT3Ygxf50JOwHBLP1fcGpZpPN1YI1IrQySepC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlHyhaLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlHyhaLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC7BC19425;
	Wed, 29 Apr 2026 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474858;
	bh=NhaC0QNCt71AY0orHcuq9ayVQKStY2oGN6eFZ3zXh4w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KlHyhaLyo6nOsj7GOQsrNj94KBLhUplK3HJEw2BTYKRQ9MF2xCVZQeHlWLoqDPa2q
	 UhkP/gAuGCH3eIZhX/wC0jh3gmt2niPZtxkigyHz2IEsev2OHwAyrusoyIpjbfLVPz
	 v4pBP1JdHpn8nX1t6bU2Fmy+ifg6OM9H5YnHcRY+FTCkCh4P++mQhZ4hfkuqkp+2lG
	 lKmX2e6T4buST5UHpoblPaKgKGPfDdBqynfFlmkWr2dc43qo/c8Xj83ZnxK8oLMR33
	 WojPl/oRv2ytxbKrYunBxqpgjbfJNlEzre4hyipm3B91hAO06m/Mw7ohL0PWB+cu1B
	 Yosa9oi005pMg==
Date: Wed, 29 Apr 2026 08:00:57 -0700
Subject: [PATCH 09/10] fuse2fs: set sync, immutable,
 and append at file load time
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215544.4110156.9861127440007449277.stgit@frogsfrogsfrogs>
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

Convey these three inode flags to the kernel when we're loading a file.
This way the kernel can advertise and enforce those flags so that the
fuse server doesn't have to.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   16 ++++++++++++++++
 misc/fuse2fs.c    |   53 ++++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 54 insertions(+), 15 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 51958d6677288c..b4105333f4fe22 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -2441,6 +2441,22 @@ static int fuse4fs_stat_inode(struct fuse4fs *ff, ext2_ino_t ino,
 	entry->entry_timeout = FUSE4FS_ATTR_TIMEOUT;
 
 	fstat->iflags = 0;
+
+#ifdef FUSE_IFLAG_SYNC
+	if (inodep->i_flags & EXT2_SYNC_FL)
+		fstat->iflags |= FUSE_IFLAG_SYNC;
+#endif
+
+#ifdef FUSE_IFLAG_IMMUTABLE
+	if (inodep->i_flags & EXT2_IMMUTABLE_FL)
+		fstat->iflags |= FUSE_IFLAG_IMMUTABLE;
+#endif
+
+#ifdef FUSE_IFLAG_APPEND
+	if (inodep->i_flags & EXT2_APPEND_FL)
+		fstat->iflags |= FUSE_IFLAG_APPEND;
+#endif
+
 #ifdef HAVE_FUSE_IOMAP
 	if (fuse4fs_iomap_enabled(ff)) {
 		fstat->iflags |= FUSE_IFLAG_IOMAP | FUSE_IFLAG_EXCLUSIVE;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 026c547618b5cd..6e4780121d5c83 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -1956,7 +1956,7 @@ static void *op_init(struct fuse_conn_info *conn,
 }
 
 static int fuse2fs_stat(struct fuse2fs *ff, ext2_ino_t ino,
-			struct stat *statbuf)
+			struct stat *statbuf, unsigned int *iflags)
 {
 	struct ext2_inode_large inode;
 	ext2_filsys fs = ff->fs;
@@ -2013,6 +2013,7 @@ static int fuse2fs_stat(struct fuse2fs *ff, ext2_ino_t ino,
 			statbuf->st_rdev = inode.i_block[1];
 	}
 
+	*iflags = inode.i_flags;
 	return ret;
 }
 
@@ -2047,22 +2048,31 @@ static int __fuse2fs_file_ino(struct fuse2fs *ff, const char *path,
 # define fuse2fs_file_ino(ff, path, fp, inop) \
 	__fuse2fs_file_ino((ff), (path), (fp), (inop), __func__, __LINE__)
 
+static int fuse2fs_getattr(struct fuse2fs *ff, const char *path,
+			   struct stat *statbuf, struct fuse_file_info *fi,
+			   unsigned int *iflags)
+{
+	ext2_ino_t ino;
+	int ret = 0;
+
+	FUSE2FS_CHECK_CONTEXT(ff);
+	fuse2fs_start(ff);
+	ret = fuse2fs_file_ino(ff, path, fi, &ino);
+	if (ret)
+		goto out;
+	ret = fuse2fs_stat(ff, ino, statbuf, iflags);
+out:
+	fuse2fs_finish(ff, ret);
+	return ret;
+}
+
 static int op_getattr(const char *path, struct stat *statbuf,
 		      struct fuse_file_info *fi)
 {
 	struct fuse2fs *ff = fuse2fs_get();
-	ext2_ino_t ino;
-	int ret = 0;
+	unsigned int dontcare;
 
-	FUSE2FS_CHECK_CONTEXT(ff);
-	fuse2fs_start(ff);
-	ret = fuse2fs_file_ino(ff, path, fi, &ino);
-	if (ret)
-		goto out;
-	ret = fuse2fs_stat(ff, ino, statbuf);
-out:
-	fuse2fs_finish(ff, ret);
-	return ret;
+	return fuse2fs_getattr(ff, path, statbuf, fi, &dontcare);
 }
 
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 99)
@@ -2070,11 +2080,21 @@ static int op_getattr_iflags(const char *path, struct stat *statbuf,
 			     unsigned int *iflags, struct fuse_file_info *fi)
 {
 	struct fuse2fs *ff = fuse2fs_get();
-	int ret = op_getattr(path, statbuf, fi);
+	unsigned int i_flags;
+	int ret = fuse2fs_getattr(ff, path, statbuf, fi, &i_flags);
 
 	if (ret)
 		return ret;
 
+	if (i_flags & EXT2_SYNC_FL)
+		*iflags |= FUSE_IFLAG_SYNC;
+
+	if (i_flags & EXT2_IMMUTABLE_FL)
+		*iflags |= FUSE_IFLAG_IMMUTABLE;
+
+	if (i_flags & EXT2_APPEND_FL)
+		*iflags |= FUSE_IFLAG_APPEND;
+
 	if (fuse_fs_can_enable_iomap(statbuf)) {
 		*iflags |= FUSE_IFLAG_IOMAP | FUSE_IFLAG_EXCLUSIVE;
 
@@ -3844,12 +3864,13 @@ static int fuse2fs_punch_posteof(struct fuse2fs *ff, ext2_ino_t ino,
 static int fuse2fs_file_uses_iomap(struct fuse2fs *ff, ext2_ino_t ino)
 {
 	struct stat statbuf;
+	unsigned int dontcare;
 	int ret;
 
 	if (!fuse2fs_iomap_enabled(ff))
 		return 0;
 
-	ret = fuse2fs_stat(ff, ino, &statbuf);
+	ret = fuse2fs_stat(ff, ino, &statbuf, &dontcare);
 	if (ret)
 		return ret;
 
@@ -4758,7 +4779,9 @@ static int op_readdir_iter(ext2_ino_t dir EXT2FS_ATTR((unused)),
 			(unsigned long long)i->dirpos);
 
 	if (i->flags == FUSE_READDIR_PLUS) {
-		ret = fuse2fs_stat(i->ff, dirent->inode, &stat);
+		unsigned int dontcare;
+
+		ret = fuse2fs_stat(i->ff, dirent->inode, &stat, &dontcare);
 		if (ret)
 			return DIRENT_ABORT;
 	}

