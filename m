From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] tests: use make rules to run tests in parallel (v2)
Date: Wed, 23 May 2012 14:09:20 -0600
Message-ID: <1337803760-20587-1-git-send-email-adilger@whamcloud.com>
References: <1337797871-19357-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:19745 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab2EWUJX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 May 2012 16:09:23 -0400
In-Reply-To: <1337797871-19357-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change the e2fsck/mke2fs/tune2fs/e2image/debugfs regression tests
to be driven by Makefile rules instead of by a script loop.  This
allows the tests to be run in parallel like a build and reduces
testing time significantly.

One major change to the tests themselves is to printing the test
name, description, and status together after the test has passed
or failed, to avoid mixing lines from the tests.  The other major
change is to use unique filenames for each test, which was mostly
handled already via b4db1e4c7461a50e18c9fd135b9f1ba6f27e4390, but
in some cases temporary files are changed to use $test_name.tmp to
avoid any collision between running tests.

On my old 2-CPU system it reduced the testing time from 160s to 40s.
Most of the savings is running the MMP test delays going in parallel,
but it still takes the length of the slowest test, f_mmp_garbage.
There will be ongoing benefit in the future as more tests are added
since the wallclock time will not substantially increase.

Tests were run with "make -j", "make -j4", "make -j12", "make -j16",
and "make -j24" repeatedly without any test failures.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 .gitignore                        |    1 +
 tests/Makefile.in                 |   35 ++++++++++++++------
 tests/d_loaddump/expect           |    6 ++--
 tests/d_loaddump/script           |   13 +++----
 tests/defaults/e_script           |    4 +-
 tests/e_brel_bma/script           |    3 +-
 tests/e_icount_normal/name        |    2 +-
 tests/e_irel_ima/script           |    3 +-
 tests/f_dup4/script               |    5 +--
 tests/f_dup_de/script             |    3 +-
 tests/f_dup_resize/script         |    5 +--
 tests/f_ext_journal/name          |    1 +
 tests/f_h_badnode/script          |    3 +-
 tests/f_h_badroot/script          |    3 +-
 tests/f_h_normal/script           |    3 +-
 tests/f_h_reindex/script          |    3 +-
 tests/f_h_unsigned/script         |    3 +-
 tests/f_imagic_fs/script          |    3 +-
 tests/f_mmp/script                |   15 ++++-----
 tests/f_mmp_garbage/script        |    7 ++--
 tests/f_rehash_dir/name           |    1 +
 tests/f_resize_inode/script       |   12 +++----
 tests/f_uninit_last_uninit/script |    3 +-
 tests/f_unused_itable/name        |    2 +-
 tests/i_e2image/script            |   13 +++-----
 tests/m_mkfs_overhead/script      |    8 ++---
 tests/m_mmp/script                |    4 +-
 tests/r_inline_xattr/script       |    8 ++---
 tests/r_move_itable/script        |    9 ++---
 tests/r_resize_inode/script       |   13 +++----
 tests/run_e2fsck                  |   10 +++---
 tests/t_ext_jnl_rm/script         |    8 ++---
 tests/t_mmp_1on/script            |   13 +++----
 tests/t_mmp_2off/script           |   13 +++----
 tests/test_one.in                 |   63 +++++++++++++++++++++++++++++++++++++
 tests/test_post                   |   17 ++++++++++
 tests/test_script.in              |   61 ++---------------------------------
 tests/u_mke2fs/script             |    8 ++---
 tests/u_tune2fs/script            |    8 ++---
 39 files changed, 203 insertions(+), 192 deletions(-)
 create mode 100644 tests/f_ext_journal/name
 create mode 100644 tests/f_rehash_dir/name
 create mode 100644 tests/test_one.in
 create mode 100755 tests/test_post

