From: Tao Ma <tm@tao.ma>
Subject: [PATCH 1/2] e2fsck: Let end_blk to be the maximum value of u32.
Date: Thu, 17 May 2012 15:16:06 +0800
Message-ID: <1337238967-4704-2-git-send-email-tm@tao.ma>
References: <1337238967-4704-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:56626 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761160Ab2EQHQS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 May 2012 03:16:18 -0400
Received: from [182.92.247.2] (helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1SUuwb-0005vf-43
	for linux-ext4@vger.kernel.org; Thu, 17 May 2012 01:16:17 -0600
In-Reply-To: <1337238967-4704-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Now we can use fallocate to create a large file while keep the size
to be small. It will cause the e2fsck complain about it. The test
script is simple and I have pasted it here.

DEVICE=/dev/sdb1
mount -t ext4 $DEVICE /mnt/ext4
for((i=0;i<10;i++))do fallocate -n -o $[$i*8192] -l 4096 /mnt/ext4/a;done
umount $DEVICE
e2fsck -fn $DEVICE

The error message will be like this:
e2fsck 1.42.3 (14-May-2012)
Pass 1: Checking inodes, blocks, and sizes
Inode 12 has zero length extent
	(invalid logical block 0, physical block 32775)
Clear? no

Inode 12, i_blocks is 88, should be 0.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(8231--8232) -(32770--32778)
Fix? no

Now actually the end_blk can be any value which is less than
u32, so make end_blk be the maximum value of u32.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 lib/ext2fs/extent.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index eb096d6..e2815c2 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -253,9 +253,7 @@ extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
 		ext2fs_le16_to_cpu(eh->eh_entries);
 	handle->path[0].max_entries = ext2fs_le16_to_cpu(eh->eh_max);
 	handle->path[0].curr = 0;
-	handle->path[0].end_blk =
-		(EXT2_I_SIZE(handle->inode) + fs->blocksize - 1) >>
-		 EXT2_BLOCK_SIZE_BITS(fs->super);
+	handle->path[0].end_blk = ((((unsigned long long) 1) << 32) - 1);
 	handle->path[0].visit_num = 1;
 	handle->level = 0;
 	handle->magic = EXT2_ET_MAGIC_EXTENT_HANDLE;
-- 
1.7.1

