Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9026F26F288;
	Wed, 29 Apr 2026 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474530; cv=none; b=U1G0KuwvnT7wSa+Gk8DlbyRgnEPx9YRPwazBAHUJ+ILlUfCI8qALnvYbByDuC3+P3b1iK0uzHK6uvGSiEZ7DYKB0xkN/t5YjAtWKmmNG0Q+uLCZQgdzFuKb1XF7jL9RwBaBfyhwp0XdDasZQDiOKLr1IpFjCvwDW+VJ88qR8mKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474530; c=relaxed/simple;
	bh=kGPJpQ8Ekl8cAe77Vbn2RNWO3109l029dBRceAVZtWg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ryzZq2XuXJTBnQYyy9ePctUSkDAQQTauFXkyZLhk+6vGJmgeuEyO2XFS3FUaym6U9khONdnThzpZhMziNqgKKtJHDTBAN1rcc4hLs8s276P7OeU4YMjQi6kvT7gT/ESXcA/06YHLL5XY+X79udVuGM5psU1Zwr1SimnFy/he+20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4YI/BYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4YI/BYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BE6C19425;
	Wed, 29 Apr 2026 14:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474530;
	bh=kGPJpQ8Ekl8cAe77Vbn2RNWO3109l029dBRceAVZtWg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P4YI/BYMA/9/4ve9W+oH6Zppi6pQx7q6o6vDt7guVfnmRcfmLXZu+ocxK9qt/wRde
	 /DcV7DpzzhoknR0nqCtqKEjqgTCCGw+BBKAf8Dv1GLgUHnydUeqWqRQZQO+yLyKTTY
	 3Rc6EeedAt1wEgjo79poqd/bYvLKhDe6DwsdWt4UyORoHtR55K/vTulnhKntZPDGqG
	 snRxGJ6KflhvhA/+9gKymiSVThrhmxv09oejzxSb8Pduc/INNut2UG2H5AWfoxG3v9
	 +fqlEc/uK4CzY1qakKvmNxbeeDFPhu0s2wBHpoEv6dkL+lv3GAgAjtGl3gMeJl+Dsd
	 NYq8mJCyhtn6g==
Date: Wed, 29 Apr 2026 07:55:30 -0700
Subject: [PATCH 11/19] fuse2fs: try to create loop device when ext4 device is
 a regular file
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214733.4107473.11688396903521099167.stgit@frogsfrogsfrogs>
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

If the filesystem device is a regular file, try to create a loop device
for it so that we can take advantage of iomap.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure         |   41 +++++++++++++++++++
 configure.ac      |   23 +++++++++++
 fuse4fs/fuse4fs.c |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/config.h.in   |    3 +
 misc/fuse2fs.c    |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 292 insertions(+), 4 deletions(-)


diff --git a/configure b/configure
index 344c7af2ee48f8..ba1556b34257a6 100755
--- a/configure
+++ b/configure
@@ -14691,6 +14691,47 @@ printf "%s\n" "#define HAVE_FUSE_IOMAP 1" >>confdefs.h
 
 fi
 
+if test -n "$have_fuse_iomap"; then
+	{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for fuse_loopdev.h in libfuse" >&5
+printf %s "checking for fuse_loopdev.h in libfuse... " >&6; }
+	cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+	#define _GNU_SOURCE
+	#define _FILE_OFFSET_BITS	64
+	#define FUSE_USE_VERSION	399
+	#include <fuse_loopdev.h>
+
+int
+main (void)
+{
+
+
+  ;
+  return 0;
+}
+
+_ACEOF
+if ac_fn_c_try_link "$LINENO"
+then :
+  have_fuse_loopdev=yes
+	   { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: yes" >&5
+printf "%s\n" "yes" >&6; }
+else case e in #(
+  e) { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: no" >&5
+printf "%s\n" "no" >&6; } ;;
+esac
+fi
+rm -f core conftest.err conftest.$ac_objext conftest.beam \
+    conftest$ac_exeext conftest.$ac_ext
+fi
+if test -n "$have_fuse_loopdev"
+then
+
+printf "%s\n" "#define HAVE_FUSE_LOOPDEV 1" >>confdefs.h
+
+fi
+
 have_fuse_lowlevel=
 if test -n "$FUSE_USE_VERSION"
 then
diff --git a/configure.ac b/configure.ac
index 8d85e9966877ea..8cfde4d85489e5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1432,6 +1432,29 @@ then
 	AC_DEFINE(HAVE_FUSE_IOMAP, 1, [Define to 1 if fuse supports iomap])
 fi
 
