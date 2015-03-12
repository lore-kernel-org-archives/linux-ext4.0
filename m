From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v1 4/4] e2fsprogs: add test for mke2fs -E first_inode
 and resize2fs -I
Date: Thu, 12 Mar 2015 19:20:16 +0300
Message-ID: <20150312162016.17173.18266.stgit@buzz>
References: <20150312161341.17173.96760.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1m.cmail.yandex.net ([5.255.216.100]:46031 "EHLO
	forward-corp1m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932388AbbCLQUV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2015 12:20:21 -0400
In-Reply-To: <20150312161341.17173.96760.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test creates new filesystem with 10 special inodes and then reserves next 10.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 tests/r_resize_special/expect |  292 +++++++++++++++++++++++++++++++++++++++++
 tests/r_resize_special/name   |    1 
 tests/r_resize_special/script |   47 +++++++
 3 files changed, 340 insertions(+)
 create mode 100644 tests/r_resize_special/expect
 create mode 100644 tests/r_resize_special/name
 create mode 100644 tests/r_resize_special/script

diff --git a/tests/r_resize_special/expect b/tests/r_resize_special/expect
new file mode 100644
index 000000000000..8aba1ea0abd5
--- /dev/null
+++ b/tests/r_resize_special/expect
@@ -0,0 +1,292 @@
+mke2fs -E first_inode=11 -q -F -o Linux -b 1024 -g 1024 test.img 16384
+dumpe2fs test.img
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              4096
+Block count:              16384
+Reserved block count:     819
+Free blocks:              14277
+Free inodes:              4085
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Reserved GDT blocks:      256
+Blocks per group:         1024
+Fragments per group:      1024
+Inodes per group:         256
+Inode blocks per group:   32
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:	          128
+Default directory hash:   half_md4
+
+
+Group 0: (Blocks 1-1024)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-258
+  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
+  Inode table at 261-292 (+260)
+  718 free blocks, 245 free inodes, 2 directories
+  Free blocks: 307-1024
+  Free inodes: 12-256
+Group 1: (Blocks 1025-2048)
+  Backup superblock at 1025, Group descriptors at 1026-1026
+  Reserved GDT blocks at 1027-1282
+  Block bitmap at 1283 (+258), Inode bitmap at 1284 (+259)
+  Inode table at 1285-1316 (+260)
+  732 free blocks, 256 free inodes, 0 directories
+  Free blocks: 1317-2048
+  Free inodes: 257-512
+Group 2: (Blocks 2049-3072)
+  Block bitmap at 2049 (+0), Inode bitmap at 2050 (+1)
+  Inode table at 2051-2082 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 2083-3072
+  Free inodes: 513-768
+Group 3: (Blocks 3073-4096)
+  Backup superblock at 3073, Group descriptors at 3074-3074
+  Reserved GDT blocks at 3075-3330
+  Block bitmap at 3331 (+258), Inode bitmap at 3332 (+259)
+  Inode table at 3333-3364 (+260)
+  732 free blocks, 256 free inodes, 0 directories
+  Free blocks: 3365-4096
+  Free inodes: 769-1024
+Group 4: (Blocks 4097-5120)
+  Block bitmap at 4097 (+0), Inode bitmap at 4098 (+1)
+  Inode table at 4099-4130 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 4131-5120
+  Free inodes: 1025-1280
+Group 5: (Blocks 5121-6144)
+  Backup superblock at 5121, Group descriptors at 5122-5122
+  Reserved GDT blocks at 5123-5378
+  Block bitmap at 5379 (+258), Inode bitmap at 5380 (+259)
+  Inode table at 5381-5412 (+260)
+  732 free blocks, 256 free inodes, 0 directories
+  Free blocks: 5413-6144
+  Free inodes: 1281-1536
+Group 6: (Blocks 6145-7168)
+  Block bitmap at 6145 (+0), Inode bitmap at 6146 (+1)
+  Inode table at 6147-6178 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 6179-7168
+  Free inodes: 1537-1792
+Group 7: (Blocks 7169-8192)
+  Backup superblock at 7169, Group descriptors at 7170-7170
+  Reserved GDT blocks at 7171-7426
+  Block bitmap at 7427 (+258), Inode bitmap at 7428 (+259)
+  Inode table at 7429-7460 (+260)
+  732 free blocks, 256 free inodes, 0 directories
+  Free blocks: 7461-8192
+  Free inodes: 1793-2048
+Group 8: (Blocks 8193-9216)
+  Block bitmap at 8193 (+0), Inode bitmap at 8194 (+1)
+  Inode table at 8195-8226 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 8227-9216
+  Free inodes: 2049-2304
+Group 9: (Blocks 9217-10240)
+  Backup superblock at 9217, Group descriptors at 9218-9218
+  Reserved GDT blocks at 9219-9474
+  Block bitmap at 9475 (+258), Inode bitmap at 9476 (+259)
+  Inode table at 9477-9508 (+260)
+  732 free blocks, 256 free inodes, 0 directories
+  Free blocks: 9509-10240
+  Free inodes: 2305-2560
+Group 10: (Blocks 10241-11264)
+  Block bitmap at 10241 (+0), Inode bitmap at 10242 (+1)
+  Inode table at 10243-10274 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 10275-11264
+  Free inodes: 2561-2816
+Group 11: (Blocks 11265-12288)
+  Block bitmap at 11265 (+0), Inode bitmap at 11266 (+1)
+  Inode table at 11267-11298 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 11299-12288
+  Free inodes: 2817-3072
+Group 12: (Blocks 12289-13312)
+  Block bitmap at 12289 (+0), Inode bitmap at 12290 (+1)
+  Inode table at 12291-12322 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 12323-13312
+  Free inodes: 3073-3328
+Group 13: (Blocks 13313-14336)
+  Block bitmap at 13313 (+0), Inode bitmap at 13314 (+1)
+  Inode table at 13315-13346 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 13347-14336
+  Free inodes: 3329-3584
+Group 14: (Blocks 14337-15360)
+  Block bitmap at 14337 (+0), Inode bitmap at 14338 (+1)
+  Inode table at 14339-14370 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 14371-15360
+  Free inodes: 3585-3840
+Group 15: (Blocks 15361-16383)
+  Block bitmap at 15361 (+0), Inode bitmap at 15362 (+1)
+  Inode table at 15363-15394 (+2)
+  989 free blocks, 256 free inodes, 0 directories
+  Free blocks: 15395-16383
+  Free inodes: 3841-4096
+resize2fs -I 21 test.img
+Reserving special inodes.
+The filesystem on test.img is now 16384 (1k) blocks long.
+
+dumpe2fs test.img
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              4096
+Block count:              16384
+Reserved block count:     819
+Free blocks:              14277
+Free inodes:              4075
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Reserved GDT blocks:      256
+Blocks per group:         1024
+Fragments per group:      1024
+Inodes per group:         256
+Inode blocks per group:   32
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              21
+Inode size:	          128
+Default directory hash:   half_md4
+
+
+Group 0: (Blocks 1-1024)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-258
+  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
+  Inode table at 261-292 (+260)
+  718 free blocks, 235 free inodes, 2 directories
+  Free blocks: 307-1024
+  Free inodes: 22-256
+Group 1: (Blocks 1025-2048)
+  Backup superblock at 1025, Group descriptors at 1026-1026
+  Reserved GDT blocks at 1027-1282
+  Block bitmap at 1283 (+258), Inode bitmap at 1284 (+259)
+  Inode table at 1285-1316 (+260)
+  732 free blocks, 256 free inodes, 0 directories
+  Free blocks: 1317-2048
+  Free inodes: 257-512
+Group 2: (Blocks 2049-3072)
+  Block bitmap at 2049 (+0), Inode bitmap at 2050 (+1)
+  Inode table at 2051-2082 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 2083-3072
+  Free inodes: 513-768
+Group 3: (Blocks 3073-4096)
+  Backup superblock at 3073, Group descriptors at 3074-3074
+  Reserved GDT blocks at 3075-3330
+  Block bitmap at 3331 (+258), Inode bitmap at 3332 (+259)
+  Inode table at 3333-3364 (+260)
+  732 free blocks, 256 free inodes, 0 directories
+  Free blocks: 3365-4096
+  Free inodes: 769-1024
+Group 4: (Blocks 4097-5120)
+  Block bitmap at 4097 (+0), Inode bitmap at 4098 (+1)
+  Inode table at 4099-4130 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 4131-5120
+  Free inodes: 1025-1280
+Group 5: (Blocks 5121-6144)
+  Backup superblock at 5121, Group descriptors at 5122-5122
+  Reserved GDT blocks at 5123-5378
+  Block bitmap at 5379 (+258), Inode bitmap at 5380 (+259)
+  Inode table at 5381-5412 (+260)
+  732 free blocks, 256 free inodes, 0 directories
+  Free blocks: 5413-6144
+  Free inodes: 1281-1536
+Group 6: (Blocks 6145-7168)
+  Block bitmap at 6145 (+0), Inode bitmap at 6146 (+1)
+  Inode table at 6147-6178 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 6179-7168
+  Free inodes: 1537-1792
+Group 7: (Blocks 7169-8192)
+  Backup superblock at 7169, Group descriptors at 7170-7170
+  Reserved GDT blocks at 7171-7426
+  Block bitmap at 7427 (+258), Inode bitmap at 7428 (+259)
+  Inode table at 7429-7460 (+260)
+  732 free blocks, 256 free inodes, 0 directories
+  Free blocks: 7461-8192
+  Free inodes: 1793-2048
+Group 8: (Blocks 8193-9216)
+  Block bitmap at 8193 (+0), Inode bitmap at 8194 (+1)
+  Inode table at 8195-8226 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 8227-9216
+  Free inodes: 2049-2304
+Group 9: (Blocks 9217-10240)
+  Backup superblock at 9217, Group descriptors at 9218-9218
+  Reserved GDT blocks at 9219-9474
+  Block bitmap at 9475 (+258), Inode bitmap at 9476 (+259)
+  Inode table at 9477-9508 (+260)
+  732 free blocks, 256 free inodes, 0 directories
+  Free blocks: 9509-10240
+  Free inodes: 2305-2560
+Group 10: (Blocks 10241-11264)
+  Block bitmap at 10241 (+0), Inode bitmap at 10242 (+1)
+  Inode table at 10243-10274 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 10275-11264
+  Free inodes: 2561-2816
+Group 11: (Blocks 11265-12288)
+  Block bitmap at 11265 (+0), Inode bitmap at 11266 (+1)
+  Inode table at 11267-11298 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 11299-12288
+  Free inodes: 2817-3072
+Group 12: (Blocks 12289-13312)
+  Block bitmap at 12289 (+0), Inode bitmap at 12290 (+1)
+  Inode table at 12291-12322 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 12323-13312
+  Free inodes: 3073-3328
+Group 13: (Blocks 13313-14336)
+  Block bitmap at 13313 (+0), Inode bitmap at 13314 (+1)
+  Inode table at 13315-13346 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 13347-14336
+  Free inodes: 3329-3584
+Group 14: (Blocks 14337-15360)
+  Block bitmap at 14337 (+0), Inode bitmap at 14338 (+1)
+  Inode table at 14339-14370 (+2)
+  990 free blocks, 256 free inodes, 0 directories
+  Free blocks: 14371-15360
+  Free inodes: 3585-3840
+Group 15: (Blocks 15361-16383)
+  Block bitmap at 15361 (+0), Inode bitmap at 15362 (+1)
+  Inode table at 15363-15394 (+2)
+  989 free blocks, 256 free inodes, 0 directories
+  Free blocks: 15395-16383
+  Free inodes: 3841-4096
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 21/4096 files (0.0% non-contiguous), 2107/16384 blocks
+Exit status is 0
diff --git a/tests/r_resize_special/name b/tests/r_resize_special/name
new file mode 100644
index 000000000000..6ac3f588bee2
--- /dev/null
+++ b/tests/r_resize_special/name
@@ -0,0 +1 @@
+reserve more special inodes in filesystem
diff --git a/tests/r_resize_special/script b/tests/r_resize_special/script
new file mode 100644
index 000000000000..99abaa3f7a36
--- /dev/null
+++ b/tests/r_resize_special/script
@@ -0,0 +1,47 @@
+if test -x $RESIZE2FS_EXE; then
+
+FSCK_OPT=-yf
+OUT=$test_name.log
+EXP=$test_dir/expect
+cp /dev/null $OUT
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -E first_inode=11 -q -F -o Linux -b 1024 -g 1024 test.img 16384 > $OUT
+$MKE2FS -E first_inode=11 -q -F -o Linux -b 1024 -g 1024 $TMPFILE 16384 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
+
+echo dumpe2fs test.img >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e '/Block bitmap.*$/N;s/\n  Inode bitmap/, Inode bitmap/g' >> $OUT
+
+echo resize2fs -I 21 test.img>> $OUT
+$RESIZE2FS -I 21 $TMPFILE 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
+
+echo dumpe2fs test.img >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e '/Block bitmap.*$/N;s/\n  Inode bitmap/, Inode bitmap/g' >> $OUT
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
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
+else #if test -x $RESIZE2FS; then
+	echo "$test_name: $test_description: skipped"
+fi

