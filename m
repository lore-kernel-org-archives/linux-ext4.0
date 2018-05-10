From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix hole length detection in ext4_ind_map_blocks()
Date: Thu, 10 May 2018 17:38:51 +0200
Message-ID: <20180510153851.4689-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When ext4_ind_map_blocks() computes a length of a hole, it doesn't count
with the fact that mapped offset may be somewhere in the middle of the
completely empty subtree. In such case it will return too large length
of the hole which then results in lseek(SEEK_DATA) to end up returning
an incorrect offset beyond the end of the hole.

Fix the problem by correctly taking offset within a subtree into account
when computing a length of a hole.

Fixes: facab4d9711e7aa3532cb82643803e8f1b9518e8
CC: stable@vger.kernel.org
Reported-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/indirect.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

 I'll submit corresponding fstest shortly.

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index c32802c956d5..bf7fa1507e81 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -561,10 +561,16 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 		unsigned epb = inode->i_sb->s_blocksize / sizeof(u32);
 		int i;
 
-		/* Count number blocks in a subtree under 'partial' */
-		count = 1;
-		for (i = 0; partial + i != chain + depth - 1; i++)
-			count *= epb;
+		/*
+		 * Count number blocks in a subtree under 'partial'. At each
+		 * level we count number of complete empty subtrees beyond
+		 * current offset and then descend into the subtree only
+		 * partially beyond current offset.
+		 */
+		count = 0;
+		for (i = partial - chain + 1; i < depth; i++)
+			count = count * epb + (epb - offsets[i] - 1);
+		count++;
 		/* Fill in size of a hole we found */
 		map->m_pblk = 0;
 		map->m_len = min_t(unsigned int, map->m_len, count);
-- 
2.13.6
