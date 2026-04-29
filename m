Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD39B2E7BB6;
	Wed, 29 Apr 2026 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474655; cv=none; b=RZ3TvNLa8MSxN+swLy0PjQ0H964d60ICH0W6cWUMx0xrKagNnUnpV2Y1aG0hWmAiafqTk+7VvXeO2ZsazRK0WlNBlQLRmoNyaJ6IppHhDRbSPzoN98luqcyVN6wIhGA4+qKsjCd1MOwaXabIUcrJpLdgj9t7K3vP8kznY1mRHi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474655; c=relaxed/simple;
	bh=kq3dJ2+gy6wjNQ7nee2+gKFa23GHv9vLJoH0IH/UgDM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJmlB9oDVX8DMZXTf0jr9SVNMyylikUJF+7Ys9V3U/Bmlo3AJ8G4BoGBzai/snTqSU/NCbTn59crXjovcwhi+Wu9Uqx3DKyyeO0KMP6jKcjUrOK/FFcXJks+uCOGFJycDa77IXfJbgPf4rrVCN8rZCcNa80JWgui3RcEz96KRR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIrsRWKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIrsRWKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CD3C19425;
	Wed, 29 Apr 2026 14:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474655;
	bh=kq3dJ2+gy6wjNQ7nee2+gKFa23GHv9vLJoH0IH/UgDM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eIrsRWKT41ECWXJT17E7/VrCUY9ArfRsdCLLIIcFZzW4xNs4LqXznhbiIghyAbl1e
	 uhAMuZxf23srOfQCRH9T86ez4JDxhXCqWKQeQfIcw7J16PY9fUvBz+4bV3KV3wwLhV
	 EeKDB8lyfXhG2scWY+WRln2eM/prubvOgZUwVjF7I3fC3+DohGVVM0GwVLXYDOcV6i
	 4UGJIxof293746EdZVpCDad+8wPikJNPiI7CrDPnXRy87h3veWm3X0Sct1Rqd+BXff
	 AtlGpMa3+/CSCAlu028dC90dl8OkjKk3YyGypivrKaQMXJtm0G68QPp3t9yzrOgE95
	 JhpNDh1SI7olw==
Date: Wed, 29 Apr 2026 07:57:34 -0700
Subject: [PATCH 19/19] fuse2fs: implement freeze and shutdown requests
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214874.4107473.5521741952753076823.stgit@frogsfrogsfrogs>
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

Handle freezing and shutting down the filesystem if requested.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/fuse2fs.c    |   84 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 175 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 6ea2d30772ae5a..46f81e2066b044 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -240,6 +240,7 @@ struct fuse4fs_file_handle {
 
 enum fuse4fs_opstate {
 	F4OP_READONLY,
+	F4OP_WRITABLE_FROZEN,
 	F4OP_WRITABLE,
 	F4OP_SHUTDOWN,
 };
@@ -6388,6 +6389,91 @@ static void op_fallocate(fuse_req_t req, fuse_ino_t fino EXT2FS_ATTR((unused)),
 }
 #endif /* SUPPORT_FALLOCATE */
 
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 99)
+static void op_freezefs(fuse_req_t req, fuse_ino_t ino, uint64_t unlinked)
+{
+	struct fuse4fs *ff = fuse4fs_get(req);
+	ext2_filsys fs;
+	errcode_t err;
+	int ret = 0;
+
+	FUSE4FS_CHECK_CONTEXT(req);
+	fs = fuse4fs_start(ff);
+
+	if (ff->opstate == F4OP_WRITABLE) {
+		if (fs->super->s_error_count)
+			fs->super->s_state |= EXT2_ERROR_FS;
+		else if (!unlinked)
+			fs->super->s_state |= EXT2_VALID_FS;
+		ext2fs_mark_super_dirty(fs);
+		err = ext2fs_set_gdt_csum(fs);
+		if (err) {
+			ret = translate_error(fs, 0, err);
+			goto out_unlock;
+		}
+
+		err = ext2fs_flush2(fs, 0);
+		if (err) {
+			ret = translate_error(fs, 0, err);
+			goto out_unlock;
+		}
+
+		ff->opstate = F4OP_WRITABLE_FROZEN;
+	}
+
+out_unlock:
+	fs->super->s_state &= ~EXT2_VALID_FS;
+	fuse4fs_finish(ff, ret);
+	fuse_reply_err(req, -ret);
+}
+
+static void op_unfreezefs(fuse_req_t req, fuse_ino_t ino)
+{
+	struct fuse4fs *ff = fuse4fs_get(req);
+	ext2_filsys fs;
+	errcode_t err;
+	int ret = 0;
+
+	FUSE4FS_CHECK_CONTEXT(req);
+	fs = fuse4fs_start(ff);
+
+	if (ff->opstate == F4OP_WRITABLE_FROZEN) {
+		if (fs->super->s_error_count)
+			fs->super->s_state |= EXT2_ERROR_FS;
+		fs->super->s_state &= ~EXT2_VALID_FS;
+		ext2fs_mark_super_dirty(fs);
+		err = ext2fs_set_gdt_csum(fs);
+		if (err) {
+			ret = translate_error(fs, 0, err);
+			goto out_unlock;
+		}
+
+		err = ext2fs_flush2(fs, 0);
+		if (err) {
+			ret = translate_error(fs, 0, err);
+			goto out_unlock;
+		}
+
+		ff->opstate = F4OP_WRITABLE;
+	}
+
+out_unlock:
+	fuse4fs_finish(ff, ret);
+	fuse_reply_err(req, -ret);
+}
+
+static void op_shutdownfs(fuse_req_t req, fuse_ino_t ino, uint64_t flags)
+{
+	const struct fuse_ctx *ctxt = fuse_req_ctx(req);
+	struct fuse4fs *ff = fuse4fs_get(req);
+	int ret;
+
+	ret = ioctl_shutdown(ff, ctxt, NULL, NULL, 0);
+
+	fuse_reply_err(req, -ret);
+}
+#endif
+
 #ifdef HAVE_FUSE_IOMAP
 static void fuse4fs_iomap_hole(struct fuse4fs *ff, struct fuse_file_iomap *iomap,
 			       off_t pos, uint64_t count)
