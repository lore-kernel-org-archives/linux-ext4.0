Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1648314D15
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416299; cv=none; b=UnUV2/3ny7uAazxNoOP69eG+Usdg+1Ujq/PNTeJUTV4lyMIFnlX1o6XLn8wN63LSpY+7534ttuo+8TeE66X/vwvf0zsdEi3jDh/qHafuEY4Z68mFNSetEgt2yUEKYjMsxla0/8XTEL9eNi8Wa31GcHsAc2EwXqoz+k4v/ezbT8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416299; c=relaxed/simple;
	bh=1kEqXTmqKQDZxWz+QuEat6G4p1VgL/W+hJauNDAxH44=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSzsJhxAn7c+Q5tY5fHmG9xUFqbBKvaoJGdOCYF7QO+k5YIQxNW86p9yZbazJBIOYHZnVS2mfa5jgplBXLKf9zx8Z6ts593yppW0mV9PzNbROO8LgxYeodSwOxCBZOhzbwxS1Snh4vXByk7y7Jr9Uper7vcgRbIJAx7WvIakTCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpYvLjLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpYvLjLR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 616C51F000E9;
	Thu, 25 Jun 2026 19:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416298;
	bh=Ru0QgPlsA20mCiVneqUqoHxvJZKDbDja3luCYFxi6lE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=TpYvLjLRG8CzWI04Nap8jgL/FpmcIi7JFVCTNgjd0y5SG/Snl0firs80UqZ5/yOpD
	 XUhfkeizFi0s4pJzNck4FHxfBZC1B++bD0c0CZUQNxWH5wG267kxGRCn/PksfxzzAo
	 GCZCYr0FHZiNdFxtedjtNrBZRjpOVglIraY0jx+m1ycpOgnpOcS36ILXAPJiVsaevP
	 4lQoMvnznOpj1IWQIYAfdmkekVb/+5dvbsX1X9ZXjF7ss5Sfpu2WTl3ku+mcbwYYBO
	 XXW0txiTanpKP3lCELiH72/kxs56/3pQLARZj32dC9r8cn6j7Z5jtr27jlSh/L06NO
	 n1LK0BO1RD9+w==
Date: Thu, 25 Jun 2026 12:38:17 -0700
Subject: [PATCH 06/10] fuse4fs: hoist some code out of fuse4fs_main
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606919.1810414.5878442008850993432.stgit@frogsfrogsfrogs>
In-Reply-To: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
References: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In the next patch, we're going to create a separate fuse4fs_main
function when we're running in service mode.  Hoist into separate
helpers the code that will be shared between the two functions.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   95 +++++++++++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 46 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 155cb7332a9b3f..ebf42609c1a739 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -6055,47 +6055,64 @@ static void fuse4fs_com_err_proc(const char *whoami, errcode_t code,
 	fflush(stderr);
 }
 
