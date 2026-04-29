Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ABB308F26;
	Wed, 29 Apr 2026 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474827; cv=none; b=FOA51STylM2tc7X9/ORZKET4QqZahFP8AfzL7GbGnYRytiFJ3BuayHVoNhApTEQzyLGRsrYGyXqmBgF9UGd6fNV+O+Xzkmpj/JLoa5x34QMED1Qcizi0A/MXIsgv3s05dgAktVHsemvgpT/GrNN6jrAiggCqbi1qr5pRjT/FQtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474827; c=relaxed/simple;
	bh=oyaRtscEhPkk79C+snNz3c0AVoTMc8RL8AR9HJuLN88=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tK3Y/mi7ta4Y89COmnIRK+n3nQSCU+dxAJXFppuWZuQmqmUHSgmm5DFZQDuxw4fmwaiKn3hL8QebcfxC5p69me6rMmyPJGPty73vl7LAwiQNjZEBN8zzg5J182+cD2yPDA3FfGWNhYca3pTNezbFouVZp+34vb5T5qQXGZ3EEVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gki5SUXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gki5SUXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D46AC19425;
	Wed, 29 Apr 2026 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474827;
	bh=oyaRtscEhPkk79C+snNz3c0AVoTMc8RL8AR9HJuLN88=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Gki5SUXTLkddio8h7ecrLCxQOpFqMJVESJBuhru9oPLYtYj+wYim7/FwIlsow3xTq
	 WccVkew9shvsQmQb5GnVsNaNB592osJHl4hDxLAHrRYOPahj+EL9d96d1IY5CigwSD
	 6IlTkDm6tB/p8gZ4Hgm54g3oS/HkDLh88yZXrr4/7YS64YLdj9iKwpYYQtUz7sdovP
	 AevgVoonNj1lJlU7Mok/5Qz4ERqzbzXNaNRGjAH1tFr6OzAnEkCnzbDZznrxAQYq5Q
	 dDrBydjccbd9hOH7AgWSQWQHSYIdb8KuX4uRgHhDaXawhaUP9B/qAre+xeNADc7ZSh
	 vyr4JdnWK6V7A==
Date: Wed, 29 Apr 2026 08:00:26 -0700
Subject: [PATCH 07/10] fuse2fs: add tracing for retrieving timestamps
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215508.4110156.9976120423922421612.stgit@frogsfrogsfrogs>
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

Add tracing for retrieving timestamps so we can debug the weird
behavior.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 misc/fuse2fs.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)


diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 458fd6e5bf6dd8..e790f6c2b59ecd 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -1955,9 +1955,11 @@ static void *op_init(struct fuse_conn_info *conn,
 	return ff;
 }
 
-static int stat_inode(ext2_filsys fs, ext2_ino_t ino, struct stat *statbuf)
+static int fuse2fs_stat(struct fuse2fs *ff, ext2_ino_t ino,
+			struct stat *statbuf)
 {
 	struct ext2_inode_large inode;
+	ext2_filsys fs = ff->fs;
 	dev_t fakedev = 0;
 	errcode_t err;
 	int ret = 0;
@@ -1996,6 +1998,13 @@ static int stat_inode(ext2_filsys fs, ext2_ino_t ino, struct stat *statbuf)
 #else
 	statbuf->st_ctime = tv.tv_sec;
 #endif
+
+	dbg_printf(ff, "%s: ino=%d atime=%lld.%ld mtime=%lld.%ld ctime=%lld.%ld\n",
+		   __func__, ino,
+		   (long long int)statbuf->st_atim.tv_sec, statbuf->st_atim.tv_nsec,
+		   (long long int)statbuf->st_mtim.tv_sec, statbuf->st_mtim.tv_nsec,
+		   (long long int)statbuf->st_ctim.tv_sec, statbuf->st_ctim.tv_nsec);
+
 	if (LINUX_S_ISCHR(inode.i_mode) ||
 	    LINUX_S_ISBLK(inode.i_mode)) {
 		if (inode.i_block[0])
@@ -2042,16 +2051,15 @@ static int op_getattr(const char *path, struct stat *statbuf,
 		      struct fuse_file_info *fi)
 {
 	struct fuse2fs *ff = fuse2fs_get();
-	ext2_filsys fs;
 	ext2_ino_t ino;
 	int ret = 0;
 
 	FUSE2FS_CHECK_CONTEXT(ff);
-	fs = fuse2fs_start(ff);
+	fuse2fs_start(ff);
 	ret = fuse2fs_file_ino(ff, path, fi, &ino);
 	if (ret)
 		goto out;
-	ret = stat_inode(fs, ino, statbuf);
+	ret = fuse2fs_stat(ff, ino, statbuf);
 out:
 	fuse2fs_finish(ff, ret);
 	return ret;
@@ -3841,7 +3849,7 @@ static int fuse2fs_file_uses_iomap(struct fuse2fs *ff, ext2_ino_t ino)
 	if (!fuse2fs_iomap_enabled(ff))
 		return 0;
 
-	ret = stat_inode(ff->fs, ino, &statbuf);
+	ret = fuse2fs_stat(ff, ino, &statbuf);
 	if (ret)
 		return ret;
 
@@ -4750,7 +4758,7 @@ static int op_readdir_iter(ext2_ino_t dir EXT2FS_ATTR((unused)),
 			(unsigned long long)i->dirpos);
 
 	if (i->flags == FUSE_READDIR_PLUS) {
-		ret = stat_inode(i->fs, dirent->inode, &stat);
+		ret = fuse2fs_stat(i->ff, dirent->inode, &stat);
 		if (ret)
 			return DIRENT_ABORT;
 	}

