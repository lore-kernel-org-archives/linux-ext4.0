From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/8] xfstests: Create single function for testing xfs_io commands
Date: Fri, 28 Feb 2014 17:10:58 +0100
Message-ID: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaB1QLM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Feb 2014 11:11:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently there are several function testing various xfs_io commands.
This commit creates _require_xfs_io_command() to test any xfs_command.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/rc | 72 +++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

diff --git a/common/rc b/common/rc
index f2c3c3a..7f530d0 100644
--- a/common/rc
+++ b/common/rc
@@ -1296,12 +1296,43 @@ _user_do()
     fi
 }
 
+_require_xfs_io_command()
+{
+	if [ $# -ne 1 ]
+	then
+		echo "Usage: _require_xfs_io_command command" 1>&2
+		exit 1
+	fi
+	command=$1
+
+	testfile=$TEST_DIR/$$.xfs_io
+	case $command in
+	"falloc" )
+		testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
+		;;
+	"fpunch" | "fcollapse" | "zero" )
+		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
+			-c "$command 4k 8k" $testfile 2>&1`
+		;;
+	"fiemap")
+		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
+			-c "fiemap -v" $testfile 2>&1`
+		;;
+	*)
+		testio=`$XFS_IO_PROG -c "$command help" 2>&1`
+	esac
+
+	rm -f $testfile 2>&1 > /dev/null
+	echo $testio | grep -q "not found" && \
+		_notrun "xfs_io $command support is missing"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
+}
+
 # check that xfs_io, kernel, and filesystem all support zero
 _require_xfs_io_zero()
 {
-	testio=`$XFS_IO_PROG -c "zero help" 2>&1`
-	echo $testio | grep -q 'command "zero" not found' && \
-		_notrun "zero command not supported"
+	_require_xfs_io_command "zero"
 }
 
 # check that xfs_io, glibc, kernel, and filesystem all (!) support
@@ -1309,54 +1340,27 @@ _require_xfs_io_zero()
 #
 _require_xfs_io_falloc()
 {
-	testfile=$TEST_DIR/$$.falloc
-	testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
-	rm -f $testfile 2>&1 > /dev/null
-	echo $testio | grep -q "not found" && \
-		_notrun "xfs_io fallocate support is missing"
-	echo $testio | grep -q "Operation not supported" && \
-		_notrun "xfs_io fallocate command failed (old kernel/wrong fs?)"
+	_require_xfs_io_command "falloc"
 }
 
 # check that xfs_io, kernel and filesystem all support fallocate with hole
 # punching
 _require_xfs_io_falloc_punch()
 {
-	testfile=$TEST_DIR/$$.falloc
-	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
-		-c "fpunch 4k 8k" $testfile 2>&1`
-	rm -f $testfile 2>&1 > /dev/null
-	echo $testio | grep -q "not found" && \
-		_notrun "xfs_io fallocate punch support is missing"
-	echo $testio | grep -q "Operation not supported" && \
-		_notrun "xfs_io fallocate punch command failed (no fs support?)"
+	_require_xfs_io_command "fpunch"
 }
 
 # check that xfs_io, kernel and filesystem all support fallocate with collapse
 # range
 _require_xfs_io_falloc_collapse()
 {
-	testfile=$TEST_DIR/$$.falloc
-	testio=`$XFS_IO_PROG -f -c "pwrite 0 20k" -c "fsync" \
-		-c "fcollapse 4k 8k" $testfile 2>&1`
-	rm -f $testfile 2>&1 > /dev/null
-	echo $testio | grep -q "not found" && \
-		_notrun "xfs_io fallocate collapse range support is missing"
-	echo $testio | grep -q "Operation not supported" && \
-		_notrun "xfs_io fallocate collapse range failed (no fs support?)"
+	_require_xfs_io_command "fcollapse"
 }
 
 # check that xfs_io, kernel and filesystem support fiemap
 _require_xfs_io_fiemap()
 {
-	testfile=$TEST_DIR/$$.fiemap
-	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
-		-c "fiemap -v" $testfile 2>&1`
-	rm -f $testfile 2>&1 > /dev/null
-	echo $testio | grep -q "not found" && \
-		_notrun "xfs_io fiemap support is missing"
-	echo $testio | grep -q "Operation not supported" && \
-		_notrun "xfs_io fiemap command failed (no fs support?)"
+	_require_xfs_io_command "fiemap"
 }
 
 # Check that a fs has enough free space (in 1024b blocks)
-- 
1.8.3.1

