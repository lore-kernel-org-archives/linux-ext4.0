From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/11] ext4: Use iomap for zeroing blocks in DAX mode
Date: Tue,  8 Nov 2016 12:08:10 +0100
Message-ID: <1478603297-11793-5-git-send-email-jack@suse.cz>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34449 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752883AbcKHLKE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Nov 2016 06:10:04 -0500
In-Reply-To: <1478603297-11793-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use iomap infrastructure for zeroing blocks when in DAX mode.
ext4_iomap_begin() handles read requests just fine and that's all that
is needed for iomap_zero_range().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 83e8411370d3..df017ce3e52d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3849,8 +3849,10 @@ static int ext4_block_zero_page_range(handle_t *handle,
 	if (length > max || length < 0)
 		length = max;
 
-	if (IS_DAX(inode))
-		return dax_zero_page_range(inode, from, length, ext4_get_block);
+	if (IS_DAX(inode)) {
+		return iomap_zero_range(inode, from, length, NULL,
+					&ext4_iomap_ops);
+	}
 	return __ext4_block_zero_page_range(handle, mapping, from, length);
 }
 
-- 
2.6.6

