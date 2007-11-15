From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] set s_raid_{stripe,stride}
Date: Thu, 15 Nov 2007 11:56:54 -0700
Message-ID: <20071115185654.GB18130@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+g7M9IMkV8truYOl"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:60649 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760878AbXKOS46 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2007 13:56:58 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is a resend of a patch originally from Rupesh Thakare that allows
mke2fs and tune2fs to set/change s_raid_stripe_width and s_raid_stride
in the superblock.  Knowing the RAID geometry will allow mballoc/delalloc
to make much better decisions at allocation time to avoid RAID-level
read-modify-write for unaligned writes.

Similarly, in newer kernels the readahead has a mechanism to query
readahead sizes from the filesystem, and keeping these RAID aligned
avoids extra seeks and in some hardware RAID can also greatly reduce
the track cache overhead if there are many IO threads doing unaligned
reads causing the track cache to be flushed before it can be used.

The kernel code to use this is left as an exercise for the reader.
Hooking this into the XFS libdisk (or whatever it is called) at mke2fs
time is extra bonus points.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="e2fsprogs-stride_option.patch"

Index: e2fsprogs-1.40.2/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/initialize.c
+++ e2fsprogs-1.40.2/lib/ext2fs/initialize.c
@@ -156,6 +156,8 @@ errcode_t ext2fs_initialize(const char *
 	set_field(s_feature_incompat, 0);
 	set_field(s_feature_ro_compat, 0);
 	set_field(s_first_meta_bg, 0);
+	set_field(s_raid_stride, 0);		/* default stride size: 0 */
+	set_field(s_raid_stripe_width, 0);	/* default stripe width: 0 */
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
 		goto cleanup;
Index: e2fsprogs-1.40.2/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.40.2.orig/misc/mke2fs.c
+++ e2fsprogs-1.40.2/misc/mke2fs.c
@@ -100,7 +100,7 @@ static void usage(void)
 	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
 	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
-	"[-r fs-revision] [-R options] [-qvSV]\n\tdevice [blocks-count]\n"),
+	"[-r fs-revision] [-E options] [-qvSV]\n\tdevice [blocks-count]\n"),
 		program_name);
 	exit(1);
 }
@@ -802,14 +802,27 @@ static void parse_extended_opts(struct e
 				r_usage++;
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
+		} else if (strcmp(token, "stripe-width") == 0) {
+			if (!arg) {
+				r_usage++;
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
@@ -875,7 +888,8 @@ static void parse_extended_opts(struct e
 			"and may take an argument which\n"
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid extended options are:\n"
-			"\tstride=<stride length in blocks>\n"
+			"\tstride=<RAID per-disk data chunk in blocks>\n"
+			"\tstripe-width=<RAID stride * data disks in blocks>\n"
 			"\tresize=<resize maximum size in blocks>\n\n"));
 		free(buf);
 		exit(1);
@@ -1654,7 +1668,7 @@ int main (int argc, char *argv[])
 		test_disk(fs, &bb_list);
 
 	handle_bad_blocks(fs, bb_list);
-	fs->stride = fs->super->s_raid_stride = fs_stride;
+	fs->stride = fs_stride = fs->super->s_raid_stride;
 	retval = ext2fs_allocate_tables(fs);
 	if (retval) {
 		com_err(program_name, retval,
Index: e2fsprogs-1.40.2/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.40.2.orig/misc/tune2fs.c
+++ e2fsprogs-1.40.2/misc/tune2fs.c
@@ -71,6 +71,8 @@ static unsigned short errors;
 static int open_flag;
 static char *features_cmd;
 static char *mntopts_cmd;
+static int stride, stripe_width;
+static int stride_set, stripe_width_set;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -87,9 +89,9 @@ static void usage(void)
 		  "\t[-i interval[d|m|w]] [-j] [-J journal_options]\n"
 		  "\t[-l] [-s sparse_flag] [-m reserved_blocks_percent]\n"
 		  "\t[-o [^]mount_options[,...]] [-r reserved_blocks_count]\n"
-		  "\t[-u user] [-C mount_count] [-L volume_label] "
-		  "[-M last_mounted_dir]\n"
-		  "\t[-O [^]feature[,...]] [-T last_check_time] [-U UUID]"
+		  "\t[-u user] [-C mount_count] [-E options] [-L volume_label]"
+		  "\n\t[-M last_mounted_dir] [-O [^]feature[,...]]\n"
+		  "\t[-T last_check_time] [-U UUID]"
 		  " device\n"), program_name);
 	exit (1);
 }
@@ -505,15 +507,86 @@ static time_t parse_time(char *str)
 	return (mktime(&ts));
 }
 
+static void parse_extended_opts(const char *opts)
+{
+	char *buf, *token, *next, *p, *arg;
+	int len;
+	int r_usage = 0;
+
+	len = strlen(opts);
+	buf = malloc(len+1);
+	if (!buf) {
+		fprintf(stderr,
+			_("Couldn't allocate memory to parse options!\n"));
+		exit(1);
+	}
+	strcpy(buf, opts);
+	for (token = buf; token && *token; token = next) {
+		p = strchr(token, ',');
+		next = 0;
+		if (p) {
+			*p = 0;
+			next = p+1;
+		}
+		arg = strchr(token, '=');
+		if (arg) {
+			*arg = 0;
+			arg++;
+		}
+		if (strcmp(token, "stride") == 0) {
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
+		} else if (strcmp(token, "stripe-width") == 0) {
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
+			r_usage++;
+	}
+	if (r_usage) {
+		fprintf(stderr, _("\nBad options specified.\n\n"
+			"Extended options are separated by commas, "
+			"and may take an argument which\n"
+			"\tis set off by an equals ('=') sign.\n\n"
+			"Valid extended options are:\n"
+			"\tstride=<RAID per-disk chunk size in blocks>\n"
+			"\tstripe-width=<RAID stride*data disks in blocks>\n"));
+		exit(1);
+	}
+
+}
+
 static void parse_tune2fs_options(int argc, char **argv)
 {
 	int c;
 	char * tmp;
+	char * extended_opts = NULL;
 	struct group * gr;
 	struct passwd * pw;
 
 	printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:J:L:M:O:T:U:")) != EOF)
+	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:E:J:L:M:O:T:U:")) != EOF)
 		switch (c)
 		{
 			case 'c':
@@ -556,6 +629,10 @@ static void parse_tune2fs_options(int ar
 				e_flag = 1;
 				open_flag = EXT2_FLAG_RW;
 				break;
+			case 'E':
+				extended_opts = optarg;
+				parse_extended_opts(extended_opts);
+				break;
 			case 'f': /* Force */
 				f_flag = 1;
 				break;
@@ -930,6 +1007,16 @@ int main (int argc, char ** argv)
 
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
Index: e2fsprogs-1.40.2/misc/mke2fs.8.in
===================================================================
--- e2fsprogs-1.40.2.orig/misc/mke2fs.8.in
+++ e2fsprogs-1.40.2/misc/mke2fs.8.in
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
Index: e2fsprogs-1.40.2/misc/tune2fs.8.in
===================================================================
--- e2fsprogs-1.40.2.orig/misc/tune2fs.8.in
+++ e2fsprogs-1.40.2/misc/tune2fs.8.in
@@ -61,6 +61,10 @@ tune2fs \- adjust tunable filesystem par
 .I mount-count
 ]
 [
+.B \-E
+.I extended-options
+]
+[
 .B \-L
 .I volume-name
 ]
@@ -144,6 +148,31 @@ Remount filesystem read-only.
 Cause a kernel panic.
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

--+g7M9IMkV8truYOl--
