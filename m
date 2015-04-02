From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/35] e2fsck: turn inline data symlink into a fast symlink
 when possible
Date: Wed, 01 Apr 2015 19:34:13 -0700
Message-ID: <20150402023413.25243.97254.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35240 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbbDBCeR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:34:17 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When there's a problem accessing the EA part of an inline data symlink
and we want to truncate the symlink back to 60 characters (hoping the
user can re-establish the link later on, apparently) be sure to turn
off the inline data flag to convert the symlink back to a regular fast
symlink.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c                     |    2 ++
 tests/f_inlinedata_repair/expect.1 |    5 ++++-
 tests/f_inlinedata_repair/expect.2 |    2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 791817b..bf95ae1 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1251,6 +1251,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 						ctx->flags |= E2F_FLAG_ABORT;
 						goto endit;
 					}
+					if (LINUX_S_ISLNK(inode->i_mode))
+						inode->i_flags &= ~EXT4_INLINE_DATA_FL;
 					e2fsck_write_inode(ctx, ino, inode,
 							   "pass1");
 					failed_csum = 0;
diff --git a/tests/f_inlinedata_repair/expect.1 b/tests/f_inlinedata_repair/expect.1
index cc220ba..9c84b14 100644
--- a/tests/f_inlinedata_repair/expect.1
+++ b/tests/f_inlinedata_repair/expect.1
@@ -21,6 +21,9 @@ Salvage? yes
 Directory inode 32, block #0, offset 4: directory corrupted
 Salvage? yes
 
+Symlink /1 (inode #12) is invalid.
+Clear? yes
+
 Symlink /3 (inode #14) is invalid.
 Clear? yes
 
@@ -51,5 +54,5 @@ Unattached zero-length inode 35.  Clear? yes
 Pass 5: Checking group summary information
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 27/128 files (0.0% non-contiguous), 18/512 blocks
+test_filesys: 26/128 files (0.0% non-contiguous), 18/512 blocks
 Exit status is 1
diff --git a/tests/f_inlinedata_repair/expect.2 b/tests/f_inlinedata_repair/expect.2
index 2c400a5..69d874e 100644
--- a/tests/f_inlinedata_repair/expect.2
+++ b/tests/f_inlinedata_repair/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 27/128 files (0.0% non-contiguous), 18/512 blocks
+test_filesys: 26/128 files (0.0% non-contiguous), 18/512 blocks
 Exit status is 0

