Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68791D6DA9;
	Wed, 22 Apr 2026 23:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900309; cv=none; b=j3mSFqWfKGZby5JfONp4cVk0ni6JL6GFqdus3vGQFJ/7j5rRDNI6k5s+Iuy2hBZywnq7ITXnyRaExjWvqcMzLziJYKxYdmHay+dz1Yfgp/9tG/BmNbzzU1PoJpKflORagYACbcZrnU/MQy3BqIx0oG8QnY+Tfxd65jG3jAYO168=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900309; c=relaxed/simple;
	bh=AQVvkzucSaB9N5C7vksLYzCRX5HzVgbtRQTaOYtYY0o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpAtamfebGwIxvOB4XA3ZsmV2wACYqpGN85eC3ViIZSybnUhYbJD30OA+nHLjCttml4IQVLRFqCB12pkaQ48RKDo4oay+S9EpRenDTSI19G98Jlun8IlB8CBxlnrXk1JOLZ6g7bZ22qvgQyCjsWzn+IdNOmXq6bGUwXS5ckYvto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fojfrIVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fojfrIVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3242C2BCAF;
	Wed, 22 Apr 2026 23:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900309;
	bh=AQVvkzucSaB9N5C7vksLYzCRX5HzVgbtRQTaOYtYY0o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fojfrIVW+5czKM7ierPjdoIzoInN/cF7o61LMAjTDIlFDh3QamgSDJ9ClDCbVweif
	 ojCjYgp5TNfZu0LjnA8GtOiD3lnTW/2LxBaQrVB6n+mKju8mFYOw/0mtyy8rYfv4mf
	 vqSa/qyxFX9pjwbbzhPy0rEOUkXv4XFIFYcOuJXi7DcRtPQPbvoKBb3FFWd44jTQV/
	 2BDdVqCwJrLoeSQ+Pyiizarp9zgbCVnu2w5JelFbIAggM3Az8sZHrDwPvY0m/Vf4Eh
	 j1TNoYFfeltF5e+aq0xVfL3JSaUdYtnUcbTe51lzVoKavNQ7wltoWRdwSVM7p3IiSk
	 mV1QL9CEEOY8A==
Date: Wed, 22 Apr 2026 16:25:09 -0700
Subject: [PATCH 06/10] fuse4fs: hoist some code out of fuse4fs_main
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com,
 miklos@szeredi.hu, bernd@bsbernd.com
Message-ID: <177689989646.3821326.14492655485067596223.stgit@frogsfrogsfrogs>
In-Reply-To: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
References: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
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
index 13e1aae4b5d2e5..1203f074ac29b6 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -6016,47 +6016,64 @@ static void fuse4fs_com_err_proc(const char *whoami, errcode_t code,
 	fflush(stderr);
 }
 
-static int fuse4fs_main(struct fuse_args *args, struct fuse4fs *ff)
+static int fuse4fs_create_session(struct fuse4fs *ff, struct fuse_args *args,
+				  struct fuse_cmdline_opts *opts)
 {
-	struct fuse_cmdline_opts opts;
-	struct fuse_session *se;
-	struct fuse_loop_config *loop_config = NULL;
-	int ret;
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
@@ -6076,7 +6093,7 @@ static int fuse4fs_main(struct fuse_args *args, struct fuse4fs *ff)
 		close(ff->logfd);
 	ff->logfd = -1;
 
-	if (fuse_set_signal_handlers(se) != 0) {
+	if (fuse_set_signal_handlers(ff->fuse) != 0) {
 		ret = 6;
 		goto out_unmount;
 	}
@@ -6087,30 +6104,16 @@ static int fuse4fs_main(struct fuse_args *args, struct fuse4fs *ff)
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

