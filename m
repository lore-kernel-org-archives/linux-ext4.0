Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D808244C4F8
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 07:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792394222; cv=none; b=YSPNzYbWvivAPjWvHakTzUcTueRyc0b2FZTEuBM9vfHNabcNBiFjGBx7ok1WHRYy9/MNsvclLye9g4Bhud87SU1riqd0kdKhk003k9Khq4ZhJ06wMiSfMiltHwYbMefAcoenVTn3uHbI1nBOWsFRwDaCScvFn7Qv/8bZ1sc9byg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792394222; c=relaxed/simple;
	bh=KgL4rN8jC8/elyCQudJBOVZtLQxFsJ3o5ubtXhBEX5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bj9h9jkabn6buDkYI9knnVovpIodjnoY2S6b53YT3jHTNSKlxVI9chFvCL22DAKWWyetS2xss1g4nFvwISrXyf1IzMeF5yxfNmuobRW/iuDWBnTVcrjNR0l1TdSg/eYueiaGpPRfC1oVpbUfgCgfMXgxR7yc9ufEXKBQGaIMqV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=WhR/r3ft; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="WhR/r3ft"
Received: by linux.microsoft.com (Postfix, from userid 1217)
	id 46D1F20B7169; Mon, 19 Oct 2026 00:16:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 46D1F20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792394213;
	bh=pUTU7K10xLslvAU/RYP+Ua9RryBiTdh8/8poow8+qqo=;
	h=From:To:Cc:Subject:Date:From;
	b=WhR/r3ftbOnimPNCTTnPXmVIsKBwTL/MoaA4MbbCYfZ918tQZJ0salkyE+Ibcp2sx
	 IABEDsC3QJ/BMhv8/yQGgQdq0k3w5gLKfdXFGM8mG+XpHWUtYJtVorSskK6w9yKkO5
	 zYoHHI19NaX1o1RBiyOhLWRORqKxw510JufvikMA=
From: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger@dilger.ca,
	djwong@kernel.org,
	srivatsa@csail.mit.edu,
	Nandakumar Raghavan <naraghavan@linux.microsoft.com>
Subject: [PATCH v4] e2fsck: take flock(LOCK_EX) on whole-disk device during filesystem check
Date: Mon, 19 Oct 2026 00:16:46 -0700
Message-ID: <20261019071646.1394267-1-naraghavan@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During journal replay, e2fsck writes the primary superblock back to disk
in multiple I/O operations. The payload lands before the checksum, leaving
a transient window where the on-disk superblock has a bad checksum.

If udevd processes a change uevent during this window, libblkid probes the
primary superblock, finds a checksum mismatch, and concludes the partition
has no recognisable filesystem. udev then fires a remove event, wiping all
symlinks in /dev/disk/by-label/ and /dev/disk/by-uuid/. Any mount unit
that depends on those symlinks will fail.

udevd already serialises its own partition probes against whole-disk device
access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it requeues the
event. Take advantage of this protocol by acquiring flock(LOCK_EX) on the
whole-disk device before opening the filesystem. This forces udevd to defer
all probes on that disk until e2fsck exits and the lock is released, by
which point the filesystem is fully consistent. A shared lock would not
work, since it does not conflict with the LOCK_SH that udevd takes.

The whole-disk device is resolved using libsystemd's sd-device API
(sd_device_new_from_devnum(), sd_device_get_parent_with_subsystem_devtype())
rather than parsing sysfs, so the lock covers the same device node
that udevd itself resolves and locks.

This locking is entirely optional at build time where configure checks for
sd_device_get_parent_with_subsystem_devtype() via AC_CHECK_LIB, and
e2fsck.c only compiles in the locking code when it is found. On platforms
without libsystemd there is no udevd to race against in the first place,
so nothing is lost by skipping it there.

The lock is enabled by default, but can be disabled by setting the
lock_whole_disk boolean to false in the [options] stanza of e2fsck.conf.
This is documented in e2fsck.conf(5).

Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
---

