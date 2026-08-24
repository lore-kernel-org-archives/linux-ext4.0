Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F65A43FD11
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2026 16:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787588148; cv=none; b=nhRL4CJnsjltvaKfhhf2mFsqKzP+KKUqfa2LbL2BfJbrH410U9HGREAZyaSmksus3+xQoevndgAAXzI+WoeigUtttDG7dvv0Ar+4EzlmA7Gem+5cFlWNVx290Gm79BDc+1j42jgTRwStEvogOW1lVrfBxU6t3L0T5jiePzw70g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787588148; c=relaxed/simple;
	bh=ihXIoqA1Tt2gAt+bt0vDEOlPUVpaawNYC03zpemIii8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kwZc4loNdWut99UHLLHHYqHk/8PNZHw0dddqeacWDoW6qZlnpwUy8qAmcw9g5qx/Cwa41avO92i6QAeEP/g4TgQ0plRBUpvsOTQoBCR6twLmq83iF2DFus897O0BjNgmYlt+9VOaN9txxsh4sR7ZsUbCNmEiE6gD8QkOO8jLDs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=fp5rkbaE; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="fp5rkbaE"
Received: by linux.microsoft.com (Postfix, from userid 1217)
	id AFAE120B7166; Mon, 24 Aug 2026 09:15:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AFAE120B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787588115;
	bh=/UTVgHD5jB8AS0c0Lr1+llSsbtYQwfWrQbOD2Tc9JiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fp5rkbaEv4K6Ickt/RBBe3ArH3RUDLOfqTM+tQwEwWCEc9c+NxkgMbISUIYuon3Jt
	 mzbSEPbUmg14N+NywYX3xHlzC++72Eetg4/YfRfhbsupQk1cEJGwtcT+4rZGfU9epc
	 RcHl+lX2/zHs7aD5xKB8v7vD/BUVbCp+O7V3hCjM=
From: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger@dilger.ca,
	srivatsa@csail.mit.edu,
	Nandakumar Raghavan <naraghavan@linux.microsoft.com>
Subject: [PATCH v2] e2fsck: take flock(LOCK_EX) on whole-disk device during filesystem check
Date: Mon, 24 Aug 2026 09:15:11 -0700
Message-ID: <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <aoxF8FvVffocUSyI@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <aoxF8FvVffocUSyI@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
which point the filesystem is fully consistent.

The whole-disk device is resolved via sysfs (/sys/dev/block/MAJ:MIN/partition)
so that the lock covers the same device node that udevd locks. If sysfs
resolution fails, a warning is emitted and the lock falls back to the
partition device itself.

This mechanism relies on Linux-specific interfaces (sysfs, flock() semantics
on block devices) and is compiled out entirely on non-Linux platforms.

Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
---

Changes in v2:
- Guard the whole feature (function, call site, lock_fd, cleanup) with
  #ifdef __linux__ instead of just the function body, so it's fully
  absent from non-Linux builds 
- Collapse HAVE_SYS_*_H header guards into a single #ifdef __linux__
- Reuse a single dev_path[] buffer instead of three separate stack
  buffers
- Keep translatable warning strings on one line each, even past 80
  columns 
- Drop the blanket "could not lock" warning that fired even when the
  target wasn't a block device at all (e.g. a regular file), which was
  causing issues with tests; lock_whole_disk() now only warns/errors
  at the point of a genuine failure
- No change needed for the Ctrl-C/EINTR concern — traced and confirmed
  the existing signal handling already unwinds cleanly

 e2fsck/unix.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 335ca377..cf21752a 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -36,6 +36,11 @@ extern int optind;
 #ifdef HAVE_SYS_IOCTL_H
 #include <sys/ioctl.h>
 #endif
+#ifdef __linux__
+#include <sys/file.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#endif
 #ifdef HAVE_MALLOC_H
 #include <malloc.h>
 #endif
@@ -1397,6 +1402,90 @@ err:
 	return retval;
 }
 
+#ifdef __linux__
+static int lock_whole_disk(e2fsck_t ctx, const char *dev_name)
+{
+	struct stat st;
+	char dev_path[256]; /* reused for each sysfs/device path we build */
+	char parent_devnum[32];
+	FILE *f;
+	unsigned int maj, min;
+	int parent_resolved = 0;
+	const char *opened_path;
+	int fd;
+
+	if (stat(dev_name, &st) < 0)
+		return -1;
+
+	if (!S_ISBLK(st.st_mode))
+		return -1;
+
+	maj = major(st.st_rdev);
+	min = minor(st.st_rdev);
+
+	/*
+	 * If dev_name is a partition (sysfs 'partition' attribute exists),
+	 * resolve the parent whole-disk device so the flock covers the same
+	 * device node that udevd locks before probing any partition on it.
+	 */
+	snprintf(dev_path, sizeof(dev_path),
+		 "/sys/dev/block/%u:%u/partition", maj, min);
+
+	if (access(dev_path, F_OK) == 0) {
+		snprintf(dev_path, sizeof(dev_path),
+			 "/sys/dev/block/%u:%u/../dev", maj, min);
+
+		f = fopen(dev_path, "r");
+		if (f) {
+			if (fscanf(f, "%31s", parent_devnum) == 1) {
+				unsigned int pmaj, pmin;
+				if (sscanf(parent_devnum, "%u:%u",
+					   &pmaj, &pmin) == 2) {
+					maj = pmaj;
+					min = pmin;
+					parent_resolved = 1;
+				}
+			}
+			fclose(f);
+		}
+		if (!parent_resolved)
+			log_err(ctx, _("Warning: could not resolve whole-disk device for %s; lock may not prevent udev races\n"), dev_name);
+	}
+
+	snprintf(dev_path, sizeof(dev_path), "/dev/block/%u:%u", maj, min);
+
+	opened_path = dev_path;
+	fd = open(dev_path, O_RDONLY | O_CLOEXEC, 0);
+	if (fd < 0) {
+		fd = open(dev_name, O_RDONLY | O_CLOEXEC, 0);
+		if (fd < 0) {
+			com_err(ctx->program_name, errno,
+				_("while trying to open %s for locking"), dev_name);
+			return -1;
+		}
+		opened_path = dev_name;
+		if (parent_resolved)
+			log_err(ctx, _("Warning: %s not found; locking %s instead, lock may not prevent udev races\n"), dev_path, dev_name);
+	}
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
+			_("while trying to lock %s"), opened_path);
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+#endif /* __linux__ */
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
@@ -1413,6 +1502,9 @@ int main (int argc, char *argv[])
 	int journal_size;
 	int sysval, sys_page_size = 4096;
 	int old_bitmaps;
+#ifdef __linux__
+	int lock_fd = -1;
+#endif
 	__u32 features[3];
 	char *cp;
 	enum quota_type qtype;
@@ -1488,6 +1580,10 @@ int main (int argc, char *argv[])
 
 	check_mount(ctx);
 
+#ifdef __linux__
+	lock_fd = lock_whole_disk(ctx, ctx->filesystem_name);
+#endif
+
 	if (!(ctx->options & E2F_OPT_PREEN) &&
 	    !(ctx->options & E2F_OPT_NO) &&
 	    !(ctx->options & E2F_OPT_YES)) {
@@ -2169,6 +2265,11 @@ skip_write:
 	ext2fs_close_free(&ctx->fs);
 	free(ctx->journal_name);
 
+#ifdef __linux__
+	if (lock_fd >= 0)
+		close(lock_fd);
+#endif
+
 	if (ctx->logf)
 		fprintf(ctx->logf, "Exit status: %d\n", exit_value);
 	e2fsck_free_context(ctx);
-- 
2.54.0