+dnl
+dnl Check if fuse library has fuse_loopdev.h, which it only gained after adding
+dnl iomap support.
+dnl
+if test -n "$have_fuse_iomap"; then
+	AC_MSG_CHECKING(for fuse_loopdev.h in libfuse)
+	AC_LINK_IFELSE(
+	[	AC_LANG_PROGRAM([[
+	#define _GNU_SOURCE
+	#define _FILE_OFFSET_BITS	64
+	#define FUSE_USE_VERSION	399
+	#include <fuse_loopdev.h>
+		]], [[
+		]])
+	], have_fuse_loopdev=yes
+	   AC_MSG_RESULT(yes),
+	   AC_MSG_RESULT(no))
+fi
+if test -n "$have_fuse_loopdev"
+then
+	AC_DEFINE(HAVE_FUSE_LOOPDEV, 1, [Define to 1 if fuse supports loopdev operations])
+fi
+
 dnl
 dnl Check if the FUSE lowlevel library is supported
 dnl
diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 68f1f7c02df223..3c3debb6f60ac7 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -27,6 +27,9 @@
 #include <unistd.h>
 #include <ctype.h>
 #include <assert.h>
+#ifdef HAVE_FUSE_LOOPDEV
+# include <fuse_loopdev.h>
+#endif
 #define FUSE_DARWIN_ENABLE_EXTENSIONS 0
 #ifdef __SET_FOB_FOR_FUSE
 # error Do not set magic value __SET_FOB_FOR_FUSE!!!!
