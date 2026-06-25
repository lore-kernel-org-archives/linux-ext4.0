Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D946B25785C
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416517; cv=none; b=sH4dg+P7mMPQcjkjQkfwa60BAAIQM2tEsoXP+DEzgVsT26U17TbU+WJDZwzfW4zn90+f2FfE03s63WdojKCV+MMlyVycFEnTR4++y2DYPCrw4gm0RanQ6rAYPr2+KuU23nk58uzpryJrEQvzpZwM2Cqu10dOwbfA2lPxC3NKEYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416517; c=relaxed/simple;
	bh=S1eLbEhz0Pg57W5YWfu/37yu7KCM2MRi0X0sjY/p3RQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hlt8h5MPNtw6zF/ps92ZsMPBHHALgYCrhywVybcr5hkhvS9f7AQVl4jrHj9MoZfyrm4pKvFWCto5RlOW6hntH26FC87Bz2voa/cGG2J6hZRNbeZDKOqJG8nauG9S778Uw2AbCyqPTTW2SiBt7uLyO3khdpi9r1nFMI6DCChfaRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfrwUvW/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfrwUvW/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A74B21F000E9;
	Thu, 25 Jun 2026 19:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416515;
	bh=vkMSzlqBcEb5+lEtIlvIB8Ebx15RiM5T4e1LZbs+QGk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=UfrwUvW/RPmTwYe3F6AZmzTUSwSya81v5005F/+hIZlTBVdiDkMq1r9BpR7WkiiAR
	 Hnho00dmaUwqedZLiK4rFJn/N0rgPFdVHX/yj52ibfkLhNxE+wc24dCzmJ+jJWKlwV
	 msk35SjWhqQK+6YAQrncyE9Ww9eCcApVNX6UKBI/+HsppC0AYjhvoM9Q9N/UnWCo85
	 /wPrU+WOvI1YFzOMZA2qaQYAo2KlyVDuOoxCqs7cyJf2Jj51voZCfhkAuulpOCO2bi
	 bh/7A8gJ/nAszogIs34GTNeSlD29KGfDKlKJ/ICTMxzmF3FfWZLEKALCNLt++2XQ2O
	 VXoYfatj1kSgA==
Date: Thu, 25 Jun 2026 12:41:55 -0700
Subject: [PATCH 4/4] fuse2fs: flush dirty metadata periodically
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241607477.1811120.6955919746588775635.stgit@frogsfrogsfrogs>
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

Flush dirty metadata out to disk periodically like the kernel, to reduce
the potential for data loss if userspace doesn't explicitly fsync.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 misc/fuse2fs.c    |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 198 insertions(+), 12 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 83855e4c5e63d7..91cf65212c2e82 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -27,6 +27,7 @@
 #include <unistd.h>
 #include <ctype.h>
 #include <assert.h>
+#include <limits.h>
 #define FUSE_DARWIN_ENABLE_EXTENSIONS 0
 #ifdef __SET_FOB_FOR_FUSE
 # error Do not set magic value __SET_FOB_FOR_FUSE!!!!
@@ -309,6 +310,10 @@ struct fuse4fs {
 #endif
 	struct psi *mem_psi;
 	struct psi_handler *mem_psi_handler;
+
+	struct bthread *flush_thread;
+	unsigned int flush_interval;
+	double last_flush;
 };
 
 #ifdef HAVE_FUSE4FS_SERVICE
@@ -1003,6 +1008,71 @@ fuse4fs_set_handle(struct fuse_file_info *fp, struct fuse4fs_file_handle *fh)
 	fp->keep_cache = 1;
 }
 
