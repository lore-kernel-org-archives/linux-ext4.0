Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC63F2727FD;
	Wed, 29 Apr 2026 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474483; cv=none; b=BqLbaer3KWliez4LAh2I8moqSvR9BjWHFPGtaIeJLN+0IU8QVuCf8DJNnufGU4ChA3N6ahnZLeCY3jg08+ZYvqEV0DUF3ul/u8Js4sYow/hpC0n/6W+riR6JnYyG9i5Kub6I30SzrGqtkxttycyQ6nje6UgSuHLxlEkWRo/AMRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474483; c=relaxed/simple;
	bh=hkNf50VWPsor680ts8cbNBQsJ+GpBIQU0jqMnkD6hCU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nMTieaVFkb6IvdxjDKYlwpGeiVXR/0WdpyiUfG9VIHhWSChracD+L1wkAOukTRJoxj20SBtnzzHd2/Y+hZornlrbmYqUTXtIofC65vWzmlXWc+9e5CKWKh4lt8erObeL//JJShfGHYQafC+wTf7310+5wieLXhGFXEwhEXJi0wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8WQCGvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8WQCGvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E65C19425;
	Wed, 29 Apr 2026 14:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474483;
	bh=hkNf50VWPsor680ts8cbNBQsJ+GpBIQU0jqMnkD6hCU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p8WQCGvuBPirP/0Q3IimzzEKTZPew8BW27PzfBTf7Yb0LjnzIV6WbwC9At7Kql5Hu
	 hufRu0mKpuPh2eNAhmgUUAcExWlvAefiU2RlOYkAVssdIhOGnfAVnJZYDDZm2MbFmx
	 MXC3yMPzhLen/Oic+ESyvNx07L3pK6cnkX3A2V+0ZZBvc0yAznC94hG/jCUQrnDdcy
	 siQwoKgBFigaiz2AGyxPegRe/O+e5HmQDAxBHamld4EDL/lSV5V9zMU+k/uXnYg1q1
	 TKdMasWUGJxa4IOYTsKQCNf15cTEGm7bXO5W8syBBOxbNtlJq718BV3j/Icbv/X4c3
	 Yxz6HjfV/57nQ==
Date: Wed, 29 Apr 2026 07:54:43 -0700
Subject: [PATCH 08/19] fuse2fs: turn on iomap for pagecache IO
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214680.4107473.11866114732768812318.stgit@frogsfrogsfrogs>
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

