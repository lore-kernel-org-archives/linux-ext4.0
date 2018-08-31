From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: avoid arithemetic overflow that can trigger a BUG
Date: Fri, 31 Aug 2018 13:41:26 -0400
Message-ID: <20180831174126.13071-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

A maliciously crafted file system can cause an overflow when the
results of a 64-bit calculation is stored into a 32-bit length
parameter.

https://bugzilla.kernel.org/show_bug.cgi?id=200623

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: Wen Xu <wen.xu@gatech.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8f6ad7667974..1134c3473673 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3414,6 +3414,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned long first_block = offset >> blkbits;
 	unsigned long last_block = (offset + length - 1) >> blkbits;
+	unsigned long len;
 	struct ext4_map_blocks map;
 	bool delalloc = false;
 	int ret;
@@ -3434,7 +3435,8 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	}
 
 	map.m_lblk = first_block;
-	map.m_len = last_block - first_block + 1;
+	len = last_block - first_block + 1;
+	map.m_len = (len < UINT_MAX) ? len : UINT_MAX;
 
 	if (flags & IOMAP_REPORT) {
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
-- 
2.18.0.rc0
