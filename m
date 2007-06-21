From: Theodore Tso <tytso@MIT.EDU>
Subject: [PATCH 3 of 4] Write the updated journal inode if s_jnl_blocks was
	successfully used
Date: Thu, 21 Jun 2007 13:00:10 -0400
Message-ID: <7a1859d26e5805668862.1182445210@candygram.thunk.org>
References: <patchbomb.1182445207@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: kalpak@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55947 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbXFURBr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2007 13:01:47 -0400
In-Reply-To: <patchbomb.1182445207@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

1 file changed, 7 insertions(+)
e2fsck/journal.c |    7 +++++++


# HG changeset patch
# User tytso@mit.edu
# Date 1182441546 14400
# Node ID 7a1859d26e58056688629ee2faf2f2ee619a1bf1
# Parent  8c5c3cc3fa06ab7791d1a55c3191a4e63a32c8a5
Write the updated journal inode if s_jnl_blocks was successfully used

If the journal inode was corrected from s_jnl_blocks, write the fixed
journal inode back to disk.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

diff -r 8c5c3cc3fa06 -r 7a1859d26e58 e2fsck/journal.c
--- a/e2fsck/journal.c	Thu Jun 21 11:59:06 2007 -0400
+++ b/e2fsck/journal.c	Thu Jun 21 11:59:06 2007 -0400
@@ -285,6 +285,13 @@ static errcode_t e2fsck_get_journal(e2fs
 				goto try_backup_journal;
 			}
 		}
+		if (tried_backup_jnl && !(ctx->options & E2F_OPT_READONLY)) {
+			retval = ext2fs_write_inode(ctx->fs, sb->s_journal_inum,
+						    &j_inode->i_ext2);
+			if (retval)
+				goto errout;
+		}
+
 		journal->j_maxlen = j_inode->i_ext2.i_size / journal->j_blocksize;
 
 #ifdef USE_INODE_IO
