Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C8019CD03;
	Wed, 29 Apr 2026 14:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474499; cv=none; b=bsZYAJqx86SucOyafQ6zQRpEoXWA0ptX+K2ytIYO+PZt5ctd+87/XFhRXMB62u7oNoX2dEW56hmfcKoqmz7vCKoh54jzBH/Zo+iFMu9YXQe2bYapefknK5E6DaposLMbsfyl3BkT9YP2w5Uiuod3ZfsFnIE6rmw9zvEY99OlG0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474499; c=relaxed/simple;
	bh=72cIxZsbYtEk2ZgZd0dzZ0vl0jbzvVreJBml3pclb9M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yw0mrFb3OCe4iiC++f7zuETx6Lhb/QmWPt/zSXyvzByICLILcTs2Cv36DOyJNYNj0THmzGaxKn5lXnNUGtyMFcW53u2PVaGaSEPGHp4X+VwNHHHvfI+9MVt8w+XuwTh9XXkeasanDBMhhB0CJobkyMVkdscp/Dfg7QOm0jyL1V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inU2rfJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inU2rfJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40135C19425;
	Wed, 29 Apr 2026 14:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474499;
	bh=72cIxZsbYtEk2ZgZd0dzZ0vl0jbzvVreJBml3pclb9M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=inU2rfJ1ZNHWS1kupjyKRwyMscC4N837/j6LpedVtw+VjdYnDI6irEnHFBwhGW+fr
	 rbHLGGD0egRysfXI8m+kMFj6u5R8lW/a3RQZuRu9lRyVBeRomYRmXD9UWXXe2j8uXM
	 El3mAipljBiICRJFSBjMtqpMBEeikYc5ygdqkNO7RPI+Apa+RZVe465yBzlDgPk2Co
	 Sr/q/59Hks/lX4rv1Thi28OReKK6mfKsNfGgjSKuvaRhBzU4r0b008xjFqjA4Dq+js
	 V+shDskekJBIDUFIG74AodxEdoIHmmOGviqvGZaD1KtVDUL0OUgYqnnVwiXYKa19kR
	 aW5X2ZbLv1VhQ==
Date: Wed, 29 Apr 2026 07:54:58 -0700
Subject: [PATCH 09/19] fuse2fs: don't zero bytes in punch hole
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214698.4107473.16785309853686303058.stgit@frogsfrogsfrogs>
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

When iomap is in use for the pagecache, it will take care of zeroing the
unaligned parts of punched out regions so we don't have to do it
ourselves.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |    8 ++++++++
 misc/fuse2fs.c    |    9 +++++++++
 2 files changed, 17 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index fa82fda99ff687..40713b0d0d5e37 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -5868,6 +5868,10 @@ static errcode_t fuse4fs_zero_middle(struct fuse4fs *ff, ext2_ino_t ino,
 	int retflags;
 	errcode_t err;
 
+	/* the kernel does this for us in iomap mode */
+	if (fuse4fs_iomap_enabled(ff))
+		return 0;
+
 	if (!*buf) {
 		err = ext2fs_get_mem(fs->blocksize, buf);
 		if (err)
@@ -5904,6 +5908,10 @@ static errcode_t fuse4fs_zero_edge(struct fuse4fs *ff, ext2_ino_t ino,
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
index 679406323df86f..a37851cdf30785 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -727,6 +727,7 @@ static inline int fuse2fs_iomap_enabled(const struct fuse2fs *ff)
 }
 #else
 # define fuse2fs_iomap_enabled(...)	(0)
+# define fuse2fs_iomap_enabled(...)	(0)
 #endif
 
 static inline void fuse2fs_dump_extents(struct fuse2fs *ff, ext2_ino_t ino,
@@ -5104,6 +5105,10 @@ static errcode_t clean_block_middle(struct fuse2fs *ff, ext2_ino_t ino,
 	int retflags;
 	errcode_t err;
 
+	/* the kernel does this for us in iomap mode */
+	if (fuse2fs_iomap_enabled(ff))
+		return 0;
+
 	if (!*buf) {
 		err = ext2fs_get_mem(fs->blocksize, buf);
 		if (err)
@@ -5140,6 +5145,10 @@ static errcode_t clean_block_edge(struct fuse2fs *ff, ext2_ino_t ino,
 	off_t residue;
 	errcode_t err;
 
+	/* the kernel does this for us in iomap mode */
+	if (fuse2fs_iomap_enabled(ff))
+		return 0;
+
 	residue = FUSE2FS_OFF_IN_FSB(ff, offset);
 	if (residue == 0)
 		return 0;

