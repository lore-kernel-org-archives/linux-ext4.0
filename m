Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BF7376BD6;
	Thu, 30 Apr 2026 21:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583874; cv=none; b=GAMs4kwM1NDLAoEOKNwyAAcaxV1T+1QIrrN2MPNbwzbWchW4uQSaxVOvRrftE7C10YiaY/w8JXqpcPuHStnQOB8loDIJr+6ccqMByD1UhjMa16GABKSFLqNLMgDvaRRpxqUXtOHd8QPAu1iNVWr75FZn5lFMofXjgWXzSM91+0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583874; c=relaxed/simple;
	bh=Wxb1Gx/3wlcBgqP0tCE88te9objIdI85j4CXgs9Ces4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gVnaqWONKDGY/fpIBY03AQivdTHr/Mr/2hOCA1CpyeYxqQO3yZIhBjA2lIpDfqnk2lZc5ACdYA4Yxh5P5C/GWe6Cpxm0cM1PxNEdIwdr0GJZ0gl73uSfajTzHVJeKChJgs1EwmZvLOhziBEsaT5IhNrT8pun065O53DEkNQZxzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/PXpoZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/PXpoZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18953C2BCB3;
	Thu, 30 Apr 2026 21:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583874;
	bh=Wxb1Gx/3wlcBgqP0tCE88te9objIdI85j4CXgs9Ces4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P/PXpoZOzdLrRBqdcA40t5UL3ju8eawTVZXH0eCafzlll02nOsm8F/sPt4sI+tif3
	 5sHb8iw3Qo5fj3wx6vFMzIVCYwlmFH2NJ9vVyTLPKiBc2re0LHz3KXvrMq+Oe/OHvO
	 sQM7xLDgVgEEuKQuCAZp6/8lPjsKU6syxl2Vnvhk7wSgbnCu3BOo6YxMt0gSEfzvQm
	 NgXjflFo8fWmyza5d5DMdjigrC/vdq5JWRYDSrztLwasWl/ZRr6BFCKSoKHPHuP9Ax
	 LwEoOZoEbsVs/oifYAP8fye0DDJ/1zzguyUNlBiSo2dVDCvHeY8ndjn2E+8zjICDSj
	 qDm8kqwt+h+fg==
Date: Thu, 30 Apr 2026 14:17:53 -0700
Subject: [PATCH 11/13] example/service_ll: create a sample systemd service
 fuse server
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363730.1314717.8907760223995213134.stgit@frogsfrogsfrogs>
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

Create a simple fuse server that can be run as a systemd service.
I plan to create some more single-file fuse server examples, so most of
the boilerplate code goes in a separate file.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 example/single_file.h        |  157 +++++++++
 lib/util.h                   |   35 ++
 example/meson.build          |   14 +
 example/service_ll.c         |  328 ++++++++++++++++++
 example/service_ll.socket.in |   15 +
 example/service_ll@.service  |  102 ++++++
 example/single_file.c        |  746 ++++++++++++++++++++++++++++++++++++++++++
 meson.build                  |    1 
 8 files changed, 1398 insertions(+)
 create mode 100644 example/single_file.h
 create mode 100644 example/service_ll.c
 create mode 100644 example/service_ll.socket.in
 create mode 100644 example/service_ll@.service
 create mode 100644 example/single_file.c