@@ -7685,6 +7771,11 @@ static struct fuse_lowlevel_ops fs_ops = {
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 18)
 	.statx = op_statx,
 #endif
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 99)
+	.freezefs = op_freezefs,
+	.unfreezefs = op_unfreezefs,
+	.shutdownfs = op_shutdownfs,
+#endif
 #ifdef HAVE_FUSE_IOMAP
 	.iomap_begin = op_iomap_begin,
 	.iomap_end = op_iomap_end,
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index fe45ffa86823b0..16b010fd28d4b5 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -223,6 +223,7 @@ struct fuse2fs_file_handle {
 
 enum fuse2fs_opstate {
 	F2OP_READONLY,
+	F2OP_WRITABLE_FROZEN,
 	F2OP_WRITABLE,
 	F2OP_SHUTDOWN,
 };
@@ -5709,6 +5710,86 @@ static int op_fallocate(const char *path EXT2FS_ATTR((unused)), int mode,
 }
 #endif /* SUPPORT_FALLOCATE */
 
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 99)
+static int op_freezefs(const char *path, uint64_t unlinked)
+{
+	struct fuse2fs *ff = fuse2fs_get();
+	ext2_filsys fs;
+	errcode_t err;
+	int ret = 0;
+
+	FUSE2FS_CHECK_CONTEXT(ff);
+	fs = fuse2fs_start(ff);
+
+	if (ff->opstate == F2OP_WRITABLE) {
+		if (fs->super->s_error_count)
+			fs->super->s_state |= EXT2_ERROR_FS;
+		else if (!unlinked)
+			fs->super->s_state |= EXT2_VALID_FS;
+		ext2fs_mark_super_dirty(fs);
+		err = ext2fs_set_gdt_csum(fs);
+		if (err) {
+			ret = translate_error(fs, 0, err);
+			goto out_unlock;
+		}
+
+		err = ext2fs_flush2(fs, 0);
+		if (err) {
+			ret = translate_error(fs, 0, err);
+			goto out_unlock;
+		}
+
+		ff->opstate = F2OP_WRITABLE_FROZEN;
+	}
+
+out_unlock:
+	fs->super->s_state &= ~EXT2_VALID_FS;
+	fuse2fs_finish(ff, ret);
+	return ret;
+}
+
+static int op_unfreezefs(const char *path)
+{
+	struct fuse2fs *ff = fuse2fs_get();
+	ext2_filsys fs;
+	errcode_t err;
+	int ret = 0;
+
+	FUSE2FS_CHECK_CONTEXT(ff);
+	fs = fuse2fs_start(ff);
+
+	if (ff->opstate == F2OP_WRITABLE_FROZEN) {
+		if (fs->super->s_error_count)
+			fs->super->s_state |= EXT2_ERROR_FS;
+		ext2fs_mark_super_dirty(fs);
+		err = ext2fs_set_gdt_csum(fs);
+		if (err) {
+			ret = translate_error(fs, 0, err);
+			goto out_unlock;
+		}
+
+		err = ext2fs_flush2(fs, 0);
+		if (err) {
+			ret = translate_error(fs, 0, err);
+			goto out_unlock;
+		}
+
+		ff->opstate = F2OP_WRITABLE;
+	}
+
+out_unlock:
+	fuse2fs_finish(ff, ret);
+	return ret;
+}
+
+static int op_shutdownfs(const char *path, uint64_t flags)
+{
+	struct fuse2fs *ff = fuse2fs_get();
+
+	return ioctl_shutdown(ff, NULL, NULL);
+}
+#endif
+
 #ifdef HAVE_FUSE_IOMAP
 static void fuse2fs_iomap_hole(struct fuse2fs *ff, struct fuse_file_iomap *iomap,
 			       off_t pos, uint64_t count)
@@ -6993,6 +7074,9 @@ static struct fuse_operations fs_ops = {
 #endif
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 99)
 	.getattr_iflags = op_getattr_iflags,
+	.freezefs = op_freezefs,
+	.unfreezefs = op_unfreezefs,
+	.shutdownfs = op_shutdownfs,
 #endif
 #ifdef HAVE_FUSE_IOMAP
 	.iomap_begin = op_iomap_begin,

