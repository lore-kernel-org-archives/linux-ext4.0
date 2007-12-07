From: Josef Bacik <jbacik@redhat.com>
Subject: [RFC][PATCH] 64 bit blocks support for e2fsprogs
Date: Fri, 7 Dec 2007 11:14:45 -0500
Message-ID: <20071207161445.GB27749@dhcp243-37.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbXLGQUO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Dec 2007 11:20:14 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lB7GKDg2006806
	for <linux-ext4@vger.kernel.org>; Fri, 7 Dec 2007 11:20:13 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB7GKDAp017181
	for <linux-ext4@vger.kernel.org>; Fri, 7 Dec 2007 11:20:13 -0500
Received: from dhcp243-37.rdu.redhat.com (dhcp243-37.rdu.redhat.com [10.11.243.37])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB7GKC0E000832
	for <linux-ext4@vger.kernel.org>; Fri, 7 Dec 2007 11:20:12 -0500
Received: from dhcp243-37.rdu.redhat.com (localhost.localdomain [127.0.0.1])
	by dhcp243-37.rdu.redhat.com (8.14.1/8.14.1) with ESMTP id lB7GEkCq012885
	for <linux-ext4@vger.kernel.org>; Fri, 7 Dec 2007 11:14:46 -0500
Received: (from jwhiter@localhost)
	by dhcp243-37.rdu.redhat.com (8.14.1/8.14.1/Submit) id lB7GEjXF012884
	for linux-ext4@vger.kernel.org; Fri, 7 Dec 2007 11:14:45 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

This is a proof of concept for converting e2fsprogs over to handle large disks.
At this point I've only added the helper functions and converted mke2fs
(sloppily for now) to use the helper functions.  I know we want to make this as
painless as possible to go between ext2/3/4 so what I plan on doing is leave
everything as it is and only allow large disks to be formatted if
EXT4_FEATURE_INCOMPAT_64BIT is set.  Any feedback would be awesome, and if
somebody is already working on this please let me know so I'm not duplicating
work.  Thanks much,

Josef


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9285bda..cab4340 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1290,6 +1290,67 @@ _INLINE_ unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b)
 		return 0;
 	return ((a - 1) / b) + 1;
 }
+
+/*
+ * set the block count appropriately
+ */
+_INLINE_ void ext2fs_blocks_count_set(struct ext2_super_block *super,
+				      blk64_t blk)
+{
+	super->s_blocks_count = ext2fs_cpu_to_le32((__u32)blk);
+	super->s_blocks_count_hi = ext2fs_cpu_to_le32(blk >> 32);
+}
+
+/*
+ * set the blocks free count appropriately
+ */
+_INLINE_ void ext2fs_free_blocks_count_set(struct ext2_super_block *super,
+					   blk64_t blk)
+{
+	super->s_free_blocks_count = ext2fs_cpu_to_le32((__u32)blk);
+	super->s_free_blocks_count_hi = ext2fs_cpu_to_le32(blk >> 32);
+}
+
+/*
+ * set the blocks reserved count appropriately
+ */
+_INLINE_ void ext2fs_r_blocks_count_set(struct ext2_super_block *super,
+					blk64_t blk)
+{
+	super->s_r_blocks_count = ext2fs_cpu_to_le32((__u32)blk);
+	super->s_r_blocks_count_hi = ext2fs_cpu_to_le32(blk >> 32);
+}
+
+/*
+ * return the 64 bit block count for the fs
+ */
+__INLINE__ blk64_t ext2fs_blocks_count(struct ext2_super_block *super)
+{
+	return ((blk64_t)
+		ext2fs_le32_to_cpu(super->s_blocks_count_hi) << 32) |
+		ext2fs_le32_to_cpu(super->s_blocks_count);
+}
+
+/*
+ * return the 64 bit free blocks count for the fs
+ */
+__INLINE__ blk64_t ext2fs_free_blocks_count(struct ext2_super_block *super)
+{
+	return ((blk64_t)
+		ext2fs_le32_to_cpu(super->s_free_blocks_count_hi) << 32) |
+		ext2fs_le32_to_cpu(super->s_free_blocks_count);
+}
+
+/*
+ * return the 64 bit reserved blocks count for the fs
+ */
+__INLINE__ blk64_t ext2fs_r_blocks_count(struct ext2_super_block *super)
+{
+	return ((blk64_t)
+		ext2fs_le32_to_cpu(super->s_r_blocks_count_hi) << 32) |
+		ext2fs_le32_to_cpu(super->s_r_blocks_count);
+}		
+	
 #undef _INLINE_
 #endif
 
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index dbbedc0..57cd3ec 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -78,6 +78,7 @@ int	force;
 int	noaction;
 int	journal_size;
 int	journal_flags;
 char	*bad_blocks_filename;
 __u32	fs_stride;
 