diff --git a/example/single_file.h b/example/single_file.h
new file mode 100644
index 00000000000000..6e5d3e7c975385
--- /dev/null
+++ b/example/single_file.h
@@ -0,0 +1,157 @@
+/*
+ * FUSE: Filesystem in Userspace
+ * Copyright (C) 2026 Oracle.
+ *
+ * This program can be distributed under the terms of the GNU GPLv2.
+ * See the file GPL2.txt.
+ *
+ * This file is shared library code for example fuse servers that want to
+ * expose a single regular file that wraps another file in a manner that goes
+ * beyond simple passthrough.  It is not itself a fuse server.
+ */
+#ifndef FUSE_SINGLE_FILE_H_
+#define FUSE_SINGLE_FILE_H_
+
+static inline uint64_t round_up(uint64_t b, unsigned int align)
+{
+	unsigned int m;
+
+	if (align == 0)
+		return b;
+	m = b % align;
+	if (m)
+		b += align - m;
+	return b;
+}
+
+static inline uint64_t round_down(uint64_t b, unsigned int align)
+{
+	unsigned int m;
+
+	if (align == 0)
+		return b;
+	m = b % align;
+	return b - m;
+}
+
+static inline uint64_t howmany(uint64_t b, unsigned int align)
+{
+	unsigned int m;
+
+	if (align == 0)
+		return b;
+	m = (b % align) ? 1 : 0;
+	return (b / align) + m;
+}
+
+struct single_file {
+	int backing_fd;
+
+	int64_t isize;
+	uint64_t blocks;
+
+	mode_t mode;
+
+	bool ro;
+	bool allow_dio;
+	bool sync;
+	bool require_bdev;
+
+	unsigned int blocksize;
+
+	struct timespec atime;
+	struct timespec mtime;
+	struct timespec ctime;
+
+	pthread_mutex_t lock;
+};
+
+extern struct single_file single_file;
+
+static inline uint64_t b_to_fsbt(uint64_t off)
+{
+	return off / single_file.blocksize;
+}
+
+static inline uint64_t b_to_fsb(uint64_t off)
+{
+	return (off + single_file.blocksize - 1) / single_file.blocksize;
+}
+
+static inline uint64_t fsb_to_b(uint64_t fsb)
+{
+	return fsb * single_file.blocksize;
+}
+
+enum single_file_opt_keys {
+	SINGLE_FILE_RO = 171717, /* how many options could we possibly have? */
+	SINGLE_FILE_RW,
+	SINGLE_FILE_REQUIRE_BDEV,
+	SINGLE_FILE_DIO,
+	SINGLE_FILE_NODIO,
+	SINGLE_FILE_SYNC,
+	SINGLE_FILE_NOSYNC,
+	SINGLE_FILE_SIZE,
+	SINGLE_FILE_BLOCKSIZE,
+
+	SINGLE_FILE_NR_KEYS,
+};
+
+#define SINGLE_FILE_OPT_KEYS \
+	FUSE_OPT_KEY("ro",		SINGLE_FILE_RO), \
+	FUSE_OPT_KEY("rw",		SINGLE_FILE_RW), \
+	FUSE_OPT_KEY("require_bdev",	SINGLE_FILE_REQUIRE_BDEV), \
+	FUSE_OPT_KEY("dio",		SINGLE_FILE_DIO), \
+	FUSE_OPT_KEY("nodio",		SINGLE_FILE_NODIO), \
+	FUSE_OPT_KEY("sync",		SINGLE_FILE_SYNC), \
+	FUSE_OPT_KEY("nosync",		SINGLE_FILE_NOSYNC), \
+	FUSE_OPT_KEY("size=%s",		SINGLE_FILE_SIZE), \
+	FUSE_OPT_KEY("blocksize=%s",	SINGLE_FILE_BLOCKSIZE)
+
+int single_file_opt_proc(void *data, const char *arg, int key,
+			 struct fuse_args *outargs);
+
+unsigned long long parse_num_blocks(const char *arg, int log_block_size);
+
+struct fuse_service;
+int single_file_service_open(struct fuse_service *sf, const char *path);
+
+void single_file_check_read(off_t pos, size_t *count);
+int single_file_check_write(off_t pos, size_t *count);
+
+int single_file_configure(const char *device, const char *filename);
+int single_file_configure_simple(const char *filename);
+void single_file_close(void);
+
+ssize_t single_file_pwrite(const char *buf, size_t count, off_t pos);
+ssize_t single_file_pread(char *buf, size_t count, off_t pos);
+
+/* low-level fuse operation handlers */
+
+bool is_single_file_child(fuse_ino_t parent, const char *name);
+bool is_single_file_ino(fuse_ino_t ino);
+
+void single_file_ll_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
+				off_t off, struct fuse_file_info *fi);
+
+void single_file_ll_statfs(fuse_req_t req, fuse_ino_t ino);
+
+void single_file_ll_statx(fuse_req_t req, fuse_ino_t ino, int flags, int mask,
+		       struct fuse_file_info *fi);
+
+void single_file_ll_getattr(fuse_req_t req, fuse_ino_t ino,
+			    struct fuse_file_info *fi);
+void single_file_ll_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
+			 int to_set, struct fuse_file_info *fi);
+
+void single_file_ll_lookup(fuse_req_t req, fuse_ino_t parent, const char *name);
+void single_file_ll_open(fuse_req_t req, fuse_ino_t ino,
+			 struct fuse_file_info *fi);
+
+void single_file_ll_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
+			  struct fuse_file_info *fi);
+
+int reply_buf_limited(fuse_req_t req, const char *buf, size_t bufsize,
+		      off_t off, size_t maxsize);
+
+#endif /* FUSE_SINGLE_FILE_H_ */
diff --git a/lib/util.h b/lib/util.h
index 107a2bfdd6105b..6ec6604fb74caf 100644
--- a/lib/util.h
+++ b/lib/util.h
@@ -4,6 +4,9 @@
 #include <stdint.h>
 #include <stdbool.h>
 
+#define max(x, y) ((x) > (y) ? (x) : (y))
+#define min(x, y) ((x) < (y) ? (x) : (y))
+
 #define ROUND_UP(val, round_to) (((val) + (round_to - 1)) & ~(round_to - 1))
 
 #define likely(x) __builtin_expect(!!(x), 1)
@@ -46,4 +49,36 @@ static inline uint64_t fuse_higher_32_bits(uint64_t nr)
 #define fallthrough do {} while (0)
 #endif
 
+static inline uint64_t round_up(uint64_t b, unsigned int align)
+{
+	unsigned int m;
+
+	if (align == 0)
+		return b;
+	m = b % align;
+	if (m)
+		b += align - m;
+	return b;
+}
+
+static inline uint64_t round_down(uint64_t b, unsigned int align)
+{
+	unsigned int m;
+
+	if (align == 0)
+		return b;
+	m = b % align;
+	return b - m;
+}
+
+static inline uint64_t howmany(uint64_t b, unsigned int align)
+{
+	unsigned int m;
+
+	if (align == 0)
+		return b;
+	m = (b % align) ? 1 : 0;
+	return (b / align) + m;
+}
+
 #endif /* FUSE_UTIL_H_ */
diff --git a/example/meson.build b/example/meson.build
index 76cf2d96db0349..e948f6ba74fdfa 100644
--- a/example/meson.build
+++ b/example/meson.build
@@ -12,6 +12,15 @@ if not platform.endswith('bsd') and platform != 'dragonfly'
     examples += [ 'null' ]
 endif
 
+single_file_examples = [ ]
+
+if platform.endswith('linux')
+    single_file_examples += [ 'service_ll' ]
+    configure_file(input: 'service_ll.socket.in',
+                   output: 'service_ll.socket',
+                   configuration: private_cfg)
+endif
+
 threaded_examples = [ 'notify_inval_inode',
                       'invalidate_path',
                       'notify_store_retrieve',
@@ -25,6 +34,11 @@ foreach ex : examples
                install: false)
 endforeach
 
