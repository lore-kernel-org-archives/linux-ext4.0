From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/34] tests: test debugfs punch command
Date: Sat, 13 Sep 2014 15:14:23 -0700
Message-ID: <20140913221423.13646.84263.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24597 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaIMWO2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:14:28 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test punching out various parts of sparse files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/f_punch/expect          |  143 +++++++++++++++++++++++++++++++++++++++++
 tests/f_punch/name            |    1 
 tests/f_punch/script          |  129 +++++++++++++++++++++++++++++++++++++
 tests/f_punch_bigalloc/expect |  142 +++++++++++++++++++++++++++++++++++++++++
 tests/f_punch_bigalloc/name   |    1 
 tests/f_punch_bigalloc/script |  130 +++++++++++++++++++++++++++++++++++++
 6 files changed, 546 insertions(+)
 create mode 100644 tests/f_punch/expect
 create mode 100644 tests/f_punch/name
 create mode 100644 tests/f_punch/script
 create mode 100644 tests/f_punch_bigalloc/expect
 create mode 100644 tests/f_punch_bigalloc/name
 create mode 100644 tests/f_punch_bigalloc/script


diff --git a/tests/f_punch/expect b/tests/f_punch/expect
new file mode 100644
index 0000000..a5b7fd8
--- /dev/null
+++ b/tests/f_punch/expect
@@ -0,0 +1,143 @@
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
+test_filesys: 11/4096 files (0.0% non-contiguous), 2345/65536 blocks
+Exit status is 0
+debugfs write files
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+debugfs: ex /sample
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1323              0
+ 1/ 1   1/  5     0 -     9  1313 -  1322     10 Uninit
+ 1/ 1   2/  5    11 -    12  1324 -  1325      2 Uninit
+ 1/ 1   3/  5    14 -    25  1327 -  1338     12 Uninit
+ 1/ 1   4/  5    27 -    28  1340 -  1341      2 Uninit
+ 1/ 1   5/  5    30 -    39  1343 -  1352     10 Uninit
+debugfs: ex /b8
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1390              0
+ 1/ 1   1/  4     0 -     0  1326 -  1326      1 Uninit
+ 1/ 1   2/  4     1 -     1  1339 -  1339      1 Uninit
+ 1/ 1   3/  4     2 -     2  1342 -  1342      1 Uninit
+ 1/ 1   4/  4     3 -     7  1353 -  1357      5 Uninit
+debugfs: ex /b9
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1368              0
+ 1/ 1   1/  1     0 -     8  1358 -  1366      9 Uninit
+debugfs: ex /b10
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1378              0
+ 1/ 1   1/  2     0 -     0  1367 -  1367      1 Uninit
+ 1/ 1   2/  2     1 -     9  1369 -  1377      9 Uninit
+debugfs: ex /b11
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1389              0
+ 1/ 1   1/  1     0 -     9  1379 -  1388     10 Uninit
+debugfs: ex /b12
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1401              0
+ 1/ 1   1/  2     0 -     9  1391 -  1400     10 Uninit
+ 1/ 1   2/  2    11 -    11  1402 -  1402      1 Uninit
+debugfs: ex /b13
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1413              0
+ 1/ 1   1/  2     0 -     9  1403 -  1412     10 Uninit
+ 1/ 1   2/  2    11 -    12  1414 -  1415      2 Uninit
+debugfs: ex /b14
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1426              0
+ 1/ 1   1/  2     0 -     9  1416 -  1425     10 Uninit
+ 1/ 1   2/  2    11 -    12  1427 -  1428      2 Uninit
+debugfs: ex /b15
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1439              0
+ 1/ 1   1/  3     0 -     9  1429 -  1438     10 Uninit
+ 1/ 1   2/  3    11 -    12  1440 -  1441      2 Uninit
+ 1/ 1   3/  3    14 -    14  1443 -  1443      1 Uninit
+debugfs: ex /c24
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    25 - 4294967295  1453         4294967271
+ 1/ 1   1/  3    25 -    25  1468 -  1468      1 Uninit
+ 1/ 1   2/  3    27 -    28  1470 -  1471      2 Uninit
+ 1/ 1   3/  3    30 -    39  1473 -  1482     10 Uninit
+debugfs: ex /c25
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    27 - 4294967295  1483         4294967269
+ 1/ 1   1/  2    27 -    28  1485 -  1486      2 Uninit
+ 1/ 1   2/  2    30 -    39  1488 -  1497     10 Uninit
+debugfs: ex /c26
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    27 - 4294967295  1484         4294967269
+ 1/ 1   1/  2    27 -    28  1498 -  1499      2 Uninit
+ 1/ 1   2/  2    30 -    39  1501 -  1510     10 Uninit
+debugfs: ex /c27
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    28 - 4294967295  1487         4294967268
+ 1/ 1   1/  2    28 -    28  1512 -  1512      1 Uninit
+ 1/ 1   2/  2    30 -    39  1514 -  1523     10 Uninit
+debugfs: ex /c28
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    30 - 4294967295  1500         4294967266
+ 1/ 1   1/  1    30 -    39  1526 -  1535     10 Uninit
+debugfs: ex /c29
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    30 - 4294967295  1511         4294967266
+ 1/ 1   1/  1    30 -    39  1537 -  1546     10 Uninit
+debugfs: ex /c30
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    31 - 4294967295  1513         4294967265
+ 1/ 1   1/  1    31 -    39  1549 -  1557      9 Uninit
+debugfs: ex /c31
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    32 - 4294967295  1524         4294967264
+ 1/ 1   1/  1    32 -    39  1560 -  1567      8 Uninit
+debugfs: ex /d
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1525              0
+ 1/ 1   1/  3     0 -     0  1442 -  1442      1 Uninit
+ 1/ 1   2/  3     1 -     3  1444 -  1446      3 Uninit
+ 1/ 1   3/  3    36 -    39  1573 -  1576      4 Uninit
+debugfs: ex /e
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1547              0
+ 1/ 1   1/ 11     0 -     5  1447 -  1452      6 Uninit
+ 1/ 1   2/ 11     6 -     9  1454 -  1457      4 Uninit
+ 1/ 1   3/ 11    11 -    12  1459 -  1460      2 Uninit
+ 1/ 1   4/ 11    14 -    18  1462 -  1466      5 Uninit
+ 1/ 1   5/ 11    21 -    21  1472 -  1472      1 Uninit
+ 1/ 1   6/ 11    22 -    22  1536 -  1536      1 Uninit
+ 1/ 1   7/ 11    23 -    23  1548 -  1548      1 Uninit
+ 1/ 1   8/ 11    24 -    25  1558 -  1559      2 Uninit
+ 1/ 1   9/ 11    27 -    28  1569 -  1570      2 Uninit
+ 1/ 1  10/ 11    30 -    30  1572 -  1572      1 Uninit
+ 1/ 1  11/ 11    31 -    39  1577 -  1585      9 Uninit
+debugfs: ex /f
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  2     0 -     0  9000 -  9000      1 Uninit
+ 0/ 0   2/  2  8999 -  8999 17999 - 17999      1 Uninit
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #1 (7934, counted=7933).
+Fix? yes
+
+Free blocks count wrong (62923, counted=62922).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 32/4096 files (43.8% non-contiguous), 2614/65536 blocks
+Exit status is 1
diff --git a/tests/f_punch/name b/tests/f_punch/name
new file mode 100644
index 0000000..724639f
--- /dev/null
+++ b/tests/f_punch/name
@@ -0,0 +1 @@
+punch sparse files and big files
diff --git a/tests/f_punch/script b/tests/f_punch/script
new file mode 100644
index 0000000..db6c4dd
--- /dev/null
+++ b/tests/f_punch/script
@@ -0,0 +1,129 @@
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
+fallocate /$name 0 39
+punch /$name 10 10
+punch /$name 13 13
+punch /$name 26 26
+punch /$name 29 29
+ENDL
+}
+
+#Files we create:
+# a: punch a 40k file
+# b*: punch sparse file starting at b*
+# c*: punch spare file ending at c*
+# d: midcluster to midcluster, surrounding sparse
+# e: partial middle cluster alloc
+# f: one big file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+fallocate /a 0 39
+punch /a 0 39
+ENDL
+echo "ex /a" >> $TMPFILE.cmd2
+
+make_file sample $base --uninit >> $TMPFILE.cmd
+echo "ex /sample" >> $TMPFILE.cmd2
+base=10000
+
+for i in 8 9 10 11 12 13 14 15; do
+	make_file b$i $(($base + (40 * ($i - 8)))) --uninit >> $TMPFILE.cmd
+	echo "punch /b$i $i 39" >> $TMPFILE.cmd
+	echo "ex /b$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file c$i $(($base + 320 + (40 * ($i - 24)))) --uninit >> $TMPFILE.cmd
+	echo "punch /c$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /c$i" >> $TMPFILE.cmd2
+done
+
+make_file d $(($base + 640)) --uninit >> $TMPFILE.cmd
+echo "punch /d 4 35" >> $TMPFILE.cmd
+echo "ex /d" >> $TMPFILE.cmd2
+
+make_file e $(($base + 680)) --uninit >> $TMPFILE.cmd
+echo "punch /e 19 20" >> $TMPFILE.cmd
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
+punch /f 1 8998
+ENDL
+echo "ex /f" >> $TMPFILE.cmd2
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
diff --git a/tests/f_punch_bigalloc/expect b/tests/f_punch_bigalloc/expect
new file mode 100644
index 0000000..adbef89
--- /dev/null
+++ b/tests/f_punch_bigalloc/expect
@@ -0,0 +1,142 @@
+
+Warning: the bigalloc feature is still under development
+See https://ext4.wiki.kernel.org/index.php/Bigalloc for more information
+
+Creating filesystem with 65536 1k blocks and 4096 inodes
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
+test_filesys: 11/4096 files (9.1% non-contiguous), 1144/65536 blocks
+Exit status is 0
+debugfs write files
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+debugfs: ex /sample
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1184              0
+ 1/ 1   1/  5     0 -     9  1144 -  1153     10 Uninit
+ 1/ 1   2/  5    11 -    12  1155 -  1156      2 Uninit
+ 1/ 1   3/  5    14 -    25  1158 -  1169     12 Uninit
+ 1/ 1   4/  5    27 -    28  1171 -  1172      2 Uninit
+ 1/ 1   5/  5    30 -    39  1174 -  1183     10 Uninit
+debugfs: ex /b8
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1232              0
+ 1/ 1   1/  1     0 -     7  1192 -  1199      8 Uninit
+debugfs: ex /b9
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1248              0
+ 1/ 1   1/  1     0 -     8  1200 -  1208      9 Uninit
+debugfs: ex /b10
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1272              0
+ 1/ 1   1/  1     0 -     9  1216 -  1225     10 Uninit
+debugfs: ex /b11
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1296              0
+ 1/ 1   1/  2     0 -     7  1240 -  1247      8 Uninit
+ 1/ 1   2/  2     8 -     9  1256 -  1257      2 Uninit
+debugfs: ex /b12
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1320              0
+ 1/ 1   1/  3     0 -     7  1264 -  1271      8 Uninit
+ 1/ 1   2/  3     8 -     9  1280 -  1281      2 Uninit
+ 1/ 1   3/  3    11 -    11  1283 -  1283      1 Uninit
+debugfs: ex /b13
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1344              0
+ 1/ 1   1/  3     0 -     7  1288 -  1295      8 Uninit
+ 1/ 1   2/  3     8 -     9  1304 -  1305      2 Uninit
+ 1/ 1   3/  3    11 -    12  1307 -  1308      2 Uninit
+debugfs: ex /b14
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1368              0
+ 1/ 1   1/  3     0 -     7  1312 -  1319      8 Uninit
+ 1/ 1   2/  3     8 -     9  1328 -  1329      2 Uninit
+ 1/ 1   3/  3    11 -    12  1331 -  1332      2 Uninit
+debugfs: ex /b15
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1392              0
+ 1/ 1   1/  4     0 -     7  1336 -  1343      8 Uninit
+ 1/ 1   2/  4     8 -     9  1352 -  1353      2 Uninit
+ 1/ 1   3/  4    11 -    12  1355 -  1356      2 Uninit
+ 1/ 1   4/  4    14 -    14  1358 -  1358      1 Uninit
+debugfs: ex /c24
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    25 - 4294967295  1416         4294967271
+ 1/ 1   1/  3    25 -    25  1401 -  1401      1 Uninit
+ 1/ 1   2/  3    27 -    28  1403 -  1404      2 Uninit
+ 1/ 1   3/  3    30 -    39  1406 -  1415     10 Uninit
+debugfs: ex /c25
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    27 - 4294967295  1440         4294967269
+ 1/ 1   1/  2    27 -    28  1427 -  1428      2 Uninit
+ 1/ 1   2/  2    30 -    39  1430 -  1439     10 Uninit
+debugfs: ex /c26
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    27 - 4294967295  1464         4294967269
+ 1/ 1   1/  2    27 -    28  1451 -  1452      2 Uninit
+ 1/ 1   2/  2    30 -    39  1454 -  1463     10 Uninit
+debugfs: ex /c27
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    28 - 4294967295  1488         4294967268
+ 1/ 1   1/  2    28 -    28  1476 -  1476      1 Uninit
+ 1/ 1   2/  2    30 -    39  1478 -  1487     10 Uninit
+debugfs: ex /c28
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    30 - 4294967295  1512         4294967266
+ 1/ 1   1/  1    30 -    39  1502 -  1511     10 Uninit
+debugfs: ex /c29
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    30 - 4294967295  1536         4294967266
+ 1/ 1   1/  1    30 -    39  1526 -  1535     10 Uninit
+debugfs: ex /c30
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    31 - 4294967295  1560         4294967265
+ 1/ 1   1/  1    31 -    39  1551 -  1559      9 Uninit
+debugfs: ex /c31
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1    32 - 4294967295  1584         4294967264
+ 1/ 1   1/  1    32 -    39  1576 -  1583      8 Uninit
+debugfs: ex /d
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1600              0
+ 1/ 1   1/  2     0 -     3  1360 -  1363      4 Uninit
+ 1/ 1   2/  2    36 -    39  1596 -  1599      4 Uninit
+debugfs: ex /e
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 - 4294967295  1624              0
+ 1/ 1   1/  8     0 -     9  1376 -  1385     10 Uninit
+ 1/ 1   2/  8    11 -    12  1387 -  1388      2 Uninit
+ 1/ 1   3/  8    14 -    15  1390 -  1391      2 Uninit
+ 1/ 1   4/  8    16 -    18  1568 -  1570      3 Uninit
+ 1/ 1   5/  8    21 -    23  1573 -  1575      3 Uninit
+ 1/ 1   6/  8    24 -    25  1608 -  1609      2 Uninit
+ 1/ 1   7/  8    27 -    28  1611 -  1612      2 Uninit
+ 1/ 1   8/  8    30 -    39  1614 -  1623     10 Uninit
+debugfs: ex /f
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  2     0 -     0  9000 -  9000      1 Uninit
+ 0/ 0   2/  2  8999 -  8999 17999 - 17999      1 Uninit
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (7987, counted=7986).
+Fix? yes
+
+Free blocks count wrong (63896, counted=63888).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 32/4096 files (43.8% non-contiguous), 1648/65536 blocks
+Exit status is 1
diff --git a/tests/f_punch_bigalloc/name b/tests/f_punch_bigalloc/name
new file mode 100644
index 0000000..6d61ebe
--- /dev/null
+++ b/tests/f_punch_bigalloc/name
@@ -0,0 +1 @@
+punch sparse files and big files with bigalloc
diff --git a/tests/f_punch_bigalloc/script b/tests/f_punch_bigalloc/script
new file mode 100644
index 0000000..5784154
--- /dev/null
+++ b/tests/f_punch_bigalloc/script
@@ -0,0 +1,130 @@
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
+fallocate /$name 0 39
+punch /$name 10 10
+punch /$name 13 13
+punch /$name 26 26
+punch /$name 29 29
+ENDL
+}
+
+#Files we create:
+# a: punch a 40k file
+# b*: punch sparse file starting at b*
+# c*: punch spare file ending at c*
+# d: midcluster to midcluster, surrounding sparse
+# e: partial middle cluster alloc
+# f: one big file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+fallocate /a 0 39
+punch /a 0 39
+ENDL
+echo "ex /a" >> $TMPFILE.cmd2
+
+make_file sample $base --uninit >> $TMPFILE.cmd
+echo "ex /sample" >> $TMPFILE.cmd2
+base=10000
+
+for i in 8 9 10 11 12 13 14 15; do
+	make_file b$i $(($base + (40 * ($i - 8)))) --uninit >> $TMPFILE.cmd
+	echo "punch /b$i $i 39" >> $TMPFILE.cmd
+	echo "ex /b$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file c$i $(($base + 320 + (40 * ($i - 24)))) --uninit >> $TMPFILE.cmd
+	echo "punch /c$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /c$i" >> $TMPFILE.cmd2
+done
+
+make_file d $(($base + 640)) --uninit >> $TMPFILE.cmd
+echo "punch /d 4 35" >> $TMPFILE.cmd
+echo "ex /d" >> $TMPFILE.cmd2
+
+make_file e $(($base + 680)) --uninit >> $TMPFILE.cmd
+echo "punch /e 19 20" >> $TMPFILE.cmd
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
+punch /f 1 8998
+ENDL
+echo "ex /f" >> $TMPFILE.cmd2
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

