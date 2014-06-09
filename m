From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] tests: fix left-over e2fsprogs-tmp files not getting
 clean up
Date: Mon, 9 Jun 2014 19:45:50 -0400
Message-ID: <20140609234550.GD8993@thunk.org>
References: <20140609144901.GE8418@thunk.org>
 <1402325451-5275-1-git-send-email-tytso@mit.edu>
 <3C6E678A-D052-40A1-BDEE-84A386CEB887@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	bensberg@justemail.net
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58404 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990AbaFIXpy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2014 19:45:54 -0400
Content-Disposition: inline
In-Reply-To: <3C6E678A-D052-40A1-BDEE-84A386CEB887@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 09, 2014 at 02:34:45PM -0600, Andreas Dilger wrote:
> The reason I created these temp files on the local filesystem instead of
> on /tmp where $TMPFILE normally is normally located is because tmpfs does
> not support O_DIRECT.  With the current patch all of these tests would be
> skipped in the default test configuration.

Ah, ok.  How about this then?

						- Ted

>From c34e6a131f049f008945967f2272b7c8efc1b282 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Mon, 9 Jun 2014 10:34:17 -0400
Subject: [PATCH] tests: fix left-over e2fsprogs-tmp files not getting clean up

In addition, incorporate the test name into the e2fsprogs-tmp to make
it easier to debug left-over temp files in the future.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/f_mmp/script         | 5 +++--
 tests/f_mmp_garbage/script | 5 +++--
 tests/m_mmp/script         | 7 +++++--
 tests/t_mmp_1on/script     | 5 +++--
 tests/t_mmp_2off/script    | 5 +++--
 tests/test_one.in          | 5 +++--
 6 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tests/f_mmp/script b/tests/f_mmp/script
index d921672..664f74f 100644
--- a/tests/f_mmp/script
+++ b/tests/f_mmp/script
@@ -1,7 +1,8 @@
 FSCK_OPT=-yf
 
-TMPFILE=$test_name.tmp
-> $TMPFILE
+# use current directory instead of /tmp becase tmpfs doesn't support DIO
+rm -f $TMPFILE
+TMPFILE=$(mktemp ./tmp-$test_name.XXXXXX)
 
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ]; then
diff --git a/tests/f_mmp_garbage/script b/tests/f_mmp_garbage/script
index 02cc12a..6d451a6 100644
--- a/tests/f_mmp_garbage/script
+++ b/tests/f_mmp_garbage/script
@@ -1,7 +1,8 @@
 FSCK_OPT=-yf
 
-TMPFILE=$test_name.tmp
-> $TMPFILE
+# use current directory instead of /tmp becase tmpfs doesn't support DIO
+rm -f $TMPFILE
+TMPFILE=$(mktemp ./tmp-$test_name.XXXXXX)
 
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ] ; then
diff --git a/tests/m_mmp/script b/tests/m_mmp/script
index 02b0b4b..6a9394d 100644
--- a/tests/m_mmp/script
+++ b/tests/m_mmp/script
@@ -2,8 +2,11 @@ DESCRIPTION="enable MMP during mke2fs"
 FS_SIZE=65536
 MKE2FS_DEVICE_SECTSIZE=2048
 export MKE2FS_DEVICE_SECTSIZE
-TMPFILE=$test_name.tmp
-> $TMPFILE
+
+# use current directory instead of /tmp becase tmpfs doesn't support DIO
+rm -f $TMPFILE
+TMPFILE=$(mktemp ./tmp-$test_name.XXXXXX)
+
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ]; then
 	rm -f $TMPFILE
diff --git a/tests/t_mmp_1on/script b/tests/t_mmp_1on/script
index 8fc8158..cfed2ca 100644
--- a/tests/t_mmp_1on/script
+++ b/tests/t_mmp_1on/script
@@ -1,7 +1,8 @@
 FSCK_OPT=-yf
 
-TMPFILE=$test_name.tmp
-> $TMPFILE
+# use current directory instead of /tmp becase tmpfs doesn't support DIO
+rm -f $TMPFILE
+TMPFILE=$(mktemp ./tmp-$test_name.XXXXXX)
 
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ] ; then
diff --git a/tests/t_mmp_2off/script b/tests/t_mmp_2off/script
index 1dee14e..6556201 100644
--- a/tests/t_mmp_2off/script
+++ b/tests/t_mmp_2off/script
@@ -1,7 +1,8 @@
 FSCK_OPT=-yf
 
-TMPFILE=$test_name.tmp
-> $TMPFILE
+# use current directory instead of /tmp becase tmpfs doesn't support DIO
+rm -f $TMPFILE
+TMPFILE=$(mktemp ./tmp-$test_name.XXXXXX)
 
 stat -f $TMPFILE | grep -q "Type: tmpfs"
 if [ $? = 0 ]; then
diff --git a/tests/test_one.in b/tests/test_one.in
index d053fd7..01a9260 100644
--- a/tests/test_one.in
+++ b/tests/test_one.in
@@ -28,9 +28,10 @@ fi
 
 . $TEST_CONFIG
 
-TMPFILE=$(mktemp -t e2fsprogs-tmp.XXXXXX)