@@ -262,6 +265,10 @@ struct fuse4fs {
 	pthread_mutex_t bfl;
 	char *device;
 	char *shortdev;
+#ifdef HAVE_FUSE_LOOPDEV
+	char *loop_device;
+	int loop_fd;
+#endif
 
 	/* options set by fuse_opt_parse must be of type int */
 	int ro;
@@ -285,6 +292,7 @@ struct fuse4fs {
 	enum fuse4fs_feature_toggle iomap_want;
 	enum fuse4fs_iomap_state iomap_state;
 	uint32_t iomap_dev;
+	uint64_t iomap_cap;
 #endif
 	unsigned int blockmask;
 	unsigned long offset;
@@ -913,8 +921,23 @@ static inline int fuse4fs_iomap_enabled(const struct fuse4fs *ff)
 {
 	return ff->iomap_state >= IOMAP_ENABLED;
 }
+
+static inline void fuse4fs_discover_iomap(struct fuse4fs *ff)
+{
+	if (ff->iomap_want == FT_DISABLE)
+		return;
+
+	ff->iomap_cap = fuse_lowlevel_discover_iomap(-1);
+}
+
+static inline bool fuse4fs_can_iomap(const struct fuse4fs *ff)
+{
+	return ff->iomap_cap & FUSE_IOMAP_SUPPORT_FILEIO;
+}
 #else
 # define fuse4fs_iomap_enabled(...)	(0)
+# define fuse4fs_discover_iomap(...)	((void)0)
+# define fuse4fs_can_iomap(...)		(false)
 #endif
 
 static inline void fuse4fs_dump_extents(struct fuse4fs *ff, ext2_ino_t ino,
@@ -1584,6 +1607,76 @@ static void fuse4fs_release_lockfile(struct fuse4fs *ff)
 	free(ff->lockfile);
 }
 
+#ifdef HAVE_FUSE_LOOPDEV
+static int fuse4fs_try_losetup(struct fuse4fs *ff, int flags)
+{
+	bool rw = flags & EXT2_FLAG_RW;
+	int dev_fd;
+	int ret;
+
+	/*
+	 * Only transform a regular file into a loopdev for iomap, and only if
+	 * the service helper isn't required to that for us.
+	 */
+	if (!fuse4fs_can_iomap(ff) || fuse4fs_is_service(ff))
+		return 0;
+
+	/* open the actual target device, see if it's a regular file */
+	dev_fd = open(ff->device, rw ? O_RDWR : O_RDONLY);
+	if (dev_fd < 0) {
+		err_printf(ff, "%s: %s\n", _("while opening fs"),
+			   error_message(errno));
+		return -1;
+	}
+
+	ret = fuse_loopdev_setup(dev_fd, rw ? O_RDWR : O_RDONLY, ff->device, 5,
+				 &ff->loop_fd, &ff->loop_device);
+	if (ret == -EBUSY) {
+		/*
+		 * If the setup function returned EBUSY, there is already a
+		 * loop device backed by this file.  Report that the file is
+		 * already in use.  Ignore the other errors because we can
+		 * otherwise handle filesystem in a file.
+		 */
+		err_printf(ff, "%s: %s\n", _("while opening fs loopdev"),
+				   error_message(errno));
+		close(dev_fd);
+		return -1;
+	}
+
+	close(dev_fd);
+	return 0;
+}
+
+static void fuse4fs_detach_losetup(struct fuse4fs *ff)
+{
+	if (ff->loop_fd >= 0)
+		close(ff->loop_fd);
+	ff->loop_fd = -1;
+}
+
+static void fuse4fs_undo_losetup(struct fuse4fs *ff)
+{
+	fuse4fs_detach_losetup(ff);
+	free(ff->loop_device);
+	ff->loop_device = NULL;
+}
+
+static inline const char *fuse4fs_device(const struct fuse4fs *ff)
+{
+	/*
+	 * If we created a loop device for the file passed in, open that.
+	 * Otherwise open the path the user gave us.
+	 */
+	return ff->loop_device ? ff->loop_device : ff->device;
+}
+#else
+# define fuse4fs_try_losetup(...)	(0)
+# define fuse4fs_detach_losetup(...)	((void)0)
+# define fuse4fs_undo_losetup(...)	((void)0)
+# define fuse4fs_device(ff)		((ff)->device)
+#endif
+
 static void fuse4fs_unmount(struct fuse4fs *ff)
 {
 	char uuid[UUID_STR_SIZE];
@@ -1607,6 +1700,7 @@ static void fuse4fs_unmount(struct fuse4fs *ff)
 	}
 
 	fuse4fs_service_close_bdev(ff);
+	fuse4fs_undo_losetup(ff);
 
 	if (ff->lockfile)
 		fuse4fs_release_lockfile(ff);
@@ -1620,6 +1714,8 @@ static errcode_t fuse4fs_open(struct fuse4fs *ff)
 		    EXT2_FLAG_EXCLUSIVE | EXT2_FLAG_WRITE_FULL_SUPER;
 	errcode_t err;
 
+	fuse4fs_discover_iomap(ff);
+
 	if (ff->lockfile) {
 		err = fuse4fs_acquire_lockfile(ff);
 		if (err)
@@ -1632,6 +1728,12 @@ static errcode_t fuse4fs_open(struct fuse4fs *ff)
 	if (ff->directio)
 		flags |= EXT2_FLAG_DIRECT_IO;
 
+	dbg_printf(ff, "opening with flags=0x%x\n", flags);
+
+	err = fuse4fs_try_losetup(ff, flags);
+	if (err)
+		return err;
+
 	/*
 	 * If the filesystem is stored on a block device, the _EXCLUSIVE flag
 	 * causes libext2fs to try to open the block device with O_EXCL.  If
@@ -1666,8 +1768,8 @@ static errcode_t fuse4fs_open(struct fuse4fs *ff)
 		if (fuse4fs_is_service(ff))
 			err = fuse4fs_service_openfs(ff, options, &flags);
 		else
-			err = ext2fs_open2(ff->device, options, flags, 0, 0,
-					   unix_io_manager, &ff->fs);
+			err = ext2fs_open2(fuse4fs_device(ff), options, flags,
+					   0, 0, unix_io_manager, &ff->fs);
 		if ((err == EPERM || err == EACCES) &&
 		    (!ff->ro || (flags & EXT2_FLAG_RW))) {
 			/*
@@ -1681,6 +1783,11 @@ static errcode_t fuse4fs_open(struct fuse4fs *ff)
 			flags &= ~EXT2_FLAG_RW;
 			ff->ro = 1;
 
+			fuse4fs_undo_losetup(ff);
+			err = fuse4fs_try_losetup(ff, flags);
+			if (err)
+				return err;
+
 			/* Force the loop to run once more */
 			err = -1;
 		}
@@ -2129,6 +2236,8 @@ static void op_init(void *userdata, struct fuse_conn_info *conn)
 	fuse4fs_iomap_enable(conn, ff);
 	conn->time_gran = 1;
 
+	fuse4fs_detach_losetup(ff);
+
 	if (ff->opstate == F4OP_WRITABLE)
 		fuse4fs_read_bitmaps(ff);
 
@@ -7737,6 +7846,9 @@ int main(int argc, char *argv[])
 		.iomap_want = FT_DEFAULT,
 		.iomap_state = IOMAP_UNKNOWN,
 		.iomap_dev = FUSE_IOMAP_DEV_NULL,
+#endif
+#ifdef HAVE_FUSE_LOOPDEV
+		.loop_fd = -1,
 #endif
 	};
 	errcode_t err;
diff --git a/lib/config.h.in b/lib/config.h.in
index 58338cc926590e..96ed5479181a5b 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -151,6 +151,9 @@
 /* Define to 1 if fuse supports iomap */
 #undef HAVE_FUSE_IOMAP
 
+/* Define to 1 if fuse supports loopdev operations */
+#undef HAVE_FUSE_LOOPDEV
+
 /* Define to 1 if fuse supports lowlevel API */
 #undef HAVE_FUSE_LOWLEVEL
 
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index f7653dc6c20c3f..3c76eba683a10d 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -25,6 +25,9 @@
 #include <sys/ioctl.h>
 #include <unistd.h>
 #include <ctype.h>
+#ifdef HAVE_FUSE_LOOPDEV
+# include <fuse_loopdev.h>
+#endif
 #define FUSE_DARWIN_ENABLE_EXTENSIONS 0
 #ifdef __SET_FOB_FOR_FUSE
 # error Do not set magic value __SET_FOB_FOR_FUSE!!!!
@@ -245,6 +248,10 @@ struct fuse2fs {
 	pthread_mutex_t bfl;
 	char *device;
 	char *shortdev;
+#ifdef HAVE_FUSE_LOOPDEV
+	char *loop_device;
+	int loop_fd;
+#endif
 
 	/* options set by fuse_opt_parse must be of type int */
 	int ro;
@@ -268,6 +275,7 @@ struct fuse2fs {
 	enum fuse2fs_feature_toggle iomap_want;
 	enum fuse2fs_iomap_state iomap_state;
 	uint32_t iomap_dev;
+	uint64_t iomap_cap;
 #endif
 	unsigned int blockmask;
 	unsigned long offset;
@@ -725,9 +733,23 @@ static inline int fuse2fs_iomap_enabled(const struct fuse2fs *ff)
 {
 	return ff->iomap_state >= IOMAP_ENABLED;
 }
+
+static inline void fuse2fs_discover_iomap(struct fuse2fs *ff)
+{
+	if (ff->iomap_want == FT_DISABLE)
+		return;
+
+	ff->iomap_cap = fuse_lowlevel_discover_iomap(-1);
+}
+
+static inline bool fuse2fs_can_iomap(const struct fuse2fs *ff)
+{
+	return ff->iomap_cap & FUSE_IOMAP_SUPPORT_FILEIO;
+}
 #else
 # define fuse2fs_iomap_enabled(...)	(0)
-# define fuse2fs_iomap_enabled(...)	(0)
+# define fuse2fs_discover_iomap(...)	((void)0)
+# define fuse2fs_can_iomap(...)		(false)
 #endif
 
 static inline void fuse2fs_dump_extents(struct fuse2fs *ff, ext2_ino_t ino,
@@ -1201,6 +1223,73 @@ static void fuse2fs_release_lockfile(struct fuse2fs *ff)
 	free(ff->lockfile);
 }
 
+#ifdef HAVE_FUSE_LOOPDEV
+static int fuse2fs_try_losetup(struct fuse2fs *ff, int flags)
+{
+	bool rw = flags & EXT2_FLAG_RW;
+	int dev_fd;
+	int ret;
+
+	/* Only transform a regular file into a loopdev for iomap */
+	if (!fuse2fs_can_iomap(ff))
+		return 0;
+
+	/* open the actual target device, see if it's a regular file */
+	dev_fd = open(ff->device, rw ? O_RDWR : O_RDONLY);
+	if (dev_fd < 0) {
+		err_printf(ff, "%s: %s\n", _("while opening fs"),
+			   error_message(errno));
+		return -1;
+	}
+
+	ret = fuse_loopdev_setup(dev_fd, rw ? O_RDWR : O_RDONLY, ff->device, 5,
+				 &ff->loop_fd, &ff->loop_device);
+	if (ret == -EBUSY) {
+		/*
+		 * If the setup function returned EBUSY, there is already a
+		 * loop device backed by this file.  Report that the file is
+		 * already in use.  Ignore the other errors because we can
+		 * otherwise handle filesystem in a file.
+		 */
+		err_printf(ff, "%s: %s\n", _("while opening fs loopdev"),
+				   error_message(-ret));
+		close(dev_fd);
+		return -1;
+	}
+
+	close(dev_fd);
+	return 0;
+}
+
+static void fuse2fs_detach_losetup(struct fuse2fs *ff)
+{
+	if (ff->loop_fd >= 0)
+		close(ff->loop_fd);
+	ff->loop_fd = -1;
+}
+
+static void fuse2fs_undo_losetup(struct fuse2fs *ff)
+{
+	fuse2fs_detach_losetup(ff);
+	free(ff->loop_device);
+	ff->loop_device = NULL;
+}
+
+static inline const char *fuse2fs_device(const struct fuse2fs *ff)
+{
+	/*
+	 * If we created a loop device for the file passed in, open that.
+	 * Otherwise open the path the user gave us.
+	 */
+	return ff->loop_device ? ff->loop_device : ff->device;
+}
+#else
+# define fuse2fs_try_losetup(...)	(0)
+# define fuse2fs_detach_losetup(...)	((void)0)
+# define fuse2fs_undo_losetup(...)	((void)0)
+# define fuse2fs_device(ff)		((ff)->device)
+#endif
+
 static void fuse2fs_unmount(struct fuse2fs *ff)
 {
 	char uuid[UUID_STR_SIZE];
@@ -1218,6 +1307,8 @@ static void fuse2fs_unmount(struct fuse2fs *ff)
 				   uuid);
 	}
 
+	fuse2fs_undo_losetup(ff);
+
 	if (ff->lockfile)
 		fuse2fs_release_lockfile(ff);
 }
@@ -1230,6 +1321,8 @@ static errcode_t fuse2fs_open(struct fuse2fs *ff)
 		    EXT2_FLAG_EXCLUSIVE | EXT2_FLAG_WRITE_FULL_SUPER;
 	errcode_t err;
 
+	fuse2fs_discover_iomap(ff);
+
 	if (ff->lockfile) {
 		err = fuse2fs_acquire_lockfile(ff);
 		if (err)
@@ -1242,6 +1335,12 @@ static errcode_t fuse2fs_open(struct fuse2fs *ff)
 	if (ff->directio)
 		flags |= EXT2_FLAG_DIRECT_IO;
 
+	dbg_printf(ff, "opening with flags=0x%x\n", flags);
+
+	err = fuse2fs_try_losetup(ff, flags);
+	if (err)
+		return err;
+
 	/*
 	 * If the filesystem is stored on a block device, the _EXCLUSIVE flag
 	 * causes libext2fs to try to open the block device with O_EXCL.  If
@@ -1273,7 +1372,7 @@ static errcode_t fuse2fs_open(struct fuse2fs *ff)
 	 */
 	deadline = init_deadline(FUSE2FS_OPEN_TIMEOUT);
 	do {
-		err = ext2fs_open2(ff->device, options, flags, 0, 0,
+		err = ext2fs_open2(fuse2fs_device(ff), options, flags, 0, 0,
 				   unix_io_manager, &ff->fs);
 		if ((err == EPERM || err == EACCES) &&
 		    (!ff->ro || (flags & EXT2_FLAG_RW))) {
@@ -1288,6 +1387,11 @@ static errcode_t fuse2fs_open(struct fuse2fs *ff)
 			flags &= ~EXT2_FLAG_RW;
 			ff->ro = 1;
 
+			fuse2fs_undo_losetup(ff);
+			err = fuse2fs_try_losetup(ff, flags);
+			if (err)
+				return err;
+
 			/* Force the loop to run once more */
 			err = -1;
 		}
@@ -1744,6 +1848,8 @@ static void *op_init(struct fuse_conn_info *conn,
 		cfg->debug = 1;
 	cfg->nullpath_ok = 1;
 
+	fuse2fs_detach_losetup(ff);
+
 	if (ff->opstate == F2OP_WRITABLE)
 		fuse2fs_read_bitmaps(ff);
 
@@ -6852,6 +6958,9 @@ int main(int argc, char *argv[])
 		.iomap_want = FT_DEFAULT,
 		.iomap_state = IOMAP_UNKNOWN,
 		.iomap_dev = FUSE_IOMAP_DEV_NULL,
+#endif
+#ifdef HAVE_FUSE_LOOPDEV
+		.loop_fd = -1,
 #endif
 	};
 	errcode_t err;