-static int fuse4fs_main(struct fuse_args *args, struct fuse4fs *ff)
+static int fuse4fs_create_session(struct fuse4fs *ff, struct fuse_args *args,
+				  struct fuse_cmdline_opts *opts)
 {
-	struct fuse_cmdline_opts opts;
-	struct fuse_session *se;
-	struct fuse_loop_config *loop_config = NULL;
-	int ret = 0;
-
-	if (fuse_parse_cmdline(args, &opts) != 0) {
-		ret = 1;
-		goto out;
-	}
-
 	if (ff->debug)
-		opts.debug = true;
+		opts->debug = true;
 
-	if (opts.show_help) {
+	if (opts->show_help) {
 		fuse_cmdline_help();
-		ret = 0;
-		goto out_free_opts;
+		return 0;
 	}
 
-	if (opts.show_version) {
+	if (opts->show_version) {
 		printf("FUSE library version %s\n", fuse_pkgversion());
-		ret = 0;
-		goto out_free_opts;
+		return 0;
 	}
 
-	if (!opts.mountpoint) {
+	if (!opts->mountpoint) {
 		fprintf(stderr, "error: no mountpoint specified\n");
-		ret = 2;
-		goto out_free_opts;
+		return 2;
 	}
 
-	se = fuse_session_new(args, &fs_ops, sizeof(fs_ops), ff);
-	if (se == NULL) {
-		ret = 3;
-		goto out_free_opts;
+	ff->fuse = fuse_session_new(args, &fs_ops, sizeof(fs_ops), ff);
+	return ff->fuse ? 0 : 3;
+}
+
+static int fuse4fs_event_loop(struct fuse4fs *ff,
+			      struct fuse_loop_config *loop_config,
+			      const struct fuse_cmdline_opts *opts)
+{
+	/*
+	 * Since there's a Big Kernel Lock around all the libext2fs code, we
+	 * only need to start four threads -- one to decode a request, another
+	 * to do the filesystem work, a third to transmit the reply, and a
+	 * fourth to handle fuse notifications.
+	 */
+	fuse_loop_cfg_set_clone_fd(loop_config, opts->clone_fd);
+	fuse_loop_cfg_set_idle_threads(loop_config, opts->max_idle_threads);
+	fuse_loop_cfg_set_max_threads(loop_config, 4);
+
+	return fuse_session_loop_mt(ff->fuse, loop_config) == 0 ? 0 : 8;
+}
+
+static int fuse4fs_main(struct fuse_args *args, struct fuse4fs *ff)
+{
+	struct fuse_cmdline_opts opts;
+	struct fuse_loop_config *loop_config = NULL;
+	int ret;
+
+	if (fuse_parse_cmdline(args, &opts) != 0) {
+		ret = 1;
+		goto out;
 	}
-	ff->fuse = se;
 
-	if (fuse_session_mount(se, opts.mountpoint) != 0) {
+	ret = fuse4fs_create_session(ff, args, &opts);
+	if (ret || !ff->fuse)
+		goto out_free_opts;
+
+	if (fuse_session_mount(ff->fuse, opts.mountpoint) != 0) {
 		ret = 4;
 		goto out_destroy_session;
 	}
@@ -6115,7 +6132,7 @@ static int fuse4fs_main(struct fuse_args *args, struct fuse4fs *ff)
 		close(ff->logfd);
 	ff->logfd = -1;
 
-	if (fuse_set_signal_handlers(se) != 0) {
+	if (fuse_set_signal_handlers(ff->fuse) != 0) {
 		ret = 6;
 		goto out_unmount;
 	}
@@ -6126,30 +6143,16 @@ static int fuse4fs_main(struct fuse_args *args, struct fuse4fs *ff)
 		goto out_remove_signal_handlers;
 	}
 
-	/*
-	 * Since there's a Big Kernel Lock around all the libext2fs code, we
-	 * only need to start four threads -- one to decode a request, another
-	 * to do the filesystem work, a third to transmit the reply, and a
-	 * fourth to handle fuse notifications.
-	 */
-	fuse_loop_cfg_set_clone_fd(loop_config, opts.clone_fd);
-	fuse_loop_cfg_set_idle_threads(loop_config, opts.max_idle_threads);
-	fuse_loop_cfg_set_max_threads(loop_config, 4);
+	ret = fuse4fs_event_loop(ff, loop_config, &opts);
 
-	if (fuse_session_loop_mt(se, loop_config) != 0) {
-		ret = 8;
-		goto out_loopcfg;
-	}
-
-out_loopcfg:
 	fuse_loop_cfg_destroy(loop_config);
 out_remove_signal_handlers:
-	fuse_remove_signal_handlers(se);
+	fuse_remove_signal_handlers(ff->fuse);
 out_unmount:
-	fuse_session_unmount(se);
+	fuse_session_unmount(ff->fuse);
 out_destroy_session:
+	fuse_session_destroy(ff->fuse);
 	ff->fuse = NULL;
-	fuse_session_destroy(se);
 out_free_opts:
 	free(opts.mountpoint);
 out:

