From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] debugfs: add support to properly set and display extended
 timestamps
Date: Mon, 9 Dec 2013 14:14:30 -0500
Message-ID: <20131209191430.GB6096@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Mark Harris <mhlk@osj.us>,
	Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: David Turner <novalis@novalis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38216 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761240Ab3LITOf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Dec 2013 14:14:35 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In order to properly test the changes for extended timestamps, I
extracted portions of David Turner's patches to e2fsprogs, so we could
have a single commit which only adds the extended timestamps to e2fsprogs.

I moved things around a bit, to avoid the new header file
lib/extract_epoch.h with only two lines.  I also added proper support
to parse_time so that you can now have commands such as:

debugfs: set_inode_file /test ctime_lo 0x10203040
debugfs: set_inode_file /test ctime_hi 3
debugfs: set_inode_file /test ctime 205012143045
debugfs: set_inode_file /test ctime @4386555179

David, let me know what you think.  One thing which I'm still thinking
about adding is support encoding and decoding for the older style
encoding for pre-1970 dates, so we can properly test the e2fsck and
kernel patches.  What I'm still thinking about is what's the best way
to toggle between the legacy and new encoding for pre-1970 dates.

   	  	      	     	     	      - Ted

commit 05c2f96e19b6a7b769369f11538a0f93adf747a5
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Dec 9 13:55:23 2013 -0500

    debugfs: add support to properly set and display extended timestamps
    
    This code is partially derived from patches from David Turner to allow
    debugfs to properly support extended timestamps.
    
    Cc: David Turner <novalis@novalis.org>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 902ee66..7746629 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -793,27 +793,37 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	if (is_large_inode && large_inode->i_extra_isize >= 24) {
 		fprintf(out, "%s ctime: 0x%08x:%08x -- %s", prefix,
 			inode->i_ctime, large_inode->i_ctime_extra,
-			time_to_string(inode->i_ctime));
+			inode_time_to_string(inode->i_ctime,
+					     large_inode->i_ctime_extra));
 		fprintf(out, "%s atime: 0x%08x:%08x -- %s", prefix,
 			inode->i_atime, large_inode->i_atime_extra,
-			time_to_string(inode->i_atime));
+			inode_time_to_string(inode->i_atime,
+					     large_inode->i_atime_extra));
 		fprintf(out, "%s mtime: 0x%08x:%08x -- %s", prefix,
 			inode->i_mtime, large_inode->i_mtime_extra,
-			time_to_string(inode->i_mtime));
+			inode_time_to_string(inode->i_mtime,
+					     large_inode->i_mtime_extra));
 		fprintf(out, "%scrtime: 0x%08x:%08x -- %s", prefix,
 			large_inode->i_crtime, large_inode->i_crtime_extra,
-			time_to_string(large_inode->i_crtime));
+			inode_time_to_string(large_inode->i_crtime,
+					     large_inode->i_crtime_extra));
+		if (inode->i_dtime)
+			fprintf(out, "%scrtime: 0x%08x:(%08x) -- %s", prefix,
+				large_inode->i_dtime, large_inode->i_ctime_extra,
+				inode_time_to_string(inode->i_dtime,
+						     large_inode->i_ctime_extra));
 	} else {
 		fprintf(out, "%sctime: 0x%08x -- %s", prefix, inode->i_ctime,
-			time_to_string(inode->i_ctime));
+			time_to_string((__s32) inode->i_ctime));
 		fprintf(out, "%satime: 0x%08x -- %s", prefix, inode->i_atime,
-			time_to_string(inode->i_atime));
+			time_to_string((__s32) inode->i_atime));
 		fprintf(out, "%smtime: 0x%08x -- %s", prefix, inode->i_mtime,
-			time_to_string(inode->i_mtime));
+			time_to_string((__s32) inode->i_mtime));
+		if (inode->i_dtime)
+			fprintf(out, "%sdtime: 0x%08x -- %s", prefix,
+				inode->i_dtime,
+				time_to_string((__s32) inode->i_dtime));
 	}
