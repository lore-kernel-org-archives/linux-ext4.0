From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 55/54] e2fsck: actually fix inline_data flags problems when
 user says to do so
Date: Thu, 19 Mar 2015 14:44:49 -0700
Message-ID: <20150319214449.GJ11031@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25892 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbbCSVoz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Mar 2015 17:44:55 -0400
Content-Disposition: inline
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fix_problem() returning 1 means to fix the fs error, so do that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c                          |    4 ++--
 tests/f_bad_disconnected_inode/expect.1 |   18 ------------------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 4a479b6..19e1f33 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1268,12 +1268,12 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 			pctx.errcode = ext2fs_inline_data_size(fs, ino, &size);
 			if (!pctx.errcode && size &&
-			    !fix_problem(ctx, PR_1_INLINE_DATA_FEATURE, &pctx)) {
+			    fix_problem(ctx, PR_1_INLINE_DATA_FEATURE, &pctx)) {
 				sb->s_feature_incompat |=
 					EXT4_FEATURE_INCOMPAT_INLINE_DATA;
 				ext2fs_mark_super_dirty(fs);
 				inlinedata_fs = 1;
-			} else if (!fix_problem(ctx, PR_1_INLINE_DATA_SET, &pctx)) {
+			} else if (fix_problem(ctx, PR_1_INLINE_DATA_SET, &pctx)) {
 				e2fsck_clear_inode(ctx, ino, inode, 0, "pass1");
 				/* skip FINISH_INODE_LOOP */
 				continue;
diff --git a/tests/f_bad_disconnected_inode/expect.1 b/tests/f_bad_disconnected_inode/expect.1
index 9f9b447..c5ea7bf 100644
--- a/tests/f_bad_disconnected_inode/expect.1
+++ b/tests/f_bad_disconnected_inode/expect.1
@@ -8,15 +8,9 @@ Clear? yes
 Inode 15 has INLINE_DATA_FL flag on filesystem without inline data support.
 Clear? yes
 
-Inode 15 has EXTENTS_FL flag set on filesystem without extents support.
-Clear? yes
-
 Inode 16 has INLINE_DATA_FL flag on filesystem without inline data support.
 Clear? yes
 
-Inode 16 has EXTENTS_FL flag set on filesystem without extents support.
-Clear? yes
-
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 /lost+found not found.  Create? yes
@@ -30,12 +24,6 @@ Clear? yes
 Inode 13 (...) has invalid mode (0117003).
 Clear? yes
 
-i_file_acl for inode 14 (...) is 2892851642, should be zero.
-Clear? yes
-
-Inode 14 (...) has invalid mode (0154247).
-Clear? yes
-
 Pass 5: Checking group summary information
 Block bitmap differences:  -(9--19)
 Fix? yes
@@ -46,15 +34,9 @@ Fix? yes
 Free blocks count wrong (79, counted=91).
 Fix? yes
 
-Free inodes count wrong for group #0 (6, counted=5).
-Fix? yes
-
 Directories count wrong for group #0 (3, counted=2).
 Fix? yes
 
-Free inodes count wrong (6, counted=5).
-Fix? yes
