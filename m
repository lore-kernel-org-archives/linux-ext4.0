From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/6] libext2fs: iterate past lower extents during punch
Date: Mon, 20 Jan 2014 22:21:58 -0800
Message-ID: <20140121062158.20507.50066.stgit@birch.djwong.org>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20652 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaAUGWC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 01:22:02 -0500
In-Reply-To: <20140121062138.20507.60259.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're iterating extents during a punch operation, the loop exits
if the punch region is entirely to the right of the extent we're
looking at.  This can happen if the punch region starts in the middle
of a hole and covers mapped extents.  When this happens, we want to
skip to the next extent, because it might be punchable.

Also, if we've totally passed the punch range, stop.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/punch.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 25d7953..657cb53 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -288,8 +288,12 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 			   (unsigned long long) end,
 			   (unsigned long long) next);
 		if (start <= extent.e_lblk) {
+			/*
+			 * Have we iterated past the end of the punch region?
+			 * If so, we can stop.
+			 */
 			if (end < extent.e_lblk)
-				goto next_extent;
+				break;
 			dbg_printf("Case #%d\n", 1);
 			/* Start of deleted region before extent; 
 			   adjust beginning of extent */
@@ -303,8 +307,13 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 			extent.e_lblk += free_count;
 			extent.e_pblk += free_count;
 		} else if (end >= next-1) {
+			/*
+			 * Is the punch region beyond this extent?  This can
+			 * happen if start is already inside a hole.  Try to
+			 * advance to the next extent if this is the case.
+			 */
 			if (start >= next)
-				break;
+				goto next_extent;
 			/* End of deleted region after extent;
 			   adjust end of extent */
 			dbg_printf("Case #%d\n", 2);