Notes:
    Changes in v4:
    - Add an "lock_whole_disk" boolean to the [options] stanza of e2fsck.conf,
      defaulting to true, so the whole-disk lock can be disabled without
      rebuilding e2fsck (e.g. if another tool legitimately holds the disk).
      It is read in lock_whole_disk() after the S_ISBLK check, so regular-file
      images never consult it. It is ignored when built without libsystemd.
      Documented in e2fsck.conf(5).
    - The flock(LOCK_SH) cannot be used as udevd takes flock(LOCK_SH|LOCK_NB)
      on the whole-disk device before probing, and shared locks do not conflict
      with each other, so a LOCK_SH held by e2fsck would not make udevd's flock()
      fail with EAGAIN and udevd would still probe the half-written superblock.
      Only LOCK_EX causes udevd to requeue the event.
    - Added a new lock_whole_disk option in e2fsck.conf
    - No changes to the configure/libsystemd detection or to the lock_whole_disk()
      logic itself.
   
      v3: https://lore.kernel.org/linux-ext4/20260824161512.1332649-1-naraghavan@linux.microsoft.com/

    Changes in v3:
    - Resolve the parent whole-disk device using libsystemd's sd-device API
      (sd_device_new_from_devnum(), sd_device_get_parent_with_subsystem_devtype(),
      sd_device_get_devname()) instead of hand-parsing sysfs paths
    - Gate the feature on autoconf detecting
      sd_device_get_parent_with_subsystem_devtype() via AC_CHECK_LIB; compile it
      out entirely when libsystemd is absent, rather than falling back to another
      implementation
    - Use sd_device_new_from_devnum() (available since libsystemd 240) rather than
      sd_device_new_from_devname() used by the systemd.io example (requires 251+),
      to keep the version floor as low as possible
    - Keep lock_whole_disk()'s signature unconditional and provide a stub returning
      -1 on the #else branch, so main()'s primary code path has no #ifdefs in it

      v2: https://lore.kernel.org/linux-ext4/20260824161512.1332649-1-naraghavan@linux.microsoft.com/
    
    Changes in v2:
    - Guard the whole feature (function, call site, lock_fd, cleanup) rather than
      just the function body, so it is fully absent from non-Linux builds
    - Collapse the three HAVE_SYS_*_H header guards into a single conditional
    - Reuse a single dev_path[] buffer instead of three single-use stack buffers
    - Keep translatable warning strings on one line each, even past 80 columns
    - Drop the blanket "could not lock" warning that fired even when the target was
      not a block device at all (e.g. a regular file), which broke most of
      "make check"; lock_whole_disk() now only warns at the point of a genuine failure
    - No change needed for the Ctrl-C/EINTR concern: the SIGINT handler is installed
      before lock_whole_disk() runs and is not SA_RESTART, so a blocked flock() is
      interrupted and the existing E2F_FLAG_CANCEL check unwinds cleanly

      v1: https://lore.kernel.org/linux-ext4/20260824161512.1332649-1-naraghavan@linux.microsoft.com/

 MCONFIG.in              |  1 +
 configure               | 71 +++++++++++++++++++++++++++++
 configure.ac            | 14 ++++++
 e2fsck/Makefile.in      |  6 +--
 e2fsck/e2fsck.conf.5.in | 14 ++++++
 e2fsck/unix.c           | 98 +++++++++++++++++++++++++++++++++++++++++
 lib/config.h.in         |  6 +++
 7 files changed, 207 insertions(+), 3 deletions(-)

diff --git a/MCONFIG.in b/MCONFIG.in
index d66e2f3b..d3055955 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -137,6 +137,7 @@ LIBE2P = $(LIB)/libe2p@LIB_EXT@
 LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
 LIBUUID = @LIBUUID@ @SOCKET_LIB@
 LIBMAGIC = @MAGIC_LIB@
+LIBSYSTEMD = @SYSTEMD_LIB@
 LIBFUSE = @FUSE_LIB@
 LIBSUPPORT = $(LIBINTL) $(LIB)/libsupport@STATIC_LIB_EXT@
 LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
