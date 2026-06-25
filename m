Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE22FD69E
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416486; cv=none; b=emJY6HJ+WO3S4OgNjlHz7GHwx4oyIVDdiQcZ9JKGxaDfkEnejqnsFKnyHssG07Rf2MNDqV9gyAZDcERnh9kHiZ+1HXwwrsHlOpD6CF0knYNniXJjhRei4NqSG5i71zX4T+PMNIoyEq9Ah7PiJ+XHvDQ+UJmcr0thLrPneUBz8RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416486; c=relaxed/simple;
	bh=n7IDm7IDb+0U6wxweJuEs2uVEZ09yZpGUos8P7t/fjM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PnGiUWMNl4FVb+udZSQcKpC9grNIrmhp8bkZd6vfH4bDo5+1LOYV9ERAhGKruJKNsHqeHgKP4KXDiq8H1HORZ0VPMVS8clOWqhoF491+CT55Gpg74SKDH1kGX2C5l6QX2mxuDC9qkS03dhhZppIf1vivIrcSx3ZqQLAcx83BHso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJ4VDGsH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJ4VDGsH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9A0CB1F000E9;
	Thu, 25 Jun 2026 19:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416484;
	bh=GSRj/pI9PbmYmWPB0WT5VjtP6LU1T2FxZfXQIEP4J38=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=FJ4VDGsHbIgSIUWCx0UXrklyUCPjufSBX8yWkv5Kowgyx9obQ1biMv1wDlzaZ4Vcc
	 O3MVbiTXHFdMvVb7Lh+p/oBncENXeWob89eDwukXTXsSDNZT/y8pOIjVElHf/WCQ/J
	 6wilIxptkNNVkEiyfcHhqAHF49XZLlR9YOrO6Zfg2tEczxxTbGIP4y9jy/rSeeHh5i
	 jdfnKjMNupC2r2prTbb6lKCSJOaBJarVI47Iul1i7GdyRDbgJNiCCmy2LeSXtQvddS
	 IgH5PxRAv0pP5IP165W1XGm+dO6ryvBaKE/gNWnK5XMmIWpZQvmY0pw2vjoEDlh4/z
	 /M8bHvPw1yHOQ==
Date: Thu, 25 Jun 2026 12:41:24 -0700
Subject: [PATCH 2/4] fuse2fs: only reclaim buffer cache when there is memory
 pressure
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241607441.1811120.18403009424860314460.stgit@frogsfrogsfrogs>
In-Reply-To: <178241607392.1811120.7216807779096078422.stgit@frogsfrogsfrogs>
References: <178241607392.1811120.7216807779096078422.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use the pressure stall indicator library that we added in the previous
patch to make it so that we only shrink the cache when there's memory
pressure.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/Makefile.in |    3 +-
 fuse4fs/fuse4fs.c   |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/Makefile.in    |    3 +-
 misc/fuse2fs.c      |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 172 insertions(+), 2 deletions(-)


diff --git a/fuse4fs/Makefile.in b/fuse4fs/Makefile.in
index 44ae3b78a29b9d..f7475c5616ca7e 100644
--- a/fuse4fs/Makefile.in
+++ b/fuse4fs/Makefile.in
@@ -180,7 +180,8 @@ fuse4fs.o: $(srcdir)/fuse4fs.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/support/bthread.h \
  $(top_srcdir)/lib/support/thread.h $(top_srcdir)/lib/support/list.h \
  $(top_srcdir)/lib/support/cache.h $(top_srcdir)/version.h \
- $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/support/iocache.h
+ $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/support/iocache.h \
+ $(top_srcdir)/lib/support/psi.h
 journal.o: $(srcdir)/../debugfs/journal.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/../debugfs/journal.h \
  $(top_srcdir)/e2fsck/jfs_user.h $(top_srcdir)/e2fsck/e2fsck.h \
diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 9744c0941cf31b..9b04d12f7c8762 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -61,6 +61,7 @@
 #include "support/list.h"
 #include "support/cache.h"
 #include "support/iocache.h"
+#include "support/psi.h"
 
 #include "../version.h"
 #include "uuid/uuid.h"
@@ -304,6 +305,8 @@ struct fuse4fs {
 # endif
 	int bdev_fd;
 #endif
+	struct psi *mem_psi;
+	struct psi_handler *mem_psi_handler;
 };
 
 #ifdef HAVE_FUSE4FS_SERVICE
@@ -904,6 +907,74 @@ static void fuse4fs_mmp_destroy(struct fuse4fs *ff)
 # define fuse4fs_mmp_destroy(...)	((void)0)
 #endif
 
