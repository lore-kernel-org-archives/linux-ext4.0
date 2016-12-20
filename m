From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH] ext4: convert swap_inode_data() over to use swap() on most of the fields
Date: Tue, 20 Dec 2016 10:55:41 -0500
Message-ID: <1482249341-21113-1-git-send-email-jlayton@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For some odd reason, it forces a byte-by-byte copy of each field. A
plain old swap() on most of these fields would be more efficient. We
do need to retain one memswap however as that field is an array.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext4/ioctl.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 49fd1371bfa2..fb844da4836f 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -60,18 +60,16 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
 	ei1 = EXT4_I(inode1);
 	ei2 = EXT4_I(inode2);
 
-	memswap(&inode1->i_flags, &inode2->i_flags, sizeof(inode1->i_flags));
-	memswap(&inode1->i_version, &inode2->i_version,
-		  sizeof(inode1->i_version));
-	memswap(&inode1->i_blocks, &inode2->i_blocks,
-		  sizeof(inode1->i_blocks));
-	memswap(&inode1->i_bytes, &inode2->i_bytes, sizeof(inode1->i_bytes));
-	memswap(&inode1->i_atime, &inode2->i_atime, sizeof(inode1->i_atime));
-	memswap(&inode1->i_mtime, &inode2->i_mtime, sizeof(inode1->i_mtime));
+	swap(inode1->i_flags, inode2->i_flags);
+	swap(inode1->i_version, inode2->i_version);
+	swap(inode1->i_blocks, inode2->i_blocks);
+	swap(inode1->i_bytes, inode2->i_bytes);
+	swap(inode1->i_atime, inode2->i_atime);
+	swap(inode1->i_mtime, inode2->i_mtime);
 
 	memswap(ei1->i_data, ei2->i_data, sizeof(ei1->i_data));
-	memswap(&ei1->i_flags, &ei2->i_flags, sizeof(ei1->i_flags));
-	memswap(&ei1->i_disksize, &ei2->i_disksize, sizeof(ei1->i_disksize));
+	swap(ei1->i_flags, ei2->i_flags);
+	swap(ei1->i_disksize, ei2->i_disksize);
 	ext4_es_remove_extent(inode1, 0, EXT_MAX_BLOCKS);
 	ext4_es_remove_extent(inode2, 0, EXT_MAX_BLOCKS);
 
-- 
2.7.4
