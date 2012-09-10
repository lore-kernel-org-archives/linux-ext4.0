From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: kill debugfs on interrupted MMP test
Date: Mon, 10 Sep 2012 13:04:47 -0600
Message-ID: <1347303887-5513-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4, Andreas Dilger" <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:53159 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2IJTF2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Sep 2012 15:05:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the f_mmp test is interrupted during its test run, then it can
leave debugfs busy-looping in the background.  Since f_mmp is a
relatively long-running test, and is likely to be running during
a parallel test run, this can happen fairly often.

Set a signal trap for the f_mmp test script being killed, so that
the background debugfs command will always be killed by the test.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
tests/f_mmp/script | 10 +++++++++-
1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tests/f_mmp/script b/tests/f_mmp/script
index 1b0ff79..c1f13fc 100644
--- a/tests/f_mmp/script
+++ b/tests/f_mmp/script
@@ -19,10 +19,18 @@ if [ "$status" != 0 ] ; then
	return $status
fi

+kill_debugfs() {
+	trap 0
+	PID=$(ps -o pid,command | awk "/debugfs -w $TMPFILE/ { print \$1 }" |
+	      grep -v awk)
+	[ "x$PID" != "x" ] && kill -9 $PID
+}
+
# this will cause debugfs to create the $test_name.mark file once it has
# passed the MMP startup, then continue reading input until it is killed
MARKFILE=$test_name.new
rm -f $MARKFILE
+trap kill_debugfs EXIT
echo "set mmp sequence to EXT2_MMP_SEQ_FSCK..." >> $test_name.log
( { echo dump_mmp; echo "dump_inode <2> $MARKFILE"; cat /dev/zero; } |
	$DEBUGFS -w $TMPFILE >> $test_name.log 2>&1 & ) > /dev/null 2>&1 &
@@ -32,7 +40,7 @@ while [ ! -e $MARKFILE ]; do
done
rm -f $MARKFILE
echo "kill debugfs abruptly (simulates e2fsck failure) ..." >> $test_name.log
-killall -9 debugfs >> $test_name.log
+kill_debugfs


echo "e2fsck (should fail mmp_seq = EXT2_MMP_SEQ_FSCK) ..." >> $test_name.log
-- 
1.7.11.1

