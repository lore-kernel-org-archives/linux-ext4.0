From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: remove unused temporary files for MMP tests
Date: Wed,  8 Aug 2012 14:21:36 -0600
Message-ID: <1344457296-27609-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:41664 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2HHUVi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Aug 2012 16:21:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The MMP tests need to be run on a real disk instead of tmpfs, since
the MMP block access is using O_DIRECT.  As such, they create their
own test files in the local testing directory instead of using the
temporary file created in /tmp by the test_one script.  Delete the
tempfs file before clobbering TMPFILE, otherwise it will leave the
unused file in /tmp after the test is completed.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/f_mmp/script         |    1 +
 tests/f_mmp_garbage/script |    1 +
 tests/m_mmp/script         |    1 +
 tests/t_mmp_1on/script     |    1 +
 tests/t_mmp_2off/script    |    1 +
 5 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tests/f_mmp/script b/tests/f_mmp/script
index 1b0ff79..05421c4 100644
--- a/tests/f_mmp/script
+++ b/tests/f_mmp/script
@@ -1,5 +1,6 @@
 FSCK_OPT=-yf
 
+[ -f "$TMPFILE" ] && rm -f $TMPFILE
 TMPFILE=$test_name.tmp
 > $TMPFILE
 
diff --git a/tests/f_mmp_garbage/script b/tests/f_mmp_garbage/script
index 02cc12a..d4d2cb3 100644
--- a/tests/f_mmp_garbage/script
+++ b/tests/f_mmp_garbage/script
@@ -1,5 +1,6 @@
 FSCK_OPT=-yf
 
+[ -f "$TMPFILE" ] && rm -f $TMPFILE
 TMPFILE=$test_name.tmp
 > $TMPFILE
 
diff --git a/tests/m_mmp/script b/tests/m_mmp/script
index 02b0b4b..dff98f0 100644
--- a/tests/m_mmp/script
+++ b/tests/m_mmp/script
@@ -2,6 +2,7 @@ DESCRIPTION="enable MMP during mke2fs"
 FS_SIZE=65536
 MKE2FS_DEVICE_SECTSIZE=2048
 export MKE2FS_DEVICE_SECTSIZE
+[ -f "$TMPFILE" ] && rm -f $TMPFILE
 TMPFILE=$test_name.tmp
 > $TMPFILE
 stat -f $TMPFILE | grep -q "Type: tmpfs"
diff --git a/tests/t_mmp_1on/script b/tests/t_mmp_1on/script
index 8fc8158..d15b1e3 100644
--- a/tests/t_mmp_1on/script
+++ b/tests/t_mmp_1on/script
@@ -1,5 +1,6 @@
 FSCK_OPT=-yf
 
+[ -f "$TMPFILE" ] && rm -f $TMPFILE
 TMPFILE=$test_name.tmp
 > $TMPFILE
 
diff --git a/tests/t_mmp_2off/script b/tests/t_mmp_2off/script
index 1dee14e..572730b 100644
--- a/tests/t_mmp_2off/script
+++ b/tests/t_mmp_2off/script
@@ -1,5 +1,6 @@
 FSCK_OPT=-yf
 
+[ -f "$TMPFILE" ] && rm -f $TMPFILE
 TMPFILE=$test_name.tmp
 > $TMPFILE
 
-- 
1.7.3.4

