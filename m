Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03342C237C;
	Wed, 29 Apr 2026 14:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474561; cv=none; b=Soz6vefQdyBQskfOIfAHdZ/rXk1IMu81xg1jk5qpeYYqtooktsbxa7yJfdXT7ryHEO+82vwS6mNO6MNHwaj+ihArroAofzb0dyxyqcw2Uhb6Mg5Wrvr+Zn+HMIqdCEVHozlFW9ySmxLP5W3lQb8qy1yFPz6HvF/WJuXp3lZ4KZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474561; c=relaxed/simple;
	bh=d/T4p0+OsQNu4eVKVFuTeFaI4fz9ha1M/AlDZshZf2k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TCDfIFW2w5yPRJITjlOkJUL4SQus+GBSGWfj39N9g5G31DFM9s969FgPq0nuL++7Qeuca4VvohHerunilGB9pG7Q2PGjcu4lO5sHaLIvkXF5Mht5P6HNEbNpajgByliXwWLHJC8spi5kEQlxx3S4EacqqlPYWNaGWJIl2J3ufOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXjvgmdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXjvgmdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FE7C19425;
	Wed, 29 Apr 2026 14:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474561;
	bh=d/T4p0+OsQNu4eVKVFuTeFaI4fz9ha1M/AlDZshZf2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RXjvgmdElRWbVOUaDdh9XMF5VXAV2dwY9vNSH8c2871HfrvHoo2y61bo9OZqQl7hH
	 uBCxwpWmEz4UxynNLQ+0kAf4pdHgjk3+0u9nmEsXfTYMGOM6KCibLpEjTEK64V/jMt
	 VTaVuxRVKyN3b2XcNm1o4VrzZGFPkQLeoIubbdvo2Ep+6UNyfu7cWiE4kuDuLpsyC4
	 tyRSwqPeXGbM5/j0XhTjgR9bUwRiyoX2KvXwYxh+zaR+y0hGoF/6cQBHs9messhTZQ
	 f7eAI7L9otE1qVgCIsl+F5Sw4jajV7ioJOCQNq9fe/YXdXW6aXtH6g6ou9mFRpp81K
	 tThZXd7uNN3mQ==
Date: Wed, 29 Apr 2026 07:56:01 -0700
Subject: [PATCH 13/19] fuse2fs: set iomap-related inode flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214769.4107473.15899167683141272915.stgit@frogsfrogsfrogs>
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

