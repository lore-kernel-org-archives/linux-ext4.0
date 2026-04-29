Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32CC342CB0;
	Wed, 29 Apr 2026 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474733; cv=none; b=NBguQ1dKIEe/S0vOx5b7xCxXT8Rk4pNw6KMG0Xi7F/LmrJqq+qp2Kmrss/WEDsnBW0dXHKO11fyjSbvTulr+1ReMQ14aYvrdlSmWxUo0Y5gDz3yYuci2r6cJoztVCFQN2tnQBvpqQYUJ5LNSCxOh3fiN2ddiFQmm6eCu3jRc/pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474733; c=relaxed/simple;
	bh=7IdPHswuFagMSXFAwgbmpG7K5HG/P22PA/MvvqR96DU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qv+3iF/EqxAXcOKjJzhyiB0OMLR+prMkd2RVGI5f0RJ53nYR1vetDAAfgJ5SxiJPeOMRaOspqWP9d7w3AW4tfcCrD+wH1uuPWfzrXztWAZa1ri90XcfoFcGq2wqUR21OhCvME50/tcTTmPnQvdceuqv6Al/2A1cNOoLmAQHPkXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUSjrNC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUSjrNC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FA2C19425;
	Wed, 29 Apr 2026 14:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474733;
	bh=7IdPHswuFagMSXFAwgbmpG7K5HG/P22PA/MvvqR96DU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UUSjrNC5hfG0naTcATBKQrujZuITIijrd+a6om3nJR+xmbeHAky4nS9+pHUvBzDtW
	 W2sxK7z3rl2kvybksHqdyvp9+ZfE8SrCtC/6rcx8ZcRE4VgxnD4CA990CUKNVerHSZ
	 XPRpfPiCy5tUfppaS0XJpCDgKxm4wfzQac/KAqZQkCqQK1yUzHnxFiQFyDSK28u90b
	 1NlIbPB+yIpyBVzJmI/QAO/hQK8qg79594CmUuBVmj7WkIzmNfIDTsQdcvInJvo+8M
	 OS4V2kFS8ffM6k321/bgr7I/5tke/X3rNZnWa7uCx5bUxG4vGH5SCdgxJ1CJEyp32A
	 xJHXebqoIkg0Q==
Date: Wed, 29 Apr 2026 07:58:53 -0700
Subject: [PATCH 01/10] fuse2fs: add strictatime/lazytime mount options
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215400.4110156.4867561188193623409.stgit@frogsfrogsfrogs>
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

In iomap mode, we can support the strictatime/lazytime mount options.
Add them to fuse2fs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.1.in |    6 ++++++
 fuse4fs/fuse4fs.c    |   28 +++++++++++++++++++++++++++-
 misc/fuse2fs.1.in    |    6 ++++++
 misc/fuse2fs.c       |   27 +++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 1 deletion(-)


diff --git a/fuse4fs/fuse4fs.1.in b/fuse4fs/fuse4fs.1.in
index 8855867d27101d..119cbcc903d8af 100644
--- a/fuse4fs/fuse4fs.1.in
+++ b/fuse4fs/fuse4fs.1.in
@@ -90,6 +90,9 @@ .SS "fuse4fs options:"
 .I nosuid
 ) later.
 .TP
+\fB-o\fR lazytime
+if iomap is enabled, enable lazy updates of timestamps
+.TP
 \fB-o\fR lockfile=path
 use this file to control access to the filesystem
 .TP
@@ -98,6 +101,9 @@ .SS "fuse4fs options:"
 .TP
 \fB-o\fR norecovery
 do not replay the journal and mount the file system read-only
+.TP
+\fB-o\fR strictatime
+if iomap is enabled, update atime on every access
 .SS "FUSE options:"
 .TP
 \fB-d -o\fR debug
diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index ec6af3813a661a..6e5683dba4c918 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -286,6 +286,7 @@ struct fuse4fs {
 	int acl;
 	int dirsync;
 	int translate_inums;
+	int iomap_passthrough_options;
 
 	enum fuse4fs_opstate opstate;
 	int logfd;
@@ -1415,6 +1416,12 @@ static errcode_t fuse4fs_check_support(struct fuse4fs *ff)
 		return EXT2_ET_FILESYSTEM_CORRUPTED;
 	}
 
+	if (ff->iomap_passthrough_options && !fuse4fs_can_iomap(ff)) {
+		err_printf(ff, "%s\n",
+			   _("Some mount options require iomap."));
+		return EINVAL;
+	}
+
 	return 0;
 }
 
@@ -2284,6 +2291,8 @@ static void fuse4fs_iomap_enable(struct fuse_conn_info *conn,
 	if (!fuse4fs_iomap_enabled(ff)) {
 		if (ff->iomap_want == FT_ENABLE)
 			err_printf(ff, "%s\n", _("Could not enable iomap."));
+		if (ff->iomap_passthrough_options)
+			err_printf(ff, "%s\n", _("Some mount options require iomap."));
 		return;
 	}
 }
@@ -7876,6 +7885,7 @@ enum {
 	FUSE4FS_ERRORS_BEHAVIOR,
 #ifdef HAVE_FUSE_IOMAP
 	FUSE4FS_IOMAP,
+	FUSE4FS_IOMAP_PASSTHROUGH,
 #endif
 };
 