@@ -191,9 +192,9 @@ static void test_disk(ext2_filsys fs, badblocks_list *bb_list)
 	errcode_t	retval;
 	char		buf[1024];
 
-	sprintf(buf, "badblocks -b %d -X %s%s%s %u", fs->blocksize,
+	sprintf(buf, "badblocks -b %d -X %s%s%s %lu", fs->blocksize,
 		quiet ? "" : "-s ", (cflag > 1) ? "-w " : "",
-		fs->device_name, fs->super->s_blocks_count-1);
+		fs->device_name, ext2fs_blocks64_count(fs)-1);
 	if (verbose)
 		printf(_("Running command: %s\n"), buf);
 	f = popen(buf, "r");
@@ -264,7 +265,8 @@ _("Warning: the backup superblock/group descriptors at block %u contain\n"
 				group_bad++;
 				group = ext2fs_group_of_blk(fs, group_block+j);
 				fs->group_desc[group].bg_free_blocks_count++;
-				fs->super->s_free_blocks_count++;
+				ext2fs_free_blocks_count_set(
+					ext2fs_free_blocks_count(fs->super)+1);
 			}
 		}
 		group_block += fs->super->s_blocks_per_group;
@@ -486,7 +488,9 @@ static void setup_lazy_bg(ext2_filsys fs)
 				bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
 				if (!csum_flag) {
 					bg->bg_free_blocks_count = 0;
-					sb->s_free_blocks_count -= blks;
+					ext2fs_free_blocks_count_set(
+						ext2fs_free_blocks_count(sb) -
+						blks);
 				}
 			}
 		}
@@ -644,7 +648,7 @@ static void create_journal_dev(ext2_filsys fs)
 	int			count;
 
 	retval = ext2fs_create_journal_superblock(fs,
-				  fs->super->s_blocks_count, 0, &buf);
+				  ext2fs_blocks64_count(fs), 0, &buf);
 	if (retval) {
 		com_err("create_journal_dev", retval,
 			_("while initializing journal superblock"));
@@ -654,9 +658,9 @@ static void create_journal_dev(ext2_filsys fs)
 		memset(&progress, 0, sizeof(progress));
 	else
 		progress_init(&progress, _("Zeroing journal device: "),
-			      fs->super->s_blocks_count);
+			      ext2fs_blocks64_count(fs));
 
-	retval = zero_blocks(fs, 0, fs->super->s_blocks_count,
+	retval = zero_blocks(fs, 0, ext2fs_blocks64_count(fs),
 			     &progress, &blk, &count);
 	if (retval) {
 		com_err("create_journal_dev", retval,
@@ -686,9 +690,10 @@ static void show_stats(ext2_filsys fs)
 	dgrp_t			i;
 	int			need, col_left;
 	
-	if (fs_param.s_blocks_count != s->s_blocks_count)
+	if (ext2fs_blocks_count(fs_param.super) != ext2fs_blocks_count(s))
 		fprintf(stderr, _("warning: %u blocks unused.\n\n"),
-		       fs_param.s_blocks_count - s->s_blocks_count);
+		       ext2fs_blocks_count(fs_param.super) - 
+		       ext2fs_blocks_count(s));
 
 	memset(buf, 0, sizeof(buf));
 	strncpy(buf, s->s_volume_name, sizeof(s->s_volume_name));
@@ -702,11 +707,11 @@ static void show_stats(ext2_filsys fs)
 		s->s_log_block_size);
 	printf(_("Fragment size=%u (log=%u)\n"), fs->fragsize,
 		s->s_log_frag_size);
-	printf(_("%u inodes, %u blocks\n"), s->s_inodes_count,
-	       s->s_blocks_count);
+	printf(_("%u inodes, %lu blocks\n"), s->s_inodes_count,
+	       ext2fs_blocks_count(s));
 	printf(_("%u blocks (%2.2f%%) reserved for the super user\n"),
-		s->s_r_blocks_count,
-	       100.0 * s->s_r_blocks_count / s->s_blocks_count);
+		ext2fs,
+	       100.0 * ext2fs_r_blocks_count(s) / ext2fs_blocks_count(s));
 	printf(_("First data block=%u\n"), s->s_first_data_block);
 	if (s->s_reserved_gdt_blocks)
 		printf(_("Maximum filesystem blocks=%lu\n"),
@@ -829,7 +834,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				r_usage++;
 				continue;
 			}
