Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B2E2C237C;
	Wed, 29 Apr 2026 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474389; cv=none; b=Sh7U3lSmPhTFvOqwOz4ujkUIZ0901jNJf4voywk2G50SqTbzEUCY1E/91QNvx9SWfXkFGc9pKwaD0SfeZ7ggz1FeNmQWw1ZfKATln0UBX14J/H9HW29ywtNeDKjEXm7+vTwwZXFwxRxhe4X7+Wg/BmlVNBBlNU4E5WxRdVMeRLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474389; c=relaxed/simple;
	bh=hg8Tt5e6KzePgFs+DKkRNj6mEeuqAixcVqx9kvK3h1U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZ2X/RKZaRD6JljwYrkDngHbNFvRkXjBuCkQDzAed9N50+zsv3VpcTqzlW1btIrdF+CPz3mnnLblU+6BzhTwseYDkeylqOYzJFeQt0lt17d6FEuYvlTG0/49U45Q2s+Se/zfIlhxXZNR78+eyiLOVvh+6QoD4WQBHcS4wUlzcd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sXsANCUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXsANCUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842D4C19425;
	Wed, 29 Apr 2026 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474389;
	bh=hg8Tt5e6KzePgFs+DKkRNj6mEeuqAixcVqx9kvK3h1U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sXsANCUbt+wTn81uPOSANeadKtenySsqdv0Re4LW6+CNmz7UPoiAT+twyAUaYbLuN
	 xn2DgdwcIzhV+qD4QwomyewIhBtfYaAd/b71HWx5yAkudkzLpGR7rZ1yM0vqMam0KE
	 QXNs+nhK5gzhEmCo1KPVulSGga6ABuq8Fj/zh+YMXFB49HCbIvcBlrNA8+Yo60Iqy6
	 aD4HXGQss+2RL34x+IgY1EB309X6gpDdMTYkZnq2mJCmqafNiM+E823Kv0ON4GhKsl
	 QPadELilvY6qjZO+Hqeo7QtAQUaEjfm0WwDRoAfg/fth990HN53boiRj9WbUfzbytG
	 kUASGz0roRIHw==
Date: Wed, 29 Apr 2026 07:53:09 -0700
Subject: [PATCH 02/19] fuse2fs: add iomap= mount option
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214572.4107473.7793388078497205071.stgit@frogsfrogsfrogs>
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

Add a mount option to control iomap usage so that we can test before and
after scenarios.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.1.in |    6 ++++++
 fuse4fs/fuse4fs.c    |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 misc/fuse2fs.1.in    |    6 ++++++
 misc/fuse2fs.c       |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)


diff --git a/fuse4fs/fuse4fs.1.in b/fuse4fs/fuse4fs.1.in
index 8bef5f48802385..8855867d27101d 100644
--- a/fuse4fs/fuse4fs.1.in
+++ b/fuse4fs/fuse4fs.1.in
@@ -75,6 +75,12 @@ .SS "fuse4fs options:"
 \fB-o\fR fuse4fs_debug
 enable fuse4fs debugging
 .TP
+\fB-o\fR iomap=
+If set to \fI1\fR, requires iomap to be enabled.
+If set to \fI0\fR, forbids use of iomap.
+If set to \fIdefault\fR (or not set), enables iomap if present.
+This substantially improves the performance of the fuse4fs server.
+.TP
 \fB-o\fR kernel
 Behave more like the kernel ext4 driver in the following ways:
 Allows processes owned by other users to access the filesystem.
diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index a159024f778ba2..df2bda7cc22bf2 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -236,6 +236,12 @@ enum fuse4fs_opstate {
 	F4OP_SHUTDOWN,
 };
 
