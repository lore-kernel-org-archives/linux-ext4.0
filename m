Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8E627EFE9;
	Wed, 29 Apr 2026 14:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474515; cv=none; b=M0u7OJXKmhRVxufYNfR7qUlWw7iVxG7ocf1JyE4P//cU4Pz+Wz25HRla6ENYNybLwdo/DECSv8HozSP6hTehaa6w8qqY3TTTQKDNG6kuYrTaoUkjOE9dKR2HMpXq36GG9F8Q1gtuHkd6RXxIrhDhHy92VmUiJorfidSoaKjB0Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474515; c=relaxed/simple;
	bh=MeWH8mVd3Dj1CODKGWznPYE5sSmxPDPVVpQoWGL7Ia0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aDiK1SChl0ZpTduQdkLTCv4mxDwhgU6/1iav3oKij8pFdb4wWFKzzD79t05fCQlYJDF8o7165b6AUt7ccWkQzWJdJ4l4bOOrgcWfT0Z9CnihJ9rUdVw3IXsxs1tHKlqxdp7a5D8dJAFkA8NPUPn1ORGwCktuKmMSYiVUMSMEYtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t1zX1Zox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t1zX1Zox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C789EC19425;
	Wed, 29 Apr 2026 14:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474514;
	bh=MeWH8mVd3Dj1CODKGWznPYE5sSmxPDPVVpQoWGL7Ia0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t1zX1ZoxViViulUYacUBw44s2Vd80V2ilmRq/uWLKpt8kCJ1TWRYNg3fr0tUVH0Jz
	 EfbvlL7iSBzOsPtwD9d8iC17WtPQWbbKWMEE0q9rQdzwN2Mj5fhO4g2E5B2R93EDkl
	 6afout+pnryFoZYvEX26XgqfsEkCsCLxzD4GuHPntgfwARFchacItAzn4e5zk4Z4mq
	 dlhojeq1gWgqLdbynqu2nUOU9Cc6JV2I70sVs2cEC/RN/CHG0yp9kHiibopZF3rjYu
	 q4pwtG8wE8Q2b7rAqx1lLQ2GPfFOpB1fGasw3McOeGnKUEKWPZae/A72MF5DkTsONg
	 chUcYKUggdusA==
Date: Wed, 29 Apr 2026 07:55:14 -0700
Subject: [PATCH 10/19] fuse2fs: don't do file data block IO when iomap is
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214715.4107473.4460452026157984455.stgit@frogsfrogsfrogs>
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

When iomap is in use for the page cache, the kernel will take care of
all the file data block IO for us, including zeroing of punched ranges
and post-EOF bytes.  fuse2fs only needs to do IO for inline data.

Therefore, set the NOBLOCKIO ext2_file flag so that libext2fs will not
do any regular file IO to or from disk blocks at all.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   11 +++++++-
 misc/fuse2fs.c    |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 81 insertions(+), 2 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 40713b0d0d5e37..68f1f7c02df223 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -3933,9 +3933,14 @@ static int fuse4fs_truncate(struct fuse4fs *ff, ext2_ino_t ino, off_t new_size)
 	ext2_file_t file;
 	__u64 old_isize;
 	errcode_t err;
+	int flags = EXT2_FILE_WRITE;
 	int ret = 0;
 
-	err = ext2fs_file_open(fs, ino, EXT2_FILE_WRITE, &file);
+	/* the kernel handles all eof zeroing for us in iomap mode */
+	if (fuse4fs_iomap_enabled(ff))
+		flags |= EXT2_FILE_NOBLOCKIO;
+
+	err = ext2fs_file_open(fs, ino, flags, &file);
 	if (err)
 		return translate_error(fs, ino, err);
 
