Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8E4F42CAF7
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 14:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557982; cv=none; b=jX+rQFO1Ee+ipvkgpqbZQqxX4XAamq4EpKC/DYdbFXfT4yTV9vNXdFTxovrBvraEledU8Waq1bPLNWJmIQmmMJs1P2uZjcI8eSbqcaF9/Ql3FSJRHodsXjSiwKZBBNfWWvKuuExqIaYX547AGkNqvnane7tk8BEzWlS3F1YXb0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557982; c=relaxed/simple;
	bh=3LfmNVYo2/oEUwggAHqkrkUEY1lwWLZLypd8gNhtWJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VCeeSqDoQG32xBQGlvc5aj1dpU/sf4BlRz6gut5oQU0fF843ig6GTL1YkK9JFGAwanE12roOpGHuDisqTcjtVs1sbcup/bgbrf9GDdFgc5+7z27/tYLtz9QH3Y8hfzOahhm+4JTPnTnsd4bkDsUtRhaYd0Py5zjuT99jn1K89LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=JbT9ddzE; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="JbT9ddzE"
Received: from naraghavan-vm1.rtzm3qmlv3ievk0jbnqczdvmse.phxx.internal.cloudapp.net (unknown [20.125.145.238])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9188A20B7169;
	Mon, 20 Jul 2026 07:32:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9188A20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1784557968;
	bh=4mGz3iJNIjzhZYGMcGx/4a3n2nXnym3LErgN7TxbXZI=;
	h=From:To:Cc:Subject:Date:From;
	b=JbT9ddzE1D4vdQ/7BYi3FvgMZu+7+HRiXg5I+bGglsFzt97lcnpWGFxOyyel0xFdW
	 cj3HFxk8faxzvuFYvFXrmvg0tKjFPlZfRiJaYisDyyoPuA3qYriJajiGqs7wjnE9d8
	 lsFEI+e+jrDvamMqAoa4hyJI82nZzB79BUUHscDo=
From: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
	srivatsa@csail.mit.edu,
	naraghavan@linux.microsoft.com
Subject: [PATCH] e2fsck: take flock(LOCK_EX) on whole-disk device during filesystem check
Date: Mon, 20 Jul 2026 14:32:46 +0000
Message-ID: <20260720143246.4141501-1-naraghavan@linux.microsoft.com>
X-Mailer: git-send-email 2.54.0
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
which point the filesystem is fully consistent.

The whole-disk device is resolved via sysfs (/sys/dev/block/MAJ:MIN/partition)
so that the lock covers the same device node that udevd locks. If sysfs
resolution fails, a warning is emitted and the lock falls back to the
partition device itself.

Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
---
 e2fsck/unix.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 335ca377..12a9f50a 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -36,6 +36,15 @@ extern int optind;
 #ifdef HAVE_SYS_IOCTL_H
 #include <sys/ioctl.h>
 #endif
+#ifdef HAVE_SYS_FILE_H
+#include <sys/file.h>
+#endif
+#ifdef HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#endif
 #ifdef HAVE_MALLOC_H
 #include <malloc.h>
 #endif
@@ -1397,6 +1406,92 @@ err:
 	return retval;
 }
 
+static int lock_whole_disk(e2fsck_t ctx, const char *dev_name)
+{
+	struct stat st;
+	char partition_attr[256];  /* sysfs 'partition' attribute path */
+	char parent_dev_path[256]; /* sysfs '../dev' of the parent disk */
+	char parent_devnum[32];
+	FILE *f;
+	unsigned int maj, min;
+	int parent_resolved = 0;
+	char lock_path[256];
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
+	snprintf(partition_attr, sizeof(partition_attr),
+		 "/sys/dev/block/%u:%u/partition", maj, min);
+
+	if (access(partition_attr, F_OK) == 0) {
+		snprintf(parent_dev_path, sizeof(parent_dev_path),
+			 "/sys/dev/block/%u:%u/../dev", maj, min);
+
+		f = fopen(parent_dev_path, "r");
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
+			log_err(ctx, _("Warning: could not resolve whole-disk "
+				       "device for %s; lock may not prevent "
+				       "udev races\n"), dev_name);
+	}
+
+	snprintf(lock_path, sizeof(lock_path),
+		 "/dev/block/%u:%u", maj, min);
+
+	opened_path = lock_path;
+	fd = open(lock_path, O_RDONLY | O_CLOEXEC, 0);
+	if (fd < 0) {
+		fd = open(dev_name, O_RDONLY | O_CLOEXEC, 0);
+		if (fd < 0)
+			return -1;
+		opened_path = dev_name;
+		if (parent_resolved)
+			log_err(ctx, _("Warning: %s not found; locking %s "
+				       "instead, lock may not prevent "
+				       "udev races\n"), lock_path, dev_name);
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
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
@@ -1413,6 +1508,7 @@ int main (int argc, char *argv[])
 	int journal_size;
 	int sysval, sys_page_size = 4096;
 	int old_bitmaps;
+	int lock_fd = -1;
 	__u32 features[3];
 	char *cp;
 	enum quota_type qtype;
@@ -1488,6 +1584,12 @@ int main (int argc, char *argv[])
 
 	check_mount(ctx);
 
+	lock_fd = lock_whole_disk(ctx, ctx->filesystem_name);
+	if (lock_fd < 0)
+		log_err(ctx, _("Warning: could not lock %s; "
+			       "proceeding without block device lock\n"),
+			ctx->filesystem_name);
+
 	if (!(ctx->options & E2F_OPT_PREEN) &&
 	    !(ctx->options & E2F_OPT_NO) &&
 	    !(ctx->options & E2F_OPT_YES)) {
@@ -2169,6 +2271,9 @@ skip_write:
 	ext2fs_close_free(&ctx->fs);
 	free(ctx->journal_name);
 
+	if (lock_fd >= 0)
+		close(lock_fd);
+
 	if (ctx->logf)
 		fprintf(ctx->logf, "Exit status: %d\n", exit_value);
 	e2fsck_free_context(ctx);
-- 
2.54.0

