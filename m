From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V3] mke2fs: get device topology values from blkid
Date: Fri, 02 Oct 2009 11:32:42 -0500
Message-ID: <4AC62B2A.4020007@redhat.com>
References: <4AB2B6B9.7010506@redhat.com> <4AB7B27B.40008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbZJBQcl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Oct 2009 12:32:41 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n92GWkf7018404
	for <linux-ext4@vger.kernel.org>; Fri, 2 Oct 2009 12:32:46 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n92GWgbb021341
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 2 Oct 2009 12:32:45 -0400
In-Reply-To: <4AB7B27B.40008@redhat.com>
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

V3: use new blkid_new_probe_from_filename to drop some LOC

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
index 84c4361..b8f3410 100644
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
@@ -1073,6 +1076,43 @@ static int get_bool_from_profile(char **fs_types, const char *opt, int def_val)
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
+	int rc = -1;
+	int blocksize;
+	blkid_probe pr;
+	blkid_topology tp;
+	unsigned long min_io;
+	unsigned long opt_io;
+
+	pr = blkid_new_probe_from_filename(file);
+	if (!pr)
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
+	return rc;
+}
+#endif
+
 static void PRS(int argc, char *argv[])
 {
 	int		b, c;
@@ -1633,6 +1673,21 @@ got_size:
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