+static errcode_t fuse4fs_flush(struct fuse4fs *ff, int flags)
+{
+	double last_flush = gettime_monotonic();
+	errcode_t err;
+
+	err = ext2fs_flush2(ff->fs, flags);
+	if (err)
+		return err;
+
+	ff->last_flush = last_flush;
+	return 0;
+}
+
+static inline int fuse4fs_flush_wanted(struct fuse4fs *ff)
+{
+	return ff->fs != NULL && ff->opstate == F4OP_WRITABLE &&
+	       ff->last_flush + ff->flush_interval <= gettime_monotonic();
+}
+
+static void fuse4fs_flush_bthread(void *data)
+{
+	struct fuse4fs *ff = data;
+	ext2_filsys fs;
+	errcode_t err;
+	int ret = 0;
+
+	fs = fuse4fs_start(ff);
+	if (fuse4fs_flush_wanted(ff) && !bthread_cancelled(ff->flush_thread)) {
+		err = fuse4fs_flush(ff, 0);
+		if (err)
+			ret = translate_error(fs, 0, err);
+	}
+	fuse4fs_finish(ff, ret);
+}
+
+static void fuse4fs_flush_start(struct fuse4fs *ff)
+{
+	int ret;
+
+	if (!ff->flush_interval)
+		return;
+
+	ret = bthread_create("fuse4fs_flush", fuse4fs_flush_bthread, ff,
+			     ff->flush_interval, &ff->flush_thread);
+	if (ret) {
+		err_printf(ff, "flusher: %s.\n", error_message(ret));
+		return;
+	}
+
+	ret = bthread_start(ff->flush_thread);
+	if (ret)
+		err_printf(ff, "flusher: %s.\n", error_message(ret));
+}
+
+static void fuse4fs_flush_cancel(struct fuse4fs *ff)
+{
+	if (ff->flush_thread)
+		bthread_cancel(ff->flush_thread);
+}
+
+static void fuse4fs_flush_destroy(struct fuse4fs *ff)
+{
+	bthread_destroy(&ff->flush_thread);
+}
+
 static void get_now(struct timespec *now)
 {
 #ifdef CLOCK_REALTIME
@@ -1966,7 +2036,7 @@ static int fuse4fs_mount(struct fuse4fs *ff)
 		ext2fs_set_tstamp(fs->super, s_mtime, time(NULL));
 		fs->super->s_state &= ~EXT2_VALID_FS;
 		ext2fs_mark_super_dirty(fs);
-		err = ext2fs_flush2(fs, 0);
+		err = fuse4fs_flush(ff, 0);
 		if (err)
 			return translate_error(fs, 0, err);
 	}
@@ -1994,7 +2064,7 @@ static void op_destroy(void *userdata)
 		if (err)
 			translate_error(fs, 0, err);
 
-		err = ext2fs_flush2(fs, 0);
+		err = fuse4fs_flush(ff, 0);
 		if (err)
 			translate_error(fs, 0, err);
 	}
@@ -2186,6 +2256,7 @@ static void op_init(void *userdata, struct fuse_conn_info *conn)
 	 */
 	fuse4fs_mmp_start(ff);
 	fuse4fs_psi_start(ff);
+	fuse4fs_flush_start(ff);
 
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 17)
 	/*
@@ -2553,7 +2624,7 @@ static inline int fuse4fs_dirsync_flush(struct fuse4fs *ff, ext2_ino_t ino,
 		*flushed = 0;
 	return 0;
 flush:
-	err = ext2fs_flush2(fs, 0);
+	err = fuse4fs_flush(ff, 0);
 	if (err)
 		return translate_error(fs, 0, err);
 
@@ -4378,7 +4449,7 @@ static void op_release(fuse_req_t req, fuse_ino_t fino EXT2FS_ATTR((unused)),
 	if ((fp->flags & O_SYNC) &&
 	    fuse4fs_is_writeable(ff) &&
 	    (fh->open_flags & EXT2_FILE_WRITE)) {
-		err = ext2fs_flush2(fs, EXT2_FLAG_FLUSH_NO_SYNC);
+		err = fuse4fs_flush(ff, EXT2_FLAG_FLUSH_NO_SYNC);
 		if (err)
 			ret = translate_error(fs, fh->ino, err);
 	}
@@ -4409,7 +4480,7 @@ static void op_fsync(fuse_req_t req, fuse_ino_t fino EXT2FS_ATTR((unused)),
 	fs = fuse4fs_start(ff);
 	/* For now, flush everything, even if it's slow */
 	if (fuse4fs_is_writeable(ff) && fh->open_flags & EXT2_FILE_WRITE) {
-		err = ext2fs_flush2(fs, 0);
+		err = fuse4fs_flush(ff, 0);
 		if (err)
 			ret = translate_error(fs, fh->ino, err);
 	}
