From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/34] dumpe2fs: provide a machine-readable group-only mode
Date: Sat, 13 Sep 2014 15:12:18 -0700
Message-ID: <20140913221218.13646.32097.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32223 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaIMWMZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:12:25 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Spit out just the group descriptor data in a machine readable format.
This is most useful for testing and scripting purposes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/dumpe2fs.8.in                 |   10 ++++++-
 misc/dumpe2fs.c                    |   40 +++++++++++++++++++++++++---
 tests/d_dumpe2fs_group_only/expect |   51 ++++++++++++++++++++++++++++++++++++
 tests/d_dumpe2fs_group_only/name   |    1 +
 tests/d_dumpe2fs_group_only/script |   43 ++++++++++++++++++++++++++++++
 5 files changed, 139 insertions(+), 6 deletions(-)
 create mode 100644 tests/d_dumpe2fs_group_only/expect
 create mode 100644 tests/d_dumpe2fs_group_only/name
 create mode 100644 tests/d_dumpe2fs_group_only/script


diff --git a/misc/dumpe2fs.8.in b/misc/dumpe2fs.8.in
index befaf94..8d9a559 100644
--- a/misc/dumpe2fs.8.in
+++ b/misc/dumpe2fs.8.in
@@ -8,7 +8,7 @@ dumpe2fs \- dump ext2/ext3/ext4 filesystem information
 .SH SYNOPSIS
 .B dumpe2fs
 [
-.B \-bfhixV
+.B \-bfghixV
 ]
 [
 .B \-o superblock=\fIsuperblock
@@ -49,6 +49,14 @@ is examining the remains of a very badly corrupted filesystem.
 force dumpe2fs to display a filesystem even though it may have some 
 filesystem feature flags which dumpe2fs may not understand (and which
 can cause some of dumpe2fs's display to be suspect).
+.TP
+.B \-g
+display the group descriptor information in a machine readable colon-separated
+value format.  The fields displayed are the group number; the number of the
+first block in the group; the superblock location (or -1 if not present); the
+range of blocks used by the group descriptors (or -1 if not present); the block
+bitmap location; the inode bitmap location; and the range of blocks used by the
+inode table.
 .TP 
 .B \-h
 only display the superblock information and not any of the block
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 4c7bf46..05dc3c5 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -52,9 +52,9 @@ static int blocks64 = 0;
 
 static void usage(void)
 {
-	fprintf (stderr, _("Usage: %s [-bfhixV] [-o superblock=<num>] "
+	fprintf(stderr, _("Usage: %s [-bfghixV] [-o superblock=<num>] "
 		 "[-o blocksize=<num>] device\n"), program_name);
-	exit (1);
+	exit(1);
 }
 
 static void print_number(unsigned long long num)
@@ -150,7 +150,7 @@ static void print_bg_rel_offset(ext2_filsys fs, blk64_t block, int itable,
 	}
 }
 
-static void list_desc (ext2_filsys fs)
+static void list_desc(ext2_filsys fs, int grp_only)
 {
 	unsigned long i;
 	blk64_t	first_block, last_block;
@@ -187,6 +187,8 @@ static void list_desc (ext2_filsys fs)
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
 		old_desc_blocks = fs->desc_blocks;
+	if (grp_only)
+		printf("group:block:super:gdt:bbitmap:ibitmap:itable\n");
 	for (i = 0; i < fs->group_desc_count; i++) {
 		first_block = ext2fs_group_first_block2(fs, i);
 		last_block = ext2fs_group_last_block2(fs, i);
@@ -194,6 +196,27 @@ static void list_desc (ext2_filsys fs)
 		ext2fs_super_and_bgd_loc2(fs, i, &super_blk,
 					  &old_desc_blk, &new_desc_blk, 0);
 
+		if (grp_only) {
+			printf("%lu:%llu:", i, first_block);
+			if (i == 0 || super_blk)
+				printf("%llu:", super_blk);
+			else
+				printf("-1:");
+			if (old_desc_blk) {
+				print_range(old_desc_blk,
+					    old_desc_blk + old_desc_blocks - 1);
+				printf(":");
+			} else if (new_desc_blk)
+				printf("%llu:", new_desc_blk);
+			else
+				printf("-1:");
+			printf("%llu:%llu:%llu\n",
+			       ext2fs_block_bitmap_loc(fs, i),
+			       ext2fs_inode_bitmap_loc(fs, i),
+			       ext2fs_inode_table_loc(fs, i));
+			continue;
+		}
+
 		printf (_("Group %lu: (Blocks "), i);
 		print_range(first_block, last_block);
 		fputs(")", stdout);
@@ -584,6 +607,7 @@ int main (int argc, char ** argv)
 	int		flags;
 	int		header_only = 0;
 	int		c;
+	int		grp_only = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -598,7 +622,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 
-	while ((c = getopt (argc, argv, "bfhixVo:")) != EOF) {
+	while ((c = getopt(argc, argv, "bfghixVo:")) != EOF) {
 		switch (c) {
 		case 'b':
 			print_badblocks++;
@@ -606,6 +630,9 @@ int main (int argc, char ** argv)
 		case 'f':
 			force++;
 			break;
+		case 'g':
+			grp_only++;
+			break;
 		case 'h':
 			header_only++;
 			break;
@@ -672,6 +699,8 @@ try_open_again:
 	if (print_badblocks) {
 		list_bad_blocks(fs, 1);
 	} else {
+		if (grp_only)
+			goto just_descriptors;
 		list_super (fs->super);
 		if (fs->super->s_feature_incompat &
 		      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
@@ -697,7 +726,8 @@ try_bitmaps_again:
 		}
 		if (!retval && (fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS))
 			printf("%s", _("\n*** Checksum errors detected in bitmaps!  Run e2fsck now!\n\n"));
-		list_desc (fs);
+just_descriptors:
+		list_desc(fs, grp_only);
 		if (retval) {
 			printf(_("\n%s: %s: error reading bitmaps: %s\n"),
 			       program_name, device_name,
diff --git a/tests/d_dumpe2fs_group_only/expect b/tests/d_dumpe2fs_group_only/expect
new file mode 100644
index 0000000..78f97a2
--- /dev/null
+++ b/tests/d_dumpe2fs_group_only/expect
@@ -0,0 +1,51 @@
+Creating filesystem with 1048576 4k blocks and 262144 inodes
+Superblock backups stored on blocks: 
+	32768, 98304, 163840, 229376, 294912, 819200, 884736
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (32768 blocks): done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/262144 files (0.0% non-contiguous), 51278/1048576 blocks
+Exit status is 0
+dumpe2fs output
+
+group:block:super:gdt:bbitmap:ibitmap:itable
+0:0:0:1-1:257:273:289
+1:32768:32768:32769-32769:258:274:801
+2:65536:-1:-1:259:275:1313
+3:98304:98304:98305-98305:260:276:1825
+4:131072:-1:-1:261:277:2337
+5:163840:163840:163841-163841:262:278:2849
+6:196608:-1:-1:263:279:3361
+7:229376:229376:229377-229377:264:280:3873
+8:262144:-1:-1:265:281:4385
+9:294912:294912:294913-294913:266:282:4897
+10:327680:-1:-1:267:283:5409
+11:360448:-1:-1:268:284:5921
+12:393216:-1:-1:269:285:6433
+13:425984:-1:-1:270:286:6945
+14:458752:-1:-1:271:287:7457
+15:491520:-1:-1:272:288:7969
+16:524288:-1:-1:524288:524304:524320
+17:557056:-1:-1:524289:524305:524832
+18:589824:-1:-1:524290:524306:525344
+19:622592:-1:-1:524291:524307:525856
+20:655360:-1:-1:524292:524308:526368
+21:688128:-1:-1:524293:524309:526880
+22:720896:-1:-1:524294:524310:527392
+23:753664:-1:-1:524295:524311:527904
+24:786432:-1:-1:524296:524312:528416
+25:819200:819200:819201-819201:524297:524313:528928
+26:851968:-1:-1:524298:524314:529440
+27:884736:884736:884737-884737:524299:524315:529952
+28:917504:-1:-1:524300:524316:530464
+29:950272:-1:-1:524301:524317:530976
+30:983040:-1:-1:524302:524318:531488
+31:1015808:-1:-1:524303:524319:532000
diff --git a/tests/d_dumpe2fs_group_only/name b/tests/d_dumpe2fs_group_only/name
new file mode 100644
index 0000000..096c020
--- /dev/null
+++ b/tests/d_dumpe2fs_group_only/name
@@ -0,0 +1 @@
+dumpe2fs group only mode
diff --git a/tests/d_dumpe2fs_group_only/script b/tests/d_dumpe2fs_group_only/script
new file mode 100644
index 0000000..127502f
--- /dev/null
+++ b/tests/d_dumpe2fs_group_only/script
@@ -0,0 +1,43 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+$MKE2FS -F -o Linux -b 4096 -O has_journal -T ext4 $TMPFILE 1048576 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "dumpe2fs output" >> $OUT
+$DUMPE2FS -g $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+
+rm -f $TMPFILE
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi

