Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4546835C1BC;
	Wed, 29 Apr 2026 15:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474843; cv=none; b=MBSG3f3c5doTdnQwqZ16Ozof/CsjnjOC5QnxLCLlDQRpVNpX+b6bUNawJyP/dUd+ZgnIl6ii/+snduWijbz3ZXyo764f5ntdv8Pt4bsfyEkt+jgA8WywsvKhNWVadADxJzxFGPYbQ2s9DLUshtPxLFGQuFzZ8ATL+QVgHqlqsAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474843; c=relaxed/simple;
	bh=isvBrTTOROo2MgJ0e0C9f7bd1lVydsw1LWdJjv6u8w8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WXvpbkg4ve3vHLc5A17r2TvUeVi5zR9gJonFwLNKLsdlhT3XScF3hk+96yYFhSwbzWH3ndA8RS5JU1mahFralZgro1+VSGdm6udv3ZSo3Z3E2nZU5yENWwem9D5J+sSNvTxYPS0YKQwQM444cYteq446ZIVIbAQiS23mp1Gu3Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=feqGzXMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="feqGzXMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9947FC19425;
	Wed, 29 Apr 2026 15:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474842;
	bh=isvBrTTOROo2MgJ0e0C9f7bd1lVydsw1LWdJjv6u8w8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=feqGzXMKaF9xlF0BheVkSIHFUGX+PsvFpSDncFMT5CL2TD349oWDC/rq0yOR91SXr
	 nWn6Y6K6MuBUFznwFiey0aBLKTxdbphqnkGie03Db9Emjr5vji+Cpucjbym106TWIU
	 ahOm9WfWq45jP/giEyT3enqhGJh1LsPkCSRpew5Ilomp0xRHbwmaacITHeGi2yDUFv
	 RolY7PepptbSKzSr8D+G8tJFwWqTFh0F8T0xRX4jPZz++khgFXqr4liXAzhhYNQD6O
	 YeTMh5zdk2xiAvQUA4rC71DXjywnYxzp3wXj+ltC3iUtZf4kqL5DkFPhaLeIavfV++
	 rE1ghMfvEj7oA==
Date: Wed, 29 Apr 2026 08:00:42 -0700
Subject: [PATCH 08/10] fuse2fs: enable syncfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215526.4110156.16981199084806761972.stgit@frogsfrogsfrogs>
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

Enable syncfs calls in fuse2fs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   32 ++++++++++++++++++++++++++++++++
 misc/fuse2fs.c    |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 8a9ada8905983d..51958d6677288c 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -6563,7 +6563,38 @@ static void op_shutdownfs(fuse_req_t req, fuse_ino_t ino, uint64_t flags)
 	int ret;
 
 	ret = ioctl_shutdown(ff, ctxt, NULL, NULL, 0);
+	fuse_reply_err(req, -ret);
+}
 
+static void op_syncfs(fuse_req_t req, fuse_ino_t ino)
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
+	}
+
+out_unlock:
+	fuse4fs_finish(ff, ret);
 	fuse_reply_err(req, -ret);
 }
 #endif
@@ -7874,6 +7905,7 @@ static struct fuse_lowlevel_ops fs_ops = {
 	.freezefs = op_freezefs,
 	.unfreezefs = op_unfreezefs,
 	.shutdownfs = op_shutdownfs,
+	.syncfs = op_syncfs,
 #endif
 #ifdef HAVE_FUSE_IOMAP
 	.iomap_begin = op_iomap_begin,
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index e790f6c2b59ecd..026c547618b5cd 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -5851,6 +5851,39 @@ static int op_shutdownfs(const char *path, uint64_t flags)
 
 	return ioctl_shutdown(ff, NULL, NULL);
 }
+
+static int op_syncfs(const char *path)
+{
+	struct fuse2fs *ff = fuse2fs_get();
+	ext2_filsys fs;
+	errcode_t err;
+	int ret = 0;
+
+	FUSE2FS_CHECK_CONTEXT(ff);
+	dbg_printf(ff, "%s: path=%s\n", __func__, path);
+	fs = fuse2fs_start(ff);
+
+	if (ff->opstate == F2OP_WRITABLE) {
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
+	}
+
+out_unlock:
+	fuse2fs_finish(ff, ret);
+	return ret;
+}
 #endif
 
 #ifdef HAVE_FUSE_IOMAP
@@ -7140,6 +7173,7 @@ static struct fuse_operations fs_ops = {
 	.freezefs = op_freezefs,
 	.unfreezefs = op_unfreezefs,
 	.shutdownfs = op_shutdownfs,
+	.syncfs = op_syncfs,
 #endif
 #ifdef HAVE_FUSE_IOMAP
 	.iomap_begin = op_iomap_begin,