@@ -5730,6 +5801,7 @@ static int ioctl_shutdown(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 
 	err_printf(ff, "%s.\n", _("shut down requested"));
 
+	fuse4fs_flush_cancel(ff);
 	fuse4fs_mmp_cancel(ff);
 
 	/*
@@ -5738,7 +5810,7 @@ static int ioctl_shutdown(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 	 * any of the flags.  Flush whatever is dirty and shut down.
 	 */
 	if (ff->opstate == F4OP_WRITABLE)
-		ext2fs_flush2(fs, 0);
+		fuse4fs_flush(ff, 0);
 	ff->opstate = F4OP_SHUTDOWN;
 	fs->flags &= ~EXT2_FLAG_RW;
 
@@ -6192,6 +6264,7 @@ enum {
 	FUSE4FS_CACHE_SIZE,
 	FUSE4FS_DIRSYNC,
 	FUSE4FS_ERRORS_BEHAVIOR,
+	FUSE4FS_FLUSH_INTERVAL,
 };
 
 #define FUSE4FS_OPT(t, p, v) { t, offsetof(struct fuse4fs, p), v }
@@ -6216,6 +6289,7 @@ static struct fuse_opt fuse4fs_opts[] = {
 #ifdef HAVE_CLOCK_MONOTONIC
 	FUSE4FS_OPT("timing",		timing,			1),
 #endif
+	FUSE_OPT_KEY("flush_interval=%s", FUSE4FS_FLUSH_INTERVAL),
 
 	FUSE_OPT_KEY("user_xattr",	FUSE4FS_IGNORED),
 	FUSE_OPT_KEY("noblock_validity", FUSE4FS_IGNORED),
@@ -6274,6 +6348,21 @@ static int fuse4fs_opt_proc(void *data, const char *arg,
 
 		/* do not pass through to libfuse */
 		return 0;
+	case FUSE4FS_FLUSH_INTERVAL:
+		char *p;
+		unsigned long val;
+
+		errno = 0;
+		val = strtoul(arg + 15, &p, 0);
+		if (p != arg + strlen(arg) || errno || val > UINT_MAX) {
+			fprintf(stderr, "%s: %s.\n", arg,
+				_("Unrecognized flush interval"));
+			return -1;
+		}
+
+		/* do not pass through to libfuse */
+		ff->flush_interval = val;
+		return 0;
 	case FUSE4FS_IGNORED:
 		return 0;
 	case FUSE4FS_HELP:
@@ -6301,6 +6390,7 @@ static int fuse4fs_opt_proc(void *data, const char *arg,
 	"    -o cache_size=N[KMG]   use a disk cache of this size\n"
 	"    -o errors=             behavior when an error is encountered:\n"
 	"                           continue|remount-ro|panic\n"
+	"    -o flush=<time>        flush dirty metadata on this interval\n"
 	"\n",
 			outargs->argv[0]);
 		if (key == FUSE4FS_HELPFULL) {
@@ -6621,6 +6711,7 @@ int main(int argc, char *argv[])
 		.psi_sys_mem_fd = -1,
 		.psi_cgroup_mem_fd = -1,
 #endif
+		.flush_interval = 30,
 	};
 	errcode_t err;
 	FILE *orig_stderr = stderr;
@@ -6788,6 +6879,7 @@ int main(int argc, char *argv[])
  _("Mount failed while opening filesystem.  Check dmesg(1) for details."));
 		fflush(orig_stderr);
 	}
+	fuse4fs_flush_destroy(&fctx);
 	fuse4fs_psi_destroy(&fctx);
 	fuse4fs_mmp_destroy(&fctx);
 	fuse4fs_unmount(&fctx);
@@ -6969,6 +7061,7 @@ static int __translate_error(ext2_filsys fs, ext2_ino_t ino, errcode_t err,
  _("Remounting read-only due to errors."));
 			ff->opstate = F4OP_READONLY;
 		}
+		fuse4fs_flush_cancel(ff);
 		fuse4fs_mmp_cancel(ff);
 		fs->flags &= ~EXT2_FLAG_RW;
 		break;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 92ecc4ca431a95..985229ccf676d6 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -25,6 +25,7 @@
 #include <sys/ioctl.h>
 #include <unistd.h>
 #include <ctype.h>
+#include <limits.h>
 #define FUSE_DARWIN_ENABLE_EXTENSIONS 0
 #ifdef __SET_FOB_FOR_FUSE
 # error Do not set magic value __SET_FOB_FOR_FUSE!!!!
@@ -282,6 +283,10 @@ struct fuse2fs {
 #endif
 	struct psi *mem_psi;
 	struct psi_handler *mem_psi_handler;
+
+	struct bthread *flush_thread;
+	unsigned int flush_interval;
+	double last_flush;
 };
 
 #define FUSE2FS_CHECK_HANDLE(ff, fh) \
@@ -806,6 +811,71 @@ fuse2fs_set_handle(struct fuse_file_info *fp, struct fuse2fs_file_handle *fh)
 	fp->fh = (uintptr_t)fh;
 }
 
