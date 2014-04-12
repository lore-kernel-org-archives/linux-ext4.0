From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: use i_size_read in ext4_unaligned_aio()
Date: Sat, 12 Apr 2014 12:46:14 -0400
Message-ID: <1397321174-7605-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We haven't taken i_mutex yet, so we need to use i_size_read().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 6db7f7d..bc76559 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -82,7 +82,7 @@ ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
 	size_t count = iov_length(iov, nr_segs);
 	loff_t final_size = pos + count;
 
-	if (pos >= inode->i_size)
+	if (pos >= i_size_read(inode))
 		return 0;
 
 	if ((pos & blockmask) || (final_size & blockmask))
-- 
1.9.0
