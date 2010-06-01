From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 15/40] ext4: Fix buffer head leaks after calls to ext4_get_inode_loc()
Date: Tue,  1 Jun 2010 08:03:02 -0400
Message-ID: <1275393807-14369-15-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47360 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab0FAMDn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:43 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Curt Wohlgemuth <curtw@google.com>

commit fd2dd9fbaf9e498ec63eef298921e36556f7214c upstream (as of v2.6.34-rc6)

Calls to ext4_get_inode_loc() returns with a reference to a buffer
head in iloc->bh.  The callers of this function in ext4_write_inode()
when in no journal mode and in ext4_xattr_fiemap() don't release the
buffer head after using it.

Addresses-Google-Bug: #2548165

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    1 +
 fs/ext4/inode.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b38058a..3afdded 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3772,6 +3772,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		physical += offset;
 		length = EXT4_SB(inode->i_sb)->s_inode_size - offset;
 		flags |= FIEMAP_EXTENT_DATA_INLINE;
+		brelse(iloc.bh);
 	} else { /* external block */
 		physical = EXT4_I(inode)->i_file_acl << blockbits;
 		length = inode->i_sb->s_blocksize;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 28152f8..3e06a5d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5217,6 +5217,7 @@ int ext4_write_inode(struct inode *inode, int wait)
 				   (unsigned long long)iloc.bh->b_blocknr);
 			err = -EIO;
 		}
+		brelse(iloc.bh);
 	}
 	return err;
 }
-- 
1.6.6.1.1.g974db.dirty

