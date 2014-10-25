From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 34/39] debugfs: implement fallocate
Date: Sat, 25 Oct 2014 14:00:02 -0700
Message-ID: <20141025210002.532.50123.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44430 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaJYVAh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 17:00:37 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement a fallocate function for debugfs, and add some tests to
demonstrate that it works (more or less).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debug_cmds.ct                |    3 +
 debugfs/debugfs.c                    |   36 +++++++
 debugfs/debugfs.h                    |    1 
 tests/d_fallocate/expect.gz          |  Bin
 tests/d_fallocate/name               |    1 
 tests/d_fallocate/script             |  175 ++++++++++++++++++++++++++++++++++
 tests/d_fallocate_bigalloc/expect.gz |  Bin
 tests/d_fallocate_bigalloc/name      |    1 
 tests/d_fallocate_bigalloc/script    |  176 ++++++++++++++++++++++++++++++++++
 tests/d_fallocate_blkmap/expect      |   58 +++++++++++
 tests/d_fallocate_blkmap/name        |    1 
 tests/d_fallocate_blkmap/script      |   85 ++++++++++++++++
 12 files changed, 537 insertions(+)
 create mode 100644 tests/d_fallocate/expect.gz
 create mode 100644 tests/d_fallocate/name
 create mode 100644 tests/d_fallocate/script
 create mode 100644 tests/d_fallocate_bigalloc/expect.gz
 create mode 100644 tests/d_fallocate_bigalloc/name
 create mode 100644 tests/d_fallocate_bigalloc/script
 create mode 100644 tests/d_fallocate_blkmap/expect
 create mode 100644 tests/d_fallocate_blkmap/name
 create mode 100644 tests/d_fallocate_blkmap/script


diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index c6f6d6c..34dad9e 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -157,6 +157,9 @@ request do_dirsearch, "Search a directory for a particular filename",
 request do_bmap, "Calculate the logical->physical block mapping for an inode",
 	bmap;
 
+request do_fallocate, "Allocate uninitialized blocks to an inode",
+	fallocate;
+
 request do_punch, "Punch (or truncate) blocks from an inode by deallocating them",
 	punch, truncate;
 
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index db85028..b30a5ab 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2073,6 +2073,42 @@ void do_punch(int argc, char *argv[])
 		return;
 	}
 }
+
+void do_fallocate(int argc, char *argv[])
+{
+	ext2_ino_t	ino;
+	blk64_t		start, end;
+	int		err;
+	errcode_t	errcode;
+
+	if (common_args_process(argc, argv, 3, 4, argv[0],
+				"<file> start_blk [end_blk]",
+				CHECK_FS_RW | CHECK_FS_BITMAPS))
+		return;
+
+	ino = string_to_inode(argv[1]);
+	if (!ino)
+		return;
+	err = strtoblk(argv[0], argv[2], "logical block", &start);
+	if (err)
+		return;
+	if (argc == 4) {
+		err = strtoblk(argv[0], argv[3], "logical block", &end);
+		if (err)
+			return;
+	} else
+		end = ~0;
+
+	errcode = ext2fs_fallocate(current_fs, EXT2_FALLOCATE_INIT_BEYOND_EOF,
+				   ino, NULL, ~0ULL, start, end - start + 1);
+
+	if (errcode) {
+		com_err(argv[0], errcode,
+			"while fallocating inode %u from %llu to %llu\n", ino,
+			(unsigned long long) start, (unsigned long long) end);
+		return;
+	}
+}
 #endif /* READ_ONLY */
 
 void do_symlink(int argc, char *argv[])
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index e163d0a..76bb22c 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -166,6 +166,7 @@ extern void do_imap(int argc, char **argv);
 extern void do_set_current_time(int argc, char **argv);
 extern void do_supported_features(int argc, char **argv);
 extern void do_punch(int argc, char **argv);
+extern void do_fallocate(int argc, char **argv);
 extern void do_symlink(int argc, char **argv);
 
 extern void do_dump_mmp(int argc, char **argv);
diff --git a/tests/d_fallocate/expect.gz b/tests/d_fallocate/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..59d6263ab66ce86f46d3a617269427f13b9ddfde
GIT binary patch
literal 3386
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
AoB#j-

literal 0
HcmV?d00001

