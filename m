From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/4] ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()
Date: Tue,  9 Jul 2013 10:39:29 -0400
Message-ID: <1373380772-16803-1-git-send-email-tytso@mit.edu>
References: <20130709143855.GF6000@thunk.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36215 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab3GIOjf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jul 2013 10:39:35 -0400
In-Reply-To: <20130709143855.GF6000@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

On 32-bit archs when sector_t is defined as 32-bit the logic computing
data offset in ext4_inline_data_fiemap(). Fix that by properly typing
the shifted value.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
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
1.7.12.rc0.22.gcdd159b