-			if (resize <= param->s_blocks_count) {
+			if (resize <= ext2fs_blocks_count(param)) {
 				fprintf(stderr, 
 					_("The resize maximum must be greater "
 					  "than the filesystem size.\n"));
@@ -843,7 +848,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				bpg = blocksize * 8;
 			gdpb = EXT2_DESC_PER_BLOCK(param);
 			group_desc_count = 
-				ext2fs_div_ceil(param->s_blocks_count, bpg);
+				ext2fs_div_ceil(ext2fs_blocks_count(param), 
+						bpg);
 			desc_blocks = (group_desc_count +
 				       gdpb - 1) / gdpb;
 			rsv_groups = ext2fs_div_ceil(resize, bpg);
@@ -936,7 +942,7 @@ static void PRS(int argc, char *argv[])
 	char *		oldpath = getenv("PATH");
 	char *		extended_opts = 0;
 	const char *	fs_type = 0;
-	blk_t		dev_size;
+	blk64_t		dev_size;
 #ifdef __linux__
 	struct 		utsname ut;
 #endif
@@ -1230,9 +1241,10 @@ static void PRS(int argc, char *argv[])
 			blocksize, sys_page_size);
 	}
 	if (optind < argc) {
-		fs_param.s_blocks_count = parse_num_blocks(argv[optind++], 
-				fs_param.s_log_block_size);
-		if (!fs_param.s_blocks_count) {
+		ext2fs_blocks_count_set(&fs_param, 
+					parse_num_blocks(argv[optind++], 
+						fs_param.s_log_block_size));
+		if (!ext2fs_blocks_count(&fs_param)) {
 			com_err(program_name, 0, _("invalid blocks count - %s"),
 				argv[optind - 1]);
 			exit(1);
@@ -1247,8 +1259,8 @@ static void PRS(int argc, char *argv[])
 
 	fs_param.s_log_frag_size = fs_param.s_log_block_size;
 
-	if (noaction && fs_param.s_blocks_count) {
-		dev_size = fs_param.s_blocks_count;
+	if (noaction && ext2fs_blocks_count(&fs_param)) {
+		dev_size = ext2fs_blocks_count(&fs_param);
 		retval = 0;
 	} else {
 	retry:
@@ -1269,7 +1281,7 @@ static void PRS(int argc, char *argv[])
 			_("while trying to determine filesystem size"));
 		exit(1);
 	}
-	if (!fs_param.s_blocks_count) {
+	if (!ext2fs_blocks_count(&fs_param)) {
 		if (retval == EXT2_ET_UNIMPLEMENTED) {
 			com_err(program_name, 0,
 				_("Couldn't determine device size; you "
@@ -1289,20 +1301,23 @@ static void PRS(int argc, char *argv[])
 				  ));
 				exit(1);
 			}
-			fs_param.s_blocks_count = dev_size;
-			if (sys_page_size > EXT2_BLOCK_SIZE(&fs_param))
-				fs_param.s_blocks_count &= ~((sys_page_size /
-					   EXT2_BLOCK_SIZE(&fs_param))-1);
+			ext2fs_blocks_count_set(dev_size);
+			if (sys_page_size > EXT2_BLOCK_SIZE(&fs_param)) {
+				blk64_t blks = ext2fs_blocks_count(&fs_param);
+				blks &= ~((sys_page_size /
+					EXT2_BLOCK_SIZE(&fs_param))-1);
+				ext2fs_blocks_count_set(blks);
+			}
 		}
 		
-	} else if (!force && (fs_param.s_blocks_count > dev_size)) {
+	} else if (!force && (ext2fs_blocks_count(&fs_param) > dev_size)) {
 		com_err(program_name, 0,
 			_("Filesystem larger than apparent device size."));
 		proceed_question();
 	}
 
 	if (!fs_type) {
-		int megs = (__u64)fs_param.s_blocks_count *
+		int megs = ext2fs_blocks_count(&fs_param) *
 			(EXT2_BLOCK_SIZE(&fs_param) / 1024) / 1024;
 
 		if (fs_param.s_feature_incompat & 
@@ -1398,6 +1413,7 @@ static void PRS(int argc, char *argv[])
 		sector_size = atoi(tmp);
 	
 	if (blocksize <= 0) {
+		blk64_t blks = ext2fs_blocks_count(&fs_param);
 		profile_get_integer(profile, "defaults", "blocksize", 0,
 				    4096, &use_bsize);
 		profile_get_integer(profile, "fs_types", fs_type, 
@@ -1414,7 +1430,8 @@ static void PRS(int argc, char *argv[])
 		if ((blocksize < 0) && (use_bsize < (-blocksize)))
 			use_bsize = -blocksize;
 		blocksize = use_bsize;
-		fs_param.s_blocks_count /= blocksize / 1024;
+		blks /= blocksize / 1024;
+		ext2fs_blocks_count_set(&fs_param);
 	}
 
 	if (inode_ratio == 0) {
@@ -1456,7 +1473,8 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
-	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
+	if (!force && ext2fs_blocks_count(&fs_param) >= ((unsigned) 1 << 31)
+		&& !(fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ){
 		com_err(program_name, 0,
 			_("Filesystem too large.  No more than 2**31-1 blocks\n"
 			  "\t (8TB using a blocksize of 4k) are currently supported."));
@@ -1497,7 +1515,7 @@ static void PRS(int argc, char *argv[])
 	/* Make sure number of inodes specified will fit in 32 bits */
 	if (num_inodes == 0) {
 		unsigned long long n;
-		n = (unsigned long long) fs_param.s_blocks_count * blocksize / inode_ratio;
+		n = (unsigned long long) ext2fs_blocks_count(&fs_param) * blocksize / inode_ratio;
 		if (n > ~0U) {
 			com_err(program_name, 0,
 			    _("too many inodes (%llu), raise inode ratio?"), n);
@@ -1513,12 +1531,12 @@ static void PRS(int argc, char *argv[])
 	 * Calculate number of inodes based on the inode ratio
 	 */
 	fs_param.s_inodes_count = num_inodes ? num_inodes : 
-		((__u64) fs_param.s_blocks_count * blocksize)
+		(ext2fs_blocks_count(&fs_param) * blocksize)
 			/ inode_ratio;
 
 	if ((((long long)fs_param.s_inodes_count) *
 	     (inode_size ? inode_size : EXT2_GOOD_OLD_INODE_SIZE)) >=
-	    (((long long)fs_param.s_blocks_count) * 
+	    ((ext2fs_blocks_count(&fs_param)) * 
 	     EXT2_BLOCK_SIZE(&fs_param))) {
 		com_err(program_name, 0, _("inode_size (%u) * inodes_count "
 					  "(%u) too big for a\n\t"
@@ -1527,15 +1545,15 @@ static void PRS(int argc, char *argv[])
 					  "or lower inode count (-N).\n"),
 			inode_size ? inode_size : EXT2_GOOD_OLD_INODE_SIZE,
 			fs_param.s_inodes_count, 
-			(unsigned long) fs_param.s_blocks_count);
+			(unsigned long) ext2fs_blocks_count(&fs_param));
 		exit(1);
 	}
 
 	/*
 	 * Calculate number of blocks to reserve
 	 */
-	fs_param.s_r_blocks_count = e2p_percent(reserved_ratio, 
-						fs_param.s_blocks_count);
+	ext2fs_r_blocks_count_set(&fs_param, e2p_percent(reserved_ratio, 
+						ext2fs_blocks_count(&fs_param)));
 }
 
 static int filesystem_exist(const char *name)
@@ -1772,7 +1790,7 @@ int main (int argc, char *argv[])
 	} else {
 		/* rsv must be a power of two (64kB is MD RAID sb alignment) */
 		unsigned int rsv = 65536 / fs->blocksize;
-		unsigned long blocks = fs->super->s_blocks_count;
+		blk64_t blocks = ext2fs_blocks64_count(fs);
 		unsigned long start;
 		blk_t ret_blk;
 