-	if (inode->i_dtime)
-	  fprintf(out, "%sdtime: 0x%08x -- %s", prefix, inode->i_dtime,
-		  time_to_string(inode->i_dtime));
 	if (EXT2_INODE_SIZE(current_fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
 		internal_dump_inode_extra(out, prefix, inode_num,
 					  (struct ext2_inode_large *) inode);
@@ -2149,7 +2159,7 @@ void do_set_current_time(int argc, char *argv[])
 		return;
 
 	now = string_to_time(argv[1]);
-	if (now == ((time_t) -1)) {
+	if (now == -1) {
 		com_err(argv[0], 0, "Couldn't parse argument as a time: %s\n",
 			argv[1]);
 		return;
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 45175cf..32d32cc 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -33,8 +33,9 @@ extern int check_fs_not_open(char *name);
 extern int check_fs_read_write(char *name);
 extern int check_fs_bitmaps(char *name);
 extern ext2_ino_t string_to_inode(char *str);
-extern char *time_to_string(__u32);
-extern time_t string_to_time(const char *);
+extern char *inode_time_to_string(__u32 xtime, __u32 xtime_extra);
+extern char *time_to_string(__s64);
+extern __s64 string_to_time(const char *);
 extern unsigned long parse_ulong(const char *str, const char *cmd,
 				 const char *descr, int *err);
 extern unsigned long long parse_ulonglong(const char *str, const char *cmd,
diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
index bed0ce6..da2ad11 100644
--- a/debugfs/lsdel.c
+++ b/debugfs/lsdel.c
@@ -166,7 +166,7 @@ void do_lsdel(int argc, char **argv)
 			delarray[num_delarray].mode = inode.i_mode;
 			delarray[num_delarray].uid = inode_uid(inode);
 			delarray[num_delarray].size = EXT2_I_SIZE(&inode);
-			delarray[num_delarray].dtime = inode.i_dtime;
+			delarray[num_delarray].dtime = (__s32) inode.i_dtime;
 			delarray[num_delarray].num_blocks = lsd.num_blocks;
 			delarray[num_delarray].free_blocks = lsd.free_blocks;
 			num_delarray++;
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index b09e2f8..1cffeca 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -160,10 +160,14 @@ static struct field_set_info inode_fields[] = {
 	{ "uid", &set_inode.i_uid, &set_inode.osd2.linux2.l_i_uid_high,
 		2, parse_uint },
 	{ "size", &set_inode.i_size, &set_inode.i_size_high, 4, parse_uint },
-	{ "atime", &set_inode.i_atime, NULL, 4, parse_time },
-	{ "ctime", &set_inode.i_ctime, NULL, 4, parse_time },
-	{ "mtime", &set_inode.i_mtime, NULL, 4, parse_time },
-	{ "dtime", &set_inode.i_dtime, NULL, 4, parse_time },
+	{ "atime", &set_inode.i_atime, &set_inode.i_atime_extra,
+		4, parse_time },
+	{ "ctime", &set_inode.i_ctime, &set_inode.i_ctime_extra,
+		4, parse_time },
+	{ "mtime", &set_inode.i_mtime, &set_inode.i_mtime_extra,
+		4, parse_time },
+	{ "dtime", &set_inode.i_dtime, &set_inode.i_ctime_extra,
+		4, parse_time },
 	{ "gid", &set_inode.i_gid, &set_inode.osd2.linux2.l_i_gid_high,
 		2, parse_uint },
 	{ "links_count", &set_inode.i_links_count, NULL, 2, parse_uint },
@@ -199,7 +203,8 @@ static struct field_set_info inode_fields[] = {
 		4, parse_uint },
 	{ "atime_extra", &set_inode.i_atime_extra, NULL,
 		4, parse_uint },
-	{ "crtime", &set_inode.i_crtime, NULL, 4, parse_uint },
+	{ "crtime", &set_inode.i_crtime, &set_inode.i_crtime_extra,
+		4, parse_time },
 	{ "crtime_extra", &set_inode.i_crtime_extra, NULL,
 		4, parse_uint },
 	{ "bmap", NULL, NULL, 4, parse_bmap, FLAG_ARRAY },
@@ -474,21 +479,31 @@ static errcode_t parse_string(struct field_set_info *info,
 }
 
 static errcode_t parse_time(struct field_set_info *info,
-			    char *field EXT2FS_ATTR((unused)), char *arg)
+			    char *field, char *arg)
 {
-	time_t		t;
-	__u32		*ptr32;
+	__s64		t;
+	__u32		t_low, t_high;
+	__u32		*ptr_low, *ptr_high;
+	int		suffix = check_suffix(field);
+
+	if (check_suffix(field))
+		return parse_uint(info, field, arg);
 
-	ptr32 = (__u32 *) info->ptr;
+	ptr_low  = (__u32 *) info->ptr;
+	ptr_high = (__u32 *) info->ptr2;
 
 	t = string_to_time(arg);
 
-	if (t == ((time_t) -1)) {
+	if (t == -1) {
 		fprintf(stderr, "Couldn't parse '%s' for field %s.\n",
 			arg, info->name);
 		return EINVAL;
 	}
-	*ptr32 = t;
+	t_low = (__u32) t;
+	t_high = ((t - (__s32)t) >> 32) & EXT4_EPOCH_MASK;
+	*ptr_low = t_low;
+	if (ptr_high)
+		*ptr_high = (*ptr_high & ~EXT4_EPOCH_MASK) | t_high;
 	return 0;
 }
 
diff --git a/debugfs/util.c b/debugfs/util.c
index cf3a6c6..4a0abd8 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -186,11 +186,19 @@ int check_fs_bitmaps(char *name)
 	return 0;
 }
 
+char *inode_time_to_string(__u32 xtime, __u32 xtime_extra)
+{
+	__s64 t = (__s32) xtime;
+
+	t += (__s64) (xtime_extra & EXT4_EPOCH_MASK) << 32;
+	return time_to_string(t);
+}
+
 /*
- * This function takes a __u32 time value and converts it to a string,
+ * This function takes a __s64 time value and converts it to a string,
  * using ctime
  */
-char *time_to_string(__u32 cl)
+char *time_to_string(__s64 cl)
 {
 	static int	do_gmt = -1;
 	time_t		t = (time_t) cl;
@@ -211,10 +219,10 @@ char *time_to_string(__u32 cl)
  * Parse a string as a time.  Return ((time_t)-1) if the string
  * doesn't appear to be a sane time.
  */
-extern time_t string_to_time(const char *arg)
+extern __s64 string_to_time(const char *arg)
 {
 	struct	tm	ts;
-	time_t		ret;
+	__s64		ret;
 	char *tmp;
 
 	if (strcmp(arg, "now") == 0) {
@@ -222,9 +230,9 @@ extern time_t string_to_time(const char *arg)
 	}
 	if (arg[0] == '@') {
 		/* interpret it as an integer */
-		ret = strtoul(arg+1, &tmp, 0);
+		ret = strtoll(arg+1, &tmp, 0);
 		if (*tmp)
-			return ((time_t) -1);
+			return -1;
 		return ret;
 	}
 	memset(&ts, 0, sizeof(ts));
@@ -244,9 +252,9 @@ extern time_t string_to_time(const char *arg)
 	ret = mktime(&ts);
 	if (ts.tm_mday == 0 || ret == ((time_t) -1)) {
 		/* Try it as an integer... */
-		ret = strtoul(arg, &tmp, 0);
+		ret = strtoll(arg, &tmp, 0);
 		if (*tmp)
-			return ((time_t) -1);
+			return -1;
 	}
 	return ret;
 }
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fb3f7cc..fb10e7f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -809,6 +809,13 @@ struct ext2_dir_entry_2 {
 					 ~EXT2_DIR_ROUND)
 
 /*
+ * Constants for ext4's extended time encoding
+ */
+#define EXT4_EPOCH_BITS 2
+#define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
+#define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
+
+/*
  * This structure is used for multiple mount protection. It is written
  * into the block number saved in the s_mmp_block field in the superblock.
  * Programs that check MMP should assume that if SEQ_FSCK (or any unknown
