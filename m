From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 2/4] Don't byte swap extents information in the inode
Date: Sun, 16 Sep 2007 22:57:39 -0400
Message-ID: <11899978612166-git-send-email-tytso@mit.edu>
References: <1189997861181-git-send-email-tytso@mit.edu>
 <11899978613069-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33740 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbXIQC5s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Sep 2007 22:57:48 -0400
In-Reply-To: <11899978613069-git-send-email-tytso@mit.edu>
Message-Id: <2602a6e4ece40218c0344062932f1fd6d9ee7ed8.1189997130.git.tytso@mit.edu>
In-Reply-To: <5db31092e4fe5c89eb093da1aff6fda8c100647d.1189997130.git.tytso@mit.edu>
References: <5db31092e4fe5c89eb093da1aff6fda8c100647d.1189997130.git.tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Responsibility for byte swapping the extents information rests with
the low-level extent code, which translates the on-disk extents
information to the abstract extent format.  The on-disk format will
eventually get more complicated, in order to add support for 64-bit
block numbers, bit-compressed extents, etc.  So to avoid needing to
expose all of that complexity in swapfs.c, the in-memory contents of
i_blocks will not be byte-swapped and will be identical to the on-disk
format.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/swapfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index bd0844d..52ca6a0 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -158,7 +158,11 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 	if (!hostorder)
 		has_data_blocks = ext2fs_inode_data_blocks(fs, 
 					   (struct ext2_inode *) t);
+	if (hostorder && (f->i_flags & EXT4_EXTENTS_FL))
+		has_data_blocks = 0;
 	t->i_flags = ext2fs_swab32(f->i_flags);
+	if (hostorder && (t->i_flags & EXT4_EXTENTS_FL))
+		has_data_blocks = 0;
 	t->i_dir_acl = ext2fs_swab32(f->i_dir_acl);
 	if (!islnk || has_data_blocks ) {
 		for (i = 0; i < EXT2_N_BLOCKS; i++)
-- 
1.5.3.1.19.gb5ef6