diff --git a/.gitignore b/.gitignore
index 2d1a13e..eb0efe5 100644
--- a/.gitignore
+++ b/.gitignore
@@ -180,6 +180,7 @@ tests/*.log
 tests/*.log
 tests/mke2fs.conf
 tests/test_script
+tests/test_one
 util/gen-tarball
 util/subst
 util/subst.conf
diff --git a/tests/Makefile.in b/tests/Makefile.in
index 9dd1034..9f66a0b 100644
--- a/tests/Makefile.in
+++ b/tests/Makefile.in
@@ -13,23 +13,38 @@ INSTALL = @INSTALL@
 
 all:: @DO_TEST_SUITE@
 
-test_script: test_script.in Makefile mke2fs.conf
+test_one: test_one.in Makefile mke2fs.conf
+	@echo "Creating test_one script..."
+	@echo "#!/bin/sh" > test_one
+@HTREE_CMT@	@echo "HTREE=y" >> test_one
+	@echo "SRCDIR=@srcdir@" >> test_one
+	@echo "DIFF_OPTS=@UNI_DIFF_OPTS@" >> test_one
+	@cat $(srcdir)/test_one.in >> test_one
+	@chmod +x-w test_one
+
+test_script: test_one test_script.in Makefile mke2fs.conf
 	@echo "Creating test_script..."
 	@echo "#!/bin/sh" > test_script
-@HTREE_CMT@	@echo "HTREE=y" >> test_script
-	@echo 'EGREP="@EGREP@"' >> test_script
 	@echo "SRCDIR=@srcdir@" >> test_script
-	@echo "DIFF_OPTS=@UNI_DIFF_OPTS@" >> test_script
 	@cat $(srcdir)/test_script.in >> test_script
-	@chmod +x test_script
+	@chmod +x-w test_script
 
 mke2fs.conf: $(srcdir)/mke2fs.conf.in
 	$(CP) $(srcdir)/mke2fs.conf.in mke2fs.conf
 
-check:: test_script
+TESTS=$(wildcard [a-z]_*)
+$(TESTS):: test_one
+	@./test_one $@
+
+.PHONY : test_pre test_post check
+test_pre:
 	@echo "Running e2fsprogs test suite..."
 	@echo " "
-	@./test_script
+
+test_post: test_pre $(TESTS)
+	@./test_post
+
+check:: test_pre test_post
 
 check-failed:
 	@a=`/bin/ls *.failed 2> /dev/null | sed -e 's/.failed//'`; \
@@ -54,9 +69,9 @@ testnew:
 EXPECT1=${TDIR}/expect.1
 EXPECT2=${TDIR}/expect.2
 # Target which generates the expect files for the new testcase.
-testend: test_script ${TDIR}/image
+testend: test_one ${TDIR}/image
 	gzip -9 ${TDIR}/image
-	@OUT1=${EXPECT1} OUT2=${EXPECT2} ./test_script ${TDIR}
+	@OUT1=${EXPECT1} OUT2=${EXPECT2} ./test_one ${TDIR}
 	@echo; echo; echo "*** output from first e2fsck run (${EXPECT1}) ***"
 	@cat ${EXPECT1}
 	@echo "*** output from second e2fsck run (${EXPECT2}) ***"
@@ -66,7 +81,7 @@ testend: test_script ${TDIR}/image
 	@echo "If all is well, edit ${TDIR}/name and rename ${TDIR}."
 
 clean::
-	$(RM) -f *~ *.log *.new *.failed *.ok test.img test_script mke2fs.conf
+	$(RM) -f *~ *.log *.new *.failed *.ok *.tmp test_one test_script mke2fs.conf
 
 distclean:: clean
 	$(RM) -f Makefile
diff --git a/tests/d_loaddump/expect b/tests/d_loaddump/expect
index e142eac..f70df88 100644
--- a/tests/d_loaddump/expect
+++ b/tests/d_loaddump/expect
@@ -1,7 +1,7 @@
 debugfs load/dump test
 mke2fs -Fq -b 1024 test.img 512
 Exit status is 0
-debugfs -R ''write test.data test_data'' -w test.img
+debugfs -R ''write d_loaddump.tmp test_data'' -w test.img
 Allocated inode: 12
 Exit status is 0
 e2fsck -yf -N test_filesys
@@ -12,7 +12,7 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 12/64 files (0.0% non-contiguous), 158/512 blocks
 Exit status is 0
-debugfs -R ''dump test_data test.verify'' test.img
+debugfs -R ''dump test_data d_loaddump.ver.tmp'' test.img
 Exit status is 0
-cmp test.data test.verify
+cmp d_loaddump.tmp d_loaddump.ver.tmp
 Exit status is 0
diff --git a/tests/d_loaddump/script b/tests/d_loaddump/script
index 4825375..9b687eb 100644
--- a/tests/d_loaddump/script
+++ b/tests/d_loaddump/script
@@ -4,8 +4,8 @@ OUT=$test_name.log
 EXP=$test_dir/expect
 VERIFY_FSCK_OPT=-yf
 
-TEST_DATA=test.data
-VERIFY_DATA=test.verify
+TEST_DATA=$test_name.tmp
+VERIFY_DATA=$test_name.ver.tmp
 
 echo "debugfs load/dump test" > $OUT
 
@@ -47,21 +47,20 @@ echo Exit status is $status >> $OUT
 # Do the verification
 #
 
-rm -f $test_name.ok $test_name.failed $VERIFY_DATA $TEST_DATA $TMPFILE $OUT.new
+rm -f $VERIFY_DATA $TEST_DATA $TMPFILE $OUT.new
 cmp -s $OUT $EXP
 status=$?
 
 if [ "$status" = 0 ] ; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
 else
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
 fi
 
 unset VERIFY_FSCK_OPT NATIVE_FSCK_OPT OUT EXP TEST_DATA VERIFY_DATA
 
 else #if test -x $DEBUGFS_EXE; then
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi 
diff --git a/tests/defaults/e_script b/tests/defaults/e_script
index b9150ba..8c9cfb6 100644
--- a/tests/defaults/e_script
+++ b/tests/defaults/e_script
@@ -37,10 +37,10 @@ status=$?
 rm -f $test_name.failed $test_name.ok
 
 if [ "$status" = 0 ] ; then
-    echo "ok"
+    echo "$test_name: $test_description: ok"
     touch $test_name.ok
 else
-    echo "failed"
+    echo "$test_name: $test_description: failed"
     diff $DIFF_OPTS $EXPECT $OUT > $test_name.failed
 fi
 
diff --git a/tests/e_brel_bma/script b/tests/e_brel_bma/script
index c046675..037e2fb 100644
--- a/tests/e_brel_bma/script
+++ b/tests/e_brel_bma/script
@@ -1,2 +1 @@
-rm -f $test_name.ok $test_name.failed
-echo "skipped"
+echo "$test_name: $test_description: skipped"
diff --git a/tests/e_icount_normal/name b/tests/e_icount_normal/name
index eafa802..1317876 100644
--- a/tests/e_icount_normal/name
+++ b/tests/e_icount_normal/name
@@ -1 +1 @@
-inode counting abstraction optimized for storing inode counts
+inode counting structure optimized for low counts
diff --git a/tests/e_irel_ima/script b/tests/e_irel_ima/script
index c046675..037e2fb 100644
--- a/tests/e_irel_ima/script
+++ b/tests/e_irel_ima/script
@@ -1,2 +1 @@
-rm -f $test_name.ok $test_name.failed
-echo "skipped"
+echo "$test_name: $test_description: skipped"
diff --git a/tests/f_dup4/script b/tests/f_dup4/script
index 290dcc9..7c45bed 100644
--- a/tests/f_dup4/script
+++ b/tests/f_dup4/script
@@ -1,7 +1,7 @@
 if test -x $DEBUGFS_EXE; then
 
 SKIP_GUNZIP="true"
-TEST_DATA="test.data"
+TEST_DATA="$test_name.tmp"
 
 echo "/ Murphy Magic.  The SeCrEt of the UnIvErSe is 43, NOT 42" > $TEST_DATA
 
@@ -52,6 +52,5 @@ rm -f $TEST_DATA
 unset E2FSCK_TIME TEST_DATA
 
 else #if test -x $DEBUGFS_EXE; then
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi 
diff --git a/tests/f_dup_de/script b/tests/f_dup_de/script
index d331003..60378cd 100644
--- a/tests/f_dup_de/script
+++ b/tests/f_dup_de/script
@@ -12,6 +12,5 @@ fi
 rm -f "$TMPFILE".gz
 
 else #if test -x $DEBUGFS_EXE; then
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi 
diff --git a/tests/f_dup_resize/script b/tests/f_dup_resize/script
index 3f87cbb..34ec4ae 100644
--- a/tests/f_dup_resize/script
+++ b/tests/f_dup_resize/script
@@ -1,7 +1,7 @@
 if test -x $DEBUGFS_EXE; then
 
 SKIP_GUNZIP="true"
-TEST_DATA="test.data"
+TEST_DATA="$test_name.tmp"
 
 dd if=$TEST_BITS of=$TEST_DATA bs=63k count=1 conv=sync > /dev/null 2>&1
 
@@ -26,6 +26,5 @@ rm -f $TEST_DATA
 unset E2FSCK_TIME TEST_DATA
 
 else #if test -x $DEBUGFS_EXE; then
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi 
diff --git a/tests/f_ext_journal/name b/tests/f_ext_journal/name
new file mode 100644
index 0000000..10e950c
--- /dev/null
+++ b/tests/f_ext_journal/name
@@ -0,0 +1 @@
+test external journal device
diff --git a/tests/f_h_badnode/script b/tests/f_h_badnode/script
index 9eec084..e5fc6b2 100644
--- a/tests/f_h_badnode/script
+++ b/tests/f_h_badnode/script
@@ -1,6 +1,5 @@
 if test "$HTREE"x = yx ; then
 . $cmd_dir/run_e2fsck
 else
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi
diff --git a/tests/f_h_badroot/script b/tests/f_h_badroot/script
index 9eec084..e5fc6b2 100644
--- a/tests/f_h_badroot/script
+++ b/tests/f_h_badroot/script
@@ -1,6 +1,5 @@
 if test "$HTREE"x = yx ; then
 . $cmd_dir/run_e2fsck
 else
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi
diff --git a/tests/f_h_normal/script b/tests/f_h_normal/script
index 9eec084..e5fc6b2 100644
--- a/tests/f_h_normal/script
+++ b/tests/f_h_normal/script
@@ -1,6 +1,5 @@
 if test "$HTREE"x = yx ; then
 . $cmd_dir/run_e2fsck
 else
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi
diff --git a/tests/f_h_reindex/script b/tests/f_h_reindex/script
index 9eec084..e5fc6b2 100644
--- a/tests/f_h_reindex/script
+++ b/tests/f_h_reindex/script
@@ -1,6 +1,5 @@
 if test "$HTREE"x = yx ; then
 . $cmd_dir/run_e2fsck
 else
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi
diff --git a/tests/f_h_unsigned/script b/tests/f_h_unsigned/script
index 9eec084..e5fc6b2 100644
--- a/tests/f_h_unsigned/script
+++ b/tests/f_h_unsigned/script
@@ -1,6 +1,5 @@
 if test "$HTREE"x = yx ; then
 . $cmd_dir/run_e2fsck
 else
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi
diff --git a/tests/f_imagic_fs/script b/tests/f_imagic_fs/script
index 3941be0..1060f04 100644
--- a/tests/f_imagic_fs/script
+++ b/tests/f_imagic_fs/script
@@ -5,6 +5,5 @@ PREP_CMD='$DEBUGFS -w -R "feature imagic_inodes" $TMPFILE > /dev/null 2>&1'
 . $cmd_dir/run_e2fsck
 
 else #if test -x $DEBUGFS_EXE; then
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi 
diff --git a/tests/f_mmp/script b/tests/f_mmp/script
index 3d4a041..1b0ff79 100644
--- a/tests/f_mmp/script
+++ b/tests/f_mmp/script
@@ -1,13 +1,12 @@
 FSCK_OPT=-yf
 
-TMPFILE=test.img
-rm -f $test_name.failed $test_name.ok
+TMPFILE=$test_name.tmp
 > $TMPFILE
 
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ]; then
 	rm -f $TMPFILE
-	echo "skipped for tmpfs (no O_DIRECT support)"
+	echo "$test_name: $test_description: skipped for tmpfs (no O_DIRECT)"
 	return 0
 fi
 
@@ -16,7 +15,7 @@ $MKE2FS -q -F -o Linux -b 4096 -O mmp -E mmp_update_interval=1 $TMPFILE 100 >> $
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "mke2fs -O mmp failed" > $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return $status
 fi
 
@@ -41,7 +40,7 @@ $FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
 status=$?
 if [ "$status" = 0 ] ; then
 	echo "e2fsck with MMP as EXT2_MMP_SEQ_FSCK ran!" > $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return 1
 fi
 
@@ -50,7 +49,7 @@ $TUNE2FS -f -E clear_mmp $TMPFILE >> $test_name.log 2>&1
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "tune2fs clearing EXT2_MMP_SEQ_FSCK failed" > $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return 1
 fi
 
@@ -59,9 +58,9 @@ $FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "e2fsck after clearing EXT2_MMP_SEQ_FSCK failed"> $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return $status
 fi
 
-echo "ok"
+echo "$test_name: $test_description: ok"
 rm -f $TMPFILE
diff --git a/tests/f_mmp_garbage/script b/tests/f_mmp_garbage/script
index 3b2954b..02cc12a 100644
--- a/tests/f_mmp_garbage/script
+++ b/tests/f_mmp_garbage/script
@@ -1,13 +1,12 @@
 FSCK_OPT=-yf
 
-TMPFILE=test.img
-rm -f $test_name.failed $test_name.ok
+TMPFILE=$test_name.tmp
 > $TMPFILE
 
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ] ; then
 	rm -f $TMPFILE
-	echo "skipped for tmpfs (no O_DIRECT support)"
+	echo "$test_name: $test_description: skipped for tmpfs (no O_DIRECT)"
 	return 0
 fi
 
@@ -16,7 +15,7 @@ $MKE2FS -q -F -o Linux -b 4096 -O mmp -E mmp_update_interval=1 $TMPFILE 100 >> $
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "mke2fs -O mmp failed" > $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return $status
 fi
 
diff --git a/tests/f_rehash_dir/name b/tests/f_rehash_dir/name
new file mode 100644
index 0000000..a7a869a
--- /dev/null
+++ b/tests/f_rehash_dir/name
@@ -0,0 +1 @@
+optimize htree directories
diff --git a/tests/f_resize_inode/script b/tests/f_resize_inode/script
index ca934e9..840432d 100644
--- a/tests/f_resize_inode/script
+++ b/tests/f_resize_inode/script
@@ -1,10 +1,10 @@
 if test -x $DEBUGFS_EXE; then
 
-printf "e2fsck with resize_inode: "
+test_description="e2fsck with resize_inode"
 FSCK_OPT=-yf
 OUT=$test_name.log
 if [ -f $test_dir/expect.gz ]; then
-	EXP=tmp_expect
+	EXP=$test_name.tmp
 	gunzip < $test_dir/expect.gz > $EXP1
 else
 	EXP=$test_dir/expect
@@ -126,15 +126,14 @@ sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
 rm -f $OUT.new
 
 
-rm -f $test_name.ok $test_name.failed
 cmp -s $OUT $EXP
 status=$?
 
 if [ "$status" = 0 ] ; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
 else
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
 	rm -f tmp_expect
 fi
@@ -142,6 +141,5 @@ fi
 unset IMAGE FSCK_OPT OUT EXP
 
 else #if test -x $DEBUGFS_EXE; then
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi 
diff --git a/tests/f_uninit_last_uninit/script b/tests/f_uninit_last_uninit/script
index 4fcab1b..2fe4f3a 100644
--- a/tests/f_uninit_last_uninit/script
+++ b/tests/f_uninit_last_uninit/script
@@ -22,6 +22,5 @@ export E2FSCK_TIME
 unset E2FSCK_TIME
 
 else #if test -x $DEBUGFS_EXE; then
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi 
diff --git a/tests/f_unused_itable/name b/tests/f_unused_itable/name
index 39b68d6..e129137 100644
--- a/tests/f_unused_itable/name
+++ b/tests/f_unused_itable/name
@@ -1 +1 @@
-Invalid bg_unused_itable shouldn't move files to lost+found
+Don't move files to lost+found for bg_unused_itable
diff --git a/tests/i_e2image/script b/tests/i_e2image/script
index 9c6ae2a..0315ae2 100644
--- a/tests/i_e2image/script
+++ b/tests/i_e2image/script
@@ -1,4 +1,4 @@
-printf "Create/convert raw and qcow2 disk images: "
+test_description="create/convert raw/qcow2 images"
 if test -x $E2IMAGE_EXE; then
 
 ORIG_IMAGES="image1024.orig image2048.orig image4096.orig"
@@ -8,7 +8,7 @@ QCOW2_IMG=_image.qcow2
 QCOW2_TO_RAW=_image.qcow2.raw
 OUT=$test_name.log
 MD5=$SRCDIR/$test_name/$test_name.md5
-MD5_TMP=$test_name.md5tmp
+MD5_TMP=$test_name.md5.tmp
 
 rm -f $test_name/_image.* $MD5_TMP $OUT >/dev/null 2>&1
 
@@ -43,18 +43,15 @@ echo "" >> $OUT
 diff $MD5 $MD5_TMP >> $OUT 2>&1
 
 if [ $? -eq 0 ]; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
-	rm -f $test_name.failed
 else
-	rm -f $test_name.ok
 	ln -f $test_name.log $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 fi
 
 rm -f _image.* $MD5_TMP >/dev/null 2>&1
 
 else #if test -x $E2IMAGE_EXE; then
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi
diff --git a/tests/m_mkfs_overhead/script b/tests/m_mkfs_overhead/script
index ff46199..63612a8 100644
--- a/tests/m_mkfs_overhead/script
+++ b/tests/m_mkfs_overhead/script
@@ -1,4 +1,4 @@
-echo -n "test bg overhead calculation: "
+test_description="test bg overhead calculation"
 
 OUT=$test_name.log
 EXP=$test_dir/expect
@@ -17,17 +17,15 @@ $MKE2FS -F -o Linux $MKE2FS_OPTS $TMPFILE $FS_SIZE 2>&1 | sed -e 1d | \
 
 rm -f $TMPFILE
 
-rm -f $test_name.ok $test_name.failed
 cmp -s $OUT $EXP
 status1=$?
 
 if [ "$status1" = 0 ] ; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
 else
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
 fi
-rm -f tmp_expect
 
 unset OUT EXP DESCRIPTION FS_SIZE MKE2FS_OPTS MKE2FS_SKIP_PROGRESS
diff --git a/tests/m_mmp/script b/tests/m_mmp/script
index a0c9ded..02b0b4b 100644
--- a/tests/m_mmp/script
+++ b/tests/m_mmp/script
@@ -2,12 +2,12 @@ DESCRIPTION="enable MMP during mke2fs"
 FS_SIZE=65536
 MKE2FS_DEVICE_SECTSIZE=2048
 export MKE2FS_DEVICE_SECTSIZE
-TMPFILE=test.img
+TMPFILE=$test_name.tmp
 > $TMPFILE
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ]; then
 	rm -f $TMPFILE
-	echo "skipped for tmpfs (no O_DIRECT support)"
+	echo "$test_name: $test_description: skipped for tmpfs (no O_DIRECT)"
 	return 0
 fi
 MKE2FS_OPTS="-b 4096 -O mmp"
diff --git a/tests/r_inline_xattr/script b/tests/r_inline_xattr/script
index e4e0f53..021088e 100644
--- a/tests/r_inline_xattr/script
+++ b/tests/r_inline_xattr/script
@@ -34,22 +34,20 @@ rm $TMPFILE $OUT.new
 # Do the verification
 #
 
-rm -f $test_name.ok $test_name.failed
 cmp -s $OUT $EXP
 status=$?
 
 if [ "$status" = 0 ] ; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
 else
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
 fi
 
 unset IMAGE FSCK_OPT OUT EXP
 
 else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-        rm -f $test_name.ok $test_name.failed
-        echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi
 
diff --git a/tests/r_move_itable/script b/tests/r_move_itable/script
index 56a861b..9ba847e 100644
--- a/tests/r_move_itable/script
+++ b/tests/r_move_itable/script
@@ -96,16 +96,16 @@ $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 echo dumpe2fs test.img >> $OUT
 $DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs >> $OUT
 
-rm -f $test_name.ok $test_name.failed $TMPFILE
+rm -f $TMPFILE
 
 cmp -s $OUT $EXP
 status=$?
 
 if [ "$status" = 0 ] ; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
 else
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
 	rm -f tmp_expect
 fi
@@ -113,6 +113,5 @@ fi
 unset IMAGE FSCK_OPT OUT EXP
 
 else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi 
diff --git a/tests/r_resize_inode/script b/tests/r_resize_inode/script
index c8db127..da3c2ed 100644
--- a/tests/r_resize_inode/script
+++ b/tests/r_resize_inode/script
@@ -3,7 +3,7 @@ if test -x $RESIZE2FS_EXE; then
 FSCK_OPT=-yf
 OUT=$test_name.log
 if [ -f $test_dir/expect.gz ]; then
-	EXP=tmp_expect
+	EXP=$test_name.tmp
 	gunzip < $test_dir/expect.gz > $EXP1
 else
 	EXP=$test_dir/expect
@@ -83,22 +83,21 @@ $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 echo dumpe2fs test.img >> $OUT
 $DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs >> $OUT
 
-rm -f $test_name.ok $test_name.failed $TMPFILE
+rm -f $TMPFILE
 cmp -s $OUT $EXP
 status=$?
 
 if [ "$status" = 0 ] ; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
 else
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
-	rm -f tmp_expect
+	rm -f $test_name.tmp
 fi
 
 unset IMAGE FSCK_OPT OUT EXP
 
 else #if test -x $RESIZE2FS; then
-	rm -f $test_name.ok $test_name.failed
-	echo "skipped"
+	echo "$test_name: $test_description: skipped"
 fi 
diff --git a/tests/run_e2fsck b/tests/run_e2fsck
index 573e010..6a498c3 100644
--- a/tests/run_e2fsck
+++ b/tests/run_e2fsck
@@ -1,5 +1,5 @@
 if [ "$DESCRIPTION"x != x ]; then
-	printf "%s" "$DESCRIPTION: "
+	test_description="$DESCRIPTION"
 fi
 if [ "$IMAGE"x = x ]; then
 	IMAGE=$test_dir/image.gz
@@ -23,7 +23,7 @@ fi
 
 if [ "$EXP1"x = x ]; then
 	if [ -f $test_dir/expect.1.gz ]; then
-		EXP1=tmp_expect
+		EXP1=$test_name.1.tmp
 		gunzip < $test_dir/expect.1.gz > $EXP1
 	else
 		EXP1=$test_dir/expect.1
@@ -32,7 +32,7 @@ fi
 
 if [ "$EXP2"x = x ]; then
 	if [ -f $test_dir/expect.2.gz ]; then
-		EXP2=tmp_expect
+		EXP2=$test_name.2.tmp
 		gunzip < $test_dir/expect.2.gz > $EXP2
 	else
 		EXP2=$test_dir/expect.2
@@ -87,10 +87,10 @@ if [ "$SKIP_VERIFY" != "true" ] ; then
 	fi
 
 	if [ "$status1" -eq 0 -a "$status2" -eq 0 -a "$status3" -eq 0 ] ; then
-		echo "ok"
+		echo "$test_name: $test_description: ok"
 		touch $test_name.ok
 	else
-		echo "failed"
+		echo "$test_name: $test_description: failed"
 		diff $DIFF_OPTS $EXP1 $OUT1 > $test_name.failed
 		if [ "$ONE_PASS_ONLY" != "true" ]; then
 			diff $DIFF_OPTS $EXP2 $OUT2 >> $test_name.failed
diff --git a/tests/t_ext_jnl_rm/script b/tests/t_ext_jnl_rm/script
index d7217b6..b2af80c 100644
--- a/tests/t_ext_jnl_rm/script
+++ b/tests/t_ext_jnl_rm/script
@@ -1,4 +1,4 @@
-printf "remove missing external journal device: "
+test_description="remove missing external journal device"
 OUT=$test_name.log
 
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
@@ -17,12 +17,10 @@ echo "tune2fs -f -O ^has_journal $TMPFILE" >> $OUT
 $TUNE2FS -f -O ^has_journal $TMPFILE >> $OUT 2>&1
 $DUMPE2FS -h $TMPFILE >> $OUT 2>&1
 if [ "$(grep 'Journal UUID:' $OUT)" ]; then
-	rm -f $test_name.ok
 	mv $test_name.log $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 else
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	mv $test_name.log $test_name.ok
-	rm -f $test_name.failed
 fi
 rm -f $TMPFILE
diff --git a/tests/t_mmp_1on/script b/tests/t_mmp_1on/script
index 43afe9d..8fc8158 100644
--- a/tests/t_mmp_1on/script
+++ b/tests/t_mmp_1on/script
@@ -1,13 +1,12 @@
 FSCK_OPT=-yf
 
-TMPFILE=test.img
-rm -f $test_name.failed $test_name.ok
+TMPFILE=$test_name.tmp
 > $TMPFILE
 
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ] ; then
 	rm -f $TMPFILE
-	echo "skipped for tmpfs (no O_DIRECT support)"
+	echo "$test_name: $test_description: skipped for tmpfs (no O_DIRECT)"
 	return 0
 fi
 
@@ -15,7 +14,7 @@ $MKE2FS -q -F -o Linux -b 4096 $TMPFILE 100 > $test_name.log 2>&1
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "mke2fs failed" > $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return $status
 fi
 
@@ -23,18 +22,18 @@ $TUNE2FS -O mmp -E mmp_update_interval=1 $TMPFILE >> $test_name.log 2>&1
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "tune2fs -O mmp failed with $status" > $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return $status
 fi
 
 $FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
 status=$?
 if [ "$status" = 0 ] ; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
 else
 	echo "e2fsck with MMP enabled failed with $status" > $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return $status
 fi
 rm -f $TMPFILE
diff --git a/tests/t_mmp_2off/script b/tests/t_mmp_2off/script
index d9a5b3e..1dee14e 100644
--- a/tests/t_mmp_2off/script
+++ b/tests/t_mmp_2off/script
@@ -1,13 +1,12 @@
 FSCK_OPT=-yf
 
-TMPFILE=test.img
-rm -f $test_name.failed $test_name.ok
+TMPFILE=$test_name.tmp
 > $TMPFILE
 
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ]; then
 	rm -f $TMPFILE
-	echo "skipped for tmpfs (no O_DIRECT support)"
+	echo "$test_name: $test_description: skipped for tmpfs (no O_DIRECT)"
 	return 0
 fi
 
@@ -15,7 +14,7 @@ $MKE2FS -q -F -o Linux -b 4096 -O mmp $TMPFILE 100 > $test_name.log 2>&1
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "mke2fs -O mmp failed" > $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return $status
 fi
 
@@ -23,18 +22,18 @@ $TUNE2FS -O ^mmp $TMPFILE > $test_name.log 2>&1
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "tune2fs -O ^mmp failed" > $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return $status
 fi
 
 $FSCK $FSCK_OPT $TMPFILE > $test_name.log 2>&1
 status=$?
 if [ "$status" = 0 ] ; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
 else
 	echo "e2fsck after MMP disable failed" > $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 	return $status
 fi
 rm -f $TMPFILE
diff --git a/tests/test_one.in b/tests/test_one.in
new file mode 100644
index 0000000..ac16ebb
--- /dev/null
+++ b/tests/test_one.in
@@ -0,0 +1,63 @@
+#!/bin/sh
+# run a single regression test
+
+LC_ALL=C
+export LC_ALL
+
+case "$1" in 
+    --valgrind)
+    	export USE_VALGRIND="valgrind -q --sim-hints=lax-ioctls"
+	shift;
+	;;
+    --valgrind-leakcheck)
+    	export USE_VALGRIND="valgrind --sim-hints=lax-ioctls --leak-check=full --show-reachable=yes --log-file=/tmp/valgrind-%p.log"
+	shift;
+	;;
+esac
+
+case "$1" in 
+    *.failed|*.new|*.ok|*.log|*.tmp)	exit 0 ;;
+esac
+
+test_dir=$1
+cmd_dir=$SRCDIR
+
+if test "$TEST_CONFIG"x = x; then
+	TEST_CONFIG=$SRCDIR/test_config
+fi
+
+. $TEST_CONFIG
+
+TMPFILE=$(mktemp)
+
+test_name=`echo $test_dir | sed -e 's;.*/;;'`
+if [ -f $test_dir ] ; then
+	exit 0;
+fi
+if [ ! -d $test_dir ] ; then
+	echo "The test '$test_name' does not exist."
+	exit 0;
+fi
+if [ -z "`ls $test_dir`" ]; then
+	exit 0
+fi
+if [ -f $test_dir/name ]; then
+	test_description=`cat $test_dir/name`
+else
+	test_description=
+fi
+
+rm -f $test_name.ok $test_name.failed
+echo -e -n "$test_name: $test_description:\r"
+
+if [ -f $test_dir/script ]; then
+	. $test_dir/script
+else
+	test_base=`echo $test_name | sed -e 's/_.*//'`
+	default_script=$SRCDIR/defaults/${test_base}_script
+	if [ -f $default_script ]; then
+		. $SRCDIR/defaults/${test_base}_script
+	else
+		echo "$test_name: Missing test script $default_script!"
+	fi
+fi
diff --git a/tests/test_post b/tests/test_post
new file mode 100755
index 0000000..1251266
--- /dev/null
+++ b/tests/test_post
@@ -0,0 +1,17 @@
+#!/bin/sh
+# report stats about test scripts that were run
+
+num_ok=`ls *.ok 2>/dev/null | wc -l`
+num_failed=`ls *.failed 2>/dev/null | wc -l`
+
+echo "$num_ok tests succeeded	$num_failed tests failed"
+
+test "$num_failed" -eq 0 && exit 0
+
+echo -n "Tests failed: "
+for fname in $(ls *.failed); do
+	echo -n "${fname%%.failed} "
+done
+echo ""
+
+exit 1
diff --git a/tests/test_script.in b/tests/test_script.in
index b7ac86e..b493c3b 100644
--- a/tests/test_script.in
+++ b/tests/test_script.in
@@ -1,10 +1,6 @@
 #!/bin/sh
