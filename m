From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext4: Fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
Date: Wed, 29 May 2013 14:05:32 +0200
Message-ID: <1369829133-4307-4-git-send-email-jack@suse.cz>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965806Ab3E2MFl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 May 2013 08:05:41 -0400
In-Reply-To: <1369829133-4307-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 32-bit architectures with 32-bit sector_t computation of data offset
in ext4_xattr_fiemap() can overflow resulting in reporting bogus data
location. Fix the problem by typing block number to proper type before
shifting.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bc0f191..e49da58 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4659,7 +4659,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		error = ext4_get_inode_loc(inode, &iloc);
 		if (error)
 			return error;
-		physical = iloc.bh->b_blocknr << blockbits;
+		physical = (__u64)iloc.bh->b_blocknr << blockbits;
 		offset = EXT4_GOOD_OLD_INODE_SIZE +
 				EXT4_I(inode)->i_extra_isize;
 		physical += offset;
@@ -4667,7 +4667,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		flags |= FIEMAP_EXTENT_DATA_INLINE;
 		brelse(iloc.bh);
 	} else { /* external block */
-		physical = EXT4_I(inode)->i_file_acl << blockbits;
+		physical = (__u64)EXT4_I(inode)->i_file_acl << blockbits;
 		length = inode->i_sb->s_blocksize;
 	}
 
-- 
1.8.1.4