diff --git a/configure b/configure
index b04b31af..696dd07c 100755
--- a/configure
+++ b/configure
@@ -702,6 +702,7 @@ fuse3_CFLAGS
 CLOCK_GETTIME_LIB
 ARCHIVE_LIBS
 ARCHIVE_CFLAGS
+SYSTEMD_LIB
 MAGIC_LIB
 SOCKET_LIB
 SIZEOF_TIME_T
@@ -14130,6 +14131,76 @@ if test "$ac_cv_func_dlopen" = yes ; then
    MAGIC_LIB=$DLOPEN_LIB
 fi
 
+SYSTEMD_LIB=
+{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for sd_device_get_parent_with_subsystem_devtype in -lsystemd" >&5
+printf %s "checking for sd_device_get_parent_with_subsystem_devtype in -lsystemd... " >&6; }
+if test ${ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype+y}
+then :
+  printf %s "(cached) " >&6
+else case e in #(
+  e) ac_check_lib_save_LIBS=$LIBS
+LIBS="-lsystemd  $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.
+   The 'extern "C"' is for builds by C++ compilers;
+   although this is not generally supported in C code supporting it here
+   has little cost and some practical benefit (sr 110532).  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char sd_device_get_parent_with_subsystem_devtype (void);
+int
+main (void)
+{
+return sd_device_get_parent_with_subsystem_devtype ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"
+then :
+  ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype=yes
+else case e in #(
+  e) ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype=no ;;
+esac
+fi
+rm -f core conftest.err conftest.$ac_objext conftest.beam \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS ;;
+esac
+fi
+{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype" >&5
+printf "%s\n" "$ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype" >&6; }
+if test "x$ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype" = xyes
+then :
+  SYSTEMD_LIB=-lsystemd
+fi
+
+if test -n "$SYSTEMD_LIB"; then
+	       for ac_header in systemd/sd-device.h
+do :
+  ac_fn_c_check_header_compile "$LINENO" "systemd/sd-device.h" "ac_cv_header_systemd_sd_device_h" "$ac_includes_default"
+if test "x$ac_cv_header_systemd_sd_device_h" = xyes
+then :
+  printf "%s\n" "#define HAVE_SYSTEMD_SD_DEVICE_H 1" >>confdefs.h
+
+else case e in #(
+  e) SYSTEMD_LIB= ;;
+esac
+fi
+
+done
+fi
+if test -n "$SYSTEMD_LIB"; then
+
+printf "%s\n" "#define HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE 1" >>confdefs.h
+
+fi
+
 
 # Check whether --with-libarchive was given.
 if test ${with_libarchive+y}
diff --git a/configure.ac b/configure.ac
index 4921f81f..9f585aae 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1309,6 +1309,20 @@ if test "$ac_cv_func_dlopen" = yes ; then
 fi
 AC_SUBST(MAGIC_LIB)
 dnl
+dnl See if libsystemd has sd-device APIs for whole-disk BSD locking
+dnl
+SYSTEMD_LIB=
+AC_CHECK_LIB(systemd, sd_device_get_parent_with_subsystem_devtype,
+	[SYSTEMD_LIB=-lsystemd])
+if test -n "$SYSTEMD_LIB"; then
+	AC_CHECK_HEADERS([systemd/sd-device.h], , [SYSTEMD_LIB=])
+fi
+if test -n "$SYSTEMD_LIB"; then
+	AC_DEFINE(HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE, 1,
+		[Define to 1 if libsystemd has sd-device APIs for whole-disk locking])
+fi
+AC_SUBST(SYSTEMD_LIB)
+dnl
 dnl libarchive
 dnl
 AC_ARG_WITH([libarchive],
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index fbb7b156..a050eafe 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -17,20 +17,20 @@ MANPAGES=	e2fsck.8
 FMANPAGES=	e2fsck.conf.5
 
 LIBS= $(LIBSUPPORT) $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBBLKID) $(LIBUUID) \
