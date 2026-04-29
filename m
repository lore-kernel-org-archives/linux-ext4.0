Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1DD2FD696;
	Wed, 29 Apr 2026 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474452; cv=none; b=Y6rI3xWjjMJiJHa/jHiIRmeOvLQdXb9bKUqdz1jH0f2wzfGY5cR8HqdImHA6aJagrmR9GWj2YbmG7FeKvolh1YUjoWIrjscsom1W1iG5MZNiyO6n46lpUNlLEs9DKP6Dty6MvCX/zYo7gxzFWCdKU6O2ytJBob7LYUOrRsl0JQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474452; c=relaxed/simple;
	bh=WIrGWfD0P1xpeIUrGvIGPdQ9n0mQlI24JaSneegztoc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QX1owhrg1aunJ1nXHdppVVMl2G8vNQgn9/tu4A4j3pb43EQwS0NQtdjGDNitPq8KrvwpqLKzFkY+V8fn9OXos1Imt9pUdM2VdrDo+HtxXS2zTZD5YDRuXYbWhi6s6es7lIzU16b1NCCGY7Yy9cdFnXoV6vWiNirPMnyw6rr7B4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eel9ULEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eel9ULEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03363C19425;
	Wed, 29 Apr 2026 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474452;
	bh=WIrGWfD0P1xpeIUrGvIGPdQ9n0mQlI24JaSneegztoc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Eel9ULEthds8DNb4lV5N2kMqx3vMFEo/jDcP/aNay8ktqOTTKnPe1MXtlNJKiVmoN
	 tGWL0BiYICIazwOT/drEFHl6OegP2fdJRBtGerBcI3DrCp8u/CHES3sUmadlpOlGJf
	 oquHXFoyKgv7fe8fLuk6qEbT/H+aq+sEVWjoOMqkR8LvChUpkTAvkvPXraiqqlCnZC
	 v7pVgzN2I3X5BCncjxOkUeimoUrdpbAuw0yLXnwpkotP+XAI8oLtRN2l1NrRjJhOD4
	 VjVXWFvdlQEPFbDQ8l0MNQqjM+uHs9hMmvrDay2x6tugDnKbwJRdpklADGHmBno0D7
	 //fa7+yrhPWrA==
Date: Wed, 29 Apr 2026 07:54:11 -0700
Subject: [PATCH 06/19] fuse2fs: add extent dump function for debugging
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214644.4107473.15598874995123900313.stgit@frogsfrogsfrogs>
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

Add a function to dump an inode's extent map for debugging purposes.
This helped debug a problem with generic/299 failing on 1k fsblock
filesystems:

 --- a/tests/generic/299.out	2025-07-15 14:45:15.030113607 -0700
 +++ b/tests/generic/299.out.bad	2025-07-16 19:33:50.889344998 -0700
 @@ -3,3 +3,4 @@ QA output created by 299
  Run fio with random aio-dio pattern

  Start fallocate/truncate loop
 +fio: io_u error on file /opt/direct_aio.0.0: Input/output error: write offset=2602827776, buflen=131072

(The cause of this was misuse of the libext2fs extent code)

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/fuse2fs.c    |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index a1d931aed8f393..1489be2104f2b2 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -917,6 +917,74 @@ static inline int fuse4fs_iomap_enabled(const struct fuse4fs *ff)
 # define fuse4fs_iomap_enabled(...)	(0)
 #endif
 