+static errcode_t fuse2fs_flush(struct fuse2fs *ff, int flags)
+{
+	double last_flush = gettime_monotonic();
+	errcode_t err;
+
+	err = ext2fs_flush2(ff->fs, flags);
+	if (err)
+		return err;
+
+	ff->last_flush = last_flush;
+	return 0;
+}
+
+static inline int fuse2fs_flush_wanted(struct fuse2fs *ff)
+{
+	return ff->fs != NULL && ff->opstate == F2OP_WRITABLE &&
+	       ff->last_flush + ff->flush_interval <= gettime_monotonic();
+}
+
+static void fuse2fs_flush_bthread(void *data)
+{
+	struct fuse2fs *ff = data;
+	ext2_filsys fs;
+	errcode_t err;
+	int ret = 0;
+
+	fs = fuse2fs_start(ff);
+	if (fuse2fs_flush_wanted(ff) && !bthread_cancelled(ff->flush_thread)) {
+		err = fuse2fs_flush(ff, 0);
+		if (err)
+			ret = translate_error(fs, 0, err);
+	}
+	fuse2fs_finish(ff, ret);
+}
+
+static void fuse2fs_flush_start(struct fuse2fs *ff)
+{
+	int ret;
+
+	if (!ff->flush_interval)
+		return;
+
+	ret = bthread_create("fuse2fs_flush", fuse2fs_flush_bthread, ff,
+			     ff->flush_interval, &ff->flush_thread);
+	if (ret) {
+		err_printf(ff, "flusher: %s.\n", error_message(ret));
+		return;
+	}
+
+	ret = bthread_start(ff->flush_thread);
+	if (ret)
+		err_printf(ff, "flusher: %s.\n", error_message(ret));
+}
+
+static void fuse2fs_flush_cancel(struct fuse2fs *ff)
+{
+	if (ff->flush_thread)
+		bthread_cancel(ff->flush_thread);
+}
+
+static void fuse2fs_flush_destroy(struct fuse2fs *ff)
+{
+	bthread_destroy(&ff->flush_thread);
+}
+
 static void get_now(struct timespec *now)
 {
 #ifdef CLOCK_REALTIME
@@ -1487,7 +1557,7 @@ static int fuse2fs_mount(struct fuse2fs *ff)
 		ext2fs_set_tstamp(fs->super, s_mtime, time(NULL));
 		fs->super->s_state &= ~EXT2_VALID_FS;
 		ext2fs_mark_super_dirty(fs);
-		err = ext2fs_flush2(fs, 0);
+		err = fuse2fs_flush(ff, 0);
 		if (err)
 			return translate_error(fs, 0, err);
 	}
@@ -1515,7 +1585,7 @@ static void op_destroy(void *p EXT2FS_ATTR((unused)))
 		if (err)
 			translate_error(fs, 0, err);
 
-		err = ext2fs_flush2(fs, 0);
+		err = fuse2fs_flush(ff, 0);
 		if (err)
 			translate_error(fs, 0, err);
 	}
@@ -1718,6 +1788,7 @@ static void *op_init(struct fuse_conn_info *conn,
 	 */
 	fuse2fs_mmp_start(ff);
 	fuse2fs_psi_start(ff);
+	fuse2fs_flush_start(ff);
 
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 17)
 	/*
@@ -2061,7 +2132,7 @@ static inline int fuse2fs_dirsync_flush(struct fuse2fs *ff, ext2_ino_t ino,
 		*flushed = 0;
 	return 0;
 flush:
-	err = ext2fs_flush2(fs, 0);
+	err = fuse2fs_flush(ff, 0);
 	if (err)
 		return translate_error(fs, 0, err);
 
@@ -3766,7 +3837,7 @@ static int op_release(const char *path EXT2FS_ATTR((unused)),
 	if ((fp->flags & O_SYNC) &&
 	    fuse2fs_is_writeable(ff) &&
 	    (fh->open_flags & EXT2_FILE_WRITE)) {
-		err = ext2fs_flush2(fs, EXT2_FLAG_FLUSH_NO_SYNC);
+		err = fuse2fs_flush(ff, EXT2_FLAG_FLUSH_NO_SYNC);
 		if (err)
 			ret = translate_error(fs, fh->ino, err);
 	}
@@ -3795,7 +3866,7 @@ static int op_fsync(const char *path EXT2FS_ATTR((unused)),
 	fs = fuse2fs_start(ff);
 	/* For now, flush everything, even if it's slow */
 	if (fuse2fs_is_writeable(ff) && fh->open_flags & EXT2_FILE_WRITE) {
-		err = ext2fs_flush2(fs, 0);
+		err = fuse2fs_flush(ff, 0);
 		if (err)
 			ret = translate_error(fs, fh->ino, err);
 	}
