From: Rupesh Thakare <rupesh@clusterfs.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Thu, 24 May 2007 19:45:32 +0530
Message-ID: <46559E04.5060002@clusterfs.com>
References: <20070512020248.GQ6375@schatzie.adilger.int> <20070524114442.GA12526@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040406050001050201070208"
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:53528 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXEXOMB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 May 2007 10:12:01 -0400
In-Reply-To: <20070524114442.GA12526@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------040406050001050201070208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
I've added "s_raid_stripe_width" parameter in superblock.
I've also incorporated "s_raid_stride" and "s_raid_stripe_width" 
parameters in tune2fs.
The new options can be specified using  '-E options' in both mke2fs and 
tune2fs.
Both the Man pages (mke2fs and tune2fs) are updated accordingly.
Patch is attached herewith.
Thanks,
Rupesh.

Andreas Dilger wrote:
> On May 22, 2007  01:22 +0530, Kalpak Shah wrote:
>   
>>         __u16   s_raid_stride;          /* RAID stride */
>> -       __u16   s_pad;                  /* Padding */
>> +       __u16   s_mmp_interval;         /* Wait for # seconds in MMP
>> checking */
>> +       __u64   s_mmp_block;            /* Block for multi-mount protection
>> */
>>     
>
> Ted, I just noticed this updated patch w.r.t. your recent s_raid_stride
> addition.  I also want to have a separate parameter for "s_raid_stripe_width"
> which is normally N * s_raid_stride, where N is the number of disks in a
> RAID 5 N+1 (or RAID 6 N+2) parity stripe.  This is for delalloc+mballoc to
> allow it to align and size new allocations so that writes do not impose
> read-modify-write overhead on the RAID stripes.
>
> My understanding from the code is that s_raid_stride is to put the bitmaps
> for different groups on different disks to avoid always having a single
> disk busy with bitmap updates.
>
>
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

--------------040406050001050201070208
Content-Type: text/x-patch;
 name="e2fsprogs_stride.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="e2fsprogs_stride.patch"

Index: e2fsprogs-upstream/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-upstream.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-upstream/lib/ext2fs/ext2_fs.h
@@ -573,9 +573,13 @@ struct ext2_super_block {
 	__u16	s_min_extra_isize;	/* All inodes have at least # bytes */
 	__u16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
 	__u32	s_flags;		/* Miscellaneous flags */
+	/*
+	 * RAID chunksize and stripe width support
+	 */
 	__u16   s_raid_stride;		/* RAID stride */
 	__u16   s_pad;			/* Padding */
-	__u32	s_reserved[166];	/* Padding to the end of the block */
+	__u32   s_raid_stripe_width;	/* blocks on all data disks (N*stride)*/
+	__u32	s_reserved[165];	/* Padding to the end of the block */
 };
 
 /*
Index: e2fsprogs-upstream/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-upstream.orig/lib/ext2fs/initialize.c
+++ e2fsprogs-upstream/lib/ext2fs/initialize.c
@@ -156,6 +156,8 @@ errcode_t ext2fs_initialize(const char *
 	set_field(s_feature_incompat, 0);
 	set_field(s_feature_ro_compat, 0);
 	set_field(s_first_meta_bg, 0);
+	set_field(s_raid_stride, 0);		/* default stride size: 0 */
+	set_field(s_raid_stripe_width, 0);	/* default stripe width: 0 */
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
 		goto cleanup;
Index: e2fsprogs-upstream/misc/mke2fs.c
===================================================================
--- e2fsprogs-upstream.orig/misc/mke2fs.c
+++ e2fsprogs-upstream/misc/mke2fs.c
@@ -100,7 +100,7 @@ static void usage(void)
 	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
 	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
-	"[-r fs-revision] [-R options] [-qvSV]\n\tdevice [blocks-count]\n"),
+	"[-r fs-revision] [-E options] [-qvSV]\n\tdevice [blocks-count]\n"),
 		program_name);
 	exit(1);
 }
@@ -785,14 +785,27 @@ static void parse_extended_opts(struct e
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
@@ -858,6 +871,7 @@ static void parse_extended_opts(struct e
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid extended options are:\n"
 			"\tstride=<stride length in blocks>\n"
+			"\tstripe-width=<stripe width in blocks>\n"
 			"\tresize=<resize maximum size in blocks>\n\n"));
 		exit(1);
 	}
@@ -1625,7 +1639,7 @@ int main (int argc, char *argv[])
 		test_disk(fs, &bb_list);
 
 	handle_bad_blocks(fs, bb_list);
-	fs->stride = fs->super->s_raid_stride = fs_stride;
+	fs->stride = fs_stride = fs->super->s_raid_stride;
 	retval = ext2fs_allocate_tables(fs);
 	if (retval) {
 		com_err(program_name, retval,
Index: e2fsprogs-upstream/misc/tune2fs.c
===================================================================
--- e2fsprogs-upstream.orig/misc/tune2fs.c
+++ e2fsprogs-upstream/misc/tune2fs.c
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
@@ -497,15 +499,86 @@ static time_t parse_time(char *str)
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
+					_("Invalid stride parameter: %s\n"),
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
+					_("Invalid stripe-width parameter: %s\n"),
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
+			"\tstride=<stride length in blocks>\n"
+			"\tstripe-width=<stripe width in blocks>\n"));
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
@@ -548,6 +621,10 @@ static void parse_tune2fs_options(int ar
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
@@ -921,6 +998,16 @@ int main (int argc, char ** argv)
 
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
Index: e2fsprogs-upstream/misc/mke2fs.8.in
===================================================================
--- e2fsprogs-upstream.orig/misc/mke2fs.8.in
+++ e2fsprogs-upstream/misc/mke2fs.8.in
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
Index: e2fsprogs-upstream/misc/tune2fs.8.in
===================================================================
--- e2fsprogs-upstream.orig/misc/tune2fs.8.in
+++ e2fsprogs-upstream/misc/tune2fs.8.in
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

--------------040406050001050201070208--
