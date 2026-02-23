Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB55134CFBA;
	Mon, 23 Feb 2026 23:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771889905; cv=none; b=dqsHYRvteP95YEvThBpM3Xp6erZTcHdbn/X0qpFj3NVuEMkvmtJ7DUmEzaCCzpE4gl2LgNk6uDDXqprf0mf6Y+KA5kiNIlM05LYqvdxpIyr070I5nRQiTGR40RG34AEQc8Z9R0IMEb9A1+SRacOh5KSwsnvXMs3ixalDA6dvrnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771889905; c=relaxed/simple;
	bh=0sKdh0C9+IW4dp6s9/V4g3T+rgrAHyN751b/PDQr7SM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o0meyK7EXux2PQ2D914p80zKdFY6I911Wgv2CMGJpyoWdFl7Bo6XUmfQmazj+KDLpYFKbrpPK9SHbllTXr8jQ8g6aZJXWIPfoyc78fF2WMCo4evvmw2e4NtUAL3qOTsDlKdd2bHxNk8wPqEsHKovr8xuD2qVQ/Ya+ZnfDXY8mQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5QwDd43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5QwDd43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855AFC116C6;
	Mon, 23 Feb 2026 23:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771889905;
	bh=0sKdh0C9+IW4dp6s9/V4g3T+rgrAHyN751b/PDQr7SM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P5QwDd43/SCrH2jQZNJXICE3HESJwjzoO8i8wfvSOESnESbxgnmoZgCeoGPBotjW8
	 1oXTWMOgW2/CzOHb/0TDEiYLg9V6nZcJLosBkRzvWhVAE++mS/dZH3i2t3fg7ANKPu
	 GgA/mJVE79VXWhh95A0MkvK+Z7PTsiBbJwoeKQt9AiIBAlubsTZgqf/k/mYjLmvKo2
	 NBFqS1pO/2EPJIvnh7Gcew5P9OCojsksCktwbsG/SzsxdyQcxlA6xLWPvTL2IkpNPU
	 GaLLgp0wVU3iTV1ieUuNfWvTe7eljQxKQXPNCUPChJkTVNN704a3zesnz+KC8I3eO4
	 GiLs8ohqTXvDw==
Date: Mon, 23 Feb 2026 15:38:25 -0800
Subject: [PATCH 09/19] fuse2fs: don't zero bytes in punch hole
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, bernd@bsbernd.com,
 joannelkoong@gmail.com, neal@gompa.dev
Message-ID: <177188744643.3943178.15747701302952924086.stgit@frogsfrogsfrogs>
In-Reply-To: <177188744403.3943178.7675407203918355137.stgit@frogsfrogsfrogs>
References: <177188744403.3943178.7675407203918355137.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When iomap is in use for the pagecache, it will take care of zeroing the
unaligned parts of punched out regions so we don't have to do it
ourselves.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |    8 ++++++++
 misc/fuse2fs.c    |    9 +++++++++
 2 files changed, 17 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 39737c72e6133f..b28e92ed5f2e65 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -5649,6 +5649,10 @@ static errcode_t fuse4fs_zero_middle(struct fuse4fs *ff, ext2_ino_t ino,
 	int retflags;
 	errcode_t err;
 
+	/* the kernel does this for us in iomap mode */
+	if (fuse4fs_iomap_enabled(ff))
+		return 0;
+
 	if (!*buf) {
 		err = ext2fs_get_mem(fs->blocksize, buf);
 		if (err)
@@ -5685,6 +5689,10 @@ static errcode_t fuse4fs_zero_edge(struct fuse4fs *ff, ext2_ino_t ino,
 	off_t residue;
 	errcode_t err;
 
+	/* the kernel does this for us in iomap mode */
+	if (fuse4fs_iomap_enabled(ff))
+		return 0;
+
 	residue = FUSE4FS_OFF_IN_FSB(ff, offset);
 	if (residue == 0)
 		return 0;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index afb50a7e498694..be7004bb95cb8f 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -726,6 +726,7 @@ static inline int fuse2fs_iomap_enabled(const struct fuse2fs *ff)
 }
 #else
 # define fuse2fs_iomap_enabled(...)	(0)
+# define fuse2fs_iomap_enabled(...)	(0)
 #endif
 
 static inline void fuse2fs_dump_extents(struct fuse2fs *ff, ext2_ino_t ino,
@@ -5096,6 +5097,10 @@ static errcode_t clean_block_middle(struct fuse2fs *ff, ext2_ino_t ino,
 	int retflags;
 	errcode_t err;
 
+	/* the kernel does this for us in iomap mode */
+	if (fuse2fs_iomap_enabled(ff))
+		return 0;
+
 	if (!*buf) {
 		err = ext2fs_get_mem(fs->blocksize, buf);
 		if (err)
@@ -5132,6 +5137,10 @@ static errcode_t clean_block_edge(struct fuse2fs *ff, ext2_ino_t ino,
 	off_t residue;
 	errcode_t err;
 
+	/* the kernel does this for us in iomap mode */
+	if (fuse2fs_iomap_enabled(ff))
+		return 0;
+
 	residue = FUSE2FS_OFF_IN_FSB(ff, offset);
 	if (residue == 0)
 		return 0;