+enum fuse4fs_feature_toggle {
+	FT_DISABLE,
+	FT_ENABLE,
+	FT_DEFAULT,
+};
+
 #ifdef HAVE_FUSE_IOMAP
 enum fuse4fs_iomap_state {
 	IOMAP_DISABLED,
@@ -272,6 +278,7 @@ struct fuse4fs {
 	int blocklog;
 	int oom_score_adj;
 #ifdef HAVE_FUSE_IOMAP
+	enum fuse4fs_feature_toggle iomap_want;
 	enum fuse4fs_iomap_state iomap_state;
 #endif
 	unsigned int blockmask;
@@ -2013,6 +2020,12 @@ static void fuse4fs_iomap_enable(struct fuse_conn_info *conn,
 
 	if (ff->iomap_state == IOMAP_UNKNOWN)
 		ff->iomap_state = IOMAP_DISABLED;
+
+	if (!fuse4fs_iomap_enabled(ff)) {
+		if (ff->iomap_want == FT_ENABLE)
+			err_printf(ff, "%s\n", _("Could not enable iomap."));
+		return;
+	}
 }
 #else
 # define fuse4fs_iomap_enable(...)	((void)0)
@@ -6522,6 +6535,9 @@ enum {
 	FUSE4FS_CACHE_SIZE,
 	FUSE4FS_DIRSYNC,
 	FUSE4FS_ERRORS_BEHAVIOR,
+#ifdef HAVE_FUSE_IOMAP
+	FUSE4FS_IOMAP,
+#endif
 };
 
 #define FUSE4FS_OPT(t, p, v) { t, offsetof(struct fuse4fs, p), v }
@@ -6553,6 +6569,10 @@ static struct fuse_opt fuse4fs_opts[] = {
 	FUSE_OPT_KEY("cache_size=%s",	FUSE4FS_CACHE_SIZE),
 	FUSE_OPT_KEY("dirsync",		FUSE4FS_DIRSYNC),
 	FUSE_OPT_KEY("errors=%s",	FUSE4FS_ERRORS_BEHAVIOR),
+#ifdef HAVE_FUSE_IOMAP
+	FUSE_OPT_KEY("iomap=%s",	FUSE4FS_IOMAP),
+	FUSE_OPT_KEY("iomap",		FUSE4FS_IOMAP),
+#endif
 
 	FUSE_OPT_KEY("-V",             FUSE4FS_VERSION),
 	FUSE_OPT_KEY("--version",      FUSE4FS_VERSION),
@@ -6604,6 +6624,23 @@ static int fuse4fs_opt_proc(void *data, const char *arg,
 
 		/* do not pass through to libfuse */
 		return 0;
+#ifdef HAVE_FUSE_IOMAP
+	case FUSE4FS_IOMAP:
+		if (strcmp(arg, "iomap") == 0 || strcmp(arg + 6, "1") == 0)
+			ff->iomap_want = FT_ENABLE;
+		else if (strcmp(arg + 6, "0") == 0)
+			ff->iomap_want = FT_DISABLE;
+		else if (strcmp(arg + 6, "default") == 0)
+			ff->iomap_want = FT_DEFAULT;
+		else {
+			fprintf(stderr, "%s: %s\n", arg,
+ _("unknown iomap= behavior."));
+			return -1;
+		}
+
+		/* do not pass through to libfuse */
+		return 0;
+#endif
 	case FUSE4FS_IGNORED:
 		return 0;
 	case FUSE4FS_HELP:
@@ -6631,6 +6668,9 @@ static int fuse4fs_opt_proc(void *data, const char *arg,
 	"    -o cache_size=N[KMG]   use a disk cache of this size\n"
 	"    -o errors=             behavior when an error is encountered:\n"
 	"                           continue|remount-ro|panic\n"
+#ifdef HAVE_FUSE_IOMAP
+	"    -o iomap=              0 to disable iomap, 1 to enable iomap\n"
+#endif
 	"\n",
 			outargs->argv[0]);
 		if (key == FUSE4FS_HELPFULL) {
@@ -6950,6 +6990,7 @@ int main(int argc, char *argv[])
 		.bdev_fd = -1,
 #endif
 #ifdef HAVE_FUSE_IOMAP
+		.iomap_want = FT_DEFAULT,
 		.iomap_state = IOMAP_UNKNOWN,
 #endif
 	};
@@ -6983,6 +7024,11 @@ int main(int argc, char *argv[])
 	if (fuse4fs_is_service(&fctx))
 		fuse4fs_service_set_proc_cmdline(&fctx, argc, argv, &args);
 
+#ifdef HAVE_FUSE_IOMAP
+	if (fctx.iomap_want == FT_DISABLE)
+		fctx.iomap_state = IOMAP_DISABLED;
+#endif
+
 	/* /dev/sda -> sda for reporting */
 	fctx.shortdev = strrchr(fctx.device, '/');
 	if (fctx.shortdev)
diff --git a/misc/fuse2fs.1.in b/misc/fuse2fs.1.in
index 6acfa092851292..2b55fa0e723966 100644
--- a/misc/fuse2fs.1.in
+++ b/misc/fuse2fs.1.in
@@ -75,6 +75,12 @@ .SS "fuse2fs options:"
 \fB-o\fR fuse2fs_debug
 enable fuse2fs debugging
 .TP
+\fB-o\fR iomap=
+If set to \fI1\fR, requires iomap to be enabled.
+If set to \fI0\fR, forbids use of iomap.
+If set to \fIdefault\fR (or not set), enables iomap if present.
+This substantially improves the performance of the fuse2fs server.
+.TP
 \fB-o\fR kernel
 Behave more like the kernel ext4 driver in the following ways:
 Allows processes owned by other users to access the filesystem.
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 63c9b59e54fb04..15ebe6b39f1288 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -218,6 +218,12 @@ enum fuse2fs_opstate {
 	F2OP_SHUTDOWN,
 };
 
+enum fuse2fs_feature_toggle {
+	FT_DISABLE,
+	FT_ENABLE,
+	FT_DEFAULT,
+};
+
 #ifdef HAVE_FUSE_IOMAP
 enum fuse2fs_iomap_state {
 	IOMAP_DISABLED,
@@ -254,6 +260,7 @@ struct fuse2fs {
 	int blocklog;
 	int oom_score_adj;
 #ifdef HAVE_FUSE_IOMAP
+	enum fuse2fs_feature_toggle iomap_want;
 	enum fuse2fs_iomap_state iomap_state;
 #endif
 	unsigned int blockmask;
@@ -1610,6 +1617,12 @@ static void fuse2fs_iomap_enable(struct fuse_conn_info *conn,
 
 	if (ff->iomap_state == IOMAP_UNKNOWN)
 		ff->iomap_state = IOMAP_DISABLED;
+
+	if (!fuse2fs_iomap_enabled(ff)) {
+		if (ff->iomap_want == FT_ENABLE)
+			err_printf(ff, "%s\n", _("Could not enable iomap."));
+		return;
+	}
 }
 #else
 # define fuse2fs_iomap_enable(...)	((void)0)
@@ -5753,6 +5766,9 @@ enum {
 	FUSE2FS_CACHE_SIZE,
 	FUSE2FS_DIRSYNC,
 	FUSE2FS_ERRORS_BEHAVIOR,
+#ifdef HAVE_FUSE_IOMAP
+	FUSE2FS_IOMAP,
+#endif
 };
 
 #define FUSE2FS_OPT(t, p, v) { t, offsetof(struct fuse2fs, p), v }
@@ -5784,6 +5800,10 @@ static struct fuse_opt fuse2fs_opts[] = {
 	FUSE_OPT_KEY("cache_size=%s",	FUSE2FS_CACHE_SIZE),
 	FUSE_OPT_KEY("dirsync",		FUSE2FS_DIRSYNC),
 	FUSE_OPT_KEY("errors=%s",	FUSE2FS_ERRORS_BEHAVIOR),
+#ifdef HAVE_FUSE_IOMAP
+	FUSE_OPT_KEY("iomap=%s",	FUSE2FS_IOMAP),
+	FUSE_OPT_KEY("iomap",		FUSE2FS_IOMAP),
+#endif
 
 	FUSE_OPT_KEY("-V",             FUSE2FS_VERSION),
 	FUSE_OPT_KEY("--version",      FUSE2FS_VERSION),
@@ -5835,6 +5855,23 @@ static int fuse2fs_opt_proc(void *data, const char *arg,
 
 		/* do not pass through to libfuse */
 		return 0;
+#ifdef HAVE_FUSE_IOMAP
+	case FUSE2FS_IOMAP:
+		if (strcmp(arg, "iomap") == 0 || strcmp(arg + 6, "1") == 0)
+			ff->iomap_want = FT_ENABLE;
+		else if (strcmp(arg + 6, "0") == 0)
+			ff->iomap_want = FT_DISABLE;
+		else if (strcmp(arg + 6, "default") == 0)
+			ff->iomap_want = FT_DEFAULT;
+		else {
+			fprintf(stderr, "%s: %s\n", arg,
+ _("unknown iomap= behavior."));
+			return -1;
+		}
+
+		/* do not pass through to libfuse */
+		return 0;
+#endif
 	case FUSE2FS_IGNORED:
 		return 0;
 	case FUSE2FS_HELP:
@@ -5862,6 +5899,9 @@ static int fuse2fs_opt_proc(void *data, const char *arg,
 	"    -o cache_size=N[KMG]   use a disk cache of this size\n"
 	"    -o errors=             behavior when an error is encountered:\n"
 	"                           continue|remount-ro|panic\n"
+#ifdef HAVE_FUSE_IOMAP
+	"    -o iomap=              0 to disable iomap, 1 to enable iomap\n"
+#endif
 	"\n",
 			outargs->argv[0]);
 		if (key == FUSE2FS_HELPFULL) {
@@ -6013,6 +6053,7 @@ int main(int argc, char *argv[])
 		.oom_score_adj = -500,
 		.opstate = F2OP_WRITABLE,
 #ifdef HAVE_FUSE_IOMAP
+		.iomap_want = FT_DEFAULT,
 		.iomap_state = IOMAP_UNKNOWN,
 #endif
 	};
@@ -6029,6 +6070,11 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
+#ifdef HAVE_FUSE_IOMAP
+	if (fctx.iomap_want == FT_DISABLE)
+		fctx.iomap_state = IOMAP_DISABLED;
+#endif
+
 	/* /dev/sda -> sda for reporting */
 	fctx.shortdev = strrchr(fctx.device, '/');
 	if (fctx.shortdev)