@@ -4900,6 +4971,7 @@ static int ioctl_shutdown(struct fuse2fs *ff, struct fuse2fs_file_handle *fh,
 
 	err_printf(ff, "%s.\n", _("shut down requested"));
 
+	fuse2fs_flush_cancel(ff);
 	fuse2fs_mmp_cancel(ff);
 
 	/*
@@ -4908,7 +4980,7 @@ static int ioctl_shutdown(struct fuse2fs *ff, struct fuse2fs_file_handle *fh,
 	 * any of the flags.  Flush whatever is dirty and shut down.
 	 */
 	if (ff->opstate == F2OP_WRITABLE)
-		ext2fs_flush2(fs, 0);
+		fuse2fs_flush(ff, 0);
 	ff->opstate = F2OP_SHUTDOWN;
 	fs->flags &= ~EXT2_FLAG_RW;
 
@@ -5343,6 +5415,7 @@ enum {
 	FUSE2FS_CACHE_SIZE,
 	FUSE2FS_DIRSYNC,
 	FUSE2FS_ERRORS_BEHAVIOR,
+	FUSE2FS_FLUSH_INTERVAL,
 };
 
 #define FUSE2FS_OPT(t, p, v) { t, offsetof(struct fuse2fs, p), v }
@@ -5367,6 +5440,7 @@ static struct fuse_opt fuse2fs_opts[] = {
 #ifdef HAVE_CLOCK_MONOTONIC
 	FUSE2FS_OPT("timing",		timing,			1),
 #endif
+	FUSE_OPT_KEY("flush_interval=%s", FUSE2FS_FLUSH_INTERVAL),
 
 	FUSE_OPT_KEY("user_xattr",	FUSE2FS_IGNORED),
 	FUSE_OPT_KEY("noblock_validity", FUSE2FS_IGNORED),
@@ -5425,6 +5499,21 @@ static int fuse2fs_opt_proc(void *data, const char *arg,
 
 		/* do not pass through to libfuse */
 		return 0;
+	case FUSE2FS_FLUSH_INTERVAL:
+		char *p;
+		unsigned long val;
+
+		errno = 0;
+		val = strtoul(arg + 15, &p, 0);
+		if (p != arg + strlen(arg) || errno || val > UINT_MAX) {
+			fprintf(stderr, "%s: %s.\n", arg,
+				_("Unrecognized flush interval"));
+			return -1;
+		}
+
+		/* do not pass through to libfuse */
+		ff->flush_interval = val;
+		return 0;
 	case FUSE2FS_IGNORED:
 		return 0;
 	case FUSE2FS_HELP:
@@ -5452,6 +5541,7 @@ static int fuse2fs_opt_proc(void *data, const char *arg,
 	"    -o cache_size=N[KMG]   use a disk cache of this size\n"
 	"    -o errors=             behavior when an error is encountered:\n"
 	"                           continue|remount-ro|panic\n"
+	"    -o flush=<time>        flush dirty metadata on this interval\n"
 	"\n",
 			outargs->argv[0]);
 		if (key == FUSE2FS_HELPFULL) {
@@ -5602,6 +5692,7 @@ int main(int argc, char *argv[])
 		.bfl = (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER,
 		.oom_score_adj = -500,
 		.opstate = F2OP_WRITABLE,
+		.flush_interval = 30,
 	};
 	errcode_t err;
 	FILE *orig_stderr = stderr;
@@ -5741,6 +5832,7 @@ int main(int argc, char *argv[])
  _("Mount failed while opening filesystem.  Check dmesg(1) for details."));
 		fflush(orig_stderr);
 	}
+	fuse2fs_flush_destroy(&fctx);
 	fuse2fs_psi_destroy(&fctx);
 	fuse2fs_mmp_destroy(&fctx);
 	fuse2fs_unmount(&fctx);
@@ -5920,6 +6012,7 @@ static int __translate_error(ext2_filsys fs, ext2_ino_t ino, errcode_t err,
  _("Remounting read-only due to errors."));
 			ff->opstate = F2OP_READONLY;
 		}
+		fuse2fs_flush_cancel(ff);
 		fuse2fs_mmp_cancel(ff);
 		fs->flags &= ~EXT2_FLAG_RW;
 		break;