@@ -4030,6 +4035,10 @@ static int fuse4fs_open_file(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 	if (linked)
 		check |= L_OK;
 
+	/* the kernel handles all block IO for us in iomap mode */
+	if (fuse4fs_iomap_enabled(ff))
+		file->open_flags |= EXT2_FILE_NOBLOCKIO;
+
 	/*
 	 * If the caller wants to truncate the file, we need to ask for full
 	 * write access even if the caller claims to be appending.
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index a37851cdf30785..f7653dc6c20c3f 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -3463,15 +3463,72 @@ static int fuse2fs_punch_posteof(struct fuse2fs *ff, ext2_ino_t ino,
 	return 0;
 }
 
+/*
+ * Decide if file IO for this inode can use iomap.
+ *
+ * It turns out that libfuse creates internal node ids that have nothing to do
+ * with the ext2_ino_t that we give it.  These internal node ids are what
+ * actually gets igetted in the kernel, which means that there can be multiple
+ * fuse_inode objects in the kernel for a single hardlinked ondisk ext2 inode.
+ *
+ * What this means, horrifyingly, is that on a fuse filesystem that supports
+ * hard links, the in-kernel i_rwsem does not protect against concurrent writes
+ * between files that point to the same inode.  That in turn means that the
+ * file mode and size can get desynchronized between the multiple fuse_inode
+ * objects.  This also means that we cannot cache iomaps in the kernel AT ALL
+ * because the caches will get out of sync, leading to WARN_ONs from the iomap
+ * zeroing code and probably data corruption after that.
+ *
+ * Therefore, libfuse won't let us create hardlinks of iomap files, and we must
+ * never turn on iomap for existing hardlinked files.  Long term it means we
+ * have to find a way around this loss of functionality.  fuse4fs gets around
+ * this by being a low level fuse driver and controlling the nodeids itself.
+ *
+ * Returns 0 for no, 1 for yes, or a negative errno.
+ */
+#ifdef HAVE_FUSE_IOMAP
+static int fuse2fs_file_uses_iomap(struct fuse2fs *ff, ext2_ino_t ino)
+{
+	struct stat statbuf;
+	int ret;
+
+	if (!fuse2fs_iomap_enabled(ff))
+		return 0;
+
+	ret = stat_inode(ff->fs, ino, &statbuf);
+	if (ret)
+		return ret;
+
+	/* the kernel handles all block IO for us in iomap mode */
+	return fuse_fs_can_enable_iomap(&statbuf);
+}
+#else
+# define fuse2fs_file_uses_iomap(...)	(0)
+#endif
+
 static int fuse2fs_truncate(struct fuse2fs *ff, ext2_ino_t ino, off_t new_size)
 {
 	ext2_filsys fs = ff->fs;
 	ext2_file_t file;
 	__u64 old_isize;
 	errcode_t err;
+	int flags = EXT2_FILE_WRITE;
 	int ret = 0;
 
-	err = ext2fs_file_open(fs, ino, EXT2_FILE_WRITE, &file);
+	/* the kernel handles all eof zeroing for us in iomap mode */
+	ret = fuse2fs_file_uses_iomap(ff, ino);
+	switch (ret) {
+	case 0:
+		break;
+	case 1:
+		flags |= EXT2_FILE_NOBLOCKIO;
+		ret = 0;
+		break;
+	default:
+		return ret;
+	}
+
+	err = ext2fs_file_open(fs, ino, flags, &file);
 	if (err)
 		return translate_error(fs, ino, err);
 
@@ -3626,6 +3683,19 @@ static int __op_open(struct fuse2fs *ff, const char *path,
 			goto out;
 	}
 
+	/* the kernel handles all block IO for us in iomap mode */
+	ret = fuse2fs_file_uses_iomap(ff, file->ino);
+	switch (ret) {
+	case 0:
+		break;
+	case 1:
+		file->open_flags |= EXT2_FILE_NOBLOCKIO;
+		ret = 0;
+		break;
+	default:
+		goto out;
+	}
+
 	if (fp->flags & O_TRUNC) {
 		ret = fuse2fs_truncate(ff, file->ino, 0);
 		if (ret)

