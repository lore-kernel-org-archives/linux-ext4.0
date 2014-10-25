From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/39] tests: test resize2fs 32->64 and 64->32bit conversion
 code
Date: Sat, 25 Oct 2014 13:59:23 -0700
Message-ID: <20141025205923.532.70210.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44240 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaJYU76 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:59:58 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add some simple tests to check that flex_bg and meta_bg filesystems
can be converted between 32 and 64bit layouts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/r_32to64bit/expect.gz      |  Bin
 tests/r_32to64bit/name           |    1 +
 tests/r_32to64bit/script         |   75 ++++++++++++++++++++++++++++++++++++++
 tests/r_32to64bit_meta/expect.gz |  Bin
 tests/r_32to64bit_meta/name      |    1 +
 tests/r_32to64bit_meta/script    |   75 ++++++++++++++++++++++++++++++++++++++
 tests/r_64to32bit/expect.gz      |  Bin
 tests/r_64to32bit/name           |    1 +
 tests/r_64to32bit/script         |   75 ++++++++++++++++++++++++++++++++++++++
 tests/r_64to32bit_meta/expect.gz |  Bin
 tests/r_64to32bit_meta/name      |    1 +
 tests/r_64to32bit_meta/script    |   75 ++++++++++++++++++++++++++++++++++++++
 12 files changed, 304 insertions(+)
 create mode 100644 tests/r_32to64bit/expect.gz
 create mode 100644 tests/r_32to64bit/name
 create mode 100644 tests/r_32to64bit/script
 create mode 100644 tests/r_32to64bit_meta/expect.gz
 create mode 100644 tests/r_32to64bit_meta/name
 create mode 100644 tests/r_32to64bit_meta/script
 create mode 100644 tests/r_64to32bit/expect.gz
 create mode 100644 tests/r_64to32bit/name
 create mode 100644 tests/r_64to32bit/script
 create mode 100644 tests/r_64to32bit_meta/expect.gz
 create mode 100644 tests/r_64to32bit_meta/name
 create mode 100644 tests/r_64to32bit_meta/script


diff --git a/tests/r_32to64bit/expect.gz b/tests/r_32to64bit/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..4ba35c8ffb7ca9ef3159f1c40dd507c5fdcff180
GIT binary patch
literal 3144
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
E0Hg9z@c;k-

literal 0
HcmV?d00001

diff --git a/tests/r_32to64bit/name b/tests/r_32to64bit/name
new file mode 100644
index 0000000..fb45fab
--- /dev/null
+++ b/tests/r_32to64bit/name
@@ -0,0 +1 @@
+convert flex_bg 32bit fs to 64bit fs
diff --git a/tests/r_32to64bit/script b/tests/r_32to64bit/script
new file mode 100644
index 0000000..73493a4
--- /dev/null
+++ b/tests/r_32to64bit/script
@@ -0,0 +1,75 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "resize2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "resize2fs test.img -b" >> $OUT
+$RESIZE2FS $TMPFILE -b -f 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' -i $OUT
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
+fi
+
+rm $EXP
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/r_32to64bit_meta/expect.gz b/tests/r_32to64bit_meta/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..d6985ecb82b5b7bd9f5046ba99a7e6cf2d60963a
GIT binary patch
literal 2956
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

literal 0
HcmV?d00001

diff --git a/tests/r_32to64bit_meta/name b/tests/r_32to64bit_meta/name
new file mode 100644
index 0000000..d83492e
--- /dev/null
+++ b/tests/r_32to64bit_meta/name
@@ -0,0 +1 @@
+convert meta_bg 32bit fs to 64bit fs
diff --git a/tests/r_32to64bit_meta/script b/tests/r_32to64bit_meta/script
new file mode 100644
index 0000000..5d02114
--- /dev/null
+++ b/tests/r_32to64bit_meta/script
@@ -0,0 +1,75 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,meta_bg,^resize_inode
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "resize2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "resize2fs test.img -b" >> $OUT
+$RESIZE2FS $TMPFILE -b -f 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' -i $OUT
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
+fi
+
+rm $EXP
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/r_64to32bit/expect.gz b/tests/r_64to32bit/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..375a749e42b2a49724e874761048ac4cb91e010b
GIT binary patch
literal 3179
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

literal 0
HcmV?d00001

diff --git a/tests/r_64to32bit/name b/tests/r_64to32bit/name
new file mode 100644
index 0000000..4c82371
--- /dev/null
+++ b/tests/r_64to32bit/name
@@ -0,0 +1 @@
+convert flex_bg 64bit fs to 32bit fs
diff --git a/tests/r_64to32bit/script b/tests/r_64to32bit/script
new file mode 100644
index 0000000..83a37bd
--- /dev/null
+++ b/tests/r_64to32bit/script
@@ -0,0 +1,75 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "resize2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "resize2fs test.img -s" >> $OUT
+$RESIZE2FS $TMPFILE -s -f 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' -i $OUT
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
+fi
+
+rm $EXP
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/r_64to32bit_meta/expect.gz b/tests/r_64to32bit_meta/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..e39d01f1bc21038a73c3678f11dd66fba8c25aeb
GIT binary patch
literal 2924
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
Y2I|58$YVa1zGLR)AG6a^_5i>?0Su9%RsaA1

literal 0
HcmV?d00001

diff --git a/tests/r_64to32bit_meta/name b/tests/r_64to32bit_meta/name
new file mode 100644
index 0000000..e99ed8b
--- /dev/null
+++ b/tests/r_64to32bit_meta/name
@@ -0,0 +1 @@
+convert meta_bg 64bit fs to 32bit fs
diff --git a/tests/r_64to32bit_meta/script b/tests/r_64to32bit_meta/script
new file mode 100644
index 0000000..e2190ce
--- /dev/null
+++ b/tests/r_64to32bit_meta/script
@@ -0,0 +1,75 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,meta_bg,^resize_inode,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "resize2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "resize2fs test.img -s" >> $OUT
+$RESIZE2FS $TMPFILE -s -f 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' -i $OUT
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
+fi
+
+rm $EXP
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+