@@ -7902,6 +7912,17 @@ static struct fuse_opt fuse4fs_opts[] = {
 	FUSE4FS_OPT("timing",		timing,			1),
 #endif
 
+#ifdef HAVE_FUSE_IOMAP
+#ifdef MS_LAZYTIME
+	FUSE_OPT_KEY("lazytime",	FUSE4FS_IOMAP_PASSTHROUGH),
+	FUSE_OPT_KEY("nolazytime",	FUSE4FS_IOMAP_PASSTHROUGH),
+#endif
+#ifdef MS_STRICTATIME
+	FUSE_OPT_KEY("strictatime",	FUSE4FS_IOMAP_PASSTHROUGH),
+	FUSE_OPT_KEY("nostrictatime",	FUSE4FS_IOMAP_PASSTHROUGH),
+#endif
+#endif
+
 	FUSE_OPT_KEY("user_xattr",	FUSE4FS_IGNORED),
 	FUSE_OPT_KEY("noblock_validity", FUSE4FS_IGNORED),
 	FUSE_OPT_KEY("nodelalloc",	FUSE4FS_IGNORED),
@@ -7928,6 +7949,12 @@ static int fuse4fs_opt_proc(void *data, const char *arg,
 	struct fuse4fs *ff = data;
 
 	switch (key) {
+#ifdef HAVE_FUSE_IOMAP
+	case FUSE4FS_IOMAP_PASSTHROUGH:
+		ff->iomap_passthrough_options = 1;
+		/* pass through to libfuse */
+		return 1;
+#endif
 	case FUSE4FS_DIRSYNC:
 		ff->dirsync = 1;
 		/* pass through to libfuse */
@@ -8103,7 +8130,6 @@ static void fuse4fs_compute_libfuse_args(struct fuse4fs *ff,
 		ff->translate_inums = 0;
 	}
 
-
 	if (ff->debug) {
 		int	i;
 
diff --git a/misc/fuse2fs.1.in b/misc/fuse2fs.1.in
index 2b55fa0e723966..0c0934f03c9543 100644
--- a/misc/fuse2fs.1.in
+++ b/misc/fuse2fs.1.in
@@ -90,6 +90,9 @@ .SS "fuse2fs options:"
 .I nosuid
 ) later.
 .TP
+\fB-o\fR lazytime
+if iomap is enabled, enable lazy updates of timestamps
+.TP
 \fB-o\fR lockfile=path
 use this file to control access to the filesystem
 .TP
@@ -98,6 +101,9 @@ .SS "fuse2fs options:"
 .TP
 \fB-o\fR norecovery
 do not replay the journal and mount the file system read-only
+.TP
+\fB-o\fR strictatime
+if iomap is enabled, update atime on every access
 .SS "FUSE options:"
 .TP
 \fB-d -o\fR debug
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 16b010fd28d4b5..02ca7ade4aaad6 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -268,6 +268,7 @@ struct fuse2fs {
 	int directio;
 	int acl;
 	int dirsync;
+	int iomap_passthrough_options;
 
 	enum fuse2fs_opstate opstate;
 	int logfd;
@@ -1192,6 +1193,12 @@ static errcode_t fuse2fs_check_support(struct fuse2fs *ff)
 		return EXT2_ET_FILESYSTEM_CORRUPTED;
 	}
 
+	if (ff->iomap_passthrough_options && !fuse2fs_can_iomap(ff)) {
+		err_printf(ff, "%s\n",
+			   _("Some mount options require iomap."));
+		return EINVAL;
+	}
+
 	return 0;
 }
 
@@ -1820,6 +1827,8 @@ static void fuse2fs_iomap_enable(struct fuse_conn_info *conn,
 	if (!fuse2fs_iomap_enabled(ff)) {
 		if (ff->iomap_want == FT_ENABLE)
 			err_printf(ff, "%s\n", _("Could not enable iomap."));
+		if (ff->iomap_passthrough_options)
+			err_printf(ff, "%s\n", _("Some mount options require iomap."));
 		return;
 	}
 }
@@ -7113,6 +7122,7 @@ enum {
 	FUSE2FS_ERRORS_BEHAVIOR,
 #ifdef HAVE_FUSE_IOMAP
 	FUSE2FS_IOMAP,
+	FUSE2FS_IOMAP_PASSTHROUGH,
 #endif
 };
 
@@ -7139,6 +7149,17 @@ static struct fuse_opt fuse2fs_opts[] = {
 	FUSE2FS_OPT("timing",		timing,			1),
 #endif
 
+#ifdef HAVE_FUSE_IOMAP
+#ifdef MS_LAZYTIME
+	FUSE_OPT_KEY("lazytime",	FUSE2FS_IOMAP_PASSTHROUGH),
+	FUSE_OPT_KEY("nolazytime",	FUSE2FS_IOMAP_PASSTHROUGH),
+#endif
+#ifdef MS_STRICTATIME
+	FUSE_OPT_KEY("strictatime",	FUSE2FS_IOMAP_PASSTHROUGH),
+	FUSE_OPT_KEY("nostrictatime",	FUSE2FS_IOMAP_PASSTHROUGH),
+#endif
+#endif
+
 	FUSE_OPT_KEY("user_xattr",	FUSE2FS_IGNORED),
 	FUSE_OPT_KEY("noblock_validity", FUSE2FS_IGNORED),
 	FUSE_OPT_KEY("nodelalloc",	FUSE2FS_IGNORED),
@@ -7165,6 +7186,12 @@ static int fuse2fs_opt_proc(void *data, const char *arg,
 	struct fuse2fs *ff = data;
 
 	switch (key) {
+#ifdef HAVE_FUSE_IOMAP
+	case FUSE2FS_IOMAP_PASSTHROUGH:
+		ff->iomap_passthrough_options = 1;
+		/* pass through to libfuse */
+		return 1;
+#endif
 	case FUSE2FS_DIRSYNC:
 		ff->dirsync = 1;
 		/* pass through to libfuse */

