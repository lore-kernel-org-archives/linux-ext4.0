From: Tao Ma <tm@tao.ma>
Subject: [PATCH] mke2fs: Make s_inodes_per_group >= 8 in ext2fs_initialize.
Date: Mon,  9 May 2011 23:38:42 +0800
Message-ID: <1304955522-4148-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:37972 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752105Ab1EIPpi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 11:45:38 -0400
Received: from [114.251.86.0] (helo=taoma-linux.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1QJSXx-0004uL-0Q
	for linux-ext4@vger.kernel.org; Mon, 09 May 2011 09:38:58 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

current mkfs.ext4 fails if we tried with the following parameters.
mkfs.ext4  -m 0 -N 16 -O ^has_journal,^resize_inode,^uninit_bg,extent,meta_bg -b 1024 /dev/sdb3
It will cause segfault, but it is caused by another issue. See my patch
"mke2fs: Avoid segmentation fault in ext2fs_alloc_generic_bmap". And
with that patch, the mkfs.ext4 will fail with the error:
/dev/sdb3: Memory allocation failed while setting up superblock

The reason is that in ext2fs_initialize, we align s_inodes_per_group
to 8, but fails to consider the case that s_inodes_per_group < 8.
So make at least 8 inodes for s_inodes_per_group.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 lib/ext2fs/initialize.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index e1f229b..4706773 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -282,6 +282,8 @@ ipg_retry:
 	 * multiple of 8.  This is needed to simplify the bitmap
 	 * splicing code.
 	 */
+	if (super->s_inodes_per_group < 8)
+		super->s_inodes_per_group = 8;
 	super->s_inodes_per_group &= ~7;
 	fs->inode_blocks_per_group = (((super->s_inodes_per_group *
 					EXT2_INODE_SIZE(super)) +
-- 
1.6.3.GIT

