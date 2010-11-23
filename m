From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 11/22] ext3: use little-endian bitops
Date: Tue, 23 Nov 2010 22:38:13 +0900
Message-ID: <1290519504-3958-12-git-send-email-akinobu.mita@gmail.com>
References: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h. This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
No change from previous submission
 include/linux/ext3_fs.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 6ce1bca..34ef455 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -418,13 +418,18 @@ struct ext3_inode {
 #define EXT2_MOUNT_DATA_FLAGS		EXT3_MOUNT_DATA_FLAGS
 #endif
 
-#define ext3_set_bit			ext2_set_bit
+#define ext3_set_bit(nr, addr)	\
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
 #define ext3_set_bit_atomic		ext2_set_bit_atomic
-#define ext3_clear_bit			ext2_clear_bit
+#define ext3_clear_bit(nr, addr)	\
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
 #define ext3_clear_bit_atomic		ext2_clear_bit_atomic
-#define ext3_test_bit			ext2_test_bit
-#define ext3_find_first_zero_bit	ext2_find_first_zero_bit
-#define ext3_find_next_zero_bit		ext2_find_next_zero_bit
+#define ext3_test_bit(nr, addr)	\
+	test_le_bit((nr), (unsigned long *)(addr))
+#define ext3_find_first_zero_bit(addr, size)	\
+	find_first_zero_le_bit((unsigned long *)(addr), (size))
+#define ext3_find_next_zero_bit(addr, size, off)	\
+	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
 
 /*
  * Maximal mount counts between two filesystem checks
-- 
1.7.3.2
