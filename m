From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] clean up some trivial build warnings
Date: Tue, 24 Jun 2008 14:14:01 -0500
Message-ID: <48614779.6030600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbYFXTOE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2008 15:14:04 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m5OJE3LO022164
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 15:14:03 -0400
Received: from file.rdu.redhat.com (file.rdu.redhat.com [10.11.255.147])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5OJE2V0011623
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 15:14:02 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by file.rdu.redhat.com (8.13.1/8.13.1) with ESMTP id m5OJE1uW026825
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 15:14:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are a few left in my build, mostly related to ignoring return
values, but here are a few trivial cleanups.

Thanks,

-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/ext2fs/tst_csum.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/tst_csum.c	2008-06-24 13:54:51.000000000 -0500
+++ e2fsprogs/lib/ext2fs/tst_csum.c	2008-06-24 13:55:35.396045790 -0500
@@ -11,6 +11,7 @@
 
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
+#include "ext2fs/crc16.h"
 
 #ifndef offsetof
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
@@ -46,7 +47,7 @@ void print_csum(const char *msg, ext2_fi
 unsigned char sb_uuid[16] = { 0x4f, 0x25, 0xe8, 0xcf, 0xe7, 0x97, 0x48, 0x23,
 			      0xbe, 0xfa, 0xa7, 0x88, 0x4b, 0xae, 0xec, 0xdb };
 
-main(int argc, char **argv)
+int main(int argc, char **argv)
 {
 	struct ext2_super_block param;
 	errcode_t		retval;
Index: e2fsprogs/misc/badblocks.c
===================================================================
--- e2fsprogs.orig/misc/badblocks.c	2008-06-24 13:54:51.000000000 -0500
+++ e2fsprogs/misc/badblocks.c	2008-06-24 13:55:35.398045197 -0500
@@ -50,6 +50,7 @@ extern int optind;
 
 #include <sys/ioctl.h>
 #include <sys/types.h>
+#include <sys/time.h>
 
 #include "et/com_err.h"
 #include "ext2fs/ext2_io.h"
@@ -285,10 +286,10 @@ static int do_read (int dev, unsigned ch
 
 	/* Try the read */
 	if (d_flag)
-		gettimeofday(&tv1);
+		gettimeofday(&tv1, 0);
 	got = read (dev, buffer, try * block_size);
 	if (d_flag)
-		gettimeofday(&tv2);
+		gettimeofday(&tv2, 0);
 	if (got < 0)
 		got = 0;	
 	if (got & 511)
Index: e2fsprogs/misc/e2undo.c
===================================================================
--- e2fsprogs.orig/misc/e2undo.c	2008-06-24 13:54:51.000000000 -0500
+++ e2fsprogs/misc/e2undo.c	2008-06-24 13:55:35.421007176 -0500
@@ -203,7 +203,7 @@ int main(int argc, char *argv[])
 			exit(1);
 		}
 		blk_num = *(unsigned long *)key.dptr;
-		printf(_("Replayed transaction of size %d at location %ld\n"),
+		printf(_("Replayed transaction of size %zd at location %ld\n"),
 							data.dsize, blk_num);
 		retval = io_channel_write_blk(channel, blk_num,
 						-data.dsize, data.dptr);
@@ -217,4 +217,5 @@ int main(int argc, char *argv[])
 	io_channel_close(channel);
 	tdb_close(tdb);
 
+	return 0;
 }
Index: e2fsprogs/misc/mke2fs.c
===================================================================
--- e2fsprogs.orig/misc/mke2fs.c	2008-06-24 13:54:51.000000000 -0500
+++ e2fsprogs/misc/mke2fs.c	2008-06-24 13:55:35.438270700 -0500
@@ -484,7 +484,6 @@ static void create_bad_block_inode(ext2_
 static void reserve_inodes(ext2_filsys fs)
 {
 	ext2_ino_t	i;
-	int		group;
 
 	for (i = EXT2_ROOT_INO + 1; i < EXT2_FIRST_INODE(fs->super); i++)
 		ext2fs_inode_alloc_stats2(fs, i, +1, 0);
@@ -927,7 +926,6 @@ static char **parse_fs_type(const char *
 	char		*cp, *t;
 	const char	*size_type;
 	struct str_list	list;
-	int		state = 0;
 	unsigned long	meg;
 
 	if (init_list(&list))
@@ -1006,7 +1004,6 @@ static char *get_string_from_profile(cha
 				     const char *def_val)
 {
 	char *ret = 0;
-	char **cpp;
 	int i;
 
 	for (i=0; fs_types[i]; i++);
@@ -1049,7 +1046,7 @@ static void PRS(int argc, char *argv[])
 {
 	int		b, c;
 	int		size;
-	char 		*tmp, *tmp2, **cpp;
+	char 		*tmp, **cpp;
 	int		blocksize = 0;
 	int		inode_ratio = 0;
 	int		inode_size = 0;
@@ -1789,7 +1786,7 @@ static int mke2fs_setup_tdb(const char *
 	printf(_("Overwriting existing filesystem; this can be undone "
 		 "using the command:\n"
 		 "    e2undo %s %s\n\n"), tdb_file, name);
-err_out:
+
 	free(tmp_name);
 	return retval;
 }
Index: e2fsprogs/lib/blkid/probe.c
===================================================================
--- e2fsprogs.orig/lib/blkid/probe.c	2008-06-24 13:55:33.655983059 -0500
+++ e2fsprogs/lib/blkid/probe.c	2008-06-24 13:59:15.574497575 -0500
@@ -777,11 +777,11 @@ static int probe_jfs(struct blkid_probe 
 static int probe_zfs(struct blkid_probe *probe, struct blkid_magic *id,
 		     unsigned char *buf)
 {
+#if 0
 	char *vdev_label;
 	const char *pool_name = 0;
 
 	/* read nvpair data for pool name, pool GUID (complex) */
-#if 0
 	blkid_set_tag(probe->dev, "LABEL", pool_name, sizeof(pool_name));
 	set_uuid(probe->dev, pool_guid, 0);
 #endif
@@ -1252,9 +1252,10 @@ blkid_dev blkid_verify(blkid_cache cache
 		return dev;
 
 	DBG(DEBUG_PROBE,
-	    printf("need to revalidate %s (cache time %d, stat time %d,\n\t"
+	    printf("need to revalidate %s (cache time %lu, stat time %lu,\n\t"
 		   "time since last check %lu)\n",
-		   dev->bid_name, dev->bid_time, st.st_mtime, (unsigned long)diff));
+		   dev->bid_name, (unsigned long)dev->bid_time,
+		   (unsigned long)st.st_mtime, (unsigned long)diff));
 
 	if ((probe.fd = open(dev->bid_name, O_RDONLY)) < 0) {
 		DBG(DEBUG_PROBE, printf("blkid_verify: error %s (%d) while "