+static inline void fuse4fs_dump_extents(struct fuse4fs *ff, ext2_ino_t ino,
+					struct ext2_inode_large *inode,
+					const char *why)
+{
+	ext2_filsys fs = ff->fs;
+	unsigned int nr = 0;
+	blk64_t blockcount = 0;
+	struct ext2_inode_large xinode;
+	struct ext2fs_extent extent;
+	ext2_extent_handle_t extents;
+	int op = EXT2_EXTENT_ROOT;
+	errcode_t retval;
+
+	if (!inode) {
+		inode = &xinode;
+
+		retval = fuse4fs_read_inode(fs, ino, inode);
+		if (retval) {
+			com_err(__func__, retval, _("reading ino %u"), ino);
+			return;
+		}
+	}
+
+	if (!(inode->i_flags & EXT4_EXTENTS_FL))
+		return;
+
+	printf("%s: %s ino=%u isize %llu iblocks %llu\n", __func__, why, ino,
+	       EXT2_I_SIZE(inode),
+	       (ext2fs_get_stat_i_blocks(fs, EXT2_INODE(inode)) * 512) /
+	        fs->blocksize);
+	fflush(stdout);
+
+	retval = ext2fs_extent_open(fs, ino, &extents);
+	if (retval) {
+		com_err(__func__, retval, _("opening extents of ino \"%u\""),
+			ino);
+		return;
+	}
+
+	while ((retval = ext2fs_extent_get(extents, op, &extent)) == 0) {
+		op = EXT2_EXTENT_NEXT;
+
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
+			continue;
+
+		printf("[%u]: %s ino=%u lblk 0x%llx pblk 0x%llx len 0x%x flags 0x%x\n",
+		       nr++, why, ino, extent.e_lblk, extent.e_pblk,
+		       extent.e_len, extent.e_flags);
+		fflush(stdout);
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_LEAF)
+			blockcount += extent.e_len;
+		else
+			blockcount++;
+	}
+	if (retval == EXT2_ET_EXTENT_NO_NEXT)
+		retval = 0;
+	if (retval) {
+		com_err(__func__, retval, ("getting extents of ino %u"),
+			ino);
+	}
+	if (inode->i_file_acl)
+		blockcount++;
+	printf("%s: %s sum(e_len) %llu\n", __func__, why, blockcount);
+	fflush(stdout);
+
+	ext2fs_extent_free(extents);
+}
+
 static void get_now(struct timespec *now)
 {
 #ifdef CLOCK_REALTIME
@@ -6444,6 +6512,8 @@ static void op_iomap_begin(fuse_req_t req, fuse_ino_t fino, uint64_t dontcare,
 
 	/* Not filling even the first byte will make the kernel unhappy. */
 	if (read.offset > pos || read.offset + read.length <= pos) {
+		if (ff->debug)
+			fuse4fs_dump_extents(ff, ino, &inode, "BAD DATA");
 		ret = translate_error(fs, ino, EXT2_ET_INODE_CORRUPTED);
 		goto out_unlock;
 	}
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 739867fa41dd91..4b37bcde63d0f2 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -729,6 +729,74 @@ static inline int fuse2fs_iomap_enabled(const struct fuse2fs *ff)
 # define fuse2fs_iomap_enabled(...)	(0)
 #endif
 
+static inline void fuse2fs_dump_extents(struct fuse2fs *ff, ext2_ino_t ino,
+					struct ext2_inode_large *inode,
+					const char *why)
+{
+	ext2_filsys fs = ff->fs;
+	unsigned int nr = 0;
+	blk64_t blockcount = 0;
+	struct ext2_inode_large xinode;
+	struct ext2fs_extent extent;
+	ext2_extent_handle_t extents;
+	int op = EXT2_EXTENT_ROOT;
+	errcode_t retval;
+
+	if (!inode) {
+		inode = &xinode;
+
+		retval = fuse2fs_read_inode(fs, ino, inode);
+		if (retval) {
+			com_err(__func__, retval, _("reading ino %u"), ino);
+			return;
+		}
+	}
+
+	if (!(inode->i_flags & EXT4_EXTENTS_FL))
+		return;
+
+	printf("%s: %s ino=%u isize %llu iblocks %llu\n", __func__, why, ino,
+	       EXT2_I_SIZE(inode),
+	       (ext2fs_get_stat_i_blocks(fs, EXT2_INODE(inode)) * 512) /
+	        fs->blocksize);
+	fflush(stdout);
+
+	retval = ext2fs_extent_open(fs, ino, &extents);
+	if (retval) {
+		com_err(__func__, retval, _("opening extents of ino \"%u\""),
+			ino);
+		return;
+	}
+
+	while ((retval = ext2fs_extent_get(extents, op, &extent)) == 0) {
+		op = EXT2_EXTENT_NEXT;
+
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
+			continue;
+
+		printf("[%u]: %s ino=%u lblk 0x%llx pblk 0x%llx len 0x%x flags 0x%x\n",
+		       nr++, why, ino, extent.e_lblk, extent.e_pblk,
+		       extent.e_len, extent.e_flags);
+		fflush(stdout);
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_LEAF)
+			blockcount += extent.e_len;
+		else
+			blockcount++;
+	}
+	if (retval == EXT2_ET_EXTENT_NO_NEXT)
+		retval = 0;
+	if (retval) {
+		com_err(__func__, retval, ("getting extents of ino %u"),
+			ino);
+	}
+	if (inode->i_file_acl)
+		blockcount++;
+	printf("%s: %s sum(e_len) %llu\n", __func__, why, blockcount);
+	fflush(stdout);
+
+	ext2fs_extent_free(extents);
+}
+
 static void get_now(struct timespec *now)
 {
 #ifdef CLOCK_REALTIME
@@ -5681,6 +5749,8 @@ static int op_iomap_begin(const char *path, uint64_t nodeid, uint64_t attr_ino,
 
 	/* Not filling even the first byte will make the kernel unhappy. */
 	if (read->offset > pos || read->offset + read->length <= pos) {
+		if (ff->debug)
+			fuse2fs_dump_extents(ff, attr_ino, &inode, "BAD DATA");
 		ret = translate_error(fs, attr_ino, EXT2_ET_INODE_CORRUPTED);
 		goto out_unlock;
 	}