-	$(LIBINTL) $(LIBE2P) $(LIBMAGIC) $(SYSLIBS)
+	$(LIBINTL) $(LIBE2P) $(LIBMAGIC) $(LIBSYSTEMD) $(SYSLIBS)
 DEPLIBS= $(DEPLIBSUPPORT) $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBBLKID) \
 	 $(DEPLIBUUID) $(DEPLIBE2P)
 
 STATIC_LIBS= $(STATIC_LIBSUPPORT) $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) \
 	     $(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL) $(STATIC_LIBE2P) \
-	     $(LIBMAGIC) $(SYSLIBS)
+	     $(LIBMAGIC) $(LIBSYSTEMD) $(SYSLIBS)
 STATIC_DEPLIBS= $(DEPSTATIC_LIBSUPPORT) $(STATIC_LIBEXT2FS) \
 		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBBLKID) \
 		$(DEPSTATIC_LIBUUID) $(DEPSTATIC_LIBE2P)
 
 PROFILED_LIBS= $(PROFILED_LIBSUPPORT) $(PROFILED_LIBEXT2FS) \
 	       $(PROFILED_LIBCOM_ERR) $(PROFILED_LIBBLKID) $(PROFILED_LIBUUID) \
-	       $(PROFILED_LIBE2P) $(LIBINTL) $(LIBMAGIC) $(SYSLIBS)
+	       $(PROFILED_LIBE2P) $(LIBINTL) $(LIBMAGIC) $(LIBSYSTEMD) $(SYSLIBS)
 PROFILED_DEPLIBS= $(DEPPROFILED_LIBSUPPORT) $(PROFILED_LIBEXT2FS) \
 		  $(DEPPROFILED_LIBCOM_ERR) $(DEPPROFILED_LIBBLKID) \
 		  $(DEPPROFILED_LIBUUID) $(DEPPROFILED_LIBE2P)
diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
index e82610d3..3b9a118c 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -172,6 +172,20 @@ file system.  For large file systems, this can be gigabytes of memory.
 additional 5.7 GB memory if this optimization is enabled.)  This setting
 defaults to false.
 .TP
+.I lock_whole_disk
+If this boolean relation is true, e2fsck will take an exclusive
+.BR flock (2)
+on the whole-disk device containing the file system while it is being
+checked, following the protocol described at
+.IR https://systemd.io/BLOCK_DEVICE_LOCKING .
+This causes
+.BR systemd-udevd (8)
+to defer probing the device until e2fsck exits, so that it does not see
+a transiently inconsistent superblock while the journal is being replayed.
+This only has an effect when e2fsck was built with libsystemd support and
+is checking a block device; otherwise this relation is ignored.
+This setting defaults to true.
+.TP
 .I log_dir
 If the
 .I log_filename
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 335ca377..145ff223 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -36,6 +36,11 @@ extern int optind;
 #ifdef HAVE_SYS_IOCTL_H
 #include <sys/ioctl.h>
 #endif
+#ifdef HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE
+#include <sys/file.h>
+#include <sys/stat.h>
+#include <systemd/sd-device.h>
+#endif
 #ifdef HAVE_MALLOC_H
 #include <malloc.h>
 #endif
@@ -1397,6 +1402,93 @@ err:
 	return retval;
 }
 
