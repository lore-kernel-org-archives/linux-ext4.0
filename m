From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] tests: add new test f_quota_extent_opt
Date: Sat, 15 Apr 2017 09:41:17 -0400
Message-ID: <20170415134118.17808-2-tytso@mit.edu>
References: <20170415134118.17808-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39894 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754147AbdDONl0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 15 Apr 2017 09:41:26 -0400
In-Reply-To: <20170415134118.17808-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a test to validate the changes in commit 403bcb668e4f: "e2fsck:
update quota when optimizing the extent tree".

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/f_quota_extent_opt/expect.1 |  15 +++++++++++++++
 tests/f_quota_extent_opt/expect.2 |   7 +++++++
 tests/f_quota_extent_opt/image.gz | Bin 0 -> 9018 bytes
 tests/f_quota_extent_opt/name     |   1 +
 4 files changed, 23 insertions(+)
 create mode 100644 tests/f_quota_extent_opt/expect.1
 create mode 100644 tests/f_quota_extent_opt/expect.2
 create mode 100644 tests/f_quota_extent_opt/image.gz
 create mode 100644 tests/f_quota_extent_opt/name

diff --git a/tests/f_quota_extent_opt/expect.1 b/tests/f_quota_extent_opt/expect.1
new file mode 100644
index 00000000..1b966213
--- /dev/null
+++ b/tests/f_quota_extent_opt/expect.1
@@ -0,0 +1,15 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 extent tree (at level 1) could be narrower.  Fix? yes
+
+Pass 1E: Optimizing extent trees
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+[QUOTA WARNING] Usage inconsistent for ID 0:actual (147456, 3) != expected (148480, 3)
+Update quota info for quota type 0? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/1024 files (25.0% non-contiguous), 1339/4096 blocks
+Exit status is 1
diff --git a/tests/f_quota_extent_opt/expect.2 b/tests/f_quota_extent_opt/expect.2
new file mode 100644
index 00000000..0bd4632c
--- /dev/null
+++ b/tests/f_quota_extent_opt/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/1024 files (25.0% non-contiguous), 1339/4096 blocks
+Exit status is 0
diff --git a/tests/f_quota_extent_opt/image.gz b/tests/f_quota_extent_opt/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..21dcfbdfeb150a46a6746de21ad874a9eff12185
GIT binary patch
literal 9018
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
M7Ki9pt=hNh&y+Za^Z)<=

literal 0
Hc-jL100001

diff --git a/tests/f_quota_extent_opt/name b/tests/f_quota_extent_opt/name
new file mode 100644
index 00000000..8c5d7a90
--- /dev/null
+++ b/tests/f_quota_extent_opt/name
@@ -0,0 +1 @@
+extent optimization with quota
-- 
2.11.0.rc0.7.gbe5a750
