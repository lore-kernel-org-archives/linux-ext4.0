From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] tests: fix left-over e2fsprogs-tmp files not getting clean up
Date: Mon,  9 Jun 2014 10:50:50 -0400
Message-ID: <1402325451-5275-1-git-send-email-tytso@mit.edu>
References: <20140609144901.GE8418@thunk.org>
Cc: bensberg@justemail.net, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57578 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933277AbaFIOvB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2014 10:51:01 -0400
In-Reply-To: <20140609144901.GE8418@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In addition, incorporate the test name into the e2fsprogs-tmp to make
it easier to debug left-over temp files in the future.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/f_mmp/script         | 3 ---
 tests/f_mmp_garbage/script | 3 ---
 tests/m_mmp/script         | 2 --
 tests/t_mmp_1on/script     | 3 ---
 tests/t_mmp_2off/script    | 3 ---
 tests/test_one.in          | 5 +++--
 6 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/tests/f_mmp/script b/tests/f_mmp/script
index d921672..8d7ab1f 100644
--- a/tests/f_mmp/script
+++ b/tests/f_mmp/script
@@ -1,8 +1,5 @@
 FSCK_OPT=-yf
 
-TMPFILE=$test_name.tmp
-> $TMPFILE
-
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ]; then
 	rm -f $TMPFILE
diff --git a/tests/f_mmp_garbage/script b/tests/f_mmp_garbage/script
index 02cc12a..9ff4d8e 100644
--- a/tests/f_mmp_garbage/script
+++ b/tests/f_mmp_garbage/script
@@ -1,8 +1,5 @@
 FSCK_OPT=-yf
 
-TMPFILE=$test_name.tmp
-> $TMPFILE
-
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ] ; then
 	rm -f $TMPFILE
diff --git a/tests/m_mmp/script b/tests/m_mmp/script
index 02b0b4b..1ed284d 100644
--- a/tests/m_mmp/script
+++ b/tests/m_mmp/script
@@ -2,8 +2,6 @@ DESCRIPTION="enable MMP during mke2fs"
 FS_SIZE=65536
 MKE2FS_DEVICE_SECTSIZE=2048
 export MKE2FS_DEVICE_SECTSIZE
-TMPFILE=$test_name.tmp
-> $TMPFILE
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ]; then
 	rm -f $TMPFILE
diff --git a/tests/t_mmp_1on/script b/tests/t_mmp_1on/script
index 8fc8158..b99aad9 100644
--- a/tests/t_mmp_1on/script
+++ b/tests/t_mmp_1on/script
@@ -1,8 +1,5 @@
 FSCK_OPT=-yf
 
-TMPFILE=$test_name.tmp
-> $TMPFILE
-
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ] ; then
 	rm -f $TMPFILE
diff --git a/tests/t_mmp_2off/script b/tests/t_mmp_2off/script
index 1dee14e..6822278 100644
--- a/tests/t_mmp_2off/script
+++ b/tests/t_mmp_2off/script
@@ -1,8 +1,5 @@
 FSCK_OPT=-yf
 
-TMPFILE=$test_name.tmp
-> $TMPFILE
-
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ]; then
 	rm -f $TMPFILE
diff --git a/tests/test_one.in b/tests/test_one.in
index d053fd7..01a9260 100644
--- a/tests/test_one.in
+++ b/tests/test_one.in
@@ -28,9 +28,10 @@ fi
 
 . $TEST_CONFIG
 
-TMPFILE=$(mktemp -t e2fsprogs-tmp.XXXXXX)
