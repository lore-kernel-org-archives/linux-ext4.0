Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1870433121C;
	Wed, 29 Apr 2026 15:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474921; cv=none; b=IE+tNgW9Ptvn2EZKRF7gqt3ObUmAUfXtvoIQJwanw1sfJrNyGM3DJiAritMymFnsvnuhrywGAHbDfkpSSQqNsZET/owROctb3Mp8StEnPH05Ko5MNukY8yhP3qq1APR8ErfpjyQQZla3SgUNTEIfurhypZcpRkvfv2EGY9d4VXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474921; c=relaxed/simple;
	bh=uhOEUfzc4WLHDPaUiJemNfGMbyvGoKbxSNV7FopaEPM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L2fp70hgtPUoJyB6wb2rbFAO7xwGhgHbx8LLQRF/6EXTOtDLwSehYaopLtl0wp1lrg6iQPYbS2zu+KkD+XcBMrrTR7LRQl5b5vOgFYQFm77hjeS4cIKoIvLARaO6W4wBaoH325y/IP2odi3QYR6GcLsxccs1WZ01wMingZrvNsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+CXXnrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+CXXnrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8B4C19425;
	Wed, 29 Apr 2026 15:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474920;
	bh=uhOEUfzc4WLHDPaUiJemNfGMbyvGoKbxSNV7FopaEPM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T+CXXnrCSHJpijbz4lmaiwiXDHuMIiKrDYsme7qllLz1L6xVLq6aj3Wji9SHJZwBd
	 BdC7/MG1dVg7yqlqYzqKYgiduxYTTR+1HX1weEPoSSNzpgJrGx/aQitnJgCrWpW+n4
	 dX1QeGDZs6H/ZrdlZ9HSoYkfuGG24TXsO7mOmtETWaKIwZtzDrEjqn4HqIaUVRP7V6
	 YWu7pQam77CHMlygrzRpspDne/ynfQENAemwrs93vNG6P6AnNKMxpc1nrKitq+Ulgo
	 ABeJDqEEl7kI2oYtG1EfG/AwWqMD+piNfXiwT3sDU3ZXBRtLcm2t81AxyOf7PxuX1b
	 BJzsHL7KuxMjg==
Date: Wed, 29 Apr 2026 08:02:00 -0700
Subject: [PATCH 3/4] fuse4fs: upsert first file mapping to kernel on open
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215753.4110581.7454259395904906217.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215686.4110581.16852917113451473539.stgit@frogsfrogsfrogs>
References: <177747215686.4110581.16852917113451473539.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Try to speed up the first access to a file by upserting the first
file space mapping to the kernel at open time.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index d07c576d31862a..b10a9a8be00a08 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -4415,6 +4415,9 @@ static void detect_linux_executable_open(int kernel_flags, int *access_check,
 }
 #endif /* __linux__ */
 
+static void fuse4fs_try_upsert_first_mapping(struct fuse4fs *ff, ext2_ino_t ino,
+					     struct fuse_file_info *fp);
+
 static int fuse4fs_open_file(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 			     ext2_ino_t ino, bool linked,
 			     struct fuse_file_info *fp)
@@ -4509,7 +4512,7 @@ static int fuse4fs_open_file(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 	/* fuse 3.5: cache dirents from readdir contents */
 	fp->cache_readdir = 1;
 #endif
-
+	fuse4fs_try_upsert_first_mapping(ff, ino, fp);
 out:
 	if (ret)
 		ext2fs_free_mem(&file);
@@ -7277,6 +7280,37 @@ static void op_iomap_end(fuse_req_t req, fuse_ino_t fino, uint64_t dontcare,
 	fuse_reply_err(req, -ret);
 }
 
+static void fuse4fs_try_upsert_first_mapping(struct fuse4fs *ff, ext2_ino_t ino,
+					     struct fuse_file_info *fp)
+{
+	struct ext2_inode_large inode;
+	struct fuse_file_iomap read = { };
+	uint64_t fsize;
+	errcode_t err;
+
+	if (!ff->iomap_cache || (fp->flags & O_TRUNC))
+		return;
+
+	err = fuse4fs_read_inode(ff->fs, ino, &inode);
+	if (err)
+		return;
+
+	if (!S_ISREG(inode.i_mode))
+		return;
+
+	fsize = EXT2_I_SIZE(&inode);
+	if (!fsize)
+		return;
+
+	/* try to map the first 64k */
+	err = fuse4fs_iomap_begin_read(ff, ino, &inode, 0, min(fsize, 65536),
+			0, &read);
+	if (err)
+		return;
+
+	fuse_lowlevel_iomap_upsert_mappings(ff->fuse, ino, ino, &read, NULL);
+}
+
 /*
  * Maximal extent format file size.
  * Resulting logical blkno at s_maxbytes must fit in our on-disk