+static void fuse4fs_psi_memory(const struct psi *psi, unsigned int reasons,
+			       void *data)
+{
+	struct fuse4fs *ff = data;
+	ext2_filsys fs;
+	errcode_t err;
+	int ret = 0;
+
+	fs = fuse4fs_start(ff);
+	dbg_printf(ff, "%s:\n", __func__);
+	if (fs && !psi_thread_cancelled(ff->mem_psi)) {
+		err = io_channel_set_options(fs->io, "cache_shrink");
+		if (err)
+			ret = translate_error(fs, 0, err);
+	} else {
+		psi_cancel_handler(ff->mem_psi, &ff->mem_psi_handler);
+	}
+	fuse4fs_finish(ff, ret);
+}
+
+static int fuse4fs_psi_config(struct fuse4fs *ff)
+{
+	errcode_t err;
+
+	/*
+	 * Activate when there are memory stalls for 200ms every 2s; or
+	 * 5min goes by.  Unprivileged processes can only use 2s windows.
+	 */
+	err = psi_create(PSI_MEMORY, PSI_TRIM_HEAP, 20100, 2000000,
+			 5 * 60 * 1000000, &ff->mem_psi);
+	if (err) {
+		switch (errno) {
+		case ENOENT:
+		case EINVAL:
+		case EACCES:
+		case EPERM:
+			break;
+		default:
+			err_printf(ff, "PSI: %s.\n", error_message(errno));
+			return -1;
+		}
+	}
+
+	err = psi_add_handler(ff->mem_psi, fuse4fs_psi_memory, ff,
+			      &ff->mem_psi_handler);
+	if (err) {
+		err_printf(ff, "PSI: %s.\n", error_message(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+static void fuse4fs_psi_start(struct fuse4fs *ff)
+{
+	if (psi_active(ff->mem_psi))
+		psi_start_thread(ff->mem_psi);
+}
+
+static void fuse4fs_psi_destroy(struct fuse4fs *ff)
+{
+	if (!psi_active(ff->mem_psi))
+		return;
+
+	psi_del_handler(ff->mem_psi, &ff->mem_psi_handler);
+	psi_destroy(&ff->mem_psi);
+}
+
 static inline struct fuse4fs *fuse4fs_get(fuse_req_t req)
 {
 	return (struct fuse4fs *)fuse_req_userdata(req);
@@ -1744,6 +1815,11 @@ static errcode_t fuse4fs_config_cache(struct fuse4fs *ff)
 		return err;
 	}
 
+	if (psi_active(ff->mem_psi)) {
+		snprintf(buf, sizeof(buf), "cache_auto_shrink=off");
+		io_channel_set_options(ff->fs->io, buf);
+	}
+
 	return 0;
 }
 
@@ -2042,6 +2118,7 @@ static void op_init(void *userdata, struct fuse_conn_info *conn)
 	 * conveyed to the new child process.
 	 */
 	fuse4fs_mmp_start(ff);
+	fuse4fs_psi_start(ff);
 
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 17)
 	/*
@@ -6544,6 +6621,12 @@ int main(int argc, char *argv[])
 	try_set_io_flusher(&fctx);
 	try_adjust_oom_score(&fctx);
 
+	err = fuse4fs_psi_config(&fctx);
+	if (err) {
+		ret |= 32;
+		goto out;
+	}
+
 	/* Will we allow users to allocate every last block? */
 	if (getenv("FUSE4FS_ALLOC_ALL_BLOCKS")) {
 		log_printf(&fctx, "%s\n",
@@ -6636,6 +6719,7 @@ int main(int argc, char *argv[])
  _("Mount failed while opening filesystem.  Check dmesg(1) for details."));
 		fflush(orig_stderr);
 	}
+	fuse4fs_psi_destroy(&fctx);
 	fuse4fs_mmp_destroy(&fctx);
 	fuse4fs_unmount(&fctx);
 	reset_com_err_hook();
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 6f46ae7007018c..be668f69745dc2 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -881,7 +881,8 @@ fuse2fs.o: $(srcdir)/fuse2fs.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/bitops.h $(top_srcdir)/lib/ext2fs/ext2fsP.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/version.h \
  $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/support/cache.h \
- $(top_srcdir)/lib/support/list.h $(top_srcdir)/lib/support/iocache.h
+ $(top_srcdir)/lib/support/list.h $(top_srcdir)/lib/support/iocache.h \
+ $(top_srcdir)/lib/support/psi.h
 e2fuzz.o: $(srcdir)/e2fuzz.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index caa675bc9f95e9..92ecc4ca431a95 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -52,6 +52,7 @@
 #include "support/list.h"
 #include "support/cache.h"
 #include "support/iocache.h"
+#include "support/psi.h"
 
 #include "../version.h"
 #include "uuid/uuid.h"
@@ -279,6 +280,8 @@ struct fuse2fs {
 	/* options set by fuse_opt_parse must be of type int */
 	int timing;
 #endif
+	struct psi *mem_psi;
+	struct psi_handler *mem_psi_handler;
 };
 
 #define FUSE2FS_CHECK_HANDLE(ff, fh) \
@@ -716,6 +719,74 @@ static void fuse2fs_mmp_destroy(struct fuse2fs *ff)
 # define fuse2fs_mmp_destroy(...)	((void)0)
 #endif
 
+static void fuse2fs_psi_memory(const struct psi *psi, unsigned int reasons,
+			       void *data)
+{
+	struct fuse2fs *ff = data;
+	ext2_filsys fs;
+	errcode_t err;
+	int ret = 0;
+
+	fs = fuse2fs_start(ff);
+	dbg_printf(ff, "%s:\n", __func__);
+	if (fs && !psi_thread_cancelled(ff->mem_psi)) {
+		err = io_channel_set_options(fs->io, "cache_shrink");
+		if (err)
+			ret = translate_error(fs, 0, err);
+	} else {
+		psi_cancel_handler(ff->mem_psi, &ff->mem_psi_handler);
+	}
+	fuse2fs_finish(ff, ret);
+}
+
+static int fuse2fs_psi_config(struct fuse2fs *ff)
+{
+	errcode_t err;
+
+	/*
+	 * Activate when there are memory stalls for 200ms every 2s; or
+	 * 5min goes by.  Unprivileged processes can only use 2s windows.
+	 */
+	err = psi_create(PSI_MEMORY, PSI_TRIM_HEAP, 20100, 2000000,
+			 5 * 60 * 1000000, &ff->mem_psi);
+	if (err) {
+		switch (errno) {
+		case ENOENT:
+		case EINVAL:
+		case EACCES:
+		case EPERM:
+			break;
+		default:
+			err_printf(ff, "PSI: %s.\n", error_message(errno));
+			return -1;
+		}
+	}
+
+	err = psi_add_handler(ff->mem_psi, fuse2fs_psi_memory, ff,
+			      &ff->mem_psi_handler);
+	if (err) {
+		err_printf(ff, "PSI: %s.\n", error_message(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+static void fuse2fs_psi_start(struct fuse2fs *ff)
+{
+	if (psi_active(ff->mem_psi))
+		psi_start_thread(ff->mem_psi);
+}
+
+static void fuse2fs_psi_destroy(struct fuse2fs *ff)
+{
+	if (!psi_active(ff->mem_psi))
+		return;
+
+	psi_del_handler(ff->mem_psi, &ff->mem_psi_handler);
+	psi_destroy(&ff->mem_psi);
+}
+
 static inline struct fuse2fs *fuse2fs_get(void)
 {
 	struct fuse_context *ctxt = fuse_get_context();
@@ -1332,6 +1403,11 @@ static errcode_t fuse2fs_config_cache(struct fuse2fs *ff)
 		return err;
 	}
 
+	if (psi_active(ff->mem_psi)) {
+		snprintf(buf, sizeof(buf), "cache_auto_shrink=off");
+		err = io_channel_set_options(ff->fs->io, buf);
+	}
+
 	return 0;
 }
 
@@ -1641,6 +1717,7 @@ static void *op_init(struct fuse_conn_info *conn,
 	 * conveyed to the new child process.
 	 */
 	fuse2fs_mmp_start(ff);
+	fuse2fs_psi_start(ff);
 
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 17)
 	/*
@@ -5569,6 +5646,12 @@ int main(int argc, char *argv[])
 	try_set_io_flusher(&fctx);
 	try_adjust_oom_score(&fctx);
 
+	err = fuse2fs_psi_config(&fctx);
+	if (err) {
+		ret |= 32;
+		goto out;
+	}
+
 	/* Will we allow users to allocate every last block? */
 	if (getenv("FUSE2FS_ALLOC_ALL_BLOCKS")) {
 		log_printf(&fctx, "%s\n",
@@ -5658,6 +5741,7 @@ int main(int argc, char *argv[])
  _("Mount failed while opening filesystem.  Check dmesg(1) for details."));
 		fflush(orig_stderr);
 	}
+	fuse2fs_psi_destroy(&fctx);
 	fuse2fs_mmp_destroy(&fctx);
 	fuse2fs_unmount(&fctx);
 	reset_com_err_hook();

