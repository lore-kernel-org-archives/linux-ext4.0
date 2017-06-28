From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] ext4: fast symlink test should not rely on i_blocks
Date: Tue, 27 Jun 2017 17:34:55 -0700
Message-ID: <20170628003455.12748-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:36428 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752620AbdF1AfC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 20:35:02 -0400
Received: by mail-pg0-f42.google.com with SMTP id u62so23238333pgb.3
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jun 2017 17:35:01 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_inode_info->i_data is the storage area for 4 types of data:

  a) Extents data
  b) Inline data
  c) Block map
  d) Fast symlink data (symlink length < 60)

Extents data case is positively identified by EXT4_INODE_EXTENTS flag.
Inline data case is also obvious because of EXT4_INODE_INLINE_DATA
flag.

Distinguishing c) and d) however requires additional logic. This
currently relies on i_blocks count. After subtracting external xattr
block from i_blocks, if it is greater than 0 then we know that some
data blocks exist, so there must be a block map.

This logic got broken after ea_inode feature was added. That feature
charges the data blocks of external xattr inodes to the referencing
inode and so adds them to the i_blocks. To fix this, we could subtract
ea_inode blocks by iterating through all xattr entries and then check
whether remaining i_blocks count is zero. Besides being complicated,
this won't change the fact that the current way of distinguishing
between c) and d) is fragile.

The alternative solution is to test whether i_size is less than 60 to
determine fast symlink case. ext4_symlink() uses the same test to decide
whether to store the symlink in i_data. There is one caveat to address
before this can work though.

If an inode's i_nlink is zero during eviction, its i_size is set to
zero and its data is truncated. If system crashes before inode is removed
from the orphan list, next boot orphan cleanup may find the inode with
zero i_size. So, a symlink that had its data stored in a block may now
appear to be a fast symlink. The solution used in this patch is to treat
i_size = 0 as a non-fast symlink case. A zero sized symlink is not legal
so the only time this can happen is the mentioned scenario. This is also
logically correct because a i_size = 0 symlink has no data stored in
i_data.

Fixes: 74c5bfa651af ("ext4: xattr inode deduplication")

Suggested-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/inode.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index daed9b38362a..3c600f02673f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -144,16 +144,12 @@ static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
 
 /*
  * Test whether an inode is a fast symlink.
+ * A fast symlink has its symlink data stored in ext4_inode_info->i_data.
  */
 int ext4_inode_is_fast_symlink(struct inode *inode)
 {
-        int ea_blocks = EXT4_I(inode)->i_file_acl ?
-		EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;
-
-	if (ext4_has_inline_data(inode))
-		return 0;