Set FUSE_IFLAG_* when we do a getattr, so that all files will have iomap
enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   46 +++++++++++++++++++++++++++++++++++-----------
 misc/fuse2fs.c    |   20 ++++++++++++++++++++
 2 files changed, 55 insertions(+), 11 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index e2421dda75475a..f9c905c0805d9e 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -2265,6 +2265,7 @@ static void op_init(void *userdata, struct fuse_conn_info *conn)
 
 struct fuse4fs_stat {
 	struct fuse_entry_param	entry;
+	unsigned int iflags;
 };
 
 static int fuse4fs_stat_inode(struct fuse4fs *ff, ext2_ino_t ino,
@@ -2330,9 +2331,29 @@ static int fuse4fs_stat_inode(struct fuse4fs *ff, ext2_ino_t ino,
 	entry->attr_timeout = FUSE4FS_ATTR_TIMEOUT;
 	entry->entry_timeout = FUSE4FS_ATTR_TIMEOUT;
 
+	fstat->iflags = 0;
+#ifdef HAVE_FUSE_IOMAP
+	if (fuse4fs_iomap_enabled(ff))
+		fstat->iflags |= FUSE_IFLAG_IOMAP | FUSE_IFLAG_EXCLUSIVE;
+#endif
+
 	return 0;
 }
 
+#if FUSE_VERSION < FUSE_MAKE_VERSION(3, 99)
+#define fuse_reply_entry_iflags(req, entry, iflags) \
+	fuse_reply_entry((req), (entry))
+
+#define fuse_reply_attr_iflags(req, entry, iflags, timeout) \
+	fuse_reply_attr((req), (entry), (timeout))
+
+#define fuse_add_direntry_plus_iflags(req, buf, sz, name, iflags, entry, dirpos) \
+	fuse_add_direntry_plus((req), (buf), (sz), (name), (entry), (dirpos))
+
+#define fuse_reply_create_iflags(req, entry, iflags, fp) \
+	fuse_reply_create((req), (entry), (fp))
+#endif
+
 static void op_lookup(fuse_req_t req, fuse_ino_t fino, const char *name)
 {
 	struct fuse4fs_stat fstat;
@@ -2363,7 +2384,7 @@ static void op_lookup(fuse_req_t req, fuse_ino_t fino, const char *name)
 	if (ret)
 		fuse_reply_err(req, -ret);
 	else
-		fuse_reply_entry(req, &fstat.entry);
+		fuse_reply_entry_iflags(req, &fstat.entry, fstat.iflags);
 }
 
 static void op_getattr(fuse_req_t req, fuse_ino_t fino,
@@ -2383,8 +2404,8 @@ static void op_getattr(fuse_req_t req, fuse_ino_t fino,
 	if (ret)
 		fuse_reply_err(req, -ret);
 	else
-		fuse_reply_attr(req, &fstat.entry.attr,
-				fstat.entry.attr_timeout);
+		fuse_reply_attr_iflags(req, &fstat.entry.attr, fstat.iflags,
+				       fstat.entry.attr_timeout);
 }
 
 static void op_readlink(fuse_req_t req, fuse_ino_t fino)
@@ -2662,7 +2683,7 @@ static void fuse4fs_reply_entry(fuse_req_t req, ext2_ino_t ino,
 		return;
 	}
 
-	fuse_reply_entry(req, &fstat.entry);
+	fuse_reply_entry_iflags(req, &fstat.entry, fstat.iflags);
 }
 
 static void op_mknod(fuse_req_t req, fuse_ino_t fino, const char *name,
@@ -4990,10 +5011,13 @@ static int op_readdir_iter(ext2_ino_t dir EXT2FS_ATTR((unused)),
 	namebuf[dirent->name_len & 0xFF] = 0;
 
 	if (i->readdirplus) {
-		entrysize = fuse_add_direntry_plus(i->req, i->buf + i->bufused,
-						   i->bufsz - i->bufused,
-						   namebuf, &fstat.entry,
-						   i->dirpos);
+		entrysize = fuse_add_direntry_plus_iflags(i->req,
+							  i->buf + i->bufused,
+							  i->bufsz - i->bufused,
+							  namebuf,
+							  fstat.iflags,
+							  &fstat.entry,
+							  i->dirpos);
 	} else {
 		entrysize = fuse_add_direntry(i->req, i->buf + i->bufused,
 					      i->bufsz - i->bufused, namebuf,
@@ -5218,7 +5242,7 @@ static void op_create(fuse_req_t req, fuse_ino_t fino, const char *name,
 	if (ret)
 		fuse_reply_err(req, -ret);
 	else
-		fuse_reply_create(req, &fstat.entry, fp);
+		fuse_reply_create_iflags(req, &fstat.entry, fstat.iflags, fp);
 }
 
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 17)
@@ -5417,8 +5441,8 @@ static void op_setattr(fuse_req_t req, fuse_ino_t fino, struct stat *attr,
 	if (ret)
 		fuse_reply_err(req, -ret);
 	else
-		fuse_reply_attr(req, &fstat.entry.attr,
-				fstat.entry.attr_timeout);
+		fuse_reply_attr_iflags(req, &fstat.entry.attr, fstat.iflags,
+				       fstat.entry.attr_timeout);
 }
 
 #define FUSE4FS_MODIFIABLE_IFLAGS \
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index eecbf60a3360c6..c6472a1c45506f 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -1987,6 +1987,23 @@ static int op_getattr(const char *path, struct stat *statbuf,
 	return ret;
 }
 
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 99)
+static int op_getattr_iflags(const char *path, struct stat *statbuf,
+			     unsigned int *iflags, struct fuse_file_info *fi)
+{
+	int ret = op_getattr(path, statbuf, fi);
+
+	if (ret)
+		return ret;
+
+	if (fuse_fs_can_enable_iomap(statbuf))
+		*iflags |= FUSE_IFLAG_IOMAP | FUSE_IFLAG_EXCLUSIVE;
+
+	return 0;
+}
+#endif
+
+
 static int op_readlink(const char *path, char *buf, size_t len)
 {
 	struct fuse2fs *ff = fuse2fs_get();
@@ -6673,6 +6690,9 @@ static struct fuse_operations fs_ops = {
 #ifdef SUPPORT_FALLOCATE
 	.fallocate = op_fallocate,
 #endif
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 99)
+	.getattr_iflags = op_getattr_iflags,
+#endif
 #ifdef HAVE_FUSE_IOMAP
 	.iomap_begin = op_iomap_begin,
 	.iomap_end = op_iomap_end,

