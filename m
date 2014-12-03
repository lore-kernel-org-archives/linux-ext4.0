From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 50/47] e2fsck: remove 'invalid' wording from error when
 extent block fails checksum
Date: Tue, 2 Dec 2014 18:52:51 -0800
Message-ID: <20141203025251.GA10059@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30578 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaLCCw5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2014 21:52:57 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't say the physical block number is invalid if an extent block
fails only the checksum.  It passes checks, so it's not invalid.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/problem.c                      |    2 +-
 tests/f_extent_int_bad_csum/expect.1  |    2 +-
 tests/f_extent_leaf_bad_csum/expect.1 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 75e0305..b1bcc0d 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -998,7 +998,7 @@ static struct e2fsck_problem problem_table[] = {
 	 */
 	{ PR_1_EXTENT_ONLY_CSUM_INVALID,
 	  N_("@i %i extent block passes checks, but checksum does not match "
-	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
+	     "extent\n\t(logical @b %c, physical @b %b, len %N)\n"),
 	  PROMPT_FIX, 0 },
 
 	/*
diff --git a/tests/f_extent_int_bad_csum/expect.1 b/tests/f_extent_int_bad_csum/expect.1
index 57a2a61..7b412b8 100644
--- a/tests/f_extent_int_bad_csum/expect.1
+++ b/tests/f_extent_int_bad_csum/expect.1
@@ -1,6 +1,6 @@
 Pass 1: Checking inodes, blocks, and sizes
 Inode 12 extent block passes checks, but checksum does not match extent
-	(logical block 698, invalid physical block 1788, len 1)
+	(logical block 698, physical block 1788, len 1)
 Fix? yes
 
 Pass 2: Checking directory structure
diff --git a/tests/f_extent_leaf_bad_csum/expect.1 b/tests/f_extent_leaf_bad_csum/expect.1
index 0dc78ad..86e501a 100644
--- a/tests/f_extent_leaf_bad_csum/expect.1
+++ b/tests/f_extent_leaf_bad_csum/expect.1
@@ -1,6 +1,6 @@
 Pass 1: Checking inodes, blocks, and sizes
 Inode 12 extent block passes checks, but checksum does not match extent
-	(logical block 7, invalid physical block 1090, len 1)
+	(logical block 7, physical block 1090, len 1)
 Fix? yes
 
 Pass 2: Checking directory structure
