From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][19/28] e2fsprogs-stride_option.patch
Date: Sat, 02 Feb 2008 01:47:06 -0700
Message-ID: <20080202084706.GT31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58463 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbYBBIrJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:47:09 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128l9o7016659
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:47:09 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00B01S8CF600@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:47:09 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Add support for setting the s_raid_stride and s_raid_stripe_width
fields in the superblock via mke2fs and tune2fs.c.  This is useful
for mballoc to align block allocation on the RAID stripe boundaries.

Fix up the debugfs "ssv" command to set a number of new superblock fields.

Signed-off-by: Rupesh Thakare <rupesh@clusterfs.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: e2fsprogs-1.40.5/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/initialize.c
+++ e2fsprogs-1.40.5/lib/ext2fs/initialize.c
@@ -156,6 +156,8 @@ errcode_t ext2fs_initialize(const char *
 	set_field(s_feature_incompat, 0);
 	set_field(s_feature_ro_compat, 0);
 	set_field(s_first_meta_bg, 0);
+	set_field(s_raid_stride, 0);		/* default stride size: 0 */
+	set_field(s_raid_stripe_width, 0);	/* default stripe width: 0 */
 	set_field(s_flags, 0);
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
Index: e2fsprogs-1.40.5/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.40.5.orig/misc/mke2fs.c
+++ e2fsprogs-1.40.5/misc/mke2fs.c
@@ -773,7 +773,7 @@ static int set_os(struct ext2_super_bloc
 static void parse_extended_opts(struct ext2_super_block *param, 
 				const char *opts)
 {
-	char	*buf, *token, *next, *p, *arg;
+	char	*buf, *token, *next, *p, *arg, *badopt = "";
 	int	len;
 	int	r_usage = 0;
 
@@ -800,16 +800,32 @@ static void parse_extended_opts(struct e
 		if (strcmp(token, "stride") == 0) {
 			if (!arg) {
 				r_usage++;
+				badopt = token;
 				continue;
 			}
-			fs_stride = strtoul(arg, &p, 0);
-			if (*p || (fs_stride == 0)) {
+			param->s_raid_stride = strtoul(arg, &p, 0);
+			if (*p || (param->s_raid_stride == 0)) {
 				fprintf(stderr,
 					_("Invalid stride parameter: %s\n"),
 					arg);
 				r_usage++;
 				continue;
 			}
+		} else if (strcmp(token, "stripe-width") == 0 ||
+			   strcmp(token, "stripe_width") == 0) {
+			if (!arg) {
+				r_usage++;
+				badopt = token;
+				continue;
+			}
+			param->s_raid_stripe_width = strtoul(arg, &p, 0);
+			if (*p || (param->s_raid_stripe_width == 0)) {
+				fprintf(stderr,
+					_("Invalid stripe-width parameter: %s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
 		} else if (!strcmp(token, "resize")) {
 			unsigned long resize, bpg, rsv_groups;
 			unsigned long group_desc_count, desc_blocks;
@@ -818,6 +834,7 @@ static void parse_extended_opts(struct e
 
 			if (!arg) {
 				r_usage++;
+				badopt = token;
 				continue;
 			}
 
@@ -868,21 +885,31 @@ static void parse_extended_opts(struct e
 			}
 		} else if (!strcmp(token, "test_fs")) {
 			param->s_flags |= EXT2_FLAGS_TEST_FILESYS;
-		} else
+		} else {
 			r_usage++;
+			badopt = token;
+		}
 	}
 	if (r_usage) {
-		fprintf(stderr, _("\nBad options specified.\n\n"
+		fprintf(stderr, _("\nBad option(s) specified: %s\n\n"
 			"Extended options are separated by commas, "
 			"and may take an argument which\n"
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid extended options are:\n"
-			"\tstride=<stride length in blocks>\n"
-			"\tresize=<resize maximum size in blocks>\n"
-			"\ttest_fs\n"));
+			"\tstride=<RAID per-disk data chunk in blocks>\n"
+			"\tstripe-width=<RAID stride * data disks in blocks>\n"
+			"\tresize=<resize maximum size in blocks>\n\n"
+			"\ttest_fs\n"),
+			badopt);
 		free(buf);
 		exit(1);
 	}
+	if (param->s_raid_stride &&
+	    (param->s_raid_stripe_width % param->s_raid_stride) != 0)
+		fprintf(stderr, _("\nWarning: RAID stripe-width %u not an even "
+				  "multiple of stride %u.\n\n"),
+			param->s_raid_stripe_width, param->s_raid_stride);
+
 	free(buf);
 }	
 
@@ -1662,7 +1689,7 @@ int main (int argc, char *argv[])
 		test_disk(fs, &bb_list);
 
 	handle_bad_blocks(fs, bb_list);
-	fs->stride = fs->super->s_raid_stride = fs_stride;
+	fs->stride = fs_stride = fs->super->s_raid_stride;
 	retval = ext2fs_allocate_tables(fs);
 	if (retval) {
 		com_err(program_name, retval,
Index: e2fsprogs-1.40.5/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.40.5.orig/misc/tune2fs.c
+++ e2fsprogs-1.40.5/misc/tune2fs.c
@@ -71,6 +71,8 @@ static unsigned short errors;
 static int open_flag;
 static char *features_cmd;
 static char *mntopts_cmd;
+static int stride, stripe_width;
+static int stride_set, stripe_width_set;
 static char *extended_cmd;
 
 int journal_size, journal_flags;
@@ -800,7 +802,36 @@ static void parse_extended_opts(ext2_fil
 			fs->super->s_flags &= ~EXT2_FLAGS_TEST_FILESYS;
 			printf("Clearing test filesystem flag\n");
 			ext2fs_mark_super_dirty(fs);
-		} else
+		} else if (strcmp(token, "stride") == 0) {
+			if (!arg) {
+				r_usage++;
+				continue;
+			}
+			stride = strtoul(arg, &p, 0);
+			if (*p || (stride == 0)) {
+				fprintf(stderr,
+				       _("Invalid RAID stride: %s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
+			stride_set = 1;
+		} else if (strcmp(token, "stripe-width") == 0 ||
+			   strcmp(token, "stripe_width") == 0) {
+			if (!arg) {
+				r_usage++;
+				continue;
+			}
+			stripe_width = strtoul(arg, &p, 0);
+			if (*p || (stripe_width == 0)) {
+				fprintf(stderr,
+					_("Invalid RAID stripe-width: %s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
+			stripe_width_set = 1;
+		} else 
 			r_usage++;
 	}
 	if (r_usage) {
@@ -809,6 +840,8 @@ static void parse_extended_opts(ext2_fil
 			"and may take an argument which\n"
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid extended options are:\n"
+			"\tstride=<RAID per-disk chunk size in blocks>\n"
+			"\tstripe-width=<RAID stride*data disks in blocks>\n"
 			"\ttest_fs\n"
 			"\t^test_fs\n"));
 		free(buf);
@@ -1002,6 +1035,16 @@ int main (int argc, char ** argv)
 
 	if (l_flag)
 		list_super (sb);
+	if (stride_set) {
+		sb->s_raid_stride = stride;
+		ext2fs_mark_super_dirty(fs);
+		printf(_("Setting stride size to %d\n"), stride);
+	}
+	if (stripe_width_set) {
+		sb->s_raid_stripe_width = stripe_width;
+		ext2fs_mark_super_dirty(fs);
+		printf(_("Setting stripe width to %d"), stripe_width);
+	}
 	remove_error_table(&et_ext2_error_table);
 	return (ext2fs_close (fs) ? 1 : 0);
 }
Index: e2fsprogs-1.40.5/misc/mke2fs.8.in
===================================================================
--- e2fsprogs-1.40.5.orig/misc/mke2fs.8.in
+++ e2fsprogs-1.40.5/misc/mke2fs.8.in
@@ -179,10 +179,23 @@ option is still accepted for backwards c
 following extended options are supported:
 .RS 1.2i
 .TP
-.BI stride= stripe-size
+.BI stride= stride-size
 Configure the filesystem for a RAID array with
-.I stripe-size
-filesystem blocks per stripe.
+.I stride-size
+filesystem blocks. This is the number of blocks read or written to disk
+before moving to next disk. This mostly affects placement of filesystem
+metadata like bitmaps at
+.BR mke2fs (2)
+time to avoid placing them on a single disk, which can hurt the performanace.
+It may also be used by block allocator.
+.TP
+.BI stripe-width= stripe-width
+Configure the filesystem for a RAID array with
+.I stripe-width
+filesystem blocks per stripe. This is typically be stride-size * N, where
+N is the number of data disks in the RAID (e.g. RAID 5 N+1, RAID 6 N+2).
+This allows the block allocator to prevent read-modify-write of the
+parity in a RAID stripe if possible when the data is written.
 .TP
 .BI resize= max-online-resize
 Reserve enough space so that the block group descriptor table can grow
Index: e2fsprogs-1.40.5/misc/tune2fs.8.in
===================================================================
--- e2fsprogs-1.40.5.orig/misc/tune2fs.8.in
+++ e2fsprogs-1.40.5/misc/tune2fs.8.in
@@ -65,6 +65,10 @@ tune2fs \- adjust tunable filesystem par
 .I extended-options
 ]
 [
+.B \-E
+.I extended-options
+]
+[
 .B \-L
 .I volume-name
 ]
@@ -163,6 +167,31 @@ Clear the test_fs flag, indicating the f
 using production-level filesystem code.
 .RE
 .TP
+.BI \-E " extended-options"
+Set extended options for the filesystem.  Extended options are comma
+separated, and may take an argument using the equals ('=') sign.
+The following extended options are supported:
+.RS 1.2i
+.TP
+.BI stride= stride-size
+Configure the filesystem for a RAID array with
+.I stride-size
+filesystem blocks. This is the number of blocks read or written to disk
+before moving to next disk. This mostly affects placement of filesystem
+metadata like bitmaps at
+.BR mke2fs (2)
+time to avoid placing them on a single disk, which can hurt the performanace.
+It may also be used by block allocator.
+.TP
+.BI stripe-width= stripe-width
+Configure the filesystem for a RAID array with
+.I stripe-width
+filesystem blocks per stripe. This is typically be stride-size * N, where
+N is the number of data disks in the RAID (e.g. RAID 5 N+1, RAID 6 N+2).
+This allows the block allocator to prevent read-modify-write of the
+parity in a RAID stripe if possible when the data is written.
+.RE
+.TP
 .B \-f
 Force the tune2fs operation to complete even in the face of errors.  This 
 option is useful when removing the 
Index: e2fsprogs-1.40.5/debugfs/set_fields.c
===================================================================
--- e2fsprogs-1.40.5.orig/debugfs/set_fields.c
+++ e2fsprogs-1.40.5/debugfs/set_fields.c
@@ -9,12 +9,18 @@
  * %End-Header%
  */
 
-#define _XOPEN_SOURCE 500 /* for inclusion of strptime() */
+#define _XOPEN_SOURCE 600 /* for inclusion of strptime() and strtoull */
+
+#ifdef HAVE_STRTOULL
+#define STRTOULL strtoull
+#else
+#define STRTOULL strtoul
+#endif
 
 #include <stdio.h>
 #include <unistd.h>
-#include <stdlib.h>
 #include <ctype.h>
+#include <stdlib.h>
 #include <string.h>
 #include <strings.h>
 #include <time.h>
@@ -103,7 +109,6 @@ static struct field_set_info super_field
 		  parse_uint },
 	{ "reserved_gdt_blocks", &set_sb.s_reserved_gdt_blocks, 2,
 		  parse_uint },
-	/* s_padding1 */
 	{ "journal_uuid", &set_sb.s_journal_uuid, 16, parse_uuid },
 	{ "journal_inum", &set_sb.s_journal_inum, 4, parse_uint },
 	{ "journal_dev", &set_sb.s_journal_dev, 4, parse_uint },
@@ -111,13 +116,22 @@ static struct field_set_info super_field
 	{ "hash_seed", &set_sb.s_hash_seed, 16, parse_uuid },
 	{ "def_hash_version", &set_sb.s_def_hash_version, 1, parse_hashalg },
 	{ "jnl_backup_type", &set_sb.s_jnl_backup_type, 1, parse_uint },
-	/* s_reserved_word_pad */
+	{ "desc_size", &set_sb.s_desc_size, 2, parse_uint },
 	{ "default_mount_opts", &set_sb.s_default_mount_opts, 4, parse_uint },
 	{ "first_meta_bg", &set_sb.s_first_meta_bg, 4, parse_uint },
 	{ "mkfs_time", &set_sb.s_mkfs_time, 4, parse_time },
 	{ "jnl_blocks", &set_sb.s_jnl_blocks[0], 4, parse_uint, FLAG_ARRAY, 
 	  17 },
+	{ "blocks_count_hi", &set_sb.s_blocks_count_hi, 4, parse_uint },
+	{ "r_blocks_count_hi", &set_sb.s_r_blocks_count_hi, 4, parse_uint },
+	{ "min_extra_isize", &set_sb.s_min_extra_isize, 2, parse_uint },
+	{ "want_extra_isize", &set_sb.s_want_extra_isize, 2, parse_uint },
 	{ "flags", &set_sb.s_flags, 4, parse_uint },
+	{ "raid_stride", &set_sb.s_raid_stride, 2, parse_uint },
+	{ "min_extra_isize", &set_sb.s_min_extra_isize, 4, parse_uint },
+	{ "mmp_interval", &set_sb.s_mmp_interval, 2, parse_uint },
+	{ "mmp_block", &set_sb.s_mmp_block, 8, parse_uint },
+	{ "raid_stripe_width", &set_sb.s_raid_stripe_width, 4, parse_uint },
 	{ 0, 0, 0, 0 }
 };
 
@@ -144,6 +158,7 @@ static struct field_set_info inode_field
 	{ "generation", &set_inode.i_generation, 4, parse_uint },
 	{ "file_acl", &set_inode.i_file_acl, 4, parse_uint },
 	{ "dir_acl", &set_inode.i_dir_acl, 4, parse_uint },
+	{ "size_high", &set_inode.i_size_high, 4, parse_uint },
 	{ "faddr", &set_inode.i_faddr, 4, parse_uint },
 	{ "blocks_hi", &set_inode.osd2.linux2.l_i_blocks_hi, 2, parse_uint },
 	{ "frag", &set_inode.osd2.hurd2.h_i_frag, 1, parse_uint },
@@ -229,9 +244,10 @@ static struct field_set_info *find_field
 
 static errcode_t parse_uint(struct field_set_info *info, char *arg)
 {
-	unsigned long	num;
+	unsigned long long num, limit;
 	char *tmp;
 	union {
+		__u64	*ptr64;
 		__u32	*ptr32;
 		__u16	*ptr16;
 		__u8	*ptr8;
@@ -241,13 +257,23 @@ static errcode_t parse_uint(struct field
 	if (info->flags & FLAG_ARRAY)
 		u.ptr8 += array_idx * info->size;
 
-	num = strtoul(arg, &tmp, 0);
-	if (*tmp) {
+	errno = 0;
+	num = STRTOULL(arg, &tmp, 0);
+	if (*tmp || errno) {
 		fprintf(stderr, "Couldn't parse '%s' for field %s.\n",
 			arg, info->name);
 		return EINVAL;
 	}
+	limit = ~0ULL >> ((8 - info->size) * 8);
+	if (num > limit) {
+		fprintf(stderr, "Value '%s' exceeds field %s maximum %llu.\n",
+			arg, info->name, limit);
+		return EINVAL;
+	}
 	switch (info->size) {
+	case 8:
+		*u.ptr64 = num;
+		break;
 	case 4:
 		*u.ptr32 = num;
 		break;
Index: e2fsprogs-1.40.5/lib/blkid/read.c
===================================================================
--- e2fsprogs-1.40.5.orig/lib/blkid/read.c
+++ e2fsprogs-1.40.5/lib/blkid/read.c
@@ -10,6 +10,8 @@
  * %End-Header%
  */
 
+#define _XOPEN_SOURCE 600 /* for inclusion of strtoull */
+
 #include <stdio.h>
 #include <ctype.h>
 #include <string.h>
@@ -26,7 +28,6 @@
 #include "uuid/uuid.h"
 
 #ifdef HAVE_STRTOULL
-#define __USE_ISOC9X
 #define STRTOULL strtoull /* defined in stdlib.h if you try hard enough */
 #else
 /* FIXME: need to support real strtoull here */
@@ -319,8 +320,7 @@ static int parse_tag(blkid_cache cache, 
 	else if (!strcmp(name, "PRI"))
 		dev->bid_pri = strtol(value, 0, 0);
 	else if (!strcmp(name, "TIME"))
-		/* FIXME: need to parse a long long eventually */
-		dev->bid_time = strtol(value, 0, 0);
+		dev->bid_time = STRTOULL(value, 0, 0);
 	else
 		ret = blkid_set_tag(dev, name, value, strlen(value));
 

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