Turn on iomap for pagecache IO to regular files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++------
 misc/fuse2fs.c    |   61 +++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 108 insertions(+), 14 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 8b508de5b8cb65..fa82fda99ff687 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -6438,9 +6438,6 @@ static int fuse4fs_iomap_begin_read(struct fuse4fs *ff, ext2_ino_t ino,
 				    uint64_t count, uint32_t opflags,
 				    struct fuse_file_iomap *read)
 {
-	if (!(opflags & FUSE_IOMAP_OP_DIRECT))
-		return -ENOSYS;
-
 	/* fall back to slow path for inline data reads */
 	if (inode->i_flags & EXT4_INLINE_DATA_FL)
 		return -ENOSYS;
@@ -6531,9 +6528,6 @@ static int fuse4fs_iomap_begin_write(struct fuse4fs *ff, ext2_ino_t ino,
 	off_t max_size = fuse4fs_max_file_size(ff, inode);
 	int ret;
 
-	if (!(opflags & FUSE_IOMAP_OP_DIRECT))
-		return -ENOSYS;
-
 	if (pos >= max_size)
 		return -EFBIG;
 
@@ -6629,12 +6623,51 @@ static void op_iomap_begin(fuse_req_t req, fuse_ino_t fino, uint64_t dontcare,
 		fuse_reply_iomap_begin(req, &read, NULL);
 }
 
+static int fuse4fs_iomap_append_setsize(struct fuse4fs *ff, ext2_ino_t ino,
+					loff_t newsize)
+{
+	ext2_filsys fs = ff->fs;
+	struct ext2_inode_large inode;
+	ext2_off64_t isize;
+	errcode_t err;
+
+	dbg_printf(ff, "%s: ino=%u newsize=%llu\n", __func__, ino,
+		   (unsigned long long)newsize);
+
+	err = fuse4fs_read_inode(fs, ino, &inode);
+	if (err)
+		return translate_error(fs, ino, err);
+
+	isize = EXT2_I_SIZE(&inode);
+	if (newsize <= isize)
+		return 0;
+
+	dbg_printf(ff, "%s: ino=%u oldsize=%llu newsize=%llu\n", __func__, ino,
+		   (unsigned long long)isize,
+		   (unsigned long long)newsize);
+
+	/*
+	 * XXX cheesily update the ondisk size even though we only want to do
+	 * the incore size until writeback happens
+	 */
+	err = ext2fs_inode_size_set(fs, EXT2_INODE(&inode), newsize);
+	if (err)
+		return translate_error(fs, ino, err);
+
+	err = fuse4fs_write_inode(fs, ino, &inode);
+	if (err)
+		return translate_error(fs, ino, err);
+
+	return 0;
+}
+
 static void op_iomap_end(fuse_req_t req, fuse_ino_t fino, uint64_t dontcare,
 			 off_t pos, uint64_t count, uint32_t opflags,
 			 ssize_t written, const struct fuse_file_iomap *iomap)
 {
 	struct fuse4fs *ff = fuse4fs_get(req);
 	ext2_ino_t ino;
+	int ret = 0;
 
 	FUSE4FS_CHECK_CONTEXT(req);
 	FUSE4FS_CONVERT_FINO(req, &ino, fino);
@@ -6648,7 +6681,21 @@ static void op_iomap_end(fuse_req_t req, fuse_ino_t fino, uint64_t dontcare,
 		   written,
 		   iomap->flags);
 
-	fuse_reply_err(req, 0);
+	fuse4fs_start(ff);
+
+	/* XXX is this really necessary? */
+	if ((opflags & FUSE_IOMAP_OP_WRITE) &&
+	    !(opflags & FUSE_IOMAP_OP_DIRECT) &&
+	    (iomap->flags & FUSE_IOMAP_F_SIZE_CHANGED) &&
+	    written > 0) {
+		ret = fuse4fs_iomap_append_setsize(ff, ino, pos + written);
+		if (ret)
+			goto out_unlock;
+	}
+
+out_unlock:
+	fuse4fs_finish(ff, ret);
+	fuse_reply_err(req, -ret);
 }
 
 /*
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 67a5bc4c5cc986..679406323df86f 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -5673,9 +5673,6 @@ static int fuse2fs_iomap_begin_read(struct fuse2fs *ff, ext2_ino_t ino,
 				    uint64_t count, uint32_t opflags,
 				    struct fuse_file_iomap *read)
 {
-	if (!(opflags & FUSE_IOMAP_OP_DIRECT))
-		return -ENOSYS;
-
 	/* fall back to slow path for inline data reads */
 	if (inode->i_flags & EXT4_INLINE_DATA_FL)
 		return -ENOSYS;
@@ -5763,9 +5760,6 @@ static int fuse2fs_iomap_begin_write(struct fuse2fs *ff, ext2_ino_t ino,
 	off_t max_size = fuse2fs_max_file_size(ff, inode);
 	int ret;
 
-	if (!(opflags & FUSE_IOMAP_OP_DIRECT))
-		return -ENOSYS;
-
 	if (pos >= max_size)
 		return -EFBIG;
 
@@ -5860,11 +5854,50 @@ static int op_iomap_begin(const char *path, uint64_t nodeid, uint64_t attr_ino,
 	return ret;
 }
 
+static int fuse2fs_iomap_append_setsize(struct fuse2fs *ff, ext2_ino_t ino,
+					loff_t newsize)
+{
+	ext2_filsys fs = ff->fs;
+	struct ext2_inode_large inode;
+	ext2_off64_t isize;
+	errcode_t err;
+
+	dbg_printf(ff, "%s: ino=%u newsize=%llu\n", __func__, ino,
+		   (unsigned long long)newsize);
+
+	err = fuse2fs_read_inode(fs, ino, &inode);
+	if (err)
+		return translate_error(fs, ino, err);
+
+	isize = EXT2_I_SIZE(&inode);
+	if (newsize <= isize)
+		return 0;
+
+	dbg_printf(ff, "%s: ino=%u oldsize=%llu newsize=%llu\n", __func__, ino,
+		   (unsigned long long)isize,
+		   (unsigned long long)newsize);
+
+	/*
+	 * XXX cheesily update the ondisk size even though we only want to do
+	 * the incore size until writeback happens
+	 */
+	err = ext2fs_inode_size_set(fs, EXT2_INODE(&inode), newsize);
+	if (err)
+		return translate_error(fs, ino, err);
+
+	err = fuse2fs_write_inode(fs, ino, &inode);
+	if (err)
+		return translate_error(fs, ino, err);
+
+	return 0;
+}
+
 static int op_iomap_end(const char *path, uint64_t nodeid, uint64_t attr_ino,
 			off_t pos, uint64_t count, uint32_t opflags,
 			ssize_t written, const struct fuse_file_iomap *iomap)
 {
 	struct fuse2fs *ff = fuse2fs_get();
+	int ret = 0;
 
 	FUSE2FS_CHECK_CONTEXT(ff);
 
@@ -5879,7 +5912,21 @@ static int op_iomap_end(const char *path, uint64_t nodeid, uint64_t attr_ino,
 		   written,
 		   iomap->flags);
 
-	return 0;
+	fuse2fs_start(ff);
+
+	/* XXX is this really necessary? */
+	if ((opflags & FUSE_IOMAP_OP_WRITE) &&
+	    !(opflags & FUSE_IOMAP_OP_DIRECT) &&
+	    (iomap->flags & FUSE_IOMAP_F_SIZE_CHANGED) &&
+	    written > 0) {
+		ret = fuse2fs_iomap_append_setsize(ff, attr_ino, pos + written);
+		if (ret)
+			goto out_unlock;
+	}
+
+out_unlock:
+	fuse2fs_finish(ff, ret);
+	return ret;
 }
 
 /*