diff --git a/tests/d_fallocate/name b/tests/d_fallocate/name
new file mode 100644
index 0000000..72d0ed3
--- /dev/null
+++ b/tests/d_fallocate/name
@@ -0,0 +1 @@
+fallocate sparse files and big files
diff --git a/tests/d_fallocate/script b/tests/d_fallocate/script
new file mode 100644
index 0000000..829a1bd
--- /dev/null
+++ b/tests/d_fallocate/script
@@ -0,0 +1,175 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+cat > $TMPFILE.conf << ENDL
+[fs_types]
+ext4 = {
+        base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr,^has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit
+        blocksize = 1024
+        inode_size = 256
+        inode_ratio = 16384
+}
+ENDL
+MKE2FS_CONFIG=$TMPFILE.conf $MKE2FS -F -o Linux -b 1024 -O ^bigalloc -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+rm -rf $TMPFILE.conf
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write files" >> $OUT
+make_file() {
+	name="$1"
+	start="$2"
+	flag="$3"
+
+	cat << ENDL
+write /dev/null $name
+sif /$name size 40960
+eo /$name
+set_bmap $flag 10 $((start + 10))
+set_bmap $flag 13 $((start + 13))
+set_bmap $flag 26 $((start + 26))
+set_bmap $flag 29 $((start + 29))
+ec
+sif /$name blocks 8
+setb $((start + 10))
+setb $((start + 13))
+setb $((start + 26))
+setb $((start + 29))
+ENDL
+}
+
+#Files we create:
+# a: fallocate a 40k file
+# b*: falloc sparse file starting at b*
+# c*: falloc spare file ending at c*
+# d: midcluster to midcluster, surrounding sparse
+# e: partial middle cluster alloc
+# f: one big file
+# g*: falloc sparse init file starting at g*
+# h*: falloc sparse init file ending at h*
+# i: midcluster to midcluster, surrounding sparse init
+# j: partial middle cluster alloc
+# k: one big init file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+sif /a size 40960
+fallocate /a 0 39
+ENDL
+echo "ex /a" >> $TMPFILE.cmd2
+
+make_file sample $base --uninit >> $TMPFILE.cmd
+echo "ex /sample" >> $TMPFILE.cmd2
+base=10000
+
+for i in 8 9 10 11 12 13 14 15; do
+	make_file b$i $(($base + (40 * ($i - 8)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /b$i $i 39" >> $TMPFILE.cmd
+	echo "ex /b$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file c$i $(($base + 320 + (40 * ($i - 24)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /c$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /c$i" >> $TMPFILE.cmd2
+done
+
+make_file d $(($base + 640)) --uninit >> $TMPFILE.cmd
+echo "fallocate /d 4 35" >> $TMPFILE.cmd
+echo "ex /d" >> $TMPFILE.cmd2
+
+make_file e $(($base + 680)) --uninit >> $TMPFILE.cmd
+echo "fallocate /e 19 20" >> $TMPFILE.cmd
+echo "ex /e" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null f
+sif /f size 1024
+eo /f
+set_bmap --uninit 0 9000
+ec
+sif /f blocks 2
+setb 9000
+fallocate /f 0 8999
+ENDL
+echo "ex /f" >> $TMPFILE.cmd2
+
+# Now do it again, but with initialized blocks
+base=20000
+for i in 8 9 10 11 12 13 14 15; do
+	make_file g$i $(($base + (40 * ($i - 8)))) >> $TMPFILE.cmd
+	echo "fallocate /g$i $i 39" >> $TMPFILE.cmd
+	echo "ex /g$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file h$i $(($base + 320 + (40 * ($i - 24)))) >> $TMPFILE.cmd
+	echo "fallocate /h$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /h$i" >> $TMPFILE.cmd2
+done
+
+make_file i $(($base + 640)) >> $TMPFILE.cmd
+echo "fallocate /i 4 35" >> $TMPFILE.cmd
+echo "ex /i" >> $TMPFILE.cmd2
+
+make_file j $(($base + 680)) >> $TMPFILE.cmd
+echo "fallocate /j 19 20" >> $TMPFILE.cmd
+echo "ex /j" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null k
+sif /k size 1024
+eo /k
+set_bmap 0 19000
+ec
+sif /k blocks 2
+setb 19000
+fallocate /k 0 8999
+sif /k size 9216000
+ENDL
+echo "ex /k" >> $TMPFILE.cmd2
+
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd > /dev/null 2>&1
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd2 >> $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new $TMPFILE.cmd $TMPFILE.cmd2
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
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
diff --git a/tests/d_fallocate_bigalloc/expect.gz b/tests/d_fallocate_bigalloc/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..1f88dcdc60b63e9984e21d50ecdee982bd327aed
GIT binary patch
literal 2799
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
YfH#>;eXfG{^+a;}+(<JuzRbn-KS;4<*#H0l

literal 0
HcmV?d00001

diff --git a/tests/d_fallocate_bigalloc/name b/tests/d_fallocate_bigalloc/name
new file mode 100644
index 0000000..915645c
--- /dev/null
+++ b/tests/d_fallocate_bigalloc/name
@@ -0,0 +1 @@
+fallocate sparse files and big files with bigalloc
diff --git a/tests/d_fallocate_bigalloc/script b/tests/d_fallocate_bigalloc/script
new file mode 100644
index 0000000..dae8699
--- /dev/null
+++ b/tests/d_fallocate_bigalloc/script
@@ -0,0 +1,176 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+cat > $TMPFILE.conf << ENDL
+[fs_types]
+ext4 = {
+	cluster_size = 8192
+        base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr,^has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit
+        blocksize = 1024
+        inode_size = 256
+        inode_ratio = 16384
+}
+ENDL
+MKE2FS_CONFIG=$TMPFILE.conf $MKE2FS -F -o Linux -b 1024 -O bigalloc -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+rm -rf $TMPFILE.conf
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write files" >> $OUT
+make_file() {
+	name="$1"
+	start="$2"
+	flag="$3"
+
+	cat << ENDL
+write /dev/null $name
+sif /$name size 40960
+eo /$name
+set_bmap $flag 10 $((start + 10))
+set_bmap $flag 13 $((start + 13))
+set_bmap $flag 26 $((start + 26))
+set_bmap $flag 29 $((start + 29))
+ec
+sif /$name blocks 32
+setb $((start + 10))
+setb $((start + 13))
+setb $((start + 26))
+setb $((start + 29))
+ENDL
+}
+
+#Files we create:
+# a: fallocate a 40k file
+# b*: falloc sparse file starting at b*
+# c*: falloc spare file ending at c*
+# d: midcluster to midcluster, surrounding sparse
+# e: partial middle cluster alloc
+# f: one big file
+# g*: falloc sparse init file starting at g*
+# h*: falloc sparse init file ending at h*
+# i: midcluster to midcluster, surrounding sparse init
+# j: partial middle cluster alloc
+# k: one big init file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+sif /a size 40960
+fallocate /a 0 39
+ENDL
+echo "ex /a" >> $TMPFILE.cmd2
+
+make_file sample $base --uninit >> $TMPFILE.cmd
+echo "ex /sample" >> $TMPFILE.cmd2
+base=10000
+
+for i in 8 9 10 11 12 13 14 15; do
+	make_file b$i $(($base + (40 * ($i - 8)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /b$i $i 39" >> $TMPFILE.cmd
+	echo "ex /b$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file c$i $(($base + 320 + (40 * ($i - 24)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /c$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /c$i" >> $TMPFILE.cmd2
+done
+
+make_file d $(($base + 640)) --uninit >> $TMPFILE.cmd
+echo "fallocate /d 4 35" >> $TMPFILE.cmd
+echo "ex /d" >> $TMPFILE.cmd2
+
+make_file e $(($base + 680)) --uninit >> $TMPFILE.cmd
+echo "fallocate /e 19 20" >> $TMPFILE.cmd
+echo "ex /e" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null f
+sif /f size 1024
+eo /f
+set_bmap --uninit 0 9000
+ec
+sif /f blocks 16
+setb 9000
+fallocate /f 0 8999
+ENDL
+echo "ex /f" >> $TMPFILE.cmd2
+
+# Now do it again, but with initialized blocks
+base=20000
+for i in 8 9 10 11 12 13 14 15; do
+	make_file g$i $(($base + (40 * ($i - 8)))) >> $TMPFILE.cmd
+	echo "fallocate /g$i $i 39" >> $TMPFILE.cmd
+	echo "ex /g$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file h$i $(($base + 320 + (40 * ($i - 24)))) >> $TMPFILE.cmd
+	echo "fallocate /h$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /h$i" >> $TMPFILE.cmd2
+done
+
+make_file i $(($base + 640)) >> $TMPFILE.cmd
+echo "fallocate /i 4 35" >> $TMPFILE.cmd
+echo "ex /i" >> $TMPFILE.cmd2
+
+make_file j $(($base + 680)) >> $TMPFILE.cmd
+echo "fallocate /j 19 20" >> $TMPFILE.cmd
+echo "ex /j" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null k
+sif /k size 1024
+eo /k
+set_bmap 0 19000
+ec
+sif /k blocks 16
+setb 19000
+fallocate /k 0 8999
+sif /k size 9216000
+ENDL
+echo "ex /k" >> $TMPFILE.cmd2
+
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd > /dev/null 2>&1
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd2 >> $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new $TMPFILE.cmd $TMPFILE.cmd2
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
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
diff --git a/tests/d_fallocate_blkmap/expect b/tests/d_fallocate_blkmap/expect
new file mode 100644
index 0000000..f7ae606
--- /dev/null
+++ b/tests/d_fallocate_blkmap/expect
@@ -0,0 +1,58 @@
+Creating filesystem with 65536 1k blocks and 4096 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/4096 files (0.0% non-contiguous), 2340/65536 blocks
+Exit status is 0
+debugfs write files
+debugfs: stat /a
+Inode: 12   Type: regular    Mode:  0666   Flags: 0x0
+Generation: 0    Version: 0x00000000:00000000
+User:     0   Group:     0   Size: 40960
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 82
+Fragment:  Address: 0    Number: 0    Size: 0
+Size of extra inode fields: 28
+BLOCKS:
+(0-1):1312-1313, (2-11):8000-8009, (IND):8010, (12-39):8011-8038
+TOTAL: 41
+
+debugfs: stat /b
+Inode: 13   Type: regular    Mode:  0666   Flags: 0x0
+Generation: 0    Version: 0x00000000:00000000
+User:     0   Group:     0   Size: 10240000
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 20082
+Fragment:  Address: 0    Number: 0    Size: 0
+Size of extra inode fields: 28
+BLOCKS:
+(0-11):10000-10011, (IND):10012, (12-267):10013-10268, (DIND):10269, (IND):10270, (268-523):10271-10526, (IND):10527, (524-779):10528-10783, (IND):10784, (780-1035):10785-11040, (IND):11041, (1036-1291):11042-11297, (IND):11298, (1292-1547):11299-11554, (IND):11555, (1548-1803):11556-11811, (IND):11812, (1804-2059):11813-12068, (IND):12069, (2060-2315):12070-12325, (IND):12326, (2316-2571):12327-12582, (IND):12583, (2572-2827):12584-12839, (IND):12840, (2828-3083):12841-13096, (IND):13097, (3084-3339):13098-13353, (IND):13354, (3340-3595):13355-13610, (IND):13611, (3596-3851):13612-13867, (IND):13868, (3852-4107):13869-14124, (IND):14125, (4108-4363):14126-14381, (IND):14382, (4364-4619):14383-14638, (IND):14639, (4620-4875):14640-14895, (IND):14896, (4876-5131):14897-15152, (IND):15153, 
 (5132-5387):15154-15409, (IND):15410, (5388-5643):15411-15666, (IND):15667, (5644-5899):15668-15923, (IND):15924, (5900-6155):15925-16180, (IND):16181, (6156-6411):16182-16437, (IND):16438,!
  (6412-6667):16439-16694, (IND):16695, (6668-6923):16696-16951, (IND):16952, (6924-7179):16953-17208, (IND):17209, (7180-7435):17210-17465, (IND):17466, (7436-7691):17467-17722, (IND):17723, (7692-7947):17724-17979, (IND):17980, (7948-8203):17981-18236, (IND):18237, (8204-8459):18238-18493, (IND):18494, (8460-8715):18495-18750, (IND):18751, (8716-8971):18752-19007, (IND):19008, (8972-9227):19009-19264, (IND):19265, (9228-9483):19266-19521, (IND):19522, (9484-9739):19523-19778, (IND):19779, (9740-9995):19780-20035, (IND):20036, (9996-9999):20037-20040
+TOTAL: 10041
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (6841, counted=6840).
+Fix? yes
+
+Free blocks count wrong for group #1 (1551, counted=1550).
+Fix? yes
+
+Free blocks count wrong (53116, counted=53114).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 13/4096 files (7.7% non-contiguous), 12422/65536 blocks
+Exit status is 1
diff --git a/tests/d_fallocate_blkmap/name b/tests/d_fallocate_blkmap/name
new file mode 100644
index 0000000..ba2b61d
--- /dev/null
+++ b/tests/d_fallocate_blkmap/name
@@ -0,0 +1 @@
+fallocate sparse files and big files on a blockmap fs
diff --git a/tests/d_fallocate_blkmap/script b/tests/d_fallocate_blkmap/script
new file mode 100644
index 0000000..da83cd1
--- /dev/null
+++ b/tests/d_fallocate_blkmap/script
@@ -0,0 +1,85 @@
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
+cat > $TMPFILE.conf << ENDL
+[fs_types]
+ext4 = {
+        base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr,^has_journal,^extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,^64bit
+        blocksize = 1024
+        inode_size = 256
+        inode_ratio = 16384
+}
+ENDL
+MKE2FS_CONFIG=$TMPFILE.conf $MKE2FS -F -o Linux -b 1024 -O ^bigalloc -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+rm -rf $TMPFILE.conf
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write files" >> $OUT
+
+#Files we create:
+# a: fallocate a 40k file
+# k: one big file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+sif /a bmap[2] 8000
+sif /a size 40960
+sif /a i_blocks 2
+setb 8000
+fallocate /a 0 39
+
+write /dev/null b
+sif /b size 10240000
+sif /b bmap[0] 10000
+sif /b i_blocks 2
+setb 10000
+fallocate /b 0 9999
+ENDL
+echo "stat /a" >> $TMPFILE.cmd2
+echo "stat /b" >> $TMPFILE.cmd2
+
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd > /dev/null 2>&1
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd2 >> $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed -e '/^.*time:.*$/d' < $OUT.new >> $OUT
+rm -rf $OUT.new $TMPFILE.cmd $TMPFILE.cmd2
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
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

