From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/39] misc: fix compiler warnings
Date: Sat, 25 Oct 2014 13:56:30 -0700
Message-ID: <20141025205629.532.30496.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43605 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaJYU5E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:57:04 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix some gcc-4.8 warnings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 8d6032b..64fb7fe 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -84,7 +84,7 @@ void e2fsck_pass5(e2fsck_t ctx)
 static void check_inode_bitmap_checksum(e2fsck_t ctx)
 {
 	struct problem_context	pctx;
-	char		*buf;
+	char		*buf = NULL;
 	dgrp_t		i;
 	int		nbytes;
 	ext2_ino_t	ino_itr;
@@ -139,7 +139,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 static void check_block_bitmap_checksum(e2fsck_t ctx)
 {
 	struct problem_context	pctx;
-	char		*buf;
+	char		*buf = NULL;
 	dgrp_t		i;
 	int		nbytes;
 	blk64_t		blk_itr;

