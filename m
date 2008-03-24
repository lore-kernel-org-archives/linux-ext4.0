From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [E2FSPROGS, PATCH] e2fsck: Don't object to extents flags on deleted fast symlinks
Date: Mon, 24 Mar 2008 08:20:09 -0400
Message-ID: <1206361209-12689-1-git-send-email-tytso@mit.edu>
References: <20080321114234.GB6542@skywalker>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59361 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259AbYCXMUM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 08:20:12 -0400
In-Reply-To: <20080321114234.GB6542@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks to Aneesh Kumar for pointing this out.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 79e9f23..67a8370 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -713,14 +713,6 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 
-		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL) &&
-		    LINUX_S_ISLNK(inode->i_mode) &&
-		    !ext2fs_inode_has_valid_blocks(inode) &&
-		    fix_problem(ctx, PR_1_FAST_SYMLINK_EXTENT_FL, &pctx)) {
-			inode->i_flags &= ~EXT4_EXTENTS_FL;
-			e2fsck_write_inode(ctx, ino, inode, "pass1");
-		}
