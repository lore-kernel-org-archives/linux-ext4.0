From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs-next] Fix extent flag validity tests in pass1 on
 big endian boxes.
Date: Mon, 24 Mar 2008 17:13:42 -0500
Message-ID: <47E82796.9050807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbYCXWNo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 18:13:44 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m2OMDi4v014998
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 18:13:44 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2OMDhdp017677
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 18:13:43 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2OMDgH9000497
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 18:13:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Extent data is shared with the i_block[] space in the inode,
but it is always swapped on access, not when the inode is read.

In e2fsck/pass1.c we must be careful when checking validity
of the extents flag on the inode.  If the flag was set when
the inode was read & swapped, then the extents data itself
(in ->i_block[]) was NOT swapped, so testing for a valid
extent header requires some swapping first.  Then, if we
ultimately set the extents flag, all of i_block[] must be
re/un-swapped.

This passes the f_extent regression test on both ppc & x86.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
(I said I wanted to make it not-ugly... not sure I succeeded)
(also feel free to edit the comments if too verbose)

 e2fsck/pass1.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 79e9f23..0d6307d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -680,7 +680,22 @@ void e2fsck_pass1(e2fsck_t ctx)
 				return;
 			}
 		}
-		
+
+		/*
+		 * Test for incorrect extent flag settings.
+		 *
+		 * On big-endian machines we must be careful:
+		 * When the inode is read, the i_block array is not swapped
+		 * if the extent flag is set.  Therefore if we are testing
+		 * for or fixing a wrongly-set flag, we must potentially
+		 * (un)swap before testing, or after fixing.
+		 */
+
+		/*
+		 * In this case the extents flag was set when read, so
+		 * extent_header_verify is ok.  If the inode is cleared,
+		 * no need to swap... so no extra swapping here.
+		 */
 		if ((inode->i_flags & EXT4_EXTENTS_FL) && !extent_fs && 
 		    (inode->i_links_count || (ino == EXT2_BAD_INO) ||
 		     (ino == EXT2_ROOT_INO) || (ino == EXT2_JOURNAL_INO))) {
@@ -700,19 +716,48 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 
+		/*
+		 * For big-endian machines:
+		 * If the inode didn't have the extents flag set when it
+		 * was read, then the i_blocks array was swapped.  To test
+		 * as an extents header, we must swap it back first.
+		 * IF we then set the extents flag, the entire i_block
+		 * array must be un/re-swapped to make it proper extents data.
+		 */
+
 		if (extent_fs && !(inode->i_flags & EXT4_EXTENTS_FL) &&
 		    (inode->i_links_count || (ino == EXT2_BAD_INO) ||
 		     (ino == EXT2_ROOT_INO) || (ino == EXT2_JOURNAL_INO)) &&
 		    (LINUX_S_ISREG(inode->i_mode) ||
-		     LINUX_S_ISDIR(inode->i_mode)) &&
-		    (ext2fs_extent_header_verify(inode->i_block, 
-						 sizeof(inode->i_block)) == 0)) {
+		     LINUX_S_ISDIR(inode->i_mode))) {
+			void *ehp;
+#ifdef WORDS_BIGENDIAN
+			__u32 tmp_block[3];
+
+			for (i = 0; i < 3; i++)
+				tmp_block[i] = ext2fs_swab32(inode->i_block[i]);
+			ehp = tmp_block;
+#else
+			ehp = inode->i_block;
+#endif
+		    if (ext2fs_extent_header_verify(ehp,
+					 sizeof(inode->i_block)) == 0) {
 			if (fix_problem(ctx, PR_1_UNSET_EXTENT_FL, &pctx)) {
 				inode->i_flags |= EXT4_EXTENTS_FL;
+#ifdef WORDS_BIGENDIAN
+				for (i = 0; i < EXT2_N_BLOCKS; i++)
+					inode->i_block[i] =
+					       ext2fs_swab32(inode->i_block[i]);
+#endif
 				e2fsck_write_inode(ctx, ino, inode, "pass1");
 			}
+		    }
 		}
 
+		/*
+		 * ext2fs_inode_has_valid_blocks does not actually look
+		 * at i_block[] values, so not endian-sensitive here.
+		 */
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL) &&
 		    LINUX_S_ISLNK(inode->i_mode) &&
 		    !ext2fs_inode_has_valid_blocks(inode) &&
-- 1.5.4.1

