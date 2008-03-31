From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] Add new regression test: f_uninit_last_uninit
Date: Mon, 31 Mar 2008 19:36:32 -0400
Message-ID: <1207006592-13980-11-git-send-email-tytso@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int>
 <1207006592-13980-1-git-send-email-tytso@mit.edu>
 <1207006592-13980-2-git-send-email-tytso@mit.edu>
 <1207006592-13980-3-git-send-email-tytso@mit.edu>
 <1207006592-13980-4-git-send-email-tytso@mit.edu>
 <1207006592-13980-5-git-send-email-tytso@mit.edu>
 <1207006592-13980-6-git-send-email-tytso@mit.edu>
 <1207006592-13980-7-git-send-email-tytso@mit.edu>
 <1207006592-13980-8-git-send-email-tytso@mit.edu>
 <1207006592-13980-9-git-send-email-tytso@mit.edu>
 <1207006592-13980-10-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61402 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbYCaXjI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:39:08 -0400
In-Reply-To: <1207006592-13980-10-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <adilger@dilger.ca>

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/f_uninit_last_uninit/expect.1 |    9 +++++++++
 tests/f_uninit_last_uninit/expect.2 |    7 +++++++
 tests/f_uninit_last_uninit/name     |    2 ++
 tests/f_uninit_last_uninit/script   |   20 ++++++++++++++++++++
 4 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 tests/f_uninit_last_uninit/expect.1
 create mode 100644 tests/f_uninit_last_uninit/expect.2
 create mode 100644 tests/f_uninit_last_uninit/name
 create mode 100644 tests/f_uninit_last_uninit/script

diff --git a/tests/f_uninit_last_uninit/expect.1 b/tests/f_uninit_last_uninit/expect.1
new file mode 100644
index 0000000..85f05ee
--- /dev/null
+++ b/tests/f_uninit_last_uninit/expect.1
@@ -0,0 +1,9 @@
+Last group block bitmap uninitialized.  Fix? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32 files (9.1% non-contiguous), 105/10000 blocks
+Exit status is 0
diff --git a/tests/f_uninit_last_uninit/expect.2 b/tests/f_uninit_last_uninit/expect.2
new file mode 100644
index 0000000..435a8a7
--- /dev/null
+++ b/tests/f_uninit_last_uninit/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32 files (9.1% non-contiguous), 105/10000 blocks
+Exit status is 0
diff --git a/tests/f_uninit_last_uninit/name b/tests/f_uninit_last_uninit/name
new file mode 100644
index 0000000..4f93e23
--- /dev/null
+++ b/tests/f_uninit_last_uninit/name
@@ -0,0 +1,2 @@
+last group has BLOCK_UNINIT set
+
diff --git a/tests/f_uninit_last_uninit/script b/tests/f_uninit_last_uninit/script
new file mode 100644
index 0000000..477357a
--- /dev/null
+++ b/tests/f_uninit_last_uninit/script
@@ -0,0 +1,20 @@
+SKIP_GUNZIP="true"
+
+touch $TMPFILE
+$MKE2FS -N 32 -F -o Linux -O uninit_groups -b 1024 $TMPFILE 10000 > /dev/null 2>&1 
+$DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
+set_current_time 200704102100
+set_super_value lastcheck 0
+set_super_value hash_seed null
+set_super_value mkfs_time 0
+set_bg 1 flags 0x7
+set_bg 1 checksum calc
+q
+EOF
+
+E2FSCK_TIME=200704102100
+export E2FSCK_TIME
+
+. $cmd_dir/run_e2fsck
+
+unset E2FSCK_TIME
-- 
1.5.4.1.144.gdfee-dirty

