From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext4: Fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()
Date: Wed, 29 May 2013 14:05:30 +0200
Message-ID: <1369829133-4307-2-git-send-email-jack@suse.cz>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965749Ab3E2MFl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 May 2013 08:05:41 -0400
In-Reply-To: <1369829133-4307-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 32-bit archs when sector_t is defined as 32-bit the logic computing
data offset in ext4_inline_data_fiemap(). Fix that by properly typing
the shifted value.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 3e2bf87..33331b4 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1842,7 +1842,7 @@ int ext4_inline_data_fiemap(struct inode *inode,
 	if (error)
 		goto out;
 
-	physical = iloc.bh->b_blocknr << inode->i_sb->s_blocksize_bits;
+	physical = (__u64)iloc.bh->b_blocknr << inode->i_sb->s_blocksize_bits;
 	physical += (char *)ext4_raw_inode(&iloc) - iloc.bh->b_data;
 	physical += offsetof(struct ext4_inode, i_block);
 	length = i_size_read(inode);
-- 
1.8.1.4

