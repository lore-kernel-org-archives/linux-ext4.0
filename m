From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 18/20] ext4: calculate journal credits correctly
Date: Sun, 16 Nov 2008 11:05:38 -0500
Message-ID: <1226851540-8032-19-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
 <1226851540-8032-6-git-send-email-tytso@mit.edu>
 <1226851540-8032-7-git-send-email-tytso@mit.edu>
 <1226851540-8032-8-git-send-email-tytso@mit.edu>
 <1226851540-8032-9-git-send-email-tytso@mit.edu>
 <1226851540-8032-10-git-send-email-tytso@mit.edu>
 <1226851540-8032-11-git-send-email-tytso@mit.edu>
 <1226851540-8032-12-git-send-email-tytso@mit.edu>
 <1226851540-8032-13-git-send-email-tytso@mit.edu>
 <1226851540-8032-14-git-send-email-tytso@mit.edu>
 <1226851540-8032-15-git-send-email-tytso@mit.edu>
 <1226851540-8032-16-git-send-email-tytso@mit.edu>
 <1226851540-8032-17-git-send-email-tytso@mit.edu>
 <1226851540-8032-18-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58998 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753252AbYKPQXh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:23:37 -0500
In-Reply-To: <1226851540-8032-18-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes a 2.6.27 regression which was introduced in commit a02908f1.

We weren't passing the chunk parameter down to the two subections,
ext4_indirect_trans_blocks() and ext4_ext_index_trans_blocks(), with
the result that massively overestimate the amount of credits needed by
ext4_da_writepages, especially in the non-extents case.  This causes
failures especially on /boot partitions, which tend to be small and
non-extent using since GRUB doesn't handle extents.

This patch fixes the bug reported by Joseph Fannin at:
http://bugzilla.kernel.org/show_bug.cgi?id=11964

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit ac51d83705c2a38c71f39cde99708b14e6212a60)
---
 fs/ext4/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7e91913..4ec89d3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4444,9 +4444,10 @@ static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
 static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 {
 	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
-		return ext4_indirect_trans_blocks(inode, nrblocks, 0);
-	return ext4_ext_index_trans_blocks(inode, nrblocks, 0);
+		return ext4_indirect_trans_blocks(inode, nrblocks, chunk);
+	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
 }
+
 /*
  * Account for index blocks, block groups bitmaps and block group
  * descriptor blocks if modify datablocks and index blocks
-- 
1.6.0.4.8.g36f27.dirty

