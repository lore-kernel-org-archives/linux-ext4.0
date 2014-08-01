From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/19] tests: add tests for directory entry blocks with
 checksum errors
Date: Fri, 01 Aug 2014 11:13:23 -0700
Message-ID: <20140801181323.12496.25530.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33777 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbaHASN2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:13:28 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some regression tests to examine how e2fsck handles directory
entry blocks and htree blocks with (a) malformed directory entries;
(b) incorrect checksums; or (c) obviously garbage entries.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/f_dir_bad_csum/expect.1   |   62 +++++++++++++++++++++++++++++++++++++++
 tests/f_dir_bad_csum/expect.2   |    7 ++++
 tests/f_dir_bad_csum/image.gz   |  Bin
 tests/f_dir_bad_csum/name       |    1 +
 tests/f_htree_bad_csum/expect.1 |   28 ++++++++++++++++++
 tests/f_htree_bad_csum/expect.2 |    7 ++++
 tests/f_htree_bad_csum/image.gz |  Bin
 tests/f_htree_bad_csum/name     |    1 +
 8 files changed, 106 insertions(+)
 create mode 100644 tests/f_dir_bad_csum/expect.1
 create mode 100644 tests/f_dir_bad_csum/expect.2
 create mode 100644 tests/f_dir_bad_csum/image.gz
 create mode 100644 tests/f_dir_bad_csum/name
 create mode 100644 tests/f_htree_bad_csum/expect.1
 create mode 100644 tests/f_htree_bad_csum/expect.2
 create mode 100644 tests/f_htree_bad_csum/image.gz
 create mode 100644 tests/f_htree_bad_csum/name

diff --git a/tests/f_dir_bad_csum/expect.1 b/tests/f_dir_bad_csum/expect.1
new file mode 100644
index 0000000..bbcbfcb
--- /dev/null
+++ b/tests/f_dir_bad_csum/expect.1
@@ -0,0 +1,62 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Directory inode 12, block #0, offset 12: directory passes checks but fails checksum.
+Fix? yes
+
+Directory inode 13, block #0, offset 0: directory has no checksum.
+Fix? yes
+
+Directory inode 13, block #0, offset 1012: directory passes checks but fails checksum.
+Fix? yes
+
+Directory inode 14, block #0, offset 0: directory has no checksum.
+Fix? yes
+
+Directory inode 14, block #0, offset 12: directory passes checks but fails checksum.
+Fix? yes
+
+Directory inode 15, block #0, offset 0: directory has no checksum.
+Fix? yes
+
+Directory inode 15, block #0, offset 1000: directory corrupted
+Salvage? yes
+
+Directory inode 16, block #0, offset 0: directory has no checksum.
+Fix? yes
+
+Directory inode 16, block #0, offset 12: directory corrupted
+Salvage? yes
+
+Directory inode 17, block #0, offset 0: directory has no checksum.
+Fix? yes
+
+Directory inode 17, block #0, offset 0: directory corrupted
+Salvage? yes
+
+Missing '.' in directory inode 17.
+Fix? yes
+
+Setting filetype for entry '.' in ??? (17) to 2.
+Missing '..' in directory inode 17.
+Fix? yes
+
+Setting filetype for entry '..' in ??? (17) to 2.
+Entry 'file' in ??? (18) has invalid inode #: 4294967295.
+Clear? yes
+
+Pass 3: Checking directory connectivity
+'..' in /6 (17) is <The NULL inode> (0), should be / (2).
+Fix? yes
+
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Unattached inode 19
+Connect to /lost+found? yes
+
+Inode 19 ref count is 2, should be 1.  Fix? yes
+
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 19/128 files (5.3% non-contiguous), 1098/2048 blocks
+Exit status is 1
diff --git a/tests/f_dir_bad_csum/expect.2 b/tests/f_dir_bad_csum/expect.2
new file mode 100644
index 0000000..f5a3e5f
--- /dev/null
+++ b/tests/f_dir_bad_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 19/128 files (5.3% non-contiguous), 1098/2048 blocks
+Exit status is 0
diff --git a/tests/f_dir_bad_csum/image.gz b/tests/f_dir_bad_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..4b581876f07c1ec989ef85977dc53741b6356130
GIT binary patch
literal 3499
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

literal 0
HcmV?d00001

diff --git a/tests/f_dir_bad_csum/name b/tests/f_dir_bad_csum/name
new file mode 100644
index 0000000..140ae45
--- /dev/null
+++ b/tests/f_dir_bad_csum/name
@@ -0,0 +1 @@
+dir block w/ missing/bad csum, no tail, or dir block corruption (metadata_csum)
diff --git a/tests/f_htree_bad_csum/expect.1 b/tests/f_htree_bad_csum/expect.1
new file mode 100644
index 0000000..258362b
--- /dev/null
+++ b/tests/f_htree_bad_csum/expect.1
@@ -0,0 +1,28 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Problem in HTREE directory inode 12: root node fails checksum.
+Clear HTree index? yes
+
+Problem in HTREE directory inode 18: root node fails checksum.
+Clear HTree index? yes
+
+Directory inode 24, block #0, offset 1020: directory corrupted
+Salvage? yes
+
+Problem in HTREE directory inode 24: root node fails checksum.
+Clear HTree index? yes
+
+Problem in HTREE directory inode 30: root node fails checksum.
+Clear HTree index? yes
+
+Problem in HTREE directory inode 36: root node fails checksum.
+Clear HTree index? yes
+
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 47/128 files (2.1% non-contiguous), 1108/2048 blocks
+Exit status is 1
diff --git a/tests/f_htree_bad_csum/expect.2 b/tests/f_htree_bad_csum/expect.2
new file mode 100644
index 0000000..7e3523b
--- /dev/null
+++ b/tests/f_htree_bad_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 47/128 files (2.1% non-contiguous), 1108/2048 blocks
+Exit status is 0
diff --git a/tests/f_htree_bad_csum/image.gz b/tests/f_htree_bad_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..def571c7900f39bf236a52f0086fccb54049c8c2
GIT binary patch
literal 5462
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

literal 0
HcmV?d00001

diff --git a/tests/f_htree_bad_csum/name b/tests/f_htree_bad_csum/name
new file mode 100644
index 0000000..ebfc3ea
--- /dev/null
+++ b/tests/f_htree_bad_csum/name
@@ -0,0 +1 @@
+htree block w/ missing/bad csum, bad protective dirent, or htree index corruption (metadata_csum)

