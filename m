Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2509C27EFE9;
	Wed, 29 Apr 2026 14:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474640; cv=none; b=PGa+/YdU2i3VWEK5gSPHD3ONpyKoSAvRM6O38xxV3Q2YsX+vfcRw9+35pG04RXbE8dvgYf+UXfRGub12IO968TQ5N/RZeDyb1TE/MDOuOrZwA8Y3prqoxqliQj3qJiV6XhjCLHDUoNizs9gdvyhZJ9XRXge+SOKFpAbtg+rZBS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474640; c=relaxed/simple;
	bh=tCi7wwALN1ce27SquWkJbr9vDfxpixM4HQt7Q00zrgk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fr7OPLSQ5VuYmsqVfbnkbdM+mRfODSuoS5sX49NMHTweKH9ez9kNbuKGJcHlAKE6V/oZf7qwUSvbIRfcuLXekZRjTyHoJOhnMu9mGyngyIstjbwWJQECbMMwjNI7jo9L2osf6uLT3V8S+5W/m5OKWNcOz93vHu5CIMCOPsfOJ8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqMvmYIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqMvmYIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D51C19425;
	Wed, 29 Apr 2026 14:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474639;
	bh=tCi7wwALN1ce27SquWkJbr9vDfxpixM4HQt7Q00zrgk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iqMvmYIjQBkXa8+Erogr/iISdGVSr1jxu4ZNvlmcgBG7yxSdOqz8luB8B2vTBMnmj
	 IiirlW7fn1hK97Frs88fZc9myOlMLXaE9QUCZ27VPYVemzh/nMv9zbP/jXgGvomwzS
	 GwUZQZuuscSdhEoq8axaUW6JwUImq5XBqzFxCTQ8hbleXwu8kxFQnt7p5t9DhYlKwY
	 F1VR1vQTXd7ZMJV5iCdBXpcMMbszrL20lEg+LjEXxTCz7uBTPUfTqUNMouHDjNVPYK
	 xcWniLz5/6fqQBAIDiiYITw4839bN9CCqmnQ5UJy0o0GW46jXC3iH4HUEcuWjVer4G
	 VA/l7pH+jAWDA==
Date: Wed, 29 Apr 2026 07:57:19 -0700
Subject: [PATCH 18/19] fuse4fs: disable fs reclaim and write throttling
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214856.4107473.4498426418327534752.stgit@frogsfrogsfrogs>
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

Ask the kernel if we can disable fs reclaim and write throttling.

Disabling fs reclaim prevents livelocks where the fuse server can
allocate memory, fault into the kernel, and then the allocation tries to
initiate writeback by calling back into the same fuse server.

Disabling BDI write throttling means that writeback won't be throttled
by metadata writes to the filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 49708bdf7b655d..6ea2d30772ae5a 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -7969,6 +7969,19 @@ static void try_set_io_flusher(struct fuse4fs *ff)
 #endif
 }
 
+/* Undo try_set_io_flusher */
+static void try_clear_io_flusher(struct fuse4fs *ff)
+{
+#ifdef HAVE_PR_SET_IO_FLUSHER
+	/*
+	 * zero ret means it's already set, negative means we can't even
+	 * look at the value so don't bother clearing it
+	 */
+	if (prctl(PR_GET_IO_FLUSHER, 0, 0, 0, 0) > 0)
+		prctl(PR_SET_IO_FLUSHER, 0, 0, 0, 0);
+#endif
+}
+
 /* Try to adjust the OOM score so that we don't get killed */
 static void try_adjust_oom_score(struct fuse4fs *ff)
 {
@@ -8022,6 +8035,23 @@ static int fuse4fs_event_loop(struct fuse4fs *ff,
 			      struct fuse_loop_config *loop_config,
 			      const struct fuse_cmdline_opts *opts)
 {
+	bool clear_io_flusher = false;
+	int ret;
+
+	/*
+	 * Try to set ourselves up with fs reclaim disabled to prevent
+	 * recursive reclaim and throttling.  This must be done before starting
+	 * the worker threads so that they inherit the process flags.
+	 */
+	ret = fuse_lowlevel_disable_fsreclaim(ff->fuse, 1);
+	if (ret) {
+		err_printf(ff, "%s: %s.\n",
+ _("Could not register as FS flusher thread"),
+			   strerror(-ret));
+		try_set_io_flusher(ff);
+		clear_io_flusher = true;
+	}
+
 	/*
 	 * Since there's a Big Kernel Lock around all the libext2fs code, we
 	 * only need to start four threads -- one to decode a request, another
@@ -8032,7 +8062,10 @@ static int fuse4fs_event_loop(struct fuse4fs *ff,
 	fuse_loop_cfg_set_idle_threads(loop_config, opts->max_idle_threads);
 	fuse_loop_cfg_set_max_threads(loop_config, 4);
 
-	return fuse_session_loop_mt(ff->fuse, loop_config) == 0 ? 0 : 8;
+	ret = fuse_session_loop_mt(ff->fuse, loop_config) == 0 ? 0 : 8;
+	if (clear_io_flusher)
+		try_clear_io_flusher(ff);
+	return ret;
 }
 
 #ifdef HAVE_FUSE4FS_SERVICE
@@ -8251,7 +8284,6 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	try_set_io_flusher(&fctx);
 	try_adjust_oom_score(&fctx);
 
 	/* Will we allow users to allocate every last block? */

