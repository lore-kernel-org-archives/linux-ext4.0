Return-Path: <SRS0=vjzE=OW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.13]:60446 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbeLMSOt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Dec 2018 13:14:49 -0500
From: Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3] tests: replace perl usage with shell built-in
Date: Thu, 13 Dec 2018 11:06:39 -0700
Message-Id: <1544724399-84147-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A couple of tests use perl only for generating a string of
N characters long.  Instead of requiring perl just for a few
tests, use shell built-in commands and don't spawn a separate
subshell just to get a string of characters.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/d_xattr_sorting/script    |  3 ++-
 tests/f_badsymlinks2/mkimage.sh |  4 +++-
 tests/f_create_symlinks/script  | 12 ++++++------
 util/gen-sample-fs              |  4 +++-
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/tests/d_xattr_sorting/script b/tests/d_xattr_sorting/script
index 8666115..49bcece 100644
--- a/tests/d_xattr_sorting/script
+++ b/tests/d_xattr_sorting/script
@@ -22,7 +22,8 @@ echo Exit status is $status >> $OUT.new
 
 B=$(mktemp ${TMPDIR:-/tmp}/b.XXXXXX)
 
-perl -e 'print "x" x 256;' > $B
+F="xxxx"; F+=$F$F$F; F+=$F$F$F; F+=$F$F$F
+printf "%s" $F > $B
 
 echo "ea_set -f /tmp/b / security.SMEG64" >> $OUT.new
 $DEBUGFS -w -R "ea_set -f $B / security.SMEG64" $TMPFILE >> $OUT.new 2>&1
diff --git a/tests/f_badsymlinks2/mkimage.sh b/tests/f_badsymlinks2/mkimage.sh
index 6bbf020..fe0ebb7 100755
--- a/tests/f_badsymlinks2/mkimage.sh
+++ b/tests/f_badsymlinks2/mkimage.sh
@@ -18,10 +18,12 @@ do_tune2fs() {
 	mount image mnt
 }
 
+A="AAAA"; A+=$A$A$A; A+=$A$A$A; A+=$A$A$A; A+=$A$A$A; A+=$A$A$A
 symlink() {
 	local len=$1
 	local src=$2
-	local target=$(perl -e 'print "A" x '$len)
+	local target=${A:0:$len}
+
 	ln -s $target $src
 	stat -c %i $src
 }
diff --git a/tests/f_create_symlinks/script b/tests/f_create_symlinks/script
index 169f58d..72741fd 100644
--- a/tests/f_create_symlinks/script
+++ b/tests/f_create_symlinks/script
@@ -15,22 +15,22 @@ fi
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 
 echo mke2fs -q -F -o Linux -b 1024 -g 256 -O inline_data,extents -I 256 test.img 1024 > $OUT.new
-$MKE2FS -q -F -o Linux -b 1024 -g 256 -O inline_data,extents -I 256 $TMPFILE 1024 >> $OUT 2>&1
+$MKE2FS -q -F -o Linux -b 1024 -g 256 -O inline_data,extents -I 256 $TMPFILE 1024 >> $OUT.new 2>&1
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 
+B="xxxx"; B+=$B$B$B; B+=$B$B$B; B+=$B$B$B; B+=$B$B$B$B$B
 for i in 30 60 70 500 1023 1024 1500; do
-	echo "debugfs -R \"symlink /l_$i $(perl -e "print 'x' x $i;")\" test.img" >> $OUT.new
-	$DEBUGFS -w -R "symlink /l_$i $(perl -e "print 'x' x $i;")" $TMPFILE \
-		 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT.new
+	echo "debugfs -R \"symlink /l_$i ${B:0:i}\" test.img" >> $OUT.new
+	$DEBUGFS -w -R "symlink /l_$i ${B:0:i}" $TMPFILE >> $OUT.new 2>&1
 done
+unset B
 
 for i in 30 60 70 500 1023 1024 1500; do
 	echo "debugfs -R \"stat /l_$i\" test.img" >> $OUT.new
-	$DEBUGFS -R "stat /l_$i" $TMPFILE 2>&1 | \
-		 grep -v "time: " >> $OUT.new
+	$DEBUGFS -R "stat /l_$i" $TMPFILE 2>&1 | grep -v "time: " >> $OUT.new
 done
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE >> $OUT.new 2>&1
diff --git a/util/gen-sample-fs b/util/gen-sample-fs
index 8e13916..a92c822 100755
--- a/util/gen-sample-fs
+++ b/util/gen-sample-fs
@@ -7,8 +7,10 @@ cp /dev/null $FS
 mke2fs -q -t ext4 -O inline_data,^has_journal -I 256 -b 4096 -N 64 $FS 256
 mount -t ext4 $FS $MNT
 ln -s symlink_data $MNT/symlink
+
+L="xxxx"; L+=$L$L$L; L+=$L$L$L; L+=$L$L$L; L+=$L$L$L
 for i in 30 70 500 1023 1024; do
-	ln -s /$(perl -e "print 'x' x $i;") $MNT/l_$i
+	ln -s /${L:0:$i} $MNT/l_$i
 done
 touch $MNT/acl
 setfacl -m u:daemon:r $MNT/acl
-- 
1.8.0