+# Run all or specified test scripts
 #
-# Test script for e2fsck
-#
-
-LC_ALL=C
-export LC_ALL
 
 case "$1" in 
     --valgrind)
@@ -18,13 +14,12 @@ case "$1" in
 esac
 
 if test "$1"x = x ; then
-  TESTS=`ls -d $SRCDIR/[a-zA-Z]_* | $EGREP -v "\.failed|\.new"`
+  TESTS=`ls -d $SRCDIR/[a-zA-Z]_*`
 else
   TESTS=
   for i 
   do
     case $i in
-	*.failed|*.new)	continue ;;
 	[a-zA-Z])	TESTS="$TESTS $SRCDIR/${i}_*" ;;
 	*)		TESTS="$TESTS $SRCDIR/$i" ;;
     esac
@@ -33,57 +28,9 @@ fi
 
 cmd_dir=$SRCDIR
 
-if test "$TEST_CONFIG"x = x; then
-	TEST_CONFIG=$SRCDIR/test_config
-fi
-
-. $TEST_CONFIG
-
-TMPFILE=$(mktemp)
-
 for test_dir in $TESTS
 do
-	test_name=`echo $test_dir | sed -e 's;.*/;;'`
-	if [ -f $test_dir ] ; then
-	    continue;
-	fi
-	if [ ! -d $test_dir ] ; then
-		echo "The test '$test_name' does not exist."
-		continue;
-	fi
-	if [ -z "`ls $test_dir`" ]; then
-		continue
-	fi
-	if [ -f $test_dir/name ]; then
-		test_description=`cat $test_dir/name`
-		printf "%s: %s: " "$test_name" "$test_description"
-	else
-		printf "%s: " "$test_name"
-	fi
-	if [ -f $test_dir/script ]; then
-		. $test_dir/script
-	else
-		test_base=`echo $test_name | sed -e 's/_.*//'`
-		default_script=$SRCDIR/defaults/${test_base}_script
-		if [ -f $default_script ]; then
-			. $SRCDIR/defaults/${test_base}_script
-		else
-			echo "Missing test script!"
-		fi
-	fi
-done
-
-num_ok=`ls *.ok 2>/dev/null | wc -l`
-num_failed=`ls *.failed 2>/dev/null | wc -l`
-
-echo "$num_ok tests succeeded	$num_failed tests failed"
-
-test "$num_failed" -eq 0 && exit 0
-
-echo -n "Tests failed: "
-for fname in $(ls *.failed); do
-	echo -n "${fname%%.failed} "
+	$cmd_dir/test_one $test_dir
 done
