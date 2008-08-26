From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] e2fsck shouln't consider superblock summaries as fatal
Date: Tue, 26 Aug 2008 04:45:02 -0600
Message-ID: <20080826104502.GH3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51983 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbYHZKpF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 06:45:05 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7QAj46u009136
	for <linux-ext4@vger.kernel.org>; Tue, 26 Aug 2008 03:45:04 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6700001F72QG00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 26 Aug 2008 03:45:04 -0700 (PDT)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Running e2fsck on a quiescent (but mounted) filesystem fails in the
common case where the superblock inode and block count summaries are
wrong.  The kernel doesn't update these values except at unmount time.
If there are other errors in the filesystem then they will already
cause e2fsck to consider the filesystem invalid, so these minor errors
should not.

Don't consider only an error in the superblock summary as incorrect.
The kernel does not update this field except at unmount time.  Any
other unfixed errors will themselves mark the filesystem invalid.

Signed-off-by: Andreas Dilger <adilger@sun.com>

--- ./e2fsck/pass5.c.orig	2008-07-09 12:36:03.000000000 -0600
+++ ./e2fsck/pass5.c	2008-08-26 04:10:40.000000000 -0600
@@ -347,8 +347,7 @@ redo_counts:
 		if (fix_problem(ctx, PR_5_FREE_BLOCK_COUNT, &pctx)) {
 			fs->super->s_free_blocks_count = free_blocks;
 			ext2fs_mark_super_dirty(fs);
-		} else
-			ext2fs_unmark_valid(fs);
+		}
 	}
 errout:
 	ext2fs_free_mem(&free_array);
@@ -566,8 +565,7 @@ do_counts:
 		if (fix_problem(ctx, PR_5_FREE_INODE_COUNT, &pctx)) {
 			fs->super->s_free_inodes_count = free_inodes;
 			ext2fs_mark_super_dirty(fs);
-		} else
-			ext2fs_unmark_valid(fs);
+		}
 	}
 errout:
 	ext2fs_free_mem(&free_array);
--- ./e2fsck/problem.c.orig	2008-07-09 12:36:03.000000000 -0600
+++ ./e2fsck/problem.c	2008-08-26 03:58:05.000000000 -0600
@@ -1577,7 +1587,7 @@ static struct e2fsck_problem problem_tab
 	/* Free inodes count wrong */
 	{ PR_5_FREE_INODE_COUNT,
 	  N_("Free @is count wrong (%i, counted=%j).\n"),
-	  PROMPT_FIX, PR_PREEN_OK | PR_PREEN_NOMSG },
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK | PR_PREEN_NOMSG },
 
 	/* Free blocks count for group wrong */
 	{ PR_5_FREE_BLOCK_COUNT_GROUP,
@@ -1587,7 +1597,7 @@ static struct e2fsck_problem problem_tab
 	/* Free blocks count wrong */
 	{ PR_5_FREE_BLOCK_COUNT,
 	  N_("Free @bs count wrong (%b, counted=%c).\n"),
-	  PROMPT_FIX, PR_PREEN_OK | PR_PREEN_NOMSG },
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK | PR_PREEN_NOMSG },
 
 	/* Programming error: bitmap endpoints don't match */
 	{ PR_5_BMAP_ENDPOINTS,

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

