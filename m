From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/19] tests: add regression tests for inodes with bad
 checksums
Date: Fri, 01 Aug 2014 11:13:49 -0700
Message-ID: <20140801181349.12496.77562.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33956 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHASNz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:13:55 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add regression tests to e2fsck to examine how it deals with inode
table blocks which (a) have been zero'd; (b) have been one'd; (c) have
corrupt inodes with obvious problems; and (d) have inodes with
non-obvious problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/f_bad_inode_csum/expect.1 |  126 +++++++++++++++++++++++++++++++++++++++
 tests/f_bad_inode_csum/expect.2 |    7 ++
 tests/f_bad_inode_csum/image.gz |  Bin
 tests/f_bad_inode_csum/name     |    1 
 4 files changed, 134 insertions(+)
 create mode 100644 tests/f_bad_inode_csum/expect.1
 create mode 100644 tests/f_bad_inode_csum/expect.2
 create mode 100644 tests/f_bad_inode_csum/image.gz
 create mode 100644 tests/f_bad_inode_csum/name

diff --git a/tests/f_bad_inode_csum/expect.1 b/tests/f_bad_inode_csum/expect.1
new file mode 100644
index 0000000..b3c628d
--- /dev/null
+++ b/tests/f_bad_inode_csum/expect.1
@@ -0,0 +1,126 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 33 has a extra size (65535) which is invalid
+Fix? yes
+
+Inode 49 passes checks, but checksum does not match inode.  Fix? yes
+
+Inode 65 passes checks, but checksum does not match inode.  Fix? yes
+
+Inode 81 passes checks, but checksum does not match inode.  Fix? yes
+
+Inode 97 seems to contain garbage.  Clear? yes
+
+Inode 98 seems to contain garbage.  Clear? yes
+
+Inode 99 seems to contain garbage.  Clear? yes
+
+Inode 100 seems to contain garbage.  Clear? yes
+
+Inode 101 seems to contain garbage.  Clear? yes
+
+Inode 102 seems to contain garbage.  Clear? yes
+
+Inode 103 seems to contain garbage.  Clear? yes
+
+Inode 104 seems to contain garbage.  Clear? yes
+
+Inode 105 seems to contain garbage.  Clear? yes
+
+Inode 106 seems to contain garbage.  Clear? yes
+
+Inode 107 seems to contain garbage.  Clear? yes
+
+Inode 108 seems to contain garbage.  Clear? yes
+
+Inode 109 seems to contain garbage.  Clear? yes
+
+Inode 110 seems to contain garbage.  Clear? yes
+
+Inode 111 seems to contain garbage.  Clear? yes
+
+Inode 112 seems to contain garbage.  Clear? yes
+
+Pass 2: Checking directory structure
+Extended attribute block for inode 49 (/38) is invalid (4294967295).
+Clear? yes
+
+Entry '86' in / (2) has deleted/unused inode 97.  Clear? yes
+
+Entry '87' in / (2) has deleted/unused inode 98.  Clear? yes
+
+Entry '88' in / (2) has deleted/unused inode 99.  Clear? yes
+
+Entry '89' in / (2) has deleted/unused inode 100.  Clear? yes
+
+Entry '90' in / (2) has deleted/unused inode 101.  Clear? yes
+
+Entry '91' in / (2) has deleted/unused inode 102.  Clear? yes
+
+Entry '92' in / (2) has deleted/unused inode 103.  Clear? yes
+
+Entry '93' in / (2) has deleted/unused inode 104.  Clear? yes
+
+Entry '94' in / (2) has deleted/unused inode 105.  Clear? yes
+
+Entry '95' in / (2) has deleted/unused inode 106.  Clear? yes
+
+Entry '96' in / (2) has deleted/unused inode 107.  Clear? yes
+
+Entry '97' in / (2) has deleted/unused inode 108.  Clear? yes
+
+Entry '98' in / (2) has deleted/unused inode 109.  Clear? yes
+
+Entry '99' in / (2) has deleted/unused inode 110.  Clear? yes
+
+Entry '100' in / (2) has deleted/unused inode 111.  Clear? yes
+
+Entry '101' in / (2) has deleted/unused inode 112.  Clear? yes
+
+Entry '102' in / (2) has deleted/unused inode 113.  Clear? yes
+
+Entry '103' in / (2) has deleted/unused inode 114.  Clear? yes
+
+Entry '104' in / (2) has deleted/unused inode 115.  Clear? yes
+
+Entry '105' in / (2) has deleted/unused inode 116.  Clear? yes
+
+Entry '106' in / (2) has deleted/unused inode 117.  Clear? yes
+
+Entry '107' in / (2) has deleted/unused inode 118.  Clear? yes
+
+Entry '108' in / (2) has deleted/unused inode 119.  Clear? yes
+
+Entry '109' in / (2) has deleted/unused inode 120.  Clear? yes
+
+Entry '110' in / (2) has deleted/unused inode 121.  Clear? yes
+
+Entry '111' in / (2) has deleted/unused inode 122.  Clear? yes
+
+Entry '112' in / (2) has deleted/unused inode 123.  Clear? yes
+
+Entry '113' in / (2) has deleted/unused inode 124.  Clear? yes
+
+Entry '114' in / (2) has deleted/unused inode 125.  Clear? yes
+
+Entry '115' in / (2) has deleted/unused inode 126.  Clear? yes
+
+Entry '116' in / (2) has deleted/unused inode 127.  Clear? yes
+
+Entry '117' in / (2) has deleted/unused inode 128.  Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Inode bitmap differences:  -(97--128)
+Fix? yes
+
+Free inodes count wrong for group #0 (0, counted=32).
+Fix? yes
+
+Free inodes count wrong (0, counted=32).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 96/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_bad_inode_csum/expect.2 b/tests/f_bad_inode_csum/expect.2
new file mode 100644
index 0000000..b97a902
--- /dev/null
+++ b/tests/f_bad_inode_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 96/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_bad_inode_csum/image.gz b/tests/f_bad_inode_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..221920b04ad0b18949bd75680159390e7b05586a
GIT binary patch
literal 4613
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
GIQ$Pa(@%{6

literal 0
HcmV?d00001

diff --git a/tests/f_bad_inode_csum/name b/tests/f_bad_inode_csum/name
new file mode 100644
index 0000000..68bf7ce
--- /dev/null
+++ b/tests/f_bad_inode_csum/name
@@ -0,0 +1 @@
+inode table corruption (metadata_csum)

