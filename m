From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/6] libext2fs: during punch,
 fix parent extents after modifying extent
Date: Mon, 20 Jan 2014 22:22:04 -0800
Message-ID: <20140121062204.20507.93142.stgit@birch.djwong.org>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20725 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaAUGWJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 01:22:09 -0500
In-Reply-To: <20140121062138.20507.60259.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When modifying/removing an extent during punch, don't forget to update
the extent's parents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/punch.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 657cb53..a3d020e 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -353,6 +353,9 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 		if (extent.e_len) {
 			dbg_print_extent("replacing", &extent);
 			retval = ext2fs_extent_replace(handle, 0, &extent);
+			if (retval)
+				goto errout;
+			retval = ext2fs_extent_fix_parents(handle);
 		} else {
 			struct ext2fs_extent	newex;
 			blk64_t			old_lblk, next_lblk;
@@ -387,6 +390,11 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 			if (retval)
 				goto errout;
 
+			retval = ext2fs_extent_fix_parents(handle);
+			if (retval && retval != EXT2_ET_NO_CURRENT_NODE)
+				goto errout;
+			retval = 0;
+
 			/* Jump forward to the next extent. */
 			ext2fs_extent_goto(handle, next_lblk);
 			op = EXT2_EXTENT_CURRENT;

