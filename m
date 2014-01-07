From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: avoid clearing beyond i_blocks when truncating an inline data file
Date: Tue,  7 Jan 2014 12:57:17 -0500
Message-ID: <1389117437-12060-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46656 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbaAGR5Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 12:57:25 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A missing cast means that when we are truncating a file which is less
than 60 bytes, we don't trunate the wrong area of memory, and in fact
we can end up truncating the next inode in the inode table, or worse
yet, some other kernel data structure.

Addresses-Coverity-Id: #751987

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/inline.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index c417e52..ed29e72 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1928,9 +1928,11 @@ void ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 		}
 
 		/* Clear the content within i_blocks. */
-		if (i_size < EXT4_MIN_INLINE_DATA_SIZE)
-			memset(ext4_raw_inode(&is.iloc)->i_block + i_size, 0,
-					EXT4_MIN_INLINE_DATA_SIZE - i_size);
+		if (i_size < EXT4_MIN_INLINE_DATA_SIZE) {
+			void *p = (void *) ext4_raw_inode(&is.iloc)->i_block;
+			memset(p + i_size, 0,
+			       EXT4_MIN_INLINE_DATA_SIZE - i_size);
+		}
 
 		EXT4_I(inode)->i_inline_size = i_size <
 					EXT4_MIN_INLINE_DATA_SIZE ?
-- 
1.8.5.rc3.362.gdf10213