+static int lock_whole_disk(e2fsck_t ctx, const char *dev_name)
+{
+#ifdef HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE
+	struct stat st;
+	sd_device *dev = NULL, *whole_dev;
+	const char *subsystem, *devtype, *whole_disk_devname;
+	int r, fd, use_lock = 1;
+
+	if (stat(dev_name, &st) < 0)
+		return -1;
+
+	if (!S_ISBLK(st.st_mode))
+		return -1;
+
+	profile_get_boolean(ctx->profile, "options", "lock_whole_disk",
+			    0, 1, &use_lock);
+	if (!use_lock)
+		return -1;
+
+	r = sd_device_new_from_devnum(&dev, 'b', st.st_rdev);
+	if (r < 0)
+		return -1;
+
+	r = sd_device_get_subsystem(dev, &subsystem);
+	if (r < 0 || strcmp(subsystem, "block") != 0) {
+		sd_device_unref(dev);
+		return -1;
+	}
+
+	r = sd_device_get_devtype(dev, &devtype);
+	if (r < 0) {
+		sd_device_unref(dev);
+		return -1;
+	}
+
+	/*
+	 * If dev_name is a partition, resolve the parent whole-disk device
+	 * so the flock covers the same device node that udevd locks before
+	 * probing any partition on it.
+	 */
+	if (strcmp(devtype, "disk") == 0)
+		whole_dev = dev;
+	else {
+		r = sd_device_get_parent_with_subsystem_devtype(dev, "block",
+								 "disk", &whole_dev);
+		if (r < 0) {
+			log_err(ctx, _("Warning: could not resolve whole-disk device for %s; lock may not prevent udev races\n"), dev_name);
+			sd_device_unref(dev);
+			return -1;
+		}
+	}
+
+	r = sd_device_get_devname(whole_dev, &whole_disk_devname);
+	if (r < 0) {
+		sd_device_unref(dev);
+		return -1;
+	}
+
+	fd = open(whole_disk_devname, O_RDONLY | O_CLOEXEC, 0);
+	if (fd < 0) {
+		com_err(ctx->program_name, errno,
+			_("while trying to open %s for locking"), whole_disk_devname);
+		sd_device_unref(dev);
+		return -1;
+	}
+	sd_device_unref(dev);
+
+	while (flock(fd, LOCK_EX) != 0) {
+		if (errno == EINTR) {
+			if (ctx->flags & E2F_FLAG_CANCEL) {
+				close(fd);
+				return -1;
+			}
+			continue;
+		}
+		com_err(ctx->program_name, errno,
+			_("while trying to lock %s"), whole_disk_devname);
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+#else
+	return -1;
+#endif /* HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE */
+}
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
@@ -1413,6 +1505,7 @@ int main (int argc, char *argv[])
 	int journal_size;
 	int sysval, sys_page_size = 4096;
 	int old_bitmaps;
+	int lock_fd = -1;
 	__u32 features[3];
 	char *cp;
 	enum quota_type qtype;
@@ -1488,6 +1581,8 @@ int main (int argc, char *argv[])
 
 	check_mount(ctx);
 
+	lock_fd = lock_whole_disk(ctx, ctx->filesystem_name);
+
 	if (!(ctx->options & E2F_OPT_PREEN) &&
 	    !(ctx->options & E2F_OPT_NO) &&
 	    !(ctx->options & E2F_OPT_YES)) {
@@ -2169,6 +2264,9 @@ skip_write:
 	ext2fs_close_free(&ctx->fs);
 	free(ctx->journal_name);
 
+	if (lock_fd >= 0)
+		close(lock_fd);
+
 	if (ctx->logf)
 		fprintf(ctx->logf, "Exit status: %d\n", exit_value);
 	e2fsck_free_context(ctx);
diff --git a/lib/config.h.in b/lib/config.h.in
index f129abfe..bc3ae4aa 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -352,6 +352,9 @@
 /* Define to 1 if if struct sockaddr contains sa_len */
 #undef HAVE_SA_LEN
 
+/* Define to 1 if libsystemd has sd-device APIs for whole-disk locking */
+#undef HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE
+
 /* Define to 1 if you have the 'secure_getenv' function. */
 #undef HAVE_SECURE_GETENV
 
@@ -430,6 +433,9 @@
 /* Define to 1 if you have the 'sysconf' function. */
 #undef HAVE_SYSCONF
 
+/* Define to 1 if you have the <systemd/sd-device.h> header file. */
+#undef HAVE_SYSTEMD_SD_DEVICE_H
+
 /* Define to 1 if you have the <sys/acl.h> header file. */
 #undef HAVE_SYS_ACL_H
 
-- 
2.55.0

