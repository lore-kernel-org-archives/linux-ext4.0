From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Thu, 17 Sep 2009 17:22:49 -0500
Message-ID: <4AB2B6B9.7010506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZIQWWq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Sep 2009 18:22:46 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8HMMoP6026111
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 18:22:50 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8HMMllI004594
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 18:22:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is just a rough cut, due to the blkid header selection
issues I mentioned earlier on the list.  It'll also need
some config-fu to be sure we've got a blkid which has these
calls, but with it in place, we'll finally have automatic
selection of stride/stripe:

# misc/mke2fs -b 4096 /dev/md0 
mke2fs 1.41.9 (22-Aug-2009)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=16 blocks, Stripe width=32 blocks
...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 84c4361..8fd3cd8 100644
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
@@ -1073,6 +1076,51 @@ static int get_bool_from_profile(char **fs_types, const char *opt, int def_val)
 extern const char *mke2fs_default_profile;
 static const char *default_files[] = { "<default>", 0 };
 
+/*
+ * Sets the geometry of a device (stripe/stride)
+ */
+static errcode_t ext2fs_get_device_geometry(const char *file,
+					    struct ext2_super_block *fs_param)
+{
+	int fd;
+	int rc = 1;
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
+		return errno;
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
+	rc = 0;
+out:
+	close(fd);
+	return rc;
+}
 static void PRS(int argc, char *argv[])
 {
 	int		b, c;
@@ -1633,6 +1681,8 @@ got_size:
 	fs_param.s_log_frag_size = fs_param.s_log_block_size =
 		int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);
 
+	ext2fs_get_device_geometry(device_name, &fs_param);
+
 	blocksize = EXT2_BLOCK_SIZE(&fs_param);
 
 	lazy_itable_init = get_bool_from_profile(fs_types,

