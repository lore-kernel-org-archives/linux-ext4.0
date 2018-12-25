Return-Path: <SRS0=xJ0y=PC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr700093.outbound.protection.outlook.com ([40.107.70.93]:60095
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbeLYF5G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Dec 2018 00:57:06 -0500
From: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
CC: Theodore Ts'o <tytso@mit.edu>, <stable@kernel.org>
Subject: [PATCH] ext4: fix a potential fiemap/page fault deadlock w/ inline_data
Date: Tue, 25 Dec 2018 00:56:53 -0500
Message-ID: <20181225055653.9382-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4_inline_data_fiemap() function calls fiemap_fill_next_extent()
while still holding the xattr semaphore.  This is not necessary and it
triggers a circular lockdep warning.  This is because
fiemap_fill_next_extent() could trigger a page fault when it writes
into page which triggers a page fault.  If that page is mmaped from
the inline file in question, this could very well result in a
deadlock.

This problem can be reproduced using generic/519 with a file system
configuration which has the inline_data feature enabled.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/inline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 27373d88b5f0..56f6e1782d5f 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1890,12 +1890,12 @@ int ext4_inline_data_fiemap(struct inode *inode,
 	physical += (char *)ext4_raw_inode(&iloc) - iloc.bh->b_data;
 	physical += offsetof(struct ext4_inode, i_block);
 
-	if (physical)
-		error = fiemap_fill_next_extent(fieinfo, start, physical,
-						inline_len, flags);
 	brelse(iloc.bh);
 out:
 	up_read(&EXT4_I(inode)->xattr_sem);
+	if (physical)
+		error = fiemap_fill_next_extent(fieinfo, start, physical,
+						inline_len, flags);
 	return (error < 0 ? error : 0);
 }
 
-- 
2.19.1