+foreach ex : single_file_examples
+    executable(ex, [ex + '.c', 'single_file.c'],
+               dependencies: [ libfuse_dep ],
+               install: false)
+endforeach
 
 foreach ex : threaded_examples
     executable(ex, ex + '.c',
diff --git a/example/service_ll.c b/example/service_ll.c
new file mode 100644
index 00000000000000..d045176443d4e3
--- /dev/null
+++ b/example/service_ll.c
@@ -0,0 +1,328 @@
+/*
+ * FUSE: Filesystem in Userspace
+ * Copyright (C) 2026 Oracle.
+ *
+ * This program can be distributed under the terms of the GNU GPLv2.
+ * See the file GPL2.txt.
+ */
+
+/** @file
+ *
+ * Minimal example filesystem using low-level API and systemd service API.
+ *
+ * - Shows how to build a low level FUSE filesystem server that can be managed
+ *   by systemd
+ * - Enables on-demand filesystem mounting via socket activation
+ * - Demonstrates requesting resources from the mount-caller's environment
+ * - Allows running FUSE servers with minimal privileges; isolated mount,
+ *   network, and pid namespaces; and a separate uid/gid (unlike traditional
+ *   FUSE which needs mount permissions and runs in the caller's environment)
+ *
+ * Compile with:
+ *
+ *     gcc -Wall single_file.c service_ll.c `pkg-config fuse3 --cflags --libs` -o service_ll
+ *
+ * Note: If the pkg-config command fails due to the absence of the fuse3.pc
+ *     file, you should configure the path to the fuse3.pc file in the
+ *     PKG_CONFIG_PATH variable.
+ *
+ * Change the ExecStart line in service_ll@.service:
+ *
+ *     ExecStart=/path/to/service_ll
+ *
+ * to point to the actual path of the service_ll binary.
+ *
+ * Finally, install the service_ll@.service and service_ll.socket files to the
+ * systemd service directory, usually /run/systemd/system.  Run these commands
+ * to activate:
+ *
+ *     systemctl daemon-reload
+ *     systemctl start service_ll.socket
+ *
+ * Then mount with:
+ *
+ *     mount -t fuse.service_ll /dev/sda /mnt
+ *
+ * ## Source code ##
+ * \include service_ll.c
+ * \include service_ll.socket
+ * \include service_ll@.service
+ * \include single_file.c
+ * \include single_file.h
+ */
+
+#define FUSE_USE_VERSION FUSE_MAKE_VERSION(3, 19)
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+
+#include <fuse_lowlevel.h>
+#include <fuse_service.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <assert.h>
+#include <pthread.h>
+#include "single_file.h"
+
+struct service_ll {
+	struct fuse_session *se;
+	char *device;
+	struct fuse_service *service;
+
+	/* really booleans */
+	int debug;
+};
+
+static struct service_ll ll = { };
+
+static void service_ll_init(void *userdata, struct fuse_conn_info *conn)
+{
+	(void)userdata;
+
+	conn->time_gran = 1;
+}
+
+static void service_ll_read(fuse_req_t req, fuse_ino_t ino, size_t count,
+			    off_t pos, struct fuse_file_info *fi)
+{
+	void *buf = NULL;
+	ssize_t got;
+	int ret;
+
+	if (!is_single_file_ino(ino)) {
+		ret = EIO;
+		goto out_reply;
+	}
+
+	if (ll.debug)
+		fprintf(stderr, "%s: pos 0x%llx count 0x%llx\n",
+			__func__,
+			(unsigned long long)pos,
+			(unsigned long long)count);
+
+	if (!single_file.allow_dio && fi->direct_io) {
+		ret = ENOSYS;
+		goto out_reply;
+	}
+
+	single_file_check_read(pos, &count);
+
+	if (!count) {
+		fuse_reply_buf(req, buf, 0);
+		return;
+	}
+
+	buf = malloc(count);
+	if (!buf) {
+		ret = ENOMEM;
+		goto out_reply;
+	}
+
+	got = single_file_pread(buf, count, pos);
+	if (got < 0) {
+		ret = -got;
+		goto out_reply;
+	}
+
+	fuse_reply_buf(req, buf, got);
+	goto out_buf;
+
+out_reply:
+	fuse_reply_err(req, ret);
+out_buf:
+	free(buf);
+}
+
+static void service_ll_write(fuse_req_t req, fuse_ino_t ino, const char *buf,
+			     size_t count, off_t pos,
+			     struct fuse_file_info *fi)
+{
+	ssize_t got;
+	int ret;
+
+	if (!is_single_file_ino(ino)) {
+		ret = EIO;
+		goto out_reply;
+	}
+
+	if (ll.debug)
+		fprintf(stderr, "%s: pos 0x%llx count 0x%llx\n",
+			__func__,
+			(unsigned long long)pos,
+			(unsigned long long)count);
+
+	if (!single_file.allow_dio && fi->direct_io) {
+		ret = ENOSYS;
+		goto out_reply;
+	}
+
+	ret = -single_file_check_write(pos, &count);
+	if (ret)
+		goto out_reply;
+
+	if (!count) {
+		fuse_reply_write(req, 0);
+		return;
+	}
+
+	got = single_file_pwrite(buf, count, pos);
+	if (got < 0) {
+		ret = -got;
+		goto out_reply;
+	}
+
+	fuse_reply_write(req, got);
+	return;
+
+out_reply:
+	fuse_reply_err(req, ret);
+}
+
+static const struct fuse_lowlevel_ops service_ll_oper = {
+	.lookup		= single_file_ll_lookup,
+	.getattr	= single_file_ll_getattr,
+	.setattr	= single_file_ll_setattr,
+	.readdir	= single_file_ll_readdir,
+	.open		= single_file_ll_open,
+	.statfs		= single_file_ll_statfs,
+	.statx		= single_file_ll_statx,
+	.fsync		= single_file_ll_fsync,
+
+	.init		= service_ll_init,
+	.read		= service_ll_read,
+	.write		= service_ll_write,
+};
+
+#define SERVICE_LL_OPT(t, p, v) { t, offsetof(struct service_ll, p), v }
+
+static struct fuse_opt service_ll_opts[] = {
+	SERVICE_LL_OPT("debug",		debug,			1),
+	SINGLE_FILE_OPT_KEYS,
+	FUSE_OPT_END
+};
+
+static int service_ll_opt_proc(void *data, const char *arg, int key,
+				 struct fuse_args *outargs)
+{
+	int ret = single_file_opt_proc(data, arg, key, outargs);
+
+	if (ret < 1)
+		return ret;
+
+	switch (key) {
+	case FUSE_OPT_KEY_NONOPT:
+		if (!ll.device) {
+			ll.device = strdup(arg);
+			return 0;
+		}
+		return 1;
+	}
+
+	return 1;
+}
+
+int main(int argc, char *argv[])
+{
+	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
+	struct fuse_cmdline_opts opts = { };
+	struct fuse_loop_config *config = NULL;
+	int ret = 1;
+
+	if (fuse_service_accept(&ll.service))
+		goto err_args;
+
+	if (!fuse_service_accepted(ll.service))
+		goto err_args;
+
+	if (fuse_service_append_args(ll.service, &args))
+		goto err_service;
+
+	if (fuse_opt_parse(&args, &ll, service_ll_opts, service_ll_opt_proc))
+		goto err_service;
+
+	if (fuse_service_parse_cmdline_opts(&args, &opts))
+		goto err_service;
+
+	if (opts.show_help) {
+		printf("usage: %s [options] <device> <mountpoint>\n\n", argv[0]);
+		fuse_cmdline_help();
+		fuse_lowlevel_help();
+		ret = 0;
+		goto err_service;
+	} else if (opts.show_version) {
+		printf("FUSE library version %s\n", fuse_pkgversion());
+		fuse_lowlevel_version();
+		ret = 0;
+		goto err_service;
+	}
+
+	if (!opts.mountpoint || !ll.device) {
+		printf("usage: %s [options] <device> <mountpoint>\n", argv[0]);
+		printf("       %s --help\n", argv[0]);
+		goto err_service;
+	}
+
+	if (single_file_service_open(ll.service, ll.device))
+		goto err_service;
+
+	if (fuse_service_finish_file_requests(ll.service))
+		goto err_singlefile;
+
+	if (single_file_configure(ll.device, NULL))
+		goto err_singlefile;
+
+	ll.se = fuse_session_new(&args, &service_ll_oper,
+				 sizeof(service_ll_oper), NULL);
+	if (ll.se == NULL)
+		goto err_singlefile;
+
+	if (!opts.singlethread) {
+		config = fuse_loop_cfg_create();
+		if (!config) {
+			ret = 1;
+			goto err_session;
+		}
+	}
+
+	if (fuse_set_signal_handlers(ll.se))
+		goto err_loopcfg;
+
+	if (fuse_service_session_mount(ll.service, ll.se, S_IFDIR, &opts))
+		goto err_signals;
+
+	/* Block until ctrl+c or fusermount -u */
+	if (opts.singlethread) {
+		fuse_service_send_goodbye(ll.service, 0);
+		fuse_service_release(ll.service);
+		ret = fuse_session_loop(ll.se);
+	} else {
+		fuse_loop_cfg_set_clone_fd(config, opts.clone_fd);
+		fuse_loop_cfg_set_max_threads(config, opts.max_threads);
+
+		fuse_service_send_goodbye(ll.service, 0);
+		fuse_service_release(ll.service);
+		ret = fuse_session_loop_mt(ll.se, config);
+	}
+
+err_signals:
+	fuse_remove_signal_handlers(ll.se);
+err_loopcfg:
+	fuse_loop_cfg_destroy(config);
+err_session:
+	fuse_session_destroy(ll.se);
+err_singlefile:
+	single_file_close();
+err_service:
+	free(opts.mountpoint);
+	free(ll.device);
+	fuse_service_send_goodbye(ll.service, ret);
+	fuse_service_destroy(&ll.service);
+err_args:
+	fuse_opt_free_args(&args);
+	return fuse_service_exit(ret);
+}
diff --git a/example/service_ll.socket.in b/example/service_ll.socket.in
new file mode 100644
index 00000000000000..c41c382878a0cd
--- /dev/null
+++ b/example/service_ll.socket.in
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=Socket for service_ll Service
+
+[Socket]
+ListenSequentialPacket=@FUSE_SERVICE_SOCKET_DIR_RAW@/service_ll
+Accept=yes
+SocketMode=@FUSE_SERVICE_SOCKET_PERMS@
+RemoveOnStop=yes
+
+[Install]
+WantedBy=sockets.target
diff --git a/example/service_ll@.service b/example/service_ll@.service
new file mode 100644
index 00000000000000..016d839babe3cc
--- /dev/null
+++ b/example/service_ll@.service
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=service_ll Sample Fuse Service
+
+# Don't leave failed units behind, systemd does not clean them up!
+CollectMode=inactive-or-failed
+
+[Service]
+Type=exec
+ExecStart=/path/to/service_ll
+
+# Try to capture core dumps
+LimitCORE=infinity
+
+SyslogIdentifier=%N
+
+# No realtime CPU scheduling
+RestrictRealtime=true
+
+# Don't let us see anything in the regular system, and don't run as root
+DynamicUser=true
+ProtectSystem=strict
+ProtectHome=true
+PrivateTmp=true
+PrivateDevices=true
+PrivateUsers=true
+
+# No network access
+PrivateNetwork=true
+ProtectHostname=true
+RestrictAddressFamilies=none
+IPAddressDeny=any
+
+# Don't let the program mess with the kernel configuration at all
+ProtectKernelLogs=true
+ProtectKernelModules=true
+ProtectKernelTunables=true
+ProtectControlGroups=true
+ProtectProc=invisible
+RestrictNamespaces=true
+RestrictFileSystems=
+
+# Hide everything in /proc, even /proc/mounts
+ProcSubset=pid
+
+# Only allow the default personality Linux
+LockPersonality=true
+
+# No writable memory pages
+MemoryDenyWriteExecute=true
+
+# Don't let our mounts leak out to the host
+PrivateMounts=true
+
+# Restrict system calls to the native arch and only enough to get things going
+SystemCallArchitectures=native
+SystemCallFilter=@system-service
+SystemCallFilter=~@privileged
+SystemCallFilter=~@resources
+
+SystemCallFilter=~@clock
+SystemCallFilter=~@cpu-emulation
+SystemCallFilter=~@debug
+SystemCallFilter=~@module
+SystemCallFilter=~@reboot
+SystemCallFilter=~@swap
+
+SystemCallFilter=~@mount
+
+# libfuse io_uring wants to pin cores and memory
+SystemCallFilter=mbind
+SystemCallFilter=sched_setaffinity
+
+# Leave a breadcrumb if we get whacked by the system call filter
+SystemCallErrorNumber=EL3RST
+
+# Log to the kernel dmesg, just like an in-kernel filesystem driver
+StandardOutput=append:/dev/ttyprintk
+StandardError=append:/dev/ttyprintk
+
+# Run with no capabilities at all
+CapabilityBoundingSet=
+AmbientCapabilities=
+NoNewPrivileges=true
+
+# We don't create files
+UMask=7777
+
+# No access to hardware /dev files at all
+ProtectClock=true
+DevicePolicy=closed
+
+# Don't mess with set[ug]id anything.
+RestrictSUIDSGID=true
+
+# Don't let OOM kills of processes in this containment group kill the whole
+# service, because we don't want filesystem drivers to go down.
+OOMPolicy=continue
+OOMScoreAdjust=-1000
diff --git a/example/single_file.c b/example/single_file.c
new file mode 100644
index 00000000000000..9b6f76504686b5
--- /dev/null
+++ b/example/single_file.c
@@ -0,0 +1,746 @@
+/*
+ * FUSE: Filesystem in Userspace
+ * Copyright (C) 2026 Oracle.
+ *
+ * This program can be distributed under the terms of the GNU GPLv2.
+ * See the file GPL2.txt.
+ *
+ * This file is shared library code for example fuse servers that want to
+ * expose a single regular file that wraps another file in a manner that goes
+ * beyond simple passthrough.  It is not itself a fuse server.
+ */
+#define _GNU_SOURCE
+#include <pthread.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#ifdef __linux__
+#include <linux/fs.h>
+#include <linux/stat.h>
+#endif
+
+#define FUSE_USE_VERSION (FUSE_MAKE_VERSION(3, 19))
+
+#include "fuse_lowlevel.h"
+#include "fuse_service.h"
+#include "single_file.h"
+
+#define min(x, y) ((x) < (y) ? (x) : (y))
+
+#if __has_attribute(__fallthrough__)
+#define fallthrough __attribute__((__fallthrough__))
+#else
+#define fallthrough do {} while (0)
+#endif
+
+struct dirbuf {
+	char *p;
+	size_t size;
+};
+
+struct single_file_stat {
+	struct fuse_entry_param entry;
+};
+
+#define SINGLE_FILE_INO		(FUSE_ROOT_ID + 1)
+
+static const char *single_file_name = "single_file";
+static bool single_file_name_set;
+static struct timespec startup_time;
+
+struct single_file single_file = {
+	.backing_fd = -1,
+	.allow_dio = true,
+	.mode = S_IFREG | 0444,
+	.lock = PTHREAD_MUTEX_INITIALIZER,
+};
+
+static void dirbuf_add(fuse_req_t req, struct dirbuf *b, const char *name,
+		       fuse_ino_t ino)
+{
+	struct stat stbuf;
+	size_t oldsize = b->size;
+
+	b->size += fuse_add_direntry(req, NULL, 0, name, NULL, 0);
+	b->p = (char *) realloc(b->p, b->size);
+	memset(&stbuf, 0, sizeof(stbuf));
+	stbuf.st_ino = ino;
+	fuse_add_direntry(req, b->p + oldsize, b->size - oldsize, name, &stbuf,
+			  b->size);
+}
+
+int reply_buf_limited(fuse_req_t req, const char *buf, size_t bufsize,
+		      off_t off, size_t maxsize)
+{
+	if (off < bufsize)
+		return fuse_reply_buf(req, buf + off,
+				      min(bufsize - off, maxsize));
+	else
+		return fuse_reply_buf(req, NULL, 0);
+}
+
+bool is_single_file_child(fuse_ino_t parent, const char *name)
+{
+	return  parent == FUSE_ROOT_ID &&
+		strcmp(name, single_file_name) == 0;
+}
+
+bool is_single_file_ino(fuse_ino_t ino)
+{
+	return ino == SINGLE_FILE_INO;
+}
+
+void single_file_ll_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
+			    off_t off, struct fuse_file_info *fi)
+{
+	struct dirbuf b;
+
+	(void) fi;
+
+	switch (ino) {
+	case FUSE_ROOT_ID:
+		break;
+	case SINGLE_FILE_INO:
+		fuse_reply_err(req, ENOTDIR);
+		return;
+	default:
+		fuse_reply_err(req, ENOENT);
+		return;
+	}
+
+	memset(&b, 0, sizeof(b));
+	dirbuf_add(req, &b, ".", FUSE_ROOT_ID);
+	dirbuf_add(req, &b, "..", FUSE_ROOT_ID);
+	dirbuf_add(req, &b, single_file_name, SINGLE_FILE_INO);
+	reply_buf_limited(req, b.p, b.size, off, size);
+	free(b.p);
+}
+
+static bool sf_stat(fuse_ino_t ino, struct single_file_stat *llstat)
+{
+	struct fuse_entry_param *entry = &llstat->entry;
+	struct stat *stbuf = &entry->attr;
+
+	if (ino == FUSE_ROOT_ID) {
+		stbuf->st_mode = S_IFDIR | 0555;
+		stbuf->st_nlink = 2;
+		stbuf->st_atim = startup_time;
+		stbuf->st_mtim = startup_time;
+		stbuf->st_ctim = startup_time;
+	} else if (ino == SINGLE_FILE_INO) {
+		stbuf->st_mode = single_file.mode;
+		stbuf->st_nlink = 1;
+		stbuf->st_size = single_file.isize;
+		stbuf->st_blksize = single_file.blocksize;
+		stbuf->st_blocks = howmany(single_file.isize, 512);
+		stbuf->st_atim = single_file.atime;
+		stbuf->st_mtim = single_file.mtime;
+		stbuf->st_ctim = single_file.ctime;
+	} else {
+		return false;
+	}
+	stbuf->st_ino = ino;
+
+	entry->generation = ino + 1;
+	entry->attr_timeout = 0.0;
+	entry->entry_timeout = 0.0;
+	entry->ino = ino;
+
+	return true;
+}
+
+#if defined(STATX_BASIC_STATS)
+static inline void sf_set_statx_attr(struct statx *stx,
+				     uint64_t statx_flag, int set)
+{
+	if (set)
+		stx->stx_attributes |= statx_flag;
+	stx->stx_attributes_mask |= statx_flag;
+}
+
+static void sf_statx_directio(struct statx *stx)
+{
+	struct statx devx;
+	int ret;
+
+	ret = statx(single_file.backing_fd, "", AT_EMPTY_PATH, STATX_DIOALIGN,
+		    &devx);
+	if (ret)
+		return;
+	if (!(devx.stx_mask & STATX_DIOALIGN))
+		return;
+
+	stx->stx_mask |= STATX_DIOALIGN;
+	stx->stx_dio_mem_align = devx.stx_dio_mem_align;
+	stx->stx_dio_offset_align = devx.stx_dio_offset_align;
+}
+
+static bool sf_statx(fuse_ino_t ino, int statx_mask, struct statx *stx)
+{
+	(void)statx_mask;
+
+	if (ino == FUSE_ROOT_ID) {
+		stx->stx_mask = STATX_BASIC_STATS | STATX_BTIME;
+		stx->stx_mode = S_IFDIR | 0555;
+		stx->stx_nlink = 2;
+		stx->stx_atime.tv_sec = startup_time.tv_sec;
+		stx->stx_atime.tv_nsec = startup_time.tv_nsec;
+		stx->stx_mtime.tv_sec = startup_time.tv_sec;
+		stx->stx_mtime.tv_nsec = startup_time.tv_nsec;
+		stx->stx_ctime.tv_sec = startup_time.tv_sec;
+		stx->stx_ctime.tv_nsec = startup_time.tv_nsec;
+		stx->stx_btime.tv_sec = startup_time.tv_sec;
+		stx->stx_btime.tv_nsec = startup_time.tv_nsec;
+	} else if (ino == SINGLE_FILE_INO) {
+		stx->stx_mask = STATX_BASIC_STATS | STATX_BTIME;
+		stx->stx_mode = single_file.mode;
+		stx->stx_nlink = 1;
+		stx->stx_size = single_file.isize;
+		stx->stx_blksize = single_file.blocksize;
+		stx->stx_blocks = howmany(single_file.isize, 512);
+		stx->stx_atime.tv_sec = single_file.atime.tv_sec;
+		stx->stx_atime.tv_nsec = single_file.atime.tv_nsec;
+		stx->stx_mtime.tv_sec = single_file.mtime.tv_sec;
+		stx->stx_mtime.tv_nsec = single_file.mtime.tv_nsec;
+		stx->stx_ctime.tv_sec = single_file.ctime.tv_sec;
+		stx->stx_ctime.tv_nsec = single_file.ctime.tv_nsec;
+		stx->stx_btime.tv_sec = startup_time.tv_sec;
+		stx->stx_btime.tv_nsec = startup_time.tv_nsec;
+	} else {
+		return false;
+	}
+	stx->stx_ino = ino;
+
+	sf_set_statx_attr(stx, STATX_ATTR_IMMUTABLE, single_file.ro);
+	sf_statx_directio(stx);
+
+	return true;
+}
+
+void single_file_ll_statx(fuse_req_t req, fuse_ino_t ino, int flags, int mask,
+			  struct fuse_file_info *fi)
+{
+	struct statx stx = { };
+	bool filled;
+
+	(void)fi;
+
+	if ((flags & AT_STATX_FORCE_SYNC) && is_single_file_ino(ino) &&
+	    single_file.backing_fd >= 0) {
+		int ret = fsync(single_file.backing_fd);
+
+		if (ret) {
+			fuse_reply_err(req, errno);
+			return;
+		}
+	}
+
+	pthread_mutex_lock(&single_file.lock);
+	filled = sf_statx(ino, mask, &stx);
+	pthread_mutex_unlock(&single_file.lock);
+	if (!filled)
+		fuse_reply_err(req, ENOENT);
+	else
+		fuse_reply_statx(req, 0, &stx, 0.0);
+}
+#else
+void single_file_ll_statx(fuse_req_t req, fuse_ino_t ino, int flags, int mask,
+			  struct fuse_file_info *fi)
+{
+	fuse_reply_err(req, ENOSYS);
+}
+#endif /* STATX_BASIC_STATS */
+
+void single_file_ll_statfs(fuse_req_t req, fuse_ino_t ino)
+{
+	struct statvfs buf;
+
+	(void)ino;
+
+	pthread_mutex_lock(&single_file.lock);
+	buf.f_bsize = single_file.blocksize;
+	buf.f_frsize = 0;
+
+	buf.f_blocks = single_file.blocks;
+	buf.f_bfree = 0;
+	buf.f_bavail = 0;
+	buf.f_files = 1;
+	buf.f_ffree = 0;
+	buf.f_favail = 0;
+	buf.f_fsid = 0x50C00L;
+	buf.f_flag = 0;
+	if (single_file.ro)
+		buf.f_flag |= ST_RDONLY;
+	buf.f_namemax = 255;
+	pthread_mutex_unlock(&single_file.lock);
+
+	fuse_reply_statfs(req, &buf);
+}
+
+void single_file_ll_getattr(fuse_req_t req, fuse_ino_t ino,
+			    struct fuse_file_info *fi)
+{
+	struct single_file_stat llstat;
+	bool filled;
+
+	(void) fi;
+
+	memset(&llstat, 0, sizeof(llstat));
+	pthread_mutex_lock(&single_file.lock);
+	filled = sf_stat(ino, &llstat);
+	pthread_mutex_unlock(&single_file.lock);
+	if (!filled)
+		fuse_reply_err(req, ENOENT);
+	else
+		fuse_reply_attr(req, &llstat.entry.attr,
+				llstat.entry.attr_timeout);
+}
+
+static void get_now(struct timespec *now)
+{
+#ifdef CLOCK_REALTIME
+	if (!clock_gettime(CLOCK_REALTIME, now))
+		return;
+#endif
+
+	now->tv_sec = time(NULL);
+	now->tv_nsec = 0;
+}
+
+void single_file_ll_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
+			    int to_set, struct fuse_file_info *fi)
+{
+	struct timespec now;
+
+	if (ino != SINGLE_FILE_INO)
+		goto deny;
+	if (to_set & (FUSE_SET_ATTR_UID | FUSE_SET_ATTR_GID |
+		      FUSE_SET_ATTR_SIZE))
+		goto deny;
+	if (single_file.ro)
+		goto deny;
+
+	get_now(&now);
+
+	pthread_mutex_lock(&single_file.lock);
+	if (to_set & FUSE_SET_ATTR_MODE)
+		single_file.mode = (single_file.mode & S_IFMT) |
+				   (attr->st_mode & ~S_IFMT);
+	if (to_set & FUSE_SET_ATTR_ATIME) {
+		if (to_set & FUSE_SET_ATTR_ATIME_NOW)
+			single_file.atime = now;
+		else
+			single_file.atime = attr->st_atim;
+	}
+	if (to_set & FUSE_SET_ATTR_MTIME) {
+		if (to_set & FUSE_SET_ATTR_MTIME_NOW)
+			single_file.mtime = now;
+		else
+			single_file.mtime = attr->st_mtim;
+	}
+	if (to_set & FUSE_SET_ATTR_CTIME)
+		single_file.ctime = now;
+	pthread_mutex_unlock(&single_file.lock);
+
+	single_file_ll_getattr(req, ino, fi);
+	return;
+deny:
+	fuse_reply_err(req, EPERM);
+}
+
+void single_file_ll_lookup(fuse_req_t req, fuse_ino_t parent, const char *name)
+{
+	struct single_file_stat llstat;
+	bool filled;
+
+	if (!is_single_file_child(parent, name)) {
+		fuse_reply_err(req, ENOENT);
+		return;
+	}
+
+	memset(&llstat, 0, sizeof(llstat));
+	pthread_mutex_lock(&single_file.lock);
+	filled = sf_stat(SINGLE_FILE_INO, &llstat);
+	pthread_mutex_unlock(&single_file.lock);
+	if (!filled)
+		fuse_reply_err(req, ENOENT);
+	else
+		fuse_reply_entry(req, &llstat.entry);
+}
+
+void single_file_ll_open(fuse_req_t req, fuse_ino_t ino,
+			 struct fuse_file_info *fi)
+{
+	if (ino != SINGLE_FILE_INO)
+		fuse_reply_err(req, EISDIR);
+	else if (single_file.ro && (fi->flags & O_ACCMODE) != O_RDONLY)
+		fuse_reply_err(req, EROFS);
+	else
+		fuse_reply_open(req, fi);
+}
+
+void single_file_ll_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
+			  struct fuse_file_info *fi)
+{
+	int ret = 0;
+
+	(void)datasync;
+	(void)fi;
+
+	if (ino == SINGLE_FILE_INO) {
+		ret = fsync(single_file.backing_fd);
+		if (ret)
+			ret = errno;
+	}
+
+	fuse_reply_err(req, ret);
+}
+
+unsigned long long parse_num_blocks(const char *arg, int log_block_size)
+{
+	char *p;
+	unsigned long long num;
+
+	num = strtoull(arg, &p, 0);
+
+	if (p[0] && p[1])
+		return 0;
+
+	switch (*p) {
+	case 'T': case 't':
+		num <<= 10;
+		fallthrough;
+	case 'G': case 'g':
+		num <<= 10;
+		fallthrough;
+	case 'M': case 'm':
+		num <<= 10;
+		fallthrough;
+	case 'K': case 'k':
+		if (log_block_size < 0)
+			num <<= 10;
+		else
+			num >>= log_block_size;
+		break;
+	case 's':
+		if (log_block_size < 0)
+			num <<= 9;
+		else
+			num >>= (1+log_block_size);
+		break;
+	case '\0':
+		break;
+	default:
+		return 0;
+	}
+	return num;
+}
+
+static int single_file_set_blocksize(const char *arg)
+{
+	unsigned long long l = parse_num_blocks(arg, -1);
+
+	if (l < 512 || l > INT32_MAX || (l & (l - 1)) != 0) {
+		fprintf(stderr, "%s: block size must be power of two between 512 and 2G.\n",
+			arg);
+		return -1;
+	}
+
+	/* do not pass through to libfuse */
+	single_file.blocksize = l;
+	return 0;
+}
+
+static int single_file_set_size(const char *arg)
+{
+	unsigned long long l = parse_num_blocks(arg, -1);
+
+	if (l < 1 || (l & 511) != 0 || l > INT64_MAX) {
+		fprintf(stderr, "%s: size must be multiple of 512 and larger than zero.\n",
+			arg);
+		return -1;
+	}
+
+	/* do not pass through to libfuse */
+	single_file.isize = l;
+	return 0;
+}
+
+int single_file_opt_proc(void *data, const char *arg, int key,
+			 struct fuse_args *outargs)
+{
+	(void)data;
+	(void)outargs;
+
+	switch (key) {
+	case SINGLE_FILE_RO:
+		/* pass through to libfuse */
+		single_file.ro = true;
+		return 1;
+	case SINGLE_FILE_RW:
+		/* pass through to libfuse */
+		single_file.ro = false;
+		return 1;
+	case SINGLE_FILE_REQUIRE_BDEV:
+		single_file.require_bdev = true;
+		return 0;
+	case SINGLE_FILE_DIO:
+		single_file.allow_dio = true;
+		return 0;
+	case SINGLE_FILE_NODIO:
+		single_file.allow_dio = false;
+		return 0;
+	case SINGLE_FILE_SYNC:
+		single_file.sync = true;
+		return 0;
+	case SINGLE_FILE_NOSYNC:
+		single_file.sync = false;
+		return 0;
+	case SINGLE_FILE_BLOCKSIZE:
+		return single_file_set_blocksize(arg + 10);
+	case SINGLE_FILE_SIZE:
+		return single_file_set_size(arg + 5);
+	}
+
+	return 1;
+}
+
+int single_file_service_open(struct fuse_service *sf, const char *path)
+{
+	int open_flags = single_file.ro ? O_RDONLY : O_RDWR;
+	int fd;
+	int ret;
+
+again:
+	if (single_file.require_bdev)
+		ret = fuse_service_request_blockdev(sf, path,
+						    open_flags | O_EXCL, 0, 0,
+						    single_file.blocksize);
+	else
+		ret = fuse_service_request_file(sf, path, open_flags | O_EXCL,
+						0, 0);
+	if (ret)
+		return ret;
+
+	if (!single_file.ro && open_flags == O_RDONLY)
+		single_file.ro = true;
+
+	ret = fuse_service_receive_file(sf, path, &fd);
+	if (ret)
+		return ret;
+
+	/* downgrade from rw to ro if necessary */
+	if ((fd == -EPERM || fd == -EACCES || fd == -EROFS) &&
+	    open_flags == O_RDWR) {
+		open_flags = O_RDONLY;
+		goto again;
+	}
+
+	if (fd < 0) {
+		fprintf(stderr, "%s: opening file: %s.\n",
+			path, strerror(-fd));
+		return -1;
+	}
+
+	single_file.backing_fd = fd;
+	return 0;
+}
+
+int single_file_check_write(off_t pos, size_t *count)
+{
+	if (pos >= single_file.isize)
+		return -EFBIG;
+
+	if (*count > single_file.isize)
+		*count = single_file.isize;
+	if (pos >= single_file.isize - *count)
+		*count = single_file.isize - pos;
+
+	return 0;
+}
+
+void single_file_check_read(off_t pos, size_t *count)
+{
+	int ret = single_file_check_write(pos, count);
+
+	if (ret)
+		*count = 0;
+}
+
+ssize_t single_file_pwrite(const char *buf, size_t count, off_t pos)
+{
+	ssize_t processed = 0;
+	ssize_t got;
+
+	while ((got = pwrite(single_file.backing_fd, buf, count, pos)) > 0) {
+		processed += got;
+		pos += got;
+		buf += got;
+		count -= got;
+	}
+
+	if (processed > 0) {
+		struct timespec now;
+
+		if (single_file.sync) {
+			int ret = fsync(single_file.backing_fd);
+
+			if (ret < 0)
+				return -errno;
+		}
+
+		get_now(&now);
+
+		pthread_mutex_lock(&single_file.lock);
+		single_file.mtime = now;
+		single_file.ctime = now;
+		pthread_mutex_unlock(&single_file.lock);
+
+		return processed;
+	}
+
+	if (got < 0)
+		return -errno;
+	return 0;
+}
+
+ssize_t single_file_pread(char *buf, size_t count, off_t pos)
+{
+	ssize_t processed = 0;
+	ssize_t got;
+
+	while ((got = pread(single_file.backing_fd, buf, count, pos)) > 0) {
+		processed += got;
+		pos += got;
+		buf += got;
+		count -= got;
+	}
+
+	if (processed)
+		return processed;
+	if (got < 0)
+		return -errno;
+	return 0;
+}
+
+int single_file_configure(const char *device, const char *filename)
+{
+	struct stat stbuf;
+	unsigned long long backing_size;
+	unsigned int proposed_blocksize;
+	int lbasize;
+	int ret;
+
+	ret = fstat(single_file.backing_fd, &stbuf);
+	if (ret) {
+		perror(device);
+		return -1;
+	}
+	lbasize = stbuf.st_blksize;
+	backing_size = stbuf.st_size;
+
+	if (S_ISBLK(stbuf.st_mode)) {
+#ifdef BLKSSZGET
+		ret = ioctl(single_file.backing_fd, BLKSSZGET, &lbasize);
+		if (ret) {
+			perror(device);
+			return -1;
+		}
+#endif
+
+#ifdef BLKGETSIZE64
+		ret = ioctl(single_file.backing_fd, BLKGETSIZE64, &backing_size);
+		if (ret) {
+			perror(device);
+			return -1;
+		}
+#endif
+	}
+
+	if (backing_size == 0) {
+		fprintf(stderr, "%s: backing file size zero?\n", device);
+		return -1;
+	}
+
+	if (lbasize == 0) {
+		fprintf(stderr, "%s: blocksize zero?\n", device);
+		return -1;
+	}
+
+	proposed_blocksize = single_file.blocksize ? single_file.blocksize :
+						     sysconf(_SC_PAGESIZE);
+	if (lbasize > proposed_blocksize) {
+		fprintf(stderr, "%s: lba size %d smaller than blocksize %u\n",
+			device, lbasize, proposed_blocksize);
+		return -1;
+	}
+
+	if (single_file.isize % proposed_blocksize > 0) {
+		fprintf(stderr, "%s: size parameter %llu not congruent with blocksize %u\n",
+			device, (unsigned long long)single_file.isize,
+			proposed_blocksize);
+		return -1;
+	}
+
+	if (single_file.isize > backing_size) {
+		fprintf(stderr, "%s: file size %llu smaller than size param %llu\n",
+			device, backing_size,
+			(unsigned long long)single_file.isize);
+		return -1;
+	}
+
+	if (!single_file.blocksize)
+		single_file.blocksize = proposed_blocksize;
+	if (!single_file.isize)
+		single_file.isize = backing_size;
+
+	single_file.isize = round_down(single_file.isize, single_file.blocksize);
+	single_file.blocks = single_file.isize / single_file.blocksize;
+
+	return single_file_configure_simple(filename);
+}
+
+int single_file_configure_simple(const char *filename)
+{
+	if (!single_file.blocksize)
+		single_file.blocksize = sysconf(_SC_PAGESIZE);
+
+	if (filename) {
+		char *n = strdup(filename);
+
+		if (!n) {
+			perror(filename);
+			return -1;
+		}
+
+		if (single_file_name_set)
+			free((void *)single_file_name);
+		single_file_name = n;
+		single_file_name_set = true;
+	}
+
+	get_now(&startup_time);
+	single_file.atime = startup_time;
+	single_file.mtime = startup_time;
+	single_file.ctime = startup_time;
+
+	if (!single_file.ro)
+		single_file.mode |= 0220;
+
+	return 0;
+}
+
+void single_file_close(void)
+{
+	close(single_file.backing_fd);
+	single_file.backing_fd = -1;
+
+	if (single_file_name_set)
+		free((void *)single_file_name);
+	single_file_name_set = false;
+}
diff --git a/meson.build b/meson.build
index 827ec45ad3ad75..de038df8d92071 100644
--- a/meson.build
+++ b/meson.build
@@ -77,6 +77,7 @@ endif
 if service_socket_perms == ''
   service_socket_perms = '0220'
 endif
+private_cfg.set('FUSE_SERVICE_SOCKET_DIR_RAW', service_socket_dir)
 private_cfg.set_quoted('FUSE_SERVICE_SOCKET_DIR', service_socket_dir)
 private_cfg.set('FUSE_SERVICE_SOCKET_PERMS', service_socket_perms)
 

