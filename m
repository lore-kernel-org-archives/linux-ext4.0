From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] mke2fs: get device topology values from blkid
Date: Mon, 21 Sep 2009 12:06:03 -0500
Message-ID: <4AB7B27B.40008@redhat.com>
References: <4AB2B6B9.7010506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbZIURGB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Sep 2009 13:06:01 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8LH653O012345
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2009 13:06:05 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8LH64wp031391
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2009 13:06:04 -0400
In-Reply-To: <4AB2B6B9.7010506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Handle automatic selection of stride/stripe:

# misc/mke2fs /dev/md0 
mke2fs 1.41.9 (22-Aug-2009)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=16 blocks, Stripe width=32 blocks
...

And warn on block device misalignment:

# misc/mke2fs /dev/sdc1 
mke2fs 1.41.9 (22-Aug-2009)
/dev/sdc1 alignment is offset by 32256 bytes.
This may result in very poor performance, (re)-partitioning suggested.
Proceed anyway? (y,n)

V2:
Add blkid_free_probe() per kzak
Add alignment check and warning message for misalignment

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(Note that this will cause the build to fail if the topo stuff is
found in the system's libblkid but the local lib/blkid headers don't
define it; either needs stubs or a library move first).









diff --git a/configure.in b/configure.in
index 4bb5b08..3319f70 100644
--- a/configure.in
+++ b/configure.in
@@ -802,7 +802,11 @@ AC_CHECK_MEMBER(struct sockaddr.sa_len,
 	[#include <sys/types.h>
 	 #include <sys/socket.h>])
 dnl
-AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate)
+dnl This will add -lblkid to the AC_CHECK_FUNCS search
+dnl
+AC_SEARCH_LIBS([blkid_probe_all], [blkid])
+dnl
+AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate blkid_probe_get_topology2)
 dnl
 dnl Check to see if -lsocket is required (solaris) to make something
 dnl that uses socket() to compile; this is needed for the UUID library
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 84c4361..a09f4d4 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -49,6 +49,7 @@ extern int optind;
 #include <sys/types.h>
 #include <libgen.h>
 #include <limits.h>
+#include <blkid/blkid.h>
 
 #include "ext2fs/ext2_fs.h"
 #include "et/com_err.h"
@@ -614,6 +615,8 @@ static void show_stats(ext2_filsys fs)
 		s->s_log_block_size);
 	printf(_("Fragment size=%u (log=%u)\n"), fs->fragsize,
 		s->s_log_frag_size);
+	printf(_("Stride=%u blocks, Stripe width=%u blocks\n"),
+	       s->s_raid_stride, s->s_raid_stripe_width);
 	printf(_("%u inodes, %u blocks\n"), s->s_inodes_count,
 	       s->s_blocks_count);
 	printf(_("%u blocks (%2.2f%%) reserved for the super user\n"),
@@ -1073,6 +1076,57 @@ static int get_bool_from_profile(char **fs_types, const char *opt, int def_val)
 extern const char *mke2fs_default_profile;
 static const char *default_files[] = { "<default>", 0 };
 
+#ifdef HAVE_BLKID_PROBE_GET_TOPOLOGY
+/*
+ * Sets the geometry of a device (stripe/stride), and returns the
+ * device's alignment offset, if any, or a negative error.
+ */
+static int ext2fs_get_device_geometry(const char *file,
+					    struct ext2_super_block *fs_param)
+{
+	int fd;
+	int rc = -1;
+	int blocksize;
+	blkid_probe pr;
+	blkid_topology tp;
+	unsigned long min_io;
+	unsigned long opt_io;
+
+#ifdef HAVE_OPEN64
+	fd = open64(file, O_RDONLY);
+#else
+	fd = open(file, O_RDONLY);
+#endif
+	if (fd < 0)
+		return rc;
+
+	pr = blkid_new_probe();
+	if (!pr)
+		goto out;
+
+	rc = blkid_probe_set_device(pr, fd, 0, 0);
+	if (rc)
+		goto out;
+
+	tp = blkid_probe_get_topology(pr);
+	if (!tp)
+		goto out;
+
+	min_io = blkid_topology_get_minimum_io_size(tp);
+	opt_io = blkid_topology_get_optimal_io_size(tp);
+	blocksize = EXT2_BLOCK_SIZE(fs_param);
+
+	fs_param->s_raid_stride = min_io / blocksize;
+	fs_param->s_raid_stripe_width = opt_io / blocksize;
+
+	rc = blkid_topology_get_alignment_offset(tp);
+out:
+	blkid_free_probe(pr);
+	close(fd);
+	return rc;
+}
+#endif
+
 static void PRS(int argc, char *argv[])
 {
 	int		b, c;
@@ -1633,6 +1687,21 @@ got_size:
 	fs_param.s_log_frag_size = fs_param.s_log_block_size =
 		int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);
 
+#ifdef HAVE_BLKID_PROBE_GET_TOPOLOGY
+	retval = ext2fs_get_device_geometry(device_name, &fs_param);
+	if (retval < 0) {
+		fprintf(stderr,
+			_("warning: Unable to get device geometry for %s"),
+			device_name);
+	} else if (retval) {
+		printf(_("%s alignment is offset by %lu bytes.\n"),
+		       device_name, retval);
+		printf(_("This may result in very poor performance, "
+			  "(re)-partitioning suggested.\n"));
+		proceed_question();
+	}
+#endif
+
 	blocksize = EXT2_BLOCK_SIZE(&fs_param);
 
 	lazy_itable_init = get_bool_from_profile(fs_types,