-echo ""
 
-exit 1
+$cmd_dir/test_post
diff --git a/tests/u_mke2fs/script b/tests/u_mke2fs/script
index ef98899..fcf5eae 100644
--- a/tests/u_mke2fs/script
+++ b/tests/u_mke2fs/script
@@ -1,4 +1,4 @@
-printf "e2undo with mke2fs: "
+test_description="e2undo with mke2fs"
 if test -x $E2UNDO_EXE; then
 
 E2FSPROGS_UNDO_DIR=/tmp
@@ -24,13 +24,11 @@ new_md5=`md5sum $TMPFILE | cut -d " " -f 1`
 echo md5sum after e2undo $new_md5 >> $OUT
 
 if [ $md5 = $new_md5 ]; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
-	rm -f $test_name.failed
 else
-	rm -f $test_name.ok
 	ln -f $test_name.log $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 fi
 rm -f $TDB_FILE $TMPFILE
 fi
diff --git a/tests/u_tune2fs/script b/tests/u_tune2fs/script
index 222b95f..4cc1e0c 100644
--- a/tests/u_tune2fs/script
+++ b/tests/u_tune2fs/script
@@ -1,4 +1,4 @@
-printf "e2undo with tune2fs: "
+test_description="e2undo with tune2fs"
 if test -x $E2UNDO_EXE; then
 
 E2FSPROGS_UNDO_DIR=/tmp
@@ -24,13 +24,11 @@ new_md5=`md5sum $TMPFILE | cut -d " " -f 1`
 echo md5sum after e2undo $new_md5 >> $OUT
 
 if [ $md5 = $new_md5 ]; then
-	echo "ok"
+	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
-	rm -f $test_name.failed
 else
-	rm -f $test_name.ok
 	ln -f $test_name.log $test_name.failed
-	echo "failed"
+	echo "$test_name: $test_description: failed"
 fi
 rm -f $TDB_FILE $TMPFILE
 fi
-- 
1.7.3.4

