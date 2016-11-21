From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] ext4: remove unused function ext4_aligned_io()
Date: Sun, 20 Nov 2016 22:02:17 -0700
Message-ID: <1479704537-21069-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1479458830-22955-9-git-send-email-jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479458830-22955-9-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The last user of ext4_aligned_io() was the DAX path in
ext4_direct_IO_write().  This usage was removed by Jan Kara's patch
entitled "ext4: Rip out DAX handling from direct IO path".

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext4/ext4.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8b76311..8a8a9b2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3262,13 +3262,6 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 	}
 }
 
-static inline bool ext4_aligned_io(struct inode *inode, loff_t off, loff_t len)
-{
-	int blksize = 1 << inode->i_blkbits;
-
-	return IS_ALIGNED(off, blksize) && IS_ALIGNED(len, blksize);
-}
-
 extern struct iomap_ops ext4_iomap_ops;
 
 #endif	/* __KERNEL__ */
-- 
2.7.4
