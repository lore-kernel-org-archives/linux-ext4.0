From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/2] debugfs: do not display fast symlink with inline data
Date: Mon,  2 Jun 2014 19:40:41 +0800
Message-ID: <1401709241-27521-2-git-send-email-wenqing.lz@taobao.com>
References: <1401709241-27521-1-git-send-email-wenqing.lz@taobao.com>
Cc: Ian Nartowicz <claws@nartowicz.co.uk>, Tao Ma <tm@tao.ma>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47491 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaFBLde (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2014 07:33:34 -0400
Received: by mail-pa0-f51.google.com with SMTP id kx10so1834826pab.10
        for <linux-ext4@vger.kernel.org>; Mon, 02 Jun 2014 04:33:34 -0700 (PDT)
In-Reply-To: <1401709241-27521-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After enabling symlink with inline data, stat command in debugfs will
think an inode is a fast symlink.  This patch fixes this issue.

Cc: Ian Nartowicz <claws@nartowicz.co.uk>
Cc: Tao Ma <tm@tao.ma>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 23a7ca3..2147ffa 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -784,7 +784,9 @@ void internal_dump_inode(FILE *out, const char *prefix,
 		fprintf(out, "Inode checksum: 0x%08x\n", crc);
 	}
 
-	if (LINUX_S_ISLNK(inode->i_mode) && ext2fs_inode_data_blocks(current_fs,inode) == 0)
+	if (LINUX_S_ISLNK(inode->i_mode) &&
+	    ext2fs_inode_data_blocks(current_fs,inode) == 0 &&
+	    !(inode->i_flags & EXT4_INLINE_DATA_FL))
 		fprintf(out, "%sFast_link_dest: %.*s\n", prefix,
 			(int) inode->i_size, (char *)inode->i_block);
 	else if (LINUX_S_ISBLK(inode->i_mode) || LINUX_S_ISCHR(inode->i_mode)) {
-- 
1.7.9.7

