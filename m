Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEEA339B2D;
	Thu, 30 Apr 2026 21:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583749; cv=none; b=L/hL/mAmm1vlhwdtTM9u6IB4bpjWK/k6IJJIHEojcr68mDAaUFbuPTH7HPzRxCpESKdd2HnqRAQUwti27YzbSkHm4LfdZ/OP83TMNezsoj1ynV+a/35qZEpY0fS/vbUU4gT3mt3gPtyYcFe8Tqpb1gbO3zRBkve9W9JuUp6OIlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583749; c=relaxed/simple;
	bh=tVDZ1EmQJZQ6DovidDNgDhcn8X8xJVspnVKP4tjMM/E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YGpDUNt6WPkod6e96zrdM4vSEGYND5TIAPS2QGZAceNvhIWr3Y8F4XQMkHZRfgsoL22z2PwjFSDc+IghxYuOQ4LMvcv97mwBD07LV8/2bRyLG6EtLWFxEZqq5HggUYdykqxWxstmLvqIircx31XYNhyE9wfluWHMviLDWS8klLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t5bvL6et; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t5bvL6et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09318C2BCB3;
	Thu, 30 Apr 2026 21:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583749;
	bh=tVDZ1EmQJZQ6DovidDNgDhcn8X8xJVspnVKP4tjMM/E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t5bvL6etPRUUmxBvRkUBBQDE6FqY0rDpPoizB0qpDPxAt+XbXJNK40YpajxOQTTsD
	 Cbs7dzruGAL+u6lJD3dQFek2hgpRbpWTpah3J/eJsjLEVyXIXhqlR2x8LpWsoRVKD3
	 iolGQ4OuDK80KJUYorHs/3/h1yWLyYpo8XTF6JwYm+4NL5QxRQcuxyyG7ft+Z7uWN3
	 O5mqx+Pj9EeLah0xjEfBX6g02PVG+UDU8UsS6P1LOPCJU405Wi7nOcdznnSd4bkJD+
	 KJEsManFAXcp5FLnwg/Rad9zgQe+CQd0iJ4fFgUnINKVbbZ4KfH9SN4bL494xMdWbF
	 BmeUGd3aFrH5w==
Date: Thu, 30 Apr 2026 14:15:48 -0700
Subject: [PATCH 03/13] mount_service: create high level fuse helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363586.1314717.10805305915591579093.stgit@frogsfrogsfrogs>
In-Reply-To: <177758363484.1314717.11777978893472254088.stgit@frogsfrogsfrogs>
References: <177758363484.1314717.11777978893472254088.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a fuse_main wrapper for fuse services.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/fuse.h         |   34 +++++++++++++++
 lib/fuse_versionscript |    1 
 lib/helper.c           |  109 ++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 140 insertions(+), 4 deletions(-)


diff --git a/include/fuse.h b/include/fuse.h
index 2bc3a9650c7c8b..129c744e39c46a 100644
--- a/include/fuse.h
+++ b/include/fuse.h
@@ -1008,6 +1008,40 @@ static inline int fuse_main_fn(int argc, char *argv[],
 #define fuse_main(argc, argv, op, user_data) \
 	fuse_main_fn(argc, argv, op, user_data)
 
+#if FUSE_MAKE_VERSION(3, 19) <= FUSE_USE_VERSION
+struct fuse_service;
+int fuse_service_main_real_versioned(struct fuse_service *service,
+				     struct fuse_args *args,
+				     const struct fuse_operations *op,
+				     size_t op_size,
+				     struct libfuse_version *version,
+				     void *user_data);
+
+/**
+ * Same as fuse_service_main_fn, but takes its information from the mount
+ * service context and an fuse_args that has already had fuse_service_append_args
+ * applied to it.
+ */
+static inline int fuse_service_main_fn(struct fuse_service *service,
+				       struct fuse_args *args,
+				       const struct fuse_operations *op,
+				       void *user_data)
+{
+	struct libfuse_version version = {
+		.major  = FUSE_MAJOR_VERSION,
+		.minor  = FUSE_MINOR_VERSION,
+		.hotfix = FUSE_HOTFIX_VERSION,
+		.padding = FUSE_USE_VERSION,
+	};
+
+	return fuse_service_main_real_versioned(service, args, op,
+						sizeof(*(op)), &version,
+						user_data);
+}
+#define fuse_service_main(s, args, op, user_data) \
+	fuse_service_main_fn(s, args, op, user_data)
+#endif /* FUSE_USE_VERSION >= FUSE_MAKE_VERSION(3, 19) */
+
 /* ----------------------------------------------------------- *
  * More detailed API					       *
  * ----------------------------------------------------------- */
diff --git a/lib/fuse_versionscript b/lib/fuse_versionscript
index f34dc959a1d1e1..acd1d28907c614 100644
--- a/lib/fuse_versionscript
+++ b/lib/fuse_versionscript
@@ -236,6 +236,7 @@ FUSE_3.19 {
 		fuse_service_exit;
 		fuse_service_expect_mount_format;
 		fuse_service_finish_file_requests;
+		fuse_service_main_real_versioned;
 		fuse_service_parse_cmdline_opts;
 		fuse_service_receive_file;
 		fuse_service_release;
diff --git a/lib/helper.c b/lib/helper.c
index 819b9a6e4d243c..04d03dc5a805f1 100644
--- a/lib/helper.c
+++ b/lib/helper.c
@@ -15,6 +15,7 @@
 #include "fuse_misc.h"
 #include "fuse_opt.h"
 #include "fuse_lowlevel.h"
+#include "fuse_service.h"
 #include "mount_util.h"
 
 #include <stdio.h>
@@ -365,6 +366,110 @@ int fuse_daemonize(int foreground)
 	return 0;
 }
 
+struct fuse *_fuse_new_31(struct fuse_args *args,
+		       const struct fuse_operations *op, size_t op_size,
+		       struct libfuse_version *version,
+		       void *user_data);
+
+int fuse_service_main_real_versioned(struct fuse_service *service,
+				     struct fuse_args *args,
+				     const struct fuse_operations *op,
+				     size_t op_size,
+				     struct libfuse_version *version,
+				     void *user_data)
+{
+	struct fuse *fuse;
+	struct fuse_cmdline_opts opts;
+	struct fuse_loop_config *loop_config = NULL;
+	int res;
+
+	if (fuse_service_parse_cmdline_opts(args, &opts) != 0) {
+		res = 1;
+		goto out0;
+	}
+
+	if (opts.show_version) {
+		printf("FUSE library version %s\n", PACKAGE_VERSION);
+		fuse_lowlevel_version();
+		res = 0;
+		goto out1;
+	}
+
+	if (opts.show_help) {
+		if (args->argv[0][0] != '\0')
+			printf("usage: %s [options] <mountpoint>\n\n",
+			       args->argv[0]);
+		printf("FUSE options:\n");
+		fuse_cmdline_help();
+		fuse_lib_help(args);
+		res = 0;
+		goto out1;
+	}
+
+	if (!opts.show_help &&
+	    !opts.mountpoint) {
+		fuse_log(FUSE_LOG_ERR, "error: no mountpoint specified\n");
+		res = 2;
+		goto out1;
+	}
+
+	fuse = _fuse_new_31(args, op, op_size, version, user_data);
+	if (fuse == NULL) {
+		res = 3;
+		goto out1;
+	}
+	struct fuse_session *se = fuse_get_session(fuse);
+
+	if (!opts.singlethread) {
+		loop_config = fuse_loop_cfg_create();
+		if (loop_config == NULL) {
+			res = 7;
+			goto out2;
+		}
+	}
+
+	if (fuse_set_signal_handlers(se) != 0) {
+		res = 6;
+		goto out3;
+	}
+
+	if (fuse_service_session_mount(service, se, 0, &opts) != 0) {
+		res = 4;
+		goto out4;
+	}
+
+	if (opts.singlethread) {
+		fuse_service_send_goodbye(service, 0);
+		fuse_service_release(service);
+
+		res = fuse_loop(fuse);
+	} else {
+		fuse_loop_cfg_set_clone_fd(loop_config, opts.clone_fd);
+		fuse_loop_cfg_set_idle_threads(loop_config, opts.max_idle_threads);
+		fuse_loop_cfg_set_max_threads(loop_config, opts.max_threads);
+
+		fuse_service_send_goodbye(service, 0);
+		fuse_service_release(service);
+
+		res = fuse_loop_mt(fuse, loop_config);
+	}
+	if (res)
+		res = 8;
+
+out4:
+	fuse_remove_signal_handlers(se);
+out3:
+	fuse_loop_cfg_destroy(loop_config);
+out2:
+	fuse_destroy(fuse);
+out1:
+	free(opts.mountpoint);
+out0:
+	fuse_service_send_goodbye(service, res);
+	fuse_service_release(service);
+	return res;
+}
+
 int fuse_main_real_versioned(int argc, char *argv[],
 			     const struct fuse_operations *op, size_t op_size,
 			     struct libfuse_version *version, void *user_data)
@@ -403,10 +508,6 @@ int fuse_main_real_versioned(int argc, char *argv[],
 		goto out1;
 	}
 
-	struct fuse *_fuse_new_31(struct fuse_args *args,
-			       const struct fuse_operations *op, size_t op_size,
-			       struct libfuse_version *version,
-			       void *user_data);
 	fuse = _fuse_new_31(&args, op, op_size, version, user_data);
 	if (fuse == NULL) {
 		res = 3;

